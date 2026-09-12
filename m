Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F0C33C198;
	Sat, 12 Sep 2026 10:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209994; cv=none; b=dVbKyXO0+LZsWERdvhPYr0hHb5l8u8S2npCtCpw/xPNNsM+Qg6jqnTUtEiR5fpIqOHqO98zDKUBt5+q00tbFVrR10ifLGwvvyCKCcahgPFqAPM2CSkqtP65pS/uCtyeuhXlaRfyvnnlF9PLMiaI+Pm5EIGJKay51WSq/b0E8kg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209994; c=relaxed/simple;
	bh=IyBUTLZj70XENndZDn6iflhArzyy+U3omzcKk/BgsHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SzpRMi5cUNFcBfxu9435D/J8hG5wVYx8b+AdpZjt0YuUOBN5AXOL6AuqK/s5RdCp+1cze8PlhweEZxYWtcSnwwetcjctmrO8Hg330+ATm6knNACcP6ibcFscQlfySFnVQK1r9qR6rP6xFeybJwK2fm+hvKBggHaK9mdZw23vB5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RO+6RXuf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RO+6RXuf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 838041F00893;
	Sat, 12 Sep 2026 10:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209993;
	bh=XTTs0Go94v33NrgAiBzL+CPIHYQbesqeS70fnIYyqGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RO+6RXufrDGwKtWwlvHYLFIBks5AbUF2AI7k55HA3/OdkwUEXILL5pW7DQFLT43mm
	 xdGui2AIiRFE0a7Pf3LYJ3H520eIvqY3Pj52eXPZK4KPSycZKpbWHe3HPdhwm9e2gN
	 IavOVTbfgUFM2Zog6nxVuhImZI0QLv/ZakkOGSA4=
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
Subject: [PATCH 6.18 0936/1518] mfd: macsmc: Fix key count endianness annotation
Date: Sat, 12 Sep 2026 08:51:45 +0200
Message-ID: <20260912065644.624147568@linuxfoundation.org>
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
index 3228e79c86eb5..90c434c9215bb 100644
--- a/drivers/mfd/macsmc.c
+++ b/drivers/mfd/macsmc.c
@@ -406,7 +406,7 @@ static int apple_smc_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct apple_smc *smc;
-	u32 count;
+	__be32 count;
 	int ret;
 
 	smc = devm_kzalloc(dev, sizeof(*smc), GFP_KERNEL);
@@ -457,8 +457,10 @@ static int apple_smc_probe(struct platform_device *pdev)
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



