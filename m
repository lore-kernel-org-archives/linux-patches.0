Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D5C3419313;
	Sat, 12 Sep 2026 08:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202215; cv=none; b=sOCW19pcr2wsoqHsqRTYSEBW+7MTtj5fn5+Ch1WKClVTXX72dYVrxJEwshVE1tsSj4gW2uLj/+en3mjsdpOK/KVbP0nyf/r75ooZtkGiYYCYHTuBxVYOm3PLXfq49S2NqRrumNtF4/JtVReUtiYJjHY7WVR13jBAWZTBWcPR0ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202215; c=relaxed/simple;
	bh=2jr6QsQjY67WSgV5S8jKvFbKSAFB21CMcp6YAceeKtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WTj7jyWalBUiFf3945xLW1cN1J8EpJUClZxVXheJKuIBkVUoOmxD7LChlzyd/AQFqjf14xfe9ZSfA3dyh0O8BEntjvVhMQdJ8K0M0QxbCU3VMmWJRRUQMSnTBSG7/eOXIWUf68shOOwfGkw/yA46v5LhU/b4WYIclTGDnhpJVyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yIyix6yB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yIyix6yB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E55161F00893;
	Sat, 12 Sep 2026 08:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202212;
	bh=gpKtfe8SOyn0yE3C620AEjKyKtZRmGBCMXJeVbbjQIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yIyix6yBTUSrdykn3Xs3i3Jj3LyHczZui3QhOLxDSh0immsBfIfKQu3cA/SWurM6H
	 p3OrX4PXxv3LLJr9PW2lh2zc9V1pof+xkzqBMU36mnmwtXHFPl6eByV2ey1/Norb8j
	 FB/HE9CQMBKBNr8PD53Ous80PpQAy5/ScUKlrcFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Sven Peter <sven@kernel.org>,
	Janne Grunau <j@jannau.net>,
	Joshua Peisach <jpeisach@ubuntu.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1157/1815] mfd: macsmc: Fix key count endianness annotation
Date: Sat, 12 Sep 2026 08:48:27 +0200
Message-ID: <20260912065716.173358528@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Peter <sven@kernel.org>

[ Upstream commit 0a29aa605286bcd01632eb6b61f59b9053312347 ]

SMC firmware returns the value of the #KEY key in big-endian unlike most
other keys. Reading it through apple_smc_read_u32() into a plain u32
and then converting with be32_to_cpu() makes sparse complain:

  drivers/mfd/macsmc.c:462:26: sparse: cast to restricted __be32

Read the raw value into a __be32 using apple_smc_read() instead.

Fixes: e038d985c982 ("mfd: Add Apple Silicon System Management Controller")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202607181046.OANjIoqR-lkp@intel.com/
Signed-off-by: Sven Peter <sven@kernel.org>
Reviewed-by: Janne Grunau <j@jannau.net>
Reviewed-by: Joshua Peisach <jpeisach@ubuntu.com>
Link: https://patch.msgid.link/20260719-b4-macsmc-be32-fix-v1-1-c7b1936307fa@kernel.org
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/macsmc.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/macsmc.c b/drivers/mfd/macsmc.c
index 358feec2d088f..514cba7dc897a 100644
--- a/drivers/mfd/macsmc.c
+++ b/drivers/mfd/macsmc.c
@@ -410,7 +410,7 @@ static int apple_smc_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct apple_smc *smc;
-	u32 count;
+	__be32 count;
 	int ret;
 
 	smc = devm_kzalloc(dev, sizeof(*smc), GFP_KERNEL);
@@ -461,8 +461,10 @@ static int apple_smc_probe(struct platform_device *pdev)
 	dev_set_drvdata(&pdev->dev, smc);
 	BLOCKING_INIT_NOTIFIER_HEAD(&smc->event_handlers);
 
-	ret = apple_smc_read_u32(smc, SMC_KEY(#KEY), &count);
-	if (ret)
+	ret = apple_smc_read(smc, SMC_KEY(#KEY), &count, sizeof(count));
+	if (ret >= 0 && ret != sizeof(count))
+		ret = -EINVAL;
+	if (ret < 0)
 		return dev_err_probe(smc->dev, ret, "Failed to get key count");
 	smc->key_count = be32_to_cpu(count);
 
-- 
2.53.0



