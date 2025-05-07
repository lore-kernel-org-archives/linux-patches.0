Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8B328DF4C;
	Wed,  7 May 2025 19:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644414; cv=none; b=bMURApE/d2LihUPUlMIBVfgqRD478NWaFpT4p16DitB400MrqEZQxF09bBK5QGLqEtwaqigY9OKpt/1luNxabJ3ZGGwsoP1ZMoVHOYaUxfLF/8y05l/f9TjjfgAVbfY7s3HcqUN2KACpo5BLhrJ9tRWwcn4HwSwl4tDwYESuFB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644414; c=relaxed/simple;
	bh=eewazFdU/+nPPJKUS62Lk9tur6LRcy7hFVRXSH2Unno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YAkObihrmmmXmKDcoD88J1etjsAwMeb1CtsZY4SD9EQj3+IkB+xprUwb7wjFuwPeaiTTxtNn1nTKeCGrTbvL2Xy5tCfTb0faQ2TjGmW0jFb32zAZCpvGRLR0up5oI3w4uF/pVKR1M/vrNnIregPrhADVmnMndLhkZINKYjY6kCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rhRLozQ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rhRLozQ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB577C4CEE2;
	Wed,  7 May 2025 19:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644414;
	bh=eewazFdU/+nPPJKUS62Lk9tur6LRcy7hFVRXSH2Unno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rhRLozQ74PNCNAF4SGJdv7GKinFsiZtXnnLeabda9+EWOzVxFOBY9YVdh6BlNAYkd
	 7F8m9TvGnNnduxHdR9vIwNsJWNWYkD63rKKBhxaZXTzkqGe/4iVAPCZ9ALWh1THGOF
	 iGrLomPjuDa/I1ZihrJ02NbeFKkTHdmprZFtCTbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janne Grunau <j@jannau.net>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>
Subject: [PATCH 6.12 036/164] drm: Select DRM_KMS_HELPER from DRM_DEBUG_DP_MST_TOPOLOGY_REFS
Date: Wed,  7 May 2025 20:38:41 +0200
Message-ID: <20250507183822.340467890@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

From: Janne Grunau <j@jannau.net>

commit 32dce6b1949a696dc7abddc04de8cbe35c260217 upstream.

Using "depends on" and "select" for the same Kconfig symbol is known to
cause circular dependencies (cmp. "Kconfig recursive dependency
limitations" in Documentation/kbuild/kconfig-language.rst.
DRM drivers are selecting drm helpers so do the same for
DRM_DEBUG_DP_MST_TOPOLOGY_REFS.
Fixes following circular dependency reported on x86 for the downstream
Asahi Linux tree:

error: recursive dependency detected!
  symbol DRM_KMS_HELPER is selected by DRM_GEM_SHMEM_HELPER
  symbol DRM_GEM_SHMEM_HELPER is selected by RUST_DRM_GEM_SHMEM_HELPER
  symbol RUST_DRM_GEM_SHMEM_HELPER is selected by DRM_ASAHI
  symbol DRM_ASAHI depends on RUST
  symbol RUST depends on CALL_PADDING
  symbol CALL_PADDING depends on OBJTOOL
  symbol OBJTOOL is selected by STACK_VALIDATION
  symbol STACK_VALIDATION depends on UNWINDER_FRAME_POINTER
  symbol UNWINDER_FRAME_POINTER is part of choice block at arch/x86/Kconfig.debug:224
  symbol <choice> unknown is visible depending on UNWINDER_GUESS
  symbol UNWINDER_GUESS prompt is visible depending on STACKDEPOT
  symbol STACKDEPOT is selected by DRM_DEBUG_DP_MST_TOPOLOGY_REFS
  symbol DRM_DEBUG_DP_MST_TOPOLOGY_REFS depends on DRM_KMS_HELPER

Fixes: 12a280c72868 ("drm/dp_mst: Add topology ref history tracking for debugging")
Cc: stable@vger.kernel.org
Signed-off-by: Janne Grunau <j@jannau.net>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://lore.kernel.org/r/20250304-drm_debug_dp_mst_topo_kconfig-v1-1-e16fd152f258@jannau.net
Signed-off-by: Alyssa Rosenzweig <alyssa@rosenzweig.io>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -185,7 +185,7 @@ config DRM_DEBUG_DP_MST_TOPOLOGY_REFS
         bool "Enable refcount backtrace history in the DP MST helpers"
 	depends on STACKTRACE_SUPPORT
         select STACKDEPOT
-        depends on DRM_KMS_HELPER
+        select DRM_KMS_HELPER
         depends on DEBUG_KERNEL
         depends on EXPERT
         help


