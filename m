Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F8A418372;
	Fri,  7 Aug 2026 15:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115247; cv=none; b=BfSPJG+tTNZ25iEjDGrFV3krpF13MsTd+ZcLdNGrSw0glsQS1ps+32Zku5og4BFX48QlRbP8DgZlSl97H1WWaLTAwvfbBB94uY77oYFBncpvy2bza7O+VAwgc9UbKX6tFiqhwnlVBDSlWK8euIVcPBMwJFjkiXLcujPR5O8v25s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115247; c=relaxed/simple;
	bh=skvm+EKUNfZbgx+DjVm7oIgMDzKy2ADmRtG8HxCzqc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kkv6CMHCNvuhSu3VhE0Jovq8EzUhr7JBhhupEHZddVQOTqY/sSQr0IMfhQPdHuY1vxLrmA06eLN587hRm7Guwit+adrz7GzNDwcIECwDK7YJUfoZyZk38h66pPFOoC62tCj6eccGlbjKWr+EZyCRMFAgwtJgcLeYSgTWwIXEkCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YtX6O8uU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YtX6O8uU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B9F61F00A3A;
	Fri,  7 Aug 2026 15:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115246;
	bh=bJ2xaspBJCDH3BmnEw2ftZTCBqr6jAGXCJEjj+wsKyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YtX6O8uU2uLgcHLbihdf7QaTox0aIsJZQrUJkrhPJaSWkwMuqYdc7mf8Zv3WHc6Ku
	 UVmfqOY+76IyZ8rcFRHRLPQFd/9IcSdbUxzkH9By33rjeqHy96UDg5WiKDkaSxZfeQ
	 UaBPJvx6GtUL7x+m7qCUXtM5wrSvLUjMrLM2JdLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 209/396] ASoC: fsl_easrc: fix m2m_init error path to use goto instead of bare return
Date: Fri,  7 Aug 2026 16:36:09 +0200
Message-ID: <20260807143428.782856468@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

From: Shengjiu Wang <shengjiu.wang@nxp.com>

commit a54bc0eef90ea760039c14bb7f3b5db42529f84d upstream.

When fsl_asrc_m2m_init() fails in fsl_easrc_probe(), the code did a
bare return ret, bypassing pm_runtime_disable() in err_pm_disable.
Use goto err_pm_disable to ensure proper cleanup on failure.

Fixes: b62eaff0650d ("ASoC: fsl_easrc: register m2m platform device")
Cc: stable@vger.kernel.org
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://patch.msgid.link/20260715024758.1252801-3-shengjiu.wang@oss.nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/fsl/fsl_easrc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/fsl/fsl_easrc.c
+++ b/sound/soc/fsl/fsl_easrc.c
@@ -2266,7 +2266,7 @@ static int fsl_easrc_probe(struct platfo
 	ret = fsl_asrc_m2m_init(easrc);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to init m2m device %d\n", ret);
-		return ret;
+		goto err_pm_disable;
 	}
 
 	return 0;


