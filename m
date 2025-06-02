Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D122C3247;
	Mon,  2 Jun 2025 14:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874957; cv=none; b=k7aj23M4I0P6fPLxUyzUVCI0cWKDUsmXHXdemB4DlYOtAP1LUxgXzeq/3zIl7RaGu0+2tPcPhU30I8ekNb8PJYPagqtbHNNyjPB098yTsCn/OzKU7F8g+PSO44k+Z0BT6MvkgDT7rOJeSSfapMZkAzrP699du6VoD33a4Fx6qCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874957; c=relaxed/simple;
	bh=xCHGzJxzVe9x8z9R+s+3+x+cFASDtWorr/Q25oO17yY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X6p8xCyvmPKIKtiGC7wjV8TE+uknXietRDWoaEPZ62kyQpWjCPvSlacsw8kXz0zzySA0doJa0Gc9ROL/kFoxPqMv0OT1zN1GZQFFOZDCg4IkeLD8/Lar5XTzG0NI7khqs8lgavrEaThP8HXC7Pp2fzl3l5Dj/zHv0QOMz4tEB9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aV8rmafY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aV8rmafY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0C58C4CEEB;
	Mon,  2 Jun 2025 14:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874957;
	bh=xCHGzJxzVe9x8z9R+s+3+x+cFASDtWorr/Q25oO17yY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aV8rmafY5Ymk4jCHAoVoOhH9qIor8Tl9n8NjnuvHRhMP/C76fPZ//e3eWO0HpBLk7
	 xaW67kV+CZ/ly4E0gZI7DnB147Ta39lML1z8uT0ASAVRv1pDOr8yKT6JtsvQi9tWe6
	 cjCjg9zuynaS+mQsr3Y4RKfFXvjuSun5oRn08/O4=
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
Subject: [PATCH 5.4 188/204] drm/i915/gvt: fix unterminated-string-initialization warning
Date: Mon,  2 Jun 2025 15:48:41 +0200
Message-ID: <20250602134303.068114449@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -223,7 +223,8 @@ int intel_vgpu_init_opregion(struct inte
 	u8 *buf;
 	struct opregion_header *header;
 	struct vbt v;
-	const char opregion_signature[16] = OPREGION_SIGNATURE;
+
+	static_assert(sizeof(header->signature) == sizeof(OPREGION_SIGNATURE) - 1);
 
 	gvt_dbg_core("init vgpu%d opregion\n", vgpu->id);
 	vgpu_opregion(vgpu)->va = (void *)__get_free_pages(GFP_KERNEL |
@@ -237,8 +238,9 @@ int intel_vgpu_init_opregion(struct inte
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


