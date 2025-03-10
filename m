Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 264B72309B6;
	Mon, 10 Mar 2025 17:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627558; cv=none; b=Yxc9jD1npdw1g3I9hSW0isFpkYPwWVpU2H3rsYfUAuC8YS2j4nrBxQMIOadlbhtedFOMp1N967RSnHzpGAZtspNWRFu4y2+RYI11leG7Bvh0SyxtuUgZK6qqSZvIwSFjeskthXtJjQ3mKJuG0A3FW7hsutQU6KJSRmvcxGHT3Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627558; c=relaxed/simple;
	bh=9l2GU0i4L03SJtG1J6OPNThI+/lFg+hYB2C+T5jxwxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sdi84VRuSR3j2yKnh0Aju4edZvOBzGNVxZVTtnOZNNCctAJzIrz2T8FYQ5uM3pfe1+hMNhgwNy5uOJrCsfgZuLQyK8dWx6PwjD0rxlf40ErgFeZL9T4WsoNcPKoP5EiGNS8NVTEWsHQ5Y3mwQLX789M9rdxiaZvmWZu8hs3Zm4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C7yJPSoj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C7yJPSoj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2CE3C4CEE5;
	Mon, 10 Mar 2025 17:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627558;
	bh=9l2GU0i4L03SJtG1J6OPNThI+/lFg+hYB2C+T5jxwxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C7yJPSojJOI5eIAcYKW287aiFhu8j6kteQB/wCQpPKAYNsIg0FkIVLoK0tRELANzf
	 vSh1SbxlVHfftjJUfaywcLquhsHNQED/vJ2GrAPKccz6t4ATrHN6SZw1eKpdjoTwuk
	 t6D3oWSgCfLMxe0nnyRQZN3oRofyTEq6outELLSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Titus Rwantare <titusr@google.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 170/269] hwmon: (pmbus) Initialise page count in pmbus_identify()
Date: Mon, 10 Mar 2025 18:05:23 +0100
Message-ID: <20250310170504.493788543@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ec40c5c599543..59424dc518c8f 100644
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



