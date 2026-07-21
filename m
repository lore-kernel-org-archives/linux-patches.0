Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75C346C4AB;
	Tue, 21 Jul 2026 17:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656633; cv=none; b=TLjUUTxP5dVpo3AKyWhUXzxz2UcpvjOxPYL04JT1OXYwQnSeMH/zhWoDVasJcC3fc3O+jUYkU/8KKKjgkIZPirXDbjKmm+QauoOdmUkOdcUhf2nyghdTgZFAJIRmKxWU7fEgjZqdMO1TMXqFACuq/8w0xTfqFNChXJ4WboRaoig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656633; c=relaxed/simple;
	bh=+DovKjbICAecvpMZ62yJpA0kwHcGrPcZ/7vxq8IFUfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kRcnJF2UVGM3phXb/tNIA+8hjI2gqrkeGvjJlwxBMteo5jGziJEgKubaXCIchNvjWd4MgzjiliCzNyv+9biSHajhEdKbD0lfefUV7/oqWWygzm0ctxMX36sOUgUoTEetIm1qzWGWvE631/SdcKyOiePLXjl6b6F38EXGnlfRDV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h4KB6ACw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h4KB6ACw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51E791F000E9;
	Tue, 21 Jul 2026 17:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656628;
	bh=mC0HihkfxivUOn1QlQlcsSb8VwhIDXycjvCR6mdq+OQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h4KB6ACwZjp2RLeDEl57aXGCLR1HKOIjyL4eIakjyDyK0CZIArj7ZOdOTIqD3ydEf
	 7U4Z/wDN4soZqXO0U570GGyyFOCMT2DojlMGHPGqzbA2vw9XiYUkaMusOQYbaZ1Lcz
	 kY6yWQ6AcUi8uUDTbRafgj5oUWDnfANjkl7m0HdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0422/1611] hwmon: (it87) Clamp negative values to zero in set_fan()
Date: Tue, 21 Jul 2026 17:08:58 +0200
Message-ID: <20260721152524.758179517@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

[ Upstream commit 7f8581c70a3bd50a932d3d2d253e99c5ec3eda74 ]

set_fan() parses user input with kstrtol() and passes the resulting
value to FAN16_TO_REG() on chips with 16-bit fan support.

Negative fan speeds are not meaningful and should be rejected before
conversion. Worst scenario, one may be able to abuse undefined
behaviour of signed overflow to possibly induce rpm * 2 == 0 in
FAN16_TO_REG(), thus causing a division by zero.

Instead, clamp val < 0 to zero and keep the conversion in its valid
input domain, avoiding unsafe arithmetic in the register conversion
path.

Found by Linux Verification Center (linuxtesting.org) with static
analysis tool SVACE.

Fixes: 17d648bf5786 ("it87: Add support for the IT8716F")
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Link: https://lore.kernel.org/r/20260529141839.1639287-1-n.zhandarovich@fintech.ru
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/it87.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/hwmon/it87.c b/drivers/hwmon/it87.c
index 5cfb98a0512f00..c0c9826d44a2e5 100644
--- a/drivers/hwmon/it87.c
+++ b/drivers/hwmon/it87.c
@@ -1401,6 +1401,9 @@ static ssize_t set_fan(struct device *dev, struct device_attribute *attr,
 	if (kstrtol(buf, 10, &val) < 0)
 		return -EINVAL;
 
+	if (val < 0)
+		val = 0;
+
 	err = it87_lock(data);
 	if (err)
 		return err;
-- 
2.53.0



