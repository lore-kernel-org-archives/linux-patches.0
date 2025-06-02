Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3E01FF61E;
	Mon,  2 Jun 2025 15:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876559; cv=none; b=qXcjyPUOWeXB+KzHVj6W3RDeNfHFGNsR4HGLaouEJVmN0jqznyRYgtSCNauadzMBA2qvASIUdCmYhgo6fwMR/L7HH/eX4gU4wx7vAvvDvKtHozgXNP/Jiv9Xqs7YGTUfVdFhjgm9pWktC/ClGrfi4aY95swrk9IJHh79HU2jKBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876559; c=relaxed/simple;
	bh=u/bmYzTTdEkNpShzUcorhswNbPKJI373i3LLnpfSxKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tXZE0pRA4d+bIn8TySMcFkT6dp2PruquB9QCDHRcJoL5UcXxKpZOek9rG9qe+5uu7btW/K+yUWujQduORkNUSdtOpO7r7A1es0paarH5RdE8o6/8hGdYNjSEWam6MzVq0SFBtORBZTaU4Z9SeCPDIqfsun1DORDROkkvFNLsQBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0o0dfhFk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0o0dfhFk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85F46C4CEEB;
	Mon,  2 Jun 2025 15:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876559;
	bh=u/bmYzTTdEkNpShzUcorhswNbPKJI373i3LLnpfSxKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0o0dfhFkfPqOWSigkJl57ICjm5xQW56bPLkb1XwuZXlL69zsynrmDoSso7xYtdQ/L
	 mnycDt6c3Wywpf8V3cS5HNhCn1+8IvPV1M7V0md6F9hSQqOTXx5Mp1WOeoBqn3wYa6
	 onkiTTeEnqT9Q0saYQroqPnAMc3KraVnNdpVtr0c=
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
Subject: [PATCH 5.15 188/207] drm/i915/gvt: fix unterminated-string-initialization warning
Date: Mon,  2 Jun 2025 15:49:20 +0200
Message-ID: <20250602134306.131826933@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


