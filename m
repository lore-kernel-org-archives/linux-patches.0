Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B09252908;
	Wed,  5 Mar 2025 17:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197206; cv=none; b=F4QWdO8yhHPjqXLk8FXnxBATUUIAR7wb/TVZuZYFYO/2x4JwkmFcWdJHC4kCPvR+GFGaJSWcNmAJTrkmBO2kCBicEfdA4Vw5A7nhsH1cvRut/imgpFaYfjDFVlbVJNVMGX26CeOxxvNfMrySKnNF7BjaBcWhCBFxh5qjRFnwzmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197206; c=relaxed/simple;
	bh=vq9IsntABmKwvMXG+04JJhIzZ2d3Gpj8Z+bl9kN1P0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kOWb1VsOgT01iQndWqxqt5/iQWFqKLxN2ewqufzHKtDBGbAPliF6Qz0+apjomzyZGLTSpW/oeMvahnslnLXalO4/aWw1NFuZWZ57oYhsE4bLaTg5PJYzcNkugW0jy1pAapN1EnXjrDyvVbrHh5UOBnQSYxiigTFtV9vSSQn0n5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gez2VFNB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gez2VFNB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41354C4CED1;
	Wed,  5 Mar 2025 17:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197206;
	bh=vq9IsntABmKwvMXG+04JJhIzZ2d3Gpj8Z+bl9kN1P0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gez2VFNBO1En+2d2UJ7ES3Ik4/4wAUr8uGikxIJcp/udfDdLnMCly8f2g88oqutKH
	 mCrG+TQvYT6GjuGUu01ouOL+E7m5Ss3DePBAdPquxTJbXHPF55gZ6AucKKwP2ecopI
	 bttKs2wjwy62KEtE2ak89tKUMOo7r/vymKPdj5fo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 077/176] ASoC: fsl_micfil: Enable default case in micfil_set_quality()
Date: Wed,  5 Mar 2025 18:47:26 +0100
Message-ID: <20250305174508.556083843@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

commit a8c9a453387640dbe45761970f41301a6985e7fa upstream.

If 'micfil->quality' received from micfil_quality_set() somehow ends
up with an unpredictable value, switch() operator will fail to
initialize local variable qsel before regmap_update_bits() tries
to utilize it.

While it is unlikely, play it safe and enable a default case that
returns -EINVAL error.

Found by Linux Verification Center (linuxtesting.org) with static
analysis tool SVACE.

Fixes: bea1d61d5892 ("ASoC: fsl_micfil: rework quality setting")
Cc: stable@vger.kernel.org
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Link: https://patch.msgid.link/20250116142436.22389-1-n.zhandarovich@fintech.ru
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/fsl/fsl_micfil.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/soc/fsl/fsl_micfil.c
+++ b/sound/soc/fsl/fsl_micfil.c
@@ -123,6 +123,8 @@ static int micfil_set_quality(struct fsl
 	case QUALITY_VLOW2:
 		qsel = MICFIL_QSEL_VLOW2_QUALITY;
 		break;
+	default:
+		return -EINVAL;
 	}
 
 	return regmap_update_bits(micfil->regmap, REG_MICFIL_CTRL2,


