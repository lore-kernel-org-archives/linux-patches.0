Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F34B7B;
	Wed, 20 Jul 2022 18:52:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53E43C3411E;
	Wed, 20 Jul 2022 18:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1658343160;
	bh=GCDUfLB7H+z3SYkt1egzk1J5ZvWGPLsC7cxT/eSNkNk=;
	h=From:To:Cc:Subject:Date:From;
	b=fYS0qQr8pQDEM7YmELk7Pwi49Oc5RmKt/wQVx4ema8Qh4kM19y5SV6b9rLDgTHB7e
	 zz4ohCy8OGMDr1Z2PXyjzjXVV6pnggMtEM/D895O6IAqEPYaHFf+/0iMrJ0MkxqobI
	 HpvCYb1kqEyce29M+KMk+9ugzfK96CgxTD27j0Nk8OHVJJTjlsKd36HYYl4DvbeG1f
	 1sG+qvZsCRCHT8vSs/vsaWdELt0DuLr4SCwQ5Qr3XCCnQxUJ9uMnDRA3gcdQOr2NgX
	 jlTqTHyw8BOQqNw84BwG4T5Xx78xKxS8fmkdMKiorZAS72McZeiY945myd/zfuVIGM
	 Qg1sEfJGIh6Uw==
From: Nathan Chancellor <nathan@kernel.org>
To: Cezary Rojewski <cezary.rojewski@intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@linux.intel.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>,
	alsa-devel@alsa-project.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH] ASoC: Intel: avs: Mark avs_path_module_type_create() as noinline
Date: Wed, 20 Jul 2022 11:52:28 -0700
Message-Id: <20220720185228.3182663-1-nathan@kernel.org>
X-Mailer: git-send-email 2.37.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When building ARCH=arm64 allmodconfig with clang, there is a warning
about high stack usage in avs_path_create(), which breaks the build due
to CONFIG_WERROR=y:

  sound/soc/intel/avs/path.c:815:18: error: stack frame size (2176) exceeds limit (2048) in 'avs_path_create' [-Werror,-Wframe-larger-than]
  struct avs_path *avs_path_create(struct avs_dev *adev, u32 dma_id,
                   ^
  1 error generated.

This warning is also visible with allmodconfig on other architectures.
The minimum set of configs that triggers this on top of ARCH=arm64
allnoconfig:

  CONFIG_COMPILE_TEST=y
  CONFIG_FORTIFY_SOURCE=y
  CONFIG_KASAN=y
  CONFIG_PCI=y
  CONFIG_SOUND=y
  CONFIG_SND=y
  CONFIG_SND_SOC=y
  CONFIG_SND_SOC_INTEL_AVS=y

When CONFIG_FORTIFY_SOURCE is enabled, memcmp() (called from
guid_equal()) becomes a wrapper to do compile time checking, which
interacts poorly with inlining plus CONFIG_KASAN=y.

With ARCH=arm64 allmodconfig + CONFIG_KASAN=n + CONFIG_FRAME_WARN=128,
the stack usage is much better:

  sound/soc/intel/avs/path.c:815:18: warning: stack frame size (624) exceeds limit (128) in 'avs_path_create' [-Wframe-larger-than]
  struct avs_path *avs_path_create(struct avs_dev *adev, u32 dma_id,
                   ^
  sound/soc/intel/avs/path.c:873:5: warning: stack frame size (144) exceeds limit (128) in 'avs_path_bind' [-Wframe-larger-than]
  int avs_path_bind(struct avs_path *path)
      ^
  2 warnings generated.

To avoid this warning, mark avs_path_module_type_create() as
noinline_for_stack, which redistributes the stack usage across multiple
functions, regardless of CONFIG_KASAN.

With ARCH=arm64 allmodconfig + CONFIG_FRAME_WARN=128, the warnings show:

  avs_path_create():             192
  avs_path_bind():               272
  avs_path_module_type_create(): 416
  avs_mux_create():              160
  avs_updown_mix_create():       160
  avs_aec_create():              176
  avs_asrc_create():             144

With ARCH=arm64 allmodconfig + CONFIG_FRAME_WARN=128 + CONFIG_KASAN=n,
the warnings show:

  avs_path_create():             192
  avs_path_bind():               144
  avs_path_module_type_create(): 416
  avs_mux_create():              176
  avs_updown_mix_create():       176
  avs_src_create():              144
  avs_aec_create():              192
  avs_asrc_create():             144
  avs_wov_create():              144

Link: https://github.com/ClangBuiltLinux/linux/issues/1642
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 sound/soc/intel/avs/path.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/intel/avs/path.c b/sound/soc/intel/avs/path.c
index 3d46dd5e5bc4..ec2aa0001f91 100644
--- a/sound/soc/intel/avs/path.c
+++ b/sound/soc/intel/avs/path.c
@@ -449,7 +449,8 @@ static int avs_modext_create(struct avs_dev *adev, struct avs_path_module *mod)
 	return ret;
 }
 
-static int avs_path_module_type_create(struct avs_dev *adev, struct avs_path_module *mod)
+static noinline_for_stack int avs_path_module_type_create(struct avs_dev *adev,
+							  struct avs_path_module *mod)
 {
 	const guid_t *type = &mod->template->cfg_ext->type;
 

base-commit: ff6992735ade75aae3e35d16b17da1008d753d28
-- 
2.37.1

