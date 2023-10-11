Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0E03A26E;
	Wed, 11 Oct 2023 20:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="peocWnSI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE1E7C433C7;
	Wed, 11 Oct 2023 20:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1697055729;
	bh=oEPFEr69GOFnlvxRi+OQJiP0bTLBwUD6RP2Enyu8lR0=;
	h=From:Date:Subject:To:Cc:From;
	b=peocWnSImSksa62GSPAn85I3k+ZvLdOPgLVoQt5Vuy/sPj9YK66RvBb43iKxBOHw3
	 cTYd37njxwYGCpuF/kg+f3j13Ac7nBoaxAPKxrwoxX3sjmEn6nNRqGEvJS7KinK40l
	 /Jupky0h+QKMjw3UNe41uZ5qN/0C/xdymc0SIB+ijTje5xbC0zb9h8uwmOi6hy2Lyf
	 m1QSEDD3/AMXmF5nRmsoTUoYtmF2e10dVbo/NkvAjZMH4Sx+ygoFrNajvGY1KVjYhB
	 XW6GNOoURwhir5Ko3mFOsF3A2/IOixOk0bRvqiezLMVcyJ27s4npOofcwqAANBZz/g
	 o8Wrxk/tqXgFA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Wed, 11 Oct 2023 13:21:51 -0700
Subject: [PATCH] ASoC: tegra: Fix -Wuninitialized in
 tegra210_amx_platform_probe()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231011-asoc-tegra-fix-uninit-soc_data-v1-1-0ef0ab44cf48@kernel.org>
X-B4-Tracking: v=1; b=H4sIAN4DJ2UC/x2NQQqAMAwEvyI5G2grIvgVEYlt1FyqtFUE8e8Gj
 zMssw9kTsIZ+uqBxJdk2aOCrSvwG8WVUYIyOOMaa6xFyrvHwmsiXOTGM0qUgiqnQEWdD2ZeWkN
 d40AjR2Kd/QfD+L4fw2s7k3AAAAA=
To: broonie@kernel.org, robh@kernel.org
Cc: lgirdwood@gmail.com, thierry.reding@gmail.com, jonathanh@nvidia.com, 
 ndesaulniers@google.com, trix@redhat.com, alsa-devel@alsa-project.org, 
 linux-tegra@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1815; i=nathan@kernel.org;
 h=from:subject:message-id; bh=oEPFEr69GOFnlvxRi+OQJiP0bTLBwUD6RP2Enyu8lR0=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDKnqzB88WXaLHs65y1J1srv9tdnW2KAIqa2lLzVmTw+t/
 aXNcU2go5SFQYyDQVZMkaX6sepxQ8M5ZxlvnJoEM4eVCWQIAxenAEzkVQ0jw4/wh6eyfp06I+s8
 L1XEO+GPR/N+s5y60A0X2YoMwxjeizD893I9Hef6XIDJYtaaUOO7zObp1vWV/Esu6ua4v7UT91J
 jAAA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns (or errors with CONFIG_WERROR=y):

  sound/soc/tegra/tegra210_amx.c:553:10: error: variable 'soc_data' is uninitialized when used here [-Werror,-Wuninitialized]
    553 |                                             soc_data->regmap_conf);
        |                                             ^~~~~~~~

A refactoring removed the initialization of this variable but its use
was not updated. Use the soc_data value in the amx variable to resolve
the warning and remove the soc_data variable, as it is now entirely
unused.

Closes: https://github.com/ClangBuiltLinux/linux/issues/1943
Fixes: 9958d85968ed ("ASoC: Use device_get_match_data()")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 sound/soc/tegra/tegra210_amx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/tegra/tegra210_amx.c b/sound/soc/tegra/tegra210_amx.c
index dd1a2c77c6ea..91e405909e0f 100644
--- a/sound/soc/tegra/tegra210_amx.c
+++ b/sound/soc/tegra/tegra210_amx.c
@@ -535,7 +535,6 @@ static int tegra210_amx_platform_probe(struct platform_device *pdev)
 	struct tegra210_amx *amx;
 	void __iomem *regs;
 	int err;
-	struct tegra210_amx_soc_data *soc_data;
 
 	amx = devm_kzalloc(dev, sizeof(*amx), GFP_KERNEL);
 	if (!amx)
@@ -550,7 +549,7 @@ static int tegra210_amx_platform_probe(struct platform_device *pdev)
 		return PTR_ERR(regs);
 
 	amx->regmap = devm_regmap_init_mmio(dev, regs,
-					    soc_data->regmap_conf);
+					    amx->soc_data->regmap_conf);
 	if (IS_ERR(amx->regmap)) {
 		dev_err(dev, "regmap init failed\n");
 		return PTR_ERR(amx->regmap);

---
base-commit: 59825951707eccf92782e109c04772d34fc07eb6
change-id: 20231011-asoc-tegra-fix-uninit-soc_data-fcd0bf50a732

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

