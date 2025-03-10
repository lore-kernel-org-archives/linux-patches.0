Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242092253FE;
	Mon, 10 Mar 2025 17:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628398; cv=none; b=Y9oomf5e9gAb8iXwy37vj5IARWyZMKiLsubftHAZnGo6EAMrTNZz0LsyaVv3zmwCZ4ihHoLTaHuZvIqL89MVrEQJmZ0HQqZ6Qby6HeXKRan+92kKDSIVBA6TX0YECamvKtcjULpSxNWu1/jwF9CZbD/srIDRlbm2plks1Zd+tzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628398; c=relaxed/simple;
	bh=EqLZZWTAYMcvSV1oHIHiH57dPFuqS0dv7JjuIfA0Xg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jXAchXWODDMTNiZRSEbrtyCPOXHNHmbrmwSHe3Gs73+5oW73nJUlLaMRPNmNgW4tbvq4i7c2UA2Hd7kluD46Gr92hRNRg/bVIY9f1FS6DQO7+nBJfrBiJdZpktLvwwuIRzTwpURjq1nJzoeG40IQF8GGNRymkhg0pwdSkr2yrEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k8rNHA4o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k8rNHA4o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 955C5C4CEE5;
	Mon, 10 Mar 2025 17:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628398;
	bh=EqLZZWTAYMcvSV1oHIHiH57dPFuqS0dv7JjuIfA0Xg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k8rNHA4oMMhiKjb++8wTOdiXeddr/ecQKg9zpOhts62XX7atV2o6RN2oiv1nbFJtV
	 4zfjA2QGg6/ztxVDgw4oAnRMqAHfAOENuJ39ZAWsHdv5zuzr6jf2HP0WuT9HegXweG
	 eUHOjwoL46DXO9evpxCtPWLFDZwodExb6rz6hs6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Titus Rwantare <titusr@google.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 044/109] hwmon: (pmbus) Initialise page count in pmbus_identify()
Date: Mon, 10 Mar 2025 18:06:28 +0100
Message-ID: <20250310170429.316499388@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d0d386990af5e..6366610a90827 100644
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



