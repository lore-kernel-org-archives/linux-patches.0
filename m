Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6573F194A50;
	Wed,  3 Jul 2024 11:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005120; cv=none; b=GwCQzy7aEj007FU7+reVxTbyVuHflRskuQvqpYXm0Y8z1HYN+kuhRWcprvipf+hAPkbVcebv5LYnxOQXnX38rwX9mOG7f+t0UCqt1iEEEEsDp6T83VWG4yHsqMMzyhWhAfb805D1Hckv9P8ylol1Nhw+euO/DXlcXT8RgWbnBAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005120; c=relaxed/simple;
	bh=jYr7wptOsm70e6gXGiPdvdu87fPuxIgA7SalYFplyIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ns6WddMqmLfP3MpDhveBfPfcyERjuyB9jXyY6NRsgRaVBtw/4IUEBZ2JY8uZUy9bL5LGaSEHrW5TO9DTE0CYCCKvIgXrvupyd1LaWn84GKk8IPCtrKsPuX6bMdRphc1OcOi2oL4prNPQgOsOo+S+WPPPUMZuQ2byLHYxvyIbEt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hA2xQd5I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hA2xQd5I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF606C2BD10;
	Wed,  3 Jul 2024 11:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005120;
	bh=jYr7wptOsm70e6gXGiPdvdu87fPuxIgA7SalYFplyIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hA2xQd5IaaTKHCYYKSF6u4Y5NXJ6T7yogbF77EWBnqgoIlkJn9raTCXbOzuYSifXx
	 M+H6JvApyGIvO0/f2Isw7azdMMX+a/b2QBoVdxD2d1F4VgUVAzNTyY55gj94z7Dtjq
	 G2brcOG3NzPo3R8zxApklCPu0cdylYiOyIka5dus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 5.10 268/290] drm/nouveau/dispnv04: fix null pointer dereference in nv17_tv_get_ld_modes
Date: Wed,  3 Jul 2024 12:40:49 +0200
Message-ID: <20240703102914.274516184@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit 66edf3fb331b6c55439b10f9862987b0916b3726 upstream.

In nv17_tv_get_ld_modes(), the return value of drm_mode_duplicate() is
assigned to mode, which will lead to a possible NULL pointer dereference
on failure of drm_mode_duplicate(). Add a check to avoid npd.

Cc: stable@vger.kernel.org
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240625081828.2620794-1-make24@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/dispnv04/tvnv17.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/nouveau/dispnv04/tvnv17.c
+++ b/drivers/gpu/drm/nouveau/dispnv04/tvnv17.c
@@ -208,6 +208,8 @@ static int nv17_tv_get_ld_modes(struct d
 		struct drm_display_mode *mode;
 
 		mode = drm_mode_duplicate(encoder->dev, tv_mode);
+		if (!mode)
+			continue;
 
 		mode->clock = tv_norm->tv_enc_mode.vrefresh *
 			mode->htotal / 1000 *


