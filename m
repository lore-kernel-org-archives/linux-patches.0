Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69C741A547;
	Tue, 21 Jul 2026 19:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662031; cv=none; b=ZDKS1GSxmc3RUuXFgNRE+rJquQQi7PQ1NcnlgNdEejMj2divaapJ4dASt8vKMSqOAOsCgnZlKJbtXdSGeSeHUrLF98APx9H5mM27Q5scGVUIEJ/V0VgcbJATh9mAiu7Or5kK5r2ZByndjq3yl5zdbwX749Pgu6vime0kePca+4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662031; c=relaxed/simple;
	bh=TLADmBmCCHPJNGxhAdIcHYPl3JgiKFmXDDFDHfVK7Pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FIqSiONPaZm0ULSoiLMEISWy6EWN67rhWia6oVsm0uSKDty3TjiFMiqEFQmmN7zc7uBq/J7EboGMct1xJ4qCupEmzvZdSCEPJEFa17jmoiYXHnAoMIlzYKjYrhHerh4Vx+3RZIk9pO2MqXK/a2o1sgPEpBviEW0KlyJBuBh2c6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aMDVFXXj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aMDVFXXj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 267551F000E9;
	Tue, 21 Jul 2026 19:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662029;
	bh=rVrYyJmLdZUxWckmjc8Mm1cGDO9r5oe26CU6IjAAklY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aMDVFXXje0a/IIFhH6keC4lXG8uPBRoK3sDBGMSse9ziqqzj3Cnv8A/f7oN30Zp7B
	 kuPsI4f7OkySnez9CEi7UdoYuifBy4k3leAwEpIODy5NAGYkwMOQBGeZL8886BhVgs
	 F+0S0dMlVxpvJckdTeLQixpQr1BmaaJVGHCPoQ/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0291/1276] hwmon: (it87) Clamp negative values to zero in set_fan()
Date: Tue, 21 Jul 2026 17:12:14 +0200
Message-ID: <20260721152452.599158887@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



