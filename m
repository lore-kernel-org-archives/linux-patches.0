Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 038D61C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:53:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 824BCC433D2;
	Wed, 28 Dec 2022 16:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672246405;
	bh=H23P28i1Gic5S2PHT2F+yKYlAsBVwd2RVFgih08qvJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UIPwd/8Oz/aTsS/RweFKlNfzc4w3oFNBiQsdpFKVqJ4EJCoBTwcAa9OVbEQwm5ruV
	 Lgcs8AsMI/Z8MByEu56mu5zmVc1ci2qucgafjlgRm6DlxDeGOxoKroQQ4xLFmT2Wi4
	 jsdMnlxIA/K6+SjgFqotym+Bwe8pp4HE8poqs7Mw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sami Tolvanen <samitolvanen@google.com>,
	Kees Cook <keescook@chromium.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0996/1146] drm/amdgpu: Fix type of second parameter in odn_edit_dpm_table() callback
Date: Wed, 28 Dec 2022 15:42:15 +0100
Message-Id: <20221228144357.421887526@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit e4d0ef752081e7aa6ffb7ccac11c499c732a2e05 ]

With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
indirect call targets are validated against the expected function
pointer prototype to make sure the call target is valid to help mitigate
ROP attacks. If they are not identical, there is a failure at run time,
which manifests as either a kernel panic or thread getting killed. A
proposed warning in clang aims to catch these at compile time, which
reveals:

  drivers/gpu/drm/amd/amdgpu/../pm/swsmu/amdgpu_smu.c:3008:29: error: incompatible function pointer types initializing 'int (*)(void *, uint32_t, long *, uint32_t)' (aka 'int (*)(void *, unsigned int, long *, unsigned int)') with an expression of type 'int (void *, enum PP_OD_DPM_TABLE_COMMAND, long *, uint32_t)' (aka 'int (void *, enum PP_OD_DPM_TABLE_COMMAND, long *, unsigned int)') [-Werror,-Wincompatible-function-pointer-types-strict]
          .odn_edit_dpm_table      = smu_od_edit_dpm_table,
                                     ^~~~~~~~~~~~~~~~~~~~~
  1 error generated.

There are only two implementations of ->odn_edit_dpm_table() in 'struct
amd_pm_funcs': smu_od_edit_dpm_table() and pp_odn_edit_dpm_table(). One
has a second parameter type of 'enum PP_OD_DPM_TABLE_COMMAND' and the
other uses 'u32'. Ultimately, smu_od_edit_dpm_table() calls
->od_edit_dpm_table() from 'struct pptable_funcs' and
pp_odn_edit_dpm_table() calls ->odn_edit_dpm_table() from 'struct
pp_hwmgr_func', which both have a second parameter type of 'enum
PP_OD_DPM_TABLE_COMMAND'.

Update the type parameter in both the prototype in 'struct amd_pm_funcs'
and pp_odn_edit_dpm_table() to 'enum PP_OD_DPM_TABLE_COMMAND', which
cleans up the warning.

Link: https://github.com/ClangBuiltLinux/linux/issues/1750
Reported-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/include/kgd_pp_interface.h   | 3 ++-
 drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/include/kgd_pp_interface.h b/drivers/gpu/drm/amd/include/kgd_pp_interface.h
index a40ead44778a..d18162e9ed1d 100644
--- a/drivers/gpu/drm/amd/include/kgd_pp_interface.h
+++ b/drivers/gpu/drm/amd/include/kgd_pp_interface.h
@@ -354,7 +354,8 @@ struct amd_pm_funcs {
 	int (*get_power_profile_mode)(void *handle, char *buf);
 	int (*set_power_profile_mode)(void *handle, long *input, uint32_t size);
 	int (*set_fine_grain_clk_vol)(void *handle, uint32_t type, long *input, uint32_t size);
-	int (*odn_edit_dpm_table)(void *handle, uint32_t type, long *input, uint32_t size);
+	int (*odn_edit_dpm_table)(void *handle, enum PP_OD_DPM_TABLE_COMMAND type,
+				  long *input, uint32_t size);
 	int (*set_mp1_state)(void *handle, enum pp_mp1_state mp1_state);
 	int (*smu_i2c_bus_access)(void *handle, bool acquire);
 	int (*gfx_state_change_set)(void *handle, uint32_t state);
diff --git a/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c b/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
index ec055858eb95..1159ae114dd0 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
@@ -838,7 +838,8 @@ static int pp_set_fine_grain_clk_vol(void *handle, uint32_t type, long *input, u
 	return hwmgr->hwmgr_func->set_fine_grain_clk_vol(hwmgr, type, input, size);
 }
 
-static int pp_odn_edit_dpm_table(void *handle, uint32_t type, long *input, uint32_t size)
+static int pp_odn_edit_dpm_table(void *handle, enum PP_OD_DPM_TABLE_COMMAND type,
+				 long *input, uint32_t size)
 {
 	struct pp_hwmgr *hwmgr = handle;
 
-- 
2.35.1



