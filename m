Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B2E13AD18;
	Mon, 24 Feb 2025 14:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408368; cv=none; b=eMIR8FJsk4ynYfk3jG1tq/iajza4HOq+I7AYgTWAnNuI9VFRjUI2ADPBb0OpPef/SU1SKy8qjPNkKfAaK0IP4eAwXimNJynayf9LmAtzXwEhQ8lkU2qSmcUCyPEIzUanrI4NnttfmXNBp8VE7gF0spK/1Q83ind96ivZEML7tG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408368; c=relaxed/simple;
	bh=EkpL3Nf5l+woQWFikTHEnzgdc+1rH4XXm5lge8QNQqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sN3Ghk2o75OsEdSKBm/E0Z9KuBq+lCWW/SYd193fwj7ZY1UW+lA86hBZ4eXS4f0m7vnQmfuMY6AdOR8g6NmS4Ak2guphaclhfftuDBuvYBvVzDg7G2AM+roaYwQPNIrHjz2xJVui6bCOVOUx5qcSUeiHATHnBVR4tQkCDJXtbok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yMMkuJlR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yMMkuJlR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D47B8C4CED6;
	Mon, 24 Feb 2025 14:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408368;
	bh=EkpL3Nf5l+woQWFikTHEnzgdc+1rH4XXm5lge8QNQqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yMMkuJlRzgmkScbNKHPNOA2QvUxxPQUjR+F01vcfEBUCLldm4WifwUWcPWL1hBz7f
	 Mfg/hMHEqih8zjpecvsXzpoV4S3jSlQRefcLKoYQ9H5OmQtfVeuwogrmZe067EBq6g
	 6Wr3/4YwXWbwkupUsfSH1ae7p/ybpjXwnYgtw9IY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lancelot SIX <lancelot.six@amd.com>,
	Jay Cornwall <jay.cornwall@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 038/154] drm/amdkfd: Ensure consistent barrier state saved in gfx12 trap handler
Date: Mon, 24 Feb 2025 15:33:57 +0100
Message-ID: <20250224142608.581426028@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lancelot SIX <lancelot.six@amd.com>

[ Upstream commit d584198a6fe4c51f4aa88ad72f258f8961a0f11c ]

It is possible for some waves in a workgroup to finish their save
sequence before the group leader has had time to capture the workgroup
barrier state.  When this happens, having those waves exit do impact the
barrier state.  As a consequence, the state captured by the group leader
is invalid, and is eventually incorrectly restored.

This patch proposes to have all waves in a workgroup wait for each other
at the end of their save sequence (just before calling s_endpgm_saved).

Signed-off-by: Lancelot SIX <lancelot.six@amd.com>
Reviewed-by: Jay Cornwall <jay.cornwall@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.12.x
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/cwsr_trap_handler.h         | 3 ++-
 drivers/gpu/drm/amd/amdkfd/cwsr_trap_handler_gfx12.asm | 4 ++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/cwsr_trap_handler.h b/drivers/gpu/drm/amd/amdkfd/cwsr_trap_handler.h
index 02f7ba8c93cd4..7062f12b5b751 100644
--- a/drivers/gpu/drm/amd/amdkfd/cwsr_trap_handler.h
+++ b/drivers/gpu/drm/amd/amdkfd/cwsr_trap_handler.h
@@ -4117,7 +4117,8 @@ static const uint32_t cwsr_trap_gfx12_hex[] = {
 	0x0000ffff, 0x8bfe7e7e,
 	0x8bea6a6a, 0xb97af804,
 	0xbe804ec2, 0xbf94fffe,
-	0xbe804a6c, 0xbfb10000,
+	0xbe804a6c, 0xbe804ec2,
+	0xbf94fffe, 0xbfb10000,
 	0xbf9f0000, 0xbf9f0000,
 	0xbf9f0000, 0xbf9f0000,
 	0xbf9f0000, 0x00000000,
diff --git a/drivers/gpu/drm/amd/amdkfd/cwsr_trap_handler_gfx12.asm b/drivers/gpu/drm/amd/amdkfd/cwsr_trap_handler_gfx12.asm
index 1740e98c6719d..7b9d36e5fa437 100644
--- a/drivers/gpu/drm/amd/amdkfd/cwsr_trap_handler_gfx12.asm
+++ b/drivers/gpu/drm/amd/amdkfd/cwsr_trap_handler_gfx12.asm
@@ -1049,6 +1049,10 @@ L_SKIP_BARRIER_RESTORE:
 	s_rfe_b64	s_restore_pc_lo						//Return to the main shader program and resume execution
 
 L_END_PGM:
+	// Make sure that no wave of the workgroup can exit the trap handler
+	// before the workgroup barrier state is saved.
+	s_barrier_signal	-2
+	s_barrier_wait	-2
 	s_endpgm_saved
 end
 
-- 
2.39.5



