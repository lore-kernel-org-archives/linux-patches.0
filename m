Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D559246BCD;
	Sat, 12 Sep 2026 10:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207342; cv=none; b=iPKA39he9BntkJde4vjTjCCZZZRTSQs0D6ad8bmphRC6wZL1uYhvGOQcbnW9Bfjhn+P2ycVqaRlOfjN/Gz4j1756KiBJ9itdXjrFWkeFvfzhp0woufgss7tmZnghRm+Znvamfv5+WLMuXgNa0MmTzcIz71bURyM6EnsNLZ5/+IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207342; c=relaxed/simple;
	bh=kIOD8XhL8w4AC9Jc2bjTAyT/4FMXi2TLz1glXnIkYN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bbJ9gxMeibtc4FDniTrqGSIbX3jctLxRgBUzxlmmHPJ4yJlqYvogaFRz3OrvR1ykEZtWRwX9PpbsfiT3ZKe4BMWdz97UjEAXOsy1UZmw43/roTEObI2UPM5S5KfskvWZXROQ9U+Wb5/nN8nqTR21fssv18v9oj/jJP+uR8vCJks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0+s4BEl/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0+s4BEl/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B1A1F000FF;
	Sat, 12 Sep 2026 10:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207341;
	bh=931WUXN5atvAPD+HeNErk9HmXazvJ3fpotD7qRsKYLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0+s4BEl/A9UQXczytSz9J48QWgTOAgTOqXnl/plj6v/iwo8WFndre8dYyaOZWf57K
	 sRlGs7DyVg9vRh74Z2AA+G1S2tZsj++UEIyOUxhstGHbJClQRWZ4rmjJ97R87trMV8
	 BwpplfA1bt+2S36+DinKwX2oXbSj2TzDUSNmlOjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0393/1518] regulator: adp5055: Fix error code in adp5055_of_parse_cb()
Date: Sat, 12 Sep 2026 08:42:42 +0200
Message-ID: <20260912065632.348842861@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit 153bc959ce0f91b4446fb6fb805b8c1d2ca20c75 ]

This code accidentally returned the wrong variable instead of a negative
error code.  Return -EINVAL.

Fixes: 147b2a96f24e ("regulator: adp5055: Add driver for adp5055")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Link: https://patch.msgid.link/alFJVBbiFNxhqa_1@stanley.mountain
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/adp5055-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/adp5055-regulator.c b/drivers/regulator/adp5055-regulator.c
index 4b004a6b2f84e..5b83f36351a2a 100644
--- a/drivers/regulator/adp5055-regulator.c
+++ b/drivers/regulator/adp5055-regulator.c
@@ -225,7 +225,7 @@ static int adp5055_of_parse_cb(struct device_node *np,
 		adp5055->dvs_limit_upper[id] = pval;
 
 	if (adp5055->dvs_limit_upper[id] > 192000 || adp5055->dvs_limit_upper[id] < 12000)
-		return dev_err_probe(config->dev, adp5055->dvs_limit_upper[id],
+		return dev_err_probe(config->dev, -EINVAL,
 			"Out of range - dvs-limit-upper-microvolt value.");
 
 	ret = of_property_read_u32(np, "adi,dvs-limit-lower-microvolt", &pval);
-- 
2.53.0



