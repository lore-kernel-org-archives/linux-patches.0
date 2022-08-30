Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8E9633;
	Tue, 30 Aug 2022 20:34:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F2F2C433C1;
	Tue, 30 Aug 2022 20:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1661891676;
	bh=DfR/G5R+/i4IGeP9oz9qCc8ZMrsJlvx/ukbT3FiHPoI=;
	h=From:To:Cc:Subject:Date:From;
	b=mnaMWCzbbcfeyiupmZgbLCEoUy8vyWotQN8moBXa8saLp2aEBIF6uKUwF9NHocwmw
	 4Uk+yN+ZY/Y0xCHq1uFl1UoOrJPxBx18zzNBkw5EHjgnBo8q6e8Cne/8p4KzGJePnc
	 QQhUAkdfQ6JvCPO3VG2OhnucfVuWVZqPORvHqaUK+l7ZNpW5QypBysB8Ps2OpHEchA
	 D0l3T+lI7a3hyvgTiMqZE+VPdi+Ct8+Q6MvG4ETq/mJU3MCB+0ALf93DeAd0ojtwLK
	 0l2Gxs2AkI1zftGzXBcHNjby7CTVrsttepidLpDkN6iU2Db4JNs5uSC9sG5ZEn+ZV3
	 CRv1IX5A0UM4g==
From: Nathan Chancellor <nathan@kernel.org>
To: Harry Wentland <harry.wentland@amd.com>,
	Leo Li <sunpeng.li@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	"Pan, Xinhui" <Xinhui.Pan@amd.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	llvm@lists.linux.dev,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 0/5] drm/amd/display: Reduce stack usage for clang
Date: Tue, 30 Aug 2022 13:34:04 -0700
Message-Id: <20220830203409.3491379-1-nathan@kernel.org>
X-Mailer: git-send-email 2.37.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This series aims to address the following warnings, which are visible
when building x86_64 allmodconfig with clang after commit 3876a8b5e241
("drm/amd/display: Enable building new display engine with KCOV
enabled").

    drivers/gpu/drm/amd/amdgpu/../display/dc/dml/dcn30/display_mode_vba_30.c:3542:6: error: stack frame size (2200) exceeds limit (2048) in 'dml30_ModeSupportAndSystemConfigurationFull' [-Werror,-Wframe-larger-than]
    void dml30_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode_lib)
        ^
    1 error generated.

    drivers/gpu/drm/amd/amdgpu/../display/dc/dml/dcn31/display_mode_vba_31.c:3908:6: error: stack frame size (2216) exceeds limit (2048) in 'dml31_ModeSupportAndSystemConfigurationFull' [-Werror,-Wframe-larger-than]
    void dml31_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode_lib)
        ^
    1 error generated.

    drivers/gpu/drm/amd/amdgpu/../display/dc/dml/dcn32/display_mode_vba_32.c:1721:6: error: stack frame size (2152) exceeds limit (2048) in 'dml32_ModeSupportAndSystemConfigurationFull' [-Werror,-Wframe-larger-than]
    void dml32_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode_lib)
        ^
    1 error generated.

This series is based on commit b3235e8635e1 ("drm/amd/display: clean up
some inconsistent indentings"). These warnings are fatal for
allmodconfig due to CONFIG_WERROR so ideally, I would like to see these
patches cherry-picked to a branch targeting mainline to allow our builds
to go back to green. However, since this series is not exactly trivial
in size, I can understand not wanting to apply these to mainline during
the -rc cycle. If they cannot be cherry-picked to mainline, I can add a
patch raising the value of -Wframe-larger-than for these files that can
be cherry-picked to 6.0/mainline then add a revert of that change as the
last patch in the stack so everything goes back to normal for -next/6.1.
I am open to other options though!

I have built this series against clang 16.0.0 (ToT) and GCC 12.2.0 for
x86_64. It has seen no runtime testing, as my only test system with AMD
graphics is a Renoir one, which as far as I understand it uses DCN 2.1.

Nathan Chancellor (5):
  drm/amd/display: Reduce number of arguments of
    dml32_CalculateWatermarksMALLUseAndDRAMSpeedChangeSupport()
  drm/amd/display: Reduce number of arguments of
    dml32_CalculatePrefetchSchedule()
  drm/amd/display: Reduce number of arguments of dml31's
    CalculateWatermarksAndDRAMSpeedChangeSupport()
  drm/amd/display: Reduce number of arguments of dml31's
    CalculateFlipSchedule()
  drm/amd/display: Mark dml30's UseMinimumDCFCLK() as noinline for stack
    usage

 .../dc/dml/dcn30/display_mode_vba_30.c        |   2 +-
 .../dc/dml/dcn31/display_mode_vba_31.c        | 420 +++++-------------
 .../dc/dml/dcn32/display_mode_vba_32.c        | 236 +++-------
 .../dc/dml/dcn32/display_mode_vba_util_32.c   | 323 ++++++--------
 .../dc/dml/dcn32/display_mode_vba_util_32.h   |  51 +--
 5 files changed, 318 insertions(+), 714 deletions(-)


base-commit: b3235e8635e1dd7ac1a27a73330e9880dfe05154
-- 
2.37.2

