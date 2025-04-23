Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39464289351;
	Wed, 23 Apr 2025 15:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421708; cv=none; b=GO4LLhwFc1YvgVHFT1NV95nsTHyRdDzlekZKZ2KyCIHO2hDf8r25Ebh2YmTnwVtWYEFU0fJ2SNssyOUGubgZdw0+l0sCBBGT5Eh+JboYJKmjVdtlEvataAeZQd7wG2H1ABC0Tuj+rVZZo18DVIKeif52E2XW5ljSiCJ+Xrc+iWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421708; c=relaxed/simple;
	bh=WSp06tm0ahuBHnK0Fk+dVRCM0p17YkEJE+aNR+fosZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uXAqJLZ1hi2dzAMWK3HEuFNEh9+SyoWD8hyB8WTFN4ddG6EoBpQE/bO/R1JlxcSvO7OyeYgZWvt4dTa5gssRGmTFKm9rUnS3M+sFojj5QXNBsBOpgIM0fT4iBJQJlpqOXQGCl75L9f6daMHDbdEQCgj5rJ5xpV+YTjUK4+Huuno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hlXkvxos; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hlXkvxos"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF9FEC4CEE2;
	Wed, 23 Apr 2025 15:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421708;
	bh=WSp06tm0ahuBHnK0Fk+dVRCM0p17YkEJE+aNR+fosZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hlXkvxosvPVEvCpfFKY1VEtLmtCKMbX4hxMFN2LdnqThxfHOFFqbnxOxZpaqi1HKH
	 yCuO833pMcWzgbDqqwRXTmU71a1jSG/gBFQ/UA9o9Sz5dD1mLa7SopZFFeTXGa7ngj
	 a6S+2DrRtoyEnROX6hvGMzHU7gzYNLTKHmA2fqLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	Nicolas Chauvet <kwizart@gmail.com>,
	Damian Tometzki <damian@riscv-rocks.de>,
	Zhenyu Wang <zhenyuw.linux@gmail.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.14 205/241] drm/i915/gvt: fix unterminated-string-initialization warning
Date: Wed, 23 Apr 2025 16:44:29 +0200
Message-ID: <20250423142628.917877180@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gvt/opregion.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/gvt/opregion.c
+++ b/drivers/gpu/drm/i915/gvt/opregion.c
@@ -222,7 +222,6 @@ int intel_vgpu_init_opregion(struct inte
 	u8 *buf;
 	struct opregion_header *header;
 	struct vbt v;
-	const char opregion_signature[16] = OPREGION_SIGNATURE;
 
 	gvt_dbg_core("init vgpu%d opregion\n", vgpu->id);
 	vgpu_opregion(vgpu)->va = (void *)__get_free_pages(GFP_KERNEL |
@@ -236,8 +235,10 @@ int intel_vgpu_init_opregion(struct inte
 	/* emulated opregion with VBT mailbox only */
 	buf = (u8 *)vgpu_opregion(vgpu)->va;
 	header = (struct opregion_header *)buf;
-	memcpy(header->signature, opregion_signature,
-	       sizeof(opregion_signature));
+
+	static_assert(sizeof(header->signature) == sizeof(OPREGION_SIGNATURE) - 1);
+	memcpy(header->signature, OPREGION_SIGNATURE, sizeof(header->signature));
+
 	header->size = 0x8;
 	header->opregion_ver = 0x02000000;
 	header->mboxes = MBOX_VBT;


