Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0205741C71;
	Mon,  2 Jun 2025 14:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875819; cv=none; b=gzZgStMC/hIbUkQni2+eGwa8IWIginkowJ1Ra9gn+rCkTSzaZ5fHKLjwIy0dDRPUwTvDBwtTmmymP2qXPQs3SFAouAy1ae0Tg15nCPPTCL8m46CYNo9mesnTTbrTLjZ4fZgmFfcXlVeIKDZ/MM2g7CBvDJ3GDrGv2HCTwvvDe5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875819; c=relaxed/simple;
	bh=ko2il6OnvEjKxYzGtcOpEv75dnGrYNV8UNomT7vcGVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S8qimo4W5rucCLxMDieEsEpD7JCtfcXcVqW5Bm/LtARWSNgWiGY/tutdzofoFOlSpDMMYSqXMzCEVPOkH9nSzHW6qpMSTG1W/MTrdyG5hNofNvJQLzCqc83pPL3DnjLnhZykixj7PWTzRlIfM1nhZiBRv2iuKQNoCY7RY2Qh4cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IApfpOh5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IApfpOh5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65F42C4CEEB;
	Mon,  2 Jun 2025 14:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875818;
	bh=ko2il6OnvEjKxYzGtcOpEv75dnGrYNV8UNomT7vcGVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IApfpOh5JeNpW3Obi+4xhtZBMZLJiXIS0dDTTjHzo7OX8uvlZAO8BlHfhQZ47cCQI
	 K1etnXf864VLiNI66E1OcEw0OeMscFRTaKfZMp197J67VcUbWA2kXmZCSr7Dv9bxKv
	 M+OOUnooY3njn+jv0apZOz6tZXSLUs0i1V2vlTw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	Nicolas Chauvet <kwizart@gmail.com>,
	Damian Tometzki <damian@riscv-rocks.de>,
	Zhenyu Wang <zhenyuw.linux@gmail.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.10 253/270] drm/i915/gvt: fix unterminated-string-initialization warning
Date: Mon,  2 Jun 2025 15:48:58 +0200
Message-ID: <20250602134317.679903957@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit 2e43ae7dd71cd9bb0d1bce1d3306bf77523feb81 upstream.

Initializing const char opregion_signature[16] = OPREGION_SIGNATURE
(which is "IntelGraphicsMem") drops the NUL termination of the
string. This is intentional, but the compiler doesn't know this.

Switch to initializing header->signature directly from the string
litaral, with sizeof destination rather than source. We don't treat the
signature as a string other than for initialization; it's really just a
blob of binary data.

Add a static assert for good measure to cross-check the sizes.

Reported-by: Kees Cook <kees@kernel.org>
Closes: https://lore.kernel.org/r/20250310222355.work.417-kees@kernel.org
Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/13934
Tested-by: Nicolas Chauvet <kwizart@gmail.com>
Tested-by: Damian Tometzki <damian@riscv-rocks.de>
Cc: stable@vger.kernel.org
Reviewed-by: Zhenyu Wang <zhenyuw.linux@gmail.com>
Link: https://lore.kernel.org/r/20250327124739.2609656-1-jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit 4f8207469094bd04aad952258ceb9ff4c77b6bfa)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
[nathan: Move static_assert() to top of function to avoid instance of
         -Wdeclaration-after-statement due to lack of b5ec6fd286df]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gvt/opregion.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/gvt/opregion.c
+++ b/drivers/gpu/drm/i915/gvt/opregion.c
@@ -222,7 +222,8 @@ int intel_vgpu_init_opregion(struct inte
 	u8 *buf;
 	struct opregion_header *header;
 	struct vbt v;
-	const char opregion_signature[16] = OPREGION_SIGNATURE;
+
+	static_assert(sizeof(header->signature) == sizeof(OPREGION_SIGNATURE) - 1);
 
 	gvt_dbg_core("init vgpu%d opregion\n", vgpu->id);
 	vgpu_opregion(vgpu)->va = (void *)__get_free_pages(GFP_KERNEL |
@@ -236,8 +237,9 @@ int intel_vgpu_init_opregion(struct inte
 	/* emulated opregion with VBT mailbox only */
 	buf = (u8 *)vgpu_opregion(vgpu)->va;
 	header = (struct opregion_header *)buf;
-	memcpy(header->signature, opregion_signature,
-	       sizeof(opregion_signature));
+
+	memcpy(header->signature, OPREGION_SIGNATURE, sizeof(header->signature));
+
 	header->size = 0x8;
 	header->opregion_ver = 0x02000000;
 	header->mboxes = MBOX_VBT;


