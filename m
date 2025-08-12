Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CFF92F5E;
	Tue, 12 Aug 2025 18:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022618; cv=none; b=gNtzP2zpWhdmTPvkVtsefOC0jl0YJrzgWl3XDQDz1vRy2ZVmb0xfqQyfABZeY4npFp8Sq2LBimCu51sCa6q3VWLkF3lmYzFXidD7/bKcMQo40Y3NmKlntr/fbLCF+SsklQfqPCgqso5JzTTqS0mF1cQBJ+3sxmmwkvgrj1Y5qGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022618; c=relaxed/simple;
	bh=em5nQT3bpMOI65tTXLlv/Fh74/5RXEL0c4gn4AggvcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MnGuyNvKeZGFzIh+ZHTZxW5uNwRpLXsAGn7Cot07eViJ/x4w9mqtXz8Uf/yUsRWZrUeLa3LpPlFFAqlX/5gXJ/62erYSP2sAxuZvhEkdKdLJZtEVGQR3t+42BsEdtRG03KLjipXjrDJKOkIriAa9v1vkup8Mky9udDNGe5VH5Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MTvo9MEb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MTvo9MEb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDDA5C4CEF0;
	Tue, 12 Aug 2025 18:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022618;
	bh=em5nQT3bpMOI65tTXLlv/Fh74/5RXEL0c4gn4AggvcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MTvo9MEbeSy0UAnmt87xS6LDNBo2IQgqsRbpXZ9dB5MnkLKv9Nl2HcUbDRcmyMgLI
	 CnztmBRXizoS+UhfyGQrFiHkX3gwwrPyFLhBWpRw/nMdK6Y5GyEdJ/NfA7lbHbIuPf
	 mBfzNAfsxzOD0PXZsVtwtVGf13562K5TlVJCjzNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 207/369] hwrng: mtk - handle devm_pm_runtime_enable errors
Date: Tue, 12 Aug 2025 19:28:24 +0200
Message-ID: <20250812173022.550637558@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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
index 1e3048f2bb38..6c4e40d0365f 100644
--- a/drivers/char/hw_random/mtk-rng.c
+++ b/drivers/char/hw_random/mtk-rng.c
@@ -142,7 +142,9 @@ static int mtk_rng_probe(struct platform_device *pdev)
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



