Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 852569445;
	Wed, 23 Aug 2023 16:33:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A79BC433C7;
	Wed, 23 Aug 2023 16:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1692808381;
	bh=oAGOZ+ekiLiOmp7hE1/xSBjmF1EMKp3By99T76ldHzg=;
	h=From:Date:Subject:To:Cc:From;
	b=KfEEuG4PAxY+ze4/trTba3y0v4nzMF2BU5VQfCVQnFpu9pRUZ7Ux3SN75/QrFpzAo
	 MFD6Brikt3mf0knjuDtlvfKsjFOVpLszis5h6+dIcBXSXmxFkhf6OeJnMpl0Suhjbp
	 fXMKS6ja78Kxrp4Ky6hzacwWbjwDctt+8eeWfPbk2uF2qFYibsYCNurqPBr7aWUjNV
	 jRmSmMi4luN/Q48pxbKV6KufC86IzQPlrKe22/CJA+t0YWHOSRlxtfRx0xHg1DfGBz
	 h1hmiNhG66WLAZDwpR9GqTB+sD3W1pNbvMMab3higzVyUnatOzoyR4HOscDsYI+kCD
	 Y02cA9VNqcG8g==
From: Nathan Chancellor <nathan@kernel.org>
Date: Wed, 23 Aug 2023 09:32:50 -0700
Subject: [PATCH] ASoC: cs42l43: Initialize ret in default case in
 cs42l43_pll_ev()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230823-cs42l43_pll_ev-init-ret-v1-1-5836f1ad5dad@kernel.org>
X-B4-Tracking: v=1; b=H4sIALE05mQC/x3MQQqDMBBG4avIrB2ISVqlVxGRaH/bgZBKEkQI3
 t3Q5bd4r1BCFCR6NYUiDknyCxVd29D6deEDlnc1aaWNGrThNVntrZl372ccLEEyR2Telg62h1N
 P9aBa7xGbnP/zOF3XDdE0twtpAAAA
To: james.schulman@cirrus.com, david.rhodes@cirrus.com, 
 rf@opensource.cirrus.com, ckeepax@opensource.cirrus.com, broonie@kernel.org
Cc: lgirdwood@gmail.com, ndesaulniers@google.com, trix@redhat.com, 
 alsa-devel@alsa-project.org, patches@opensource.cirrus.com, 
 patches@lists.linux.dev, llvm@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1488; i=nathan@kernel.org;
 h=from:subject:message-id; bh=oAGOZ+ekiLiOmp7hE1/xSBjmF1EMKp3By99T76ldHzg=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDCnPTPYo171w2Pom4577NeuFIve5ctWWe6hPO5ci+n2Sl
 vCFvXyKHaUsDGIcDLJiiizVj1WPGxrOOct449QkmDmsTCBDGLg4BWAiJqWMDL8NDPbONpAy98zu
 0lzgG++Uff/7vt1ZdyL9ti07WRGWrM7I8Ej8WpfCI3N3u5163u4vuTd9f/s1nd1pt3cij9BRtfe
 buQA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

clang warns (or errors with CONFIG_WERROR=y):

  sound/soc/codecs/cs42l43.c:1371:2: error: variable 'ret' is used uninitialized whenever switch default is taken [-Werror,-Wsometimes-uninitialized]
   1371 |         default:
        |         ^~~~~~~
  sound/soc/codecs/cs42l43.c:1377:9: note: uninitialized use occurs here
   1377 |         return ret;
        |                ^~~
  sound/soc/codecs/cs42l43.c:1349:9: note: initialize the variable 'ret' to silence this warning
   1349 |         int ret;
        |                ^
        |                 = 0
  1 error generated.

Initialize ret to 0 in the default case, as there was nothing to do for
other event types.

Closes: https://github.com/ClangBuiltLinux/linux/issues/1922
Fixes: fc918cbe874e ("ASoC: cs42l43: Add support for the cs42l43")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 sound/soc/codecs/cs42l43.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/cs42l43.c b/sound/soc/codecs/cs42l43.c
index 55a79219af35..18178ffa82f2 100644
--- a/sound/soc/codecs/cs42l43.c
+++ b/sound/soc/codecs/cs42l43.c
@@ -1369,6 +1369,7 @@ static int cs42l43_pll_ev(struct snd_soc_dapm_widget *w,
 			clk_disable_unprepare(priv->mclk);
 		break;
 	default:
+		ret = 0;
 		break;
 	}
 

---
base-commit: 014ee0692f29da8b08fed5da0fa14e04698a50f7
change-id: 20230823-cs42l43_pll_ev-init-ret-fb1e47ea0605

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

