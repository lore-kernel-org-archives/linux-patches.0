Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C215146EF8C;
	Tue, 21 Jul 2026 19:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660718; cv=none; b=ZvakV4XBCrNggHWQsQDsbo0dSpVffPuZXKpu6sWRrJeYYkfinWg17Pu8IWn7vd7sitENQoGe63oaDVfUqCyiyKfOoOpH4mtdptTvWj7p8oqnjdhIw2Xn4QsKduy+WebIvvgkSCyt1yU5TNejHFYTCXTL4Xwb3WlriPRvD/0fMi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660718; c=relaxed/simple;
	bh=eKjwgnCC9CARKsThHLwURNskbhnei77jZurU0cz8WPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TCZEWStE50IPDxTrn37mcmMDl26oxD+Lkqumy7ek6tAZ6Ad90TKpTAUUfVQoBZO++jrvs2ibxlNZXG0n8JyYd+5fPhXqo3rwLfOEKMoPtEoQyyaQqYDFQ3rGti4RKltKx2k9E10wIV5NcbxeKWcIfbUNPOhHLBBBB+NLggKuiIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tKVjAG0W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tKVjAG0W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AA8A1F000E9;
	Tue, 21 Jul 2026 19:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660716;
	bh=9D2ZTWF/WyLDZZwIvMtBdMHelmWcpDaMOG5YVQCPd8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tKVjAG0WISx5zsMp+FGmUakvrHwfy7bqGEY82GpEm8Q1C2p3zB0USNFRhjQJ9kMOW
	 T0erWZTzq05yG0uD5I2ACOnmqD/LS35RmXq5AMUKTsijl/eofcqE/VIEbCnO4/9LNo
	 NQ+nEid9rhbtU9kGAm/HHZOpj5T1ps/VAm2uvCZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Atwood <matthew.s.atwood@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	intel-xe@lists.freedesktop.org,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1085/2077] drm/xe: Fix wa_oob codegen recipe for external module builds
Date: Tue, 21 Jul 2026 17:12:38 +0200
Message-ID: <20260721152618.413872507@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellström <thomas.hellstrom@linux.intel.com>

[ Upstream commit 92dc59ab2a09097cdf249e0288ff9b69261761c6 ]

When building with 'make M=drivers/gpu/drm/xe modules', kbuild invokes
scripts/Makefile.build with obj=., causing $(obj) to expand to '.'.
Make normalizes './xe_gen_wa_oob' to 'xe_gen_wa_oob' when constructing
the $^ automatic variable (target name normalization), so the recipe
command becomes just 'xe_gen_wa_oob ...' without any path prefix, and
the shell cannot find the tool.

Fix by replacing $^ with explicit $(obj)/xe_gen_wa_oob and
$(src)/<rules-file> references in both wa_oob recipe commands.
In recipe strings, make does not apply target name normalization, so
$(obj)/xe_gen_wa_oob correctly expands to './xe_gen_wa_oob' and the
shell can execute it. This matches the pattern already used by other
DRM drivers (e.g. radeon's mkregtable).

Fixes: f037e0b78e6d ("drm/xe: add xe_device_wa infrastructure")
Cc: Matt Atwood <matthew.s.atwood@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: intel-xe@lists.freedesktop.org
Assisted-by: GitHub_Copilot:claude-sonnet-4.6
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patch.msgid.link/20260604074501.172129-1-thomas.hellstrom@linux.intel.com
(cherry picked from commit 3a11a63cc16660d514ff584e7551589655337e87)
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/Makefile b/drivers/gpu/drm/xe/Makefile
index 03242e8b3d876c..de36c8b640bafc 100644
--- a/drivers/gpu/drm/xe/Makefile
+++ b/drivers/gpu/drm/xe/Makefile
@@ -16,14 +16,14 @@ subdir-ccflags-y += -I$(obj) -I$(src)
 hostprogs := xe_gen_wa_oob
 generated_oob := $(obj)/generated/xe_wa_oob.c $(obj)/generated/xe_wa_oob.h
 quiet_cmd_wa_oob = GEN     $(notdir $(generated_oob))
-      cmd_wa_oob = mkdir -p $(@D); $^ $(generated_oob)
+      cmd_wa_oob = mkdir -p $(@D); $(obj)/xe_gen_wa_oob $(src)/xe_wa_oob.rules $(generated_oob)
 $(obj)/generated/%_wa_oob.c $(obj)/generated/%_wa_oob.h: $(obj)/xe_gen_wa_oob \
 		 $(src)/xe_wa_oob.rules
 	$(call cmd,wa_oob)
 
 generated_device_oob := $(obj)/generated/xe_device_wa_oob.c $(obj)/generated/xe_device_wa_oob.h
 quiet_cmd_device_wa_oob = GEN	$(notdir $(generated_device_oob))
-      cmd_device_wa_oob = mkdir -p $(@D); $^ $(generated_device_oob)
+      cmd_device_wa_oob = mkdir -p $(@D); $(obj)/xe_gen_wa_oob $(src)/xe_device_wa_oob.rules $(generated_device_oob)
 $(obj)/generated/%_device_wa_oob.c $(obj)/generated/%_device_wa_oob.h: $(obj)/xe_gen_wa_oob \
 		 $(src)/xe_device_wa_oob.rules
 	$(call cmd,device_wa_oob)
-- 
2.53.0



