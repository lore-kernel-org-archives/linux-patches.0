Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E273D4735F
	for <patches@lists.linux.dev>; Wed, 18 Oct 2023 18:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lJ+8nHQx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5380C433C8;
	Wed, 18 Oct 2023 18:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1697654760;
	bh=6q0NVgwgwUSFconmvxRIK81m+6tWetcDjiHlH6YuS6M=;
	h=From:Date:Subject:To:Cc:From;
	b=lJ+8nHQxdOL3WZ01wJHJt5KOpQdwQtLHvAsenLHa+M/TEBMxCjt+pluOqJQSOwEmu
	 sTt/KxqA5uKL7uq9Fz1/hOlqkf47sxIHd4xYwqIiq35djCGKYW5hfRykm3uH5OZWAz
	 ZUXaLTfdsCEQ+mpk8nhGmArX8nWyBeEB9qeIV2yL3tvCMPtVKPncxH1r7UKYGu5xra
	 iL9wnbzHmYWueAFgXwWAtwrCOkWUanizsSaJI7sz9LI7KrLdFHyxFyqLDO5EIQtSNn
	 bhwSPnuU96dcB07hbJvQj0m0xASsbujQS8JXsK0LcnZSZ4gDEYc1gYTuwCSRYTflbI
	 1MgnYbkYjWs/g==
From: Nathan Chancellor <nathan@kernel.org>
Date: Wed, 18 Oct 2023 11:45:52 -0700
Subject: [PATCH] drm/amd/display: Respect CONFIG_FRAME_WARN=0 in DML2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231018-amdgpu-dml2-respect-frame_warn-v1-1-43ec8d153743@kernel.org>
X-B4-Tracking: v=1; b=H4sIAN8nMGUC/x3NQQrCMBBG4auUWTuQpFisVxGRmPytAyaGidpC6
 d0NLr/NextVqKDSudtI8ZUqr9xgDx2Fh88zWGIzOeN6a+yJfYpz+XBMT8eKWhDePKlPuC1eMx/
 7AXa8D2OAoRYpiknW/+By3fcf0IbsZnAAAAA=
To: harry.wentland@amd.com, sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com, 
 alexander.deucher@amd.com, christian.koenig@amd.com, Xinhui.Pan@amd.com
Cc: amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1527; i=nathan@kernel.org;
 h=from:subject:message-id; bh=6q0NVgwgwUSFconmvxRIK81m+6tWetcDjiHlH6YuS6M=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDKkG6s+3eTU/Y01b7c5vu2jmz0Vu3/YKMeZlfetO45KYp
 mM6/fDzjlIWBjEOBlkxRZbqx6rHDQ3nnGW8cWoSzBxWJpAhDFycAjARBgeGPxyxD24oRE30zBM/
 enlzy6raKMubt+ZnqK9YIbMu+hfXpDuMDAsOpeyzLGutPurmtuxA9L+vG/XuL1lrsHJlpniV3t/
 DRpwA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

display_mode_code.c is unconditionally built with
-Wframe-larger-than=2048, which causes warnings even when
CONFIG_FRAME_WARN has been set to 0, which should show no warnings.

Use the existing $(frame_warn_flag) variable, which handles this
situation. This is basically commit 25f178bbd078 ("drm/amd/display:
Respect CONFIG_FRAME_WARN=0 in dml Makefile") but for DML2.

Fixes: 7966f319c66d ("drm/amd/display: Introduce DML2")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml2/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/Makefile b/drivers/gpu/drm/amd/display/dc/dml2/Makefile
index f35ed8de260d..66431525f2a0 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dml2/Makefile
@@ -61,7 +61,7 @@ ifneq ($(CONFIG_FRAME_WARN),0)
 frame_warn_flag := -Wframe-larger-than=2048
 endif
 
-CFLAGS_$(AMDDALPATH)/dc/dml2/display_mode_core.o := $(dml2_ccflags) -Wframe-larger-than=2048
+CFLAGS_$(AMDDALPATH)/dc/dml2/display_mode_core.o := $(dml2_ccflags) $(frame_warn_flag)
 CFLAGS_$(AMDDALPATH)/dc/dml2/display_mode_util.o := $(dml2_ccflags)
 CFLAGS_$(AMDDALPATH)/dc/dml2/dml2_wrapper.o := $(dml2_ccflags)
 CFLAGS_$(AMDDALPATH)/dc/dml2/dml2_utils.o := $(dml2_ccflags)

---
base-commit: cd90511557fdfb394bb4ac4c3b539b007383914c
change-id: 20231018-amdgpu-dml2-respect-frame_warn-536e19b69ce0

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

