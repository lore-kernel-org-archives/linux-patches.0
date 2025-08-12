Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB69E26CE2B;
	Tue, 12 Aug 2025 18:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024534; cv=none; b=NrZaY55EAPxI7zbuAkMPL8MMpcz91cgyOHdyGIL5whQNfcNnceDHWwmyk8H85OnqtT4+gao0RYn5zrXer1VKISPM7u0nHOqImvYZ80y6WPTFRtgKmYDrW1qnRbuSOvUFKGW1+6gSnQ+V+TZFKK7eCS4bMADwh7KCgLoePM1I2yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024534; c=relaxed/simple;
	bh=ApWBQFj8lBMaNLgDQDEwU/5t93t2jwSRJdDY4Dyaz/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uJNrsaZway0wPmuRXLMjH0PPbql/NitAa8vfY8AItIEW4XeGr/T8oV/PnQBHtfQZYmRA5PpTpEDuokvafyqS2rJItBHKtpT0bTCUvQiS3YHgGRSkru8QDedf66cbWYInVCmg0/tfoltTgZYJ3gy/wlM3vzp8sraPlEJZK2dUnoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f1aNvq/V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f1aNvq/V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F16E9C4CEF0;
	Tue, 12 Aug 2025 18:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024533;
	bh=ApWBQFj8lBMaNLgDQDEwU/5t93t2jwSRJdDY4Dyaz/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f1aNvq/VyrXT5GYdZ9ooO8boEQa2WeBtWt1YR33Rk5A0D77q8bDVrrSOt1jLZZDjx
	 u+nL9t1dqPO3Axv8SpqUrEBsMjCIHoLDDGK1tWKPCGZKjvxSB9nSaKjs8VvMOjKJ82
	 pcNabaRpca2QPc3HmxPPMSFY/HPkgKYwrTiipOBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 401/627] hwrng: mtk - handle devm_pm_runtime_enable errors
Date: Tue, 12 Aug 2025 19:31:36 +0200
Message-ID: <20250812173434.547344052@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ovidiu Panait <ovidiu.panait.oss@gmail.com>

[ Upstream commit 522a242a18adc5c63a24836715dbeec4dc3faee1 ]

Although unlikely, devm_pm_runtime_enable() call might fail, so handle
the return value.

Fixes: 78cb66caa6ab ("hwrng: mtk - Use devm_pm_runtime_enable")
Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/mtk-rng.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/mtk-rng.c b/drivers/char/hw_random/mtk-rng.c
index b7fa1bc1122b..d09a4d813766 100644
--- a/drivers/char/hw_random/mtk-rng.c
+++ b/drivers/char/hw_random/mtk-rng.c
@@ -143,7 +143,9 @@ static int mtk_rng_probe(struct platform_device *pdev)
 	dev_set_drvdata(&pdev->dev, priv);
 	pm_runtime_set_autosuspend_delay(&pdev->dev, RNG_AUTOSUSPEND_TIMEOUT);
 	pm_runtime_use_autosuspend(&pdev->dev);
-	devm_pm_runtime_enable(&pdev->dev);
+	ret = devm_pm_runtime_enable(&pdev->dev);
+	if (ret)
+		return ret;
 
 	dev_info(&pdev->dev, "registered RNG driver\n");
 
-- 
2.39.5



