Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE672236FB;
	Mon, 10 Mar 2025 17:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626796; cv=none; b=uT5TI1cOSnsfx83/wSIM0HA0VCdHkNTG1agpzJpayg3EzdZQ9BAf/+4exrXuQvZTZCjTb1MQIPyfLLG4o65hyQaPsuTsx4zvEAM5zpnABkmjP7j1EcpZAJgdIPDHEJr8Qf8o3aQdMT3/FvLkKGe3ttqajqCtZhYVnBwCpl12yV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626796; c=relaxed/simple;
	bh=Zd1ccEZIeNh+cwZFH9UGS7mFt0cUG7wY4WCHSO5sIEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ka0reNuUsw0mqFeRPQL6z423sdqE+Lgm8ph2aSMg8m7AFQqHoSM9DTKZXbdkIzird9REU067VwvVW/I7uMrRzs5e45CRX/otwBpjQst8XjyC8fEMw2LNAB1CTFM4bjxxTEqpGHUbPmEbnPi8m2r0TXN6IhfXV13FSIWve4St3lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=18xSOkGB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="18xSOkGB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7AB2C4CEE5;
	Mon, 10 Mar 2025 17:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626796;
	bh=Zd1ccEZIeNh+cwZFH9UGS7mFt0cUG7wY4WCHSO5sIEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=18xSOkGBrdMSV6YL6PDP43YVTD6ECQ0q81Wnb74t2HmdWfItOFEA3ZfKlTNQnpPV4
	 R45If/uLtpEbfF8as6nzwUC5xHdQlO5ptNoqz+HNmGlCZJVotywEOCKniJqDdBIg5H
	 WTN+LyMOosgT+0Jngoq0KkpjabFr6wKlKTduxo7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Titus Rwantare <titusr@google.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 116/207] hwmon: (pmbus) Initialise page count in pmbus_identify()
Date: Mon, 10 Mar 2025 18:05:09 +0100
Message-ID: <20250310170452.422938114@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Titus Rwantare <titusr@google.com>

[ Upstream commit 6b6e2e8fd0de3fa7c6f4f8fe6841b01770b2e7bc ]

The `pmbus_identify()` function fails to correctly determine the number
of supported pages on PMBus devices. This occurs because `info->pages`
is implicitly zero-initialised, and `pmbus_set_page()` does not perform
writes to the page register if `info->pages` is not yet initialised.
Without this patch, `info->pages` is always set to the maximum after
scanning.

This patch initialises `info->pages` to `PMBUS_PAGES` before the probing
loop, enabling `pmbus_set_page()` writes to make it out onto the bus
correctly identifying the number of pages. `PMBUS_PAGES` seemed like a
reasonable non-zero number because that's the current result of the
identification process.

Testing was done with a PMBus device in QEMU.

Signed-off-by: Titus Rwantare <titusr@google.com>
Fixes: 442aba78728e7 ("hwmon: PMBus device driver")
Link: https://lore.kernel.org/r/20250227222455.2583468-1-titusr@google.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/pmbus.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hwmon/pmbus/pmbus.c b/drivers/hwmon/pmbus/pmbus.c
index 77cf268e7d2d6..920cd5408141a 100644
--- a/drivers/hwmon/pmbus/pmbus.c
+++ b/drivers/hwmon/pmbus/pmbus.c
@@ -103,6 +103,8 @@ static int pmbus_identify(struct i2c_client *client,
 		if (pmbus_check_byte_register(client, 0, PMBUS_PAGE)) {
 			int page;
 
+			info->pages = PMBUS_PAGES;
+
 			for (page = 1; page < PMBUS_PAGES; page++) {
 				if (pmbus_set_page(client, page, 0xff) < 0)
 					break;
-- 
2.39.5



