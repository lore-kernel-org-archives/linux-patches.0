Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F80E47125A;
	Tue, 21 Jul 2026 18:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657503; cv=none; b=VD64REIfXCP5TsQSCTl69oJy7QVP8VQB0zZCAtx/C/fLH5o701/uFED6MCLp424GLQFDbVjRkrGyFwQbUwkfEQtELUUpj6A3nSHQb3WegIGC9jPU4UT4w4+cmYipin1G9dp8+7Q6RDbz/S283SQTCPNhvpX+Fe2xXkCEk4cSCXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657503; c=relaxed/simple;
	bh=SPZ5/yQcDaUfOSzzoR8Lz2vh5ByXzbx9BLJwL2sMx0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TDnh4qyo9cnmaId3oE6LnMhQCSMca2ZpK2OomsSZ8GqiDCyBsjEFBlglrfNakR2t3ax5QD30ziXPIbJ8rwVX75www9TeUpAKRLlk4kzJ3TcaSOp8u7uZBcKmS7uUluKoJwNGVbjsHaN4dCGF/XBUwkNaQ9immWn1PJZ7BZt1EG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=veLuYuu9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="veLuYuu9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02BED1F000E9;
	Tue, 21 Jul 2026 18:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657502;
	bh=yxXbOYyefm4tMQGpip/RBQtGHxsqErYuQpaM7QICW7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=veLuYuu9dEt8vJv67AEV1afrB4/DdaMEdq3TsiVPs0qerUeRcIBef9tJIs8vLAAM8
	 N1fRtQiEbg1om5zV0GpV5copR/EnVgHbG/rIBE9dyJ0b1aNdNoisehBrwbhCZKXClR
	 DhlnzK7obEeBfIV2npw64T1vXjdJ1ocndc20W2Cg=
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
Subject: [PATCH 6.18 0787/1611] drm/xe: Fix wa_oob codegen recipe for external module builds
Date: Tue, 21 Jul 2026 17:15:03 +0200
Message-ID: <20260721152533.090304322@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index d9c6cf0f189efb..ee52b751623f0c 100644
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



