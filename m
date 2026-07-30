Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6973D75C4;
	Thu, 30 Jul 2026 14:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422521; cv=none; b=HYZENXvtjb3V2i3jjH2RGJxPsqL/nCBUqrGLD8kjR3UoXhOOMdh8lBzKo3kXFDddbzHtxiQKdmSCGnOvn3gjAsCGI5X2GTanPLskrfasJwCrmqMLxFGZyBUj/qnBxpRaxhow68J8v1zM2ClF/J3QvOop/FH29md7CwGUYivXxqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422521; c=relaxed/simple;
	bh=TD5Yzyg/j/uGXC9JZGRXOwH3hHZLdA3vfPSMvH2mIQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ei/fUSNnS7o19HerYTS+5JBCJBrm/Lz8rto7+Ek+j3ycntXCCIljTiOcVid6GynG7NZ2bWd3wqKOlwByZOERKe7178R50H2Hprjq2SwjGGxBZLmOV+JcW5QmRPXvWiJ22riiCCaw5BzprzUTtMlbnI/NQvty2HL6r96xo5wWkSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qVUDtFz6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qVUDtFz6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4478F1F000E9;
	Thu, 30 Jul 2026 14:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422519;
	bh=SY5vhOSmxyOJrT0EnaFPcSYJBHsyJQg1g6jS0Hy6PBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qVUDtFz6XhgbKRorknXxEfm3Cl/qLQzd/GO/0E0ktPG5dZZkFNp/JXtP68/dKawYG
	 6aLjO5gcdBWr7M5Tbv6vHZ29vHSEjiavXhBsRgEK44T5b4pMbnQk+0F83flGrNOLY3
	 olEaRqUa1iMJjgMELxzO/1OGJhTZLwHDtHWXf13U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Linmao Li <lilinmao@kylinos.cn>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>
Subject: [PATCH 7.1 468/744] drm/vc4: Prevent shader BO mappings from becoming writable
Date: Thu, 30 Jul 2026 16:12:21 +0200
Message-ID: <20260730141454.244931181@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

From: Linmao Li <lilinmao@kylinos.cn>

commit 0c9e6367639548307d3f578f6943ce72c9d39087 upstream.

vc4_gem_object_mmap() rejects a writable mapping of a validated shader
BO, but leaves VM_MAYWRITE set.  Userspace can map the BO read-only and
then turn it writable with mprotect().

Validated shader BOs must stay read-only: the validator checks the
instructions once and the GPU trusts them afterwards.  A writable
mapping lets userspace rewrite the code after validation, bypassing the
validator.

Clear VM_MAYWRITE on the read-only path so the mapping cannot be
upgraded, as i915 already does for its read-only objects.

Fixes: 463873d57014 ("drm/vc4: Add an API for creating GPU shaders in GEM BOs.")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/dri-devel/20260720085554.B0AF01F000E9@smtp.kernel.org/
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Link: https://patch.msgid.link/20260721011558.1672477-1-lilinmao@kylinos.cn
Reviewed-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vc4/vc4_bo.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/vc4/vc4_bo.c
+++ b/drivers/gpu/drm/vc4/vc4_bo.c
@@ -733,9 +733,13 @@ static int vc4_gem_object_mmap(struct dr
 {
 	struct vc4_bo *bo = to_vc4_bo(obj);
 
-	if (bo->validated_shader && (vma->vm_flags & VM_WRITE)) {
-		DRM_DEBUG("mmapping of shader BOs for writing not allowed.\n");
-		return -EINVAL;
+	if (bo->validated_shader) {
+		if (vma->vm_flags & VM_WRITE) {
+			DRM_DEBUG("mmapping of shader BOs for writing not allowed.\n");
+			return -EINVAL;
+		}
+
+		vm_flags_clear(vma, VM_MAYWRITE);
 	}
 
 	mutex_lock(&bo->madv_lock);


