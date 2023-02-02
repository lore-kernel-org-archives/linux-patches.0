Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9607E7;
	Thu,  2 Feb 2023 16:34:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B514C433EF;
	Thu,  2 Feb 2023 16:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1675355686;
	bh=4bpf1y8Gwhp/w9VhMFKg+NgCFgYS/3a8aHv9zIxyUdk=;
	h=From:Date:Subject:To:Cc:From;
	b=a8pb53m9EEH4lcl2zbe6hBoYTQA9c27xtXYEhoFxg7e1lH9MiJtbOLBBouPeoSmpR
	 ckznj66rT1B25SnUxOIJ59UHhwUVxFMeztZKuiLAKXa6B+ysdKqMRYieMbIFugkz4U
	 7vlG7AWufG9p7674WsHIeLdHoY0zaxVwaZV52eDvBF5KGBpRRB3VbvHaOWkMn+h6aV
	 oMwuVWQDWmrj1zIg3TLLHPw9TTCkDURUKIpJTXPeLq89M7bRsJ0o7c4EgLzAs01gy7
	 /du4bZuLQik1rn5xiL1k5h38sE25t0QJCSUHrifAvdyaceXrc4/fVEcs8ZOAodWZiC
	 KgvAYCXtZlw1w==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 02 Feb 2023 09:34:19 -0700
Subject: [PATCH] ASoC: mchp-spdifrx: Fix uninitialized use of mr in
 mchp_spdifrx_hw_params()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230202-mchp-spdifrx-fix-uninit-mr-v1-1-629a045d7a2f@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAvm22MC/x2NTQqDMBCFryKz7kCaWrC9Sukixkkzi6RhRosg3
 t2xmwcf728DJWFSeHYbCP1Y+VsNrpcOYg71Q8iTMXjnb84ES8wNtU2cZMXEKy6VK89YBAd390O
 yUB8fYANjUMJRQo35nChBZ5LTaELW/L++3vt+AIUW/mGFAAAA
To: codrin.ciubotariu@microchip.com, lgirdwood@gmail.com, 
 broonie@kernel.org, claudiu.beznea@microchip.com
Cc: nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com, 
 ndesaulniers@google.com, trix@redhat.com, alsa-devel@alsa-project.org, 
 linux-arm-kernel@lists.infradead.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1470; i=nathan@kernel.org;
 h=from:subject:message-id; bh=4bpf1y8Gwhp/w9VhMFKg+NgCFgYS/3a8aHv9zIxyUdk=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDMm3n6kqqfjOfldQz9a39+jF+4pXzLtd8lxfTajM1DKdK
 XsyJCK9o5SFQYyDQVZMkaX6sepxQ8M5ZxlvnJoEM4eVCWQIAxenAEwkhY/hf5Tv1MuePe38l53T
 LZ/HbLx4MZdlqlwuY63NGm/RJcltaxkZJqszrOzi0PiSx9EjLJDllJbocFoo9mmq/Bf/cLWtZxr
 ZAQ==
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns:

  ../sound/soc/atmel/mchp-spdifrx.c:455:3: error: variable 'mr' is uninitialized when used here [-Werror,-Wuninitialized]
                  mr |= SPDIFRX_MR_ENDIAN_BIG;
                  ^~
  ../sound/soc/atmel/mchp-spdifrx.c:432:8: note: initialize the variable 'mr' to silence this warning
          u32 mr;
                ^
                 = 0
  1 error generated.

Zero initialize mr so that these bitwise OR and assignment operation
works unconditionally.

Fixes: fa09fa60385a ("ASoC: mchp-spdifrx: fix controls which rely on rsr register")
Link: https://github.com/ClangBuiltLinux/linux/issues/1797
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 sound/soc/atmel/mchp-spdifrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/atmel/mchp-spdifrx.c b/sound/soc/atmel/mchp-spdifrx.c
index 526dd3a17471..eb0c0ef4541e 100644
--- a/sound/soc/atmel/mchp-spdifrx.c
+++ b/sound/soc/atmel/mchp-spdifrx.c
@@ -429,7 +429,7 @@ static int mchp_spdifrx_hw_params(struct snd_pcm_substream *substream,
 				  struct snd_soc_dai *dai)
 {
 	struct mchp_spdifrx_dev *dev = snd_soc_dai_get_drvdata(dai);
-	u32 mr;
+	u32 mr = 0;
 	int ret;
 
 	dev_dbg(dev->dev, "%s() rate=%u format=%#x width=%u channels=%u\n",

---
base-commit: 1d78f19d90d1932c83d8c96c6f86fbb06c05e29a
change-id: 20230202-mchp-spdifrx-fix-uninit-mr-80528f2024c9

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

