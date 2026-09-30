Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A9B30FC27;
	Wed, 30 Sep 2026 17:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787623; cv=none; b=jK0l29K0+AmbNRM22l91NWrAdpYFlls7oV02e2kcktDjpO/bZpUHJJ8qYIYVYHzCE4RQUyFpk1UwzACnIRPgtkVFYJnGdrc44BMD50SolLwZKusYwa8zB6ipQy4MmIGUt8981pyDP2rE0LCe6DSefOrfUUI4Ce049PuwFswPrA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787623; c=relaxed/simple;
	bh=2MqgFV0xuDtk/WFc8Iyq+YWvs67/VHL/QE1lj5D41b8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RYYwlwdqDHAw5nleodX8/GQSv1/Bp6wW2oHL7LgWJrF7ZpInyQzY1BXNrOV5d5pWi8v+iWQCG13+7Vr6vEB49X+qObhSrGDUG1yJLpyFS2ubnZn34YKm63LuMtOKAhuoC2ab2JsOeuZwnUF8TQ2RjYFSzAkNifZ7mrnl0NSU5bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XVWKLKk3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XVWKLKk3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEFEC1F000FF;
	Wed, 30 Sep 2026 17:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787622;
	bh=p6nMrCZgDLYM1KdNIANyKiLrNaQcyhhjHFRvPZVkXoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XVWKLKk3q0hLyIz8mniAqwrePNC8JyniS0snbmXcJPUbbUYHtsz2mXnahiCdk2iQm
	 2OO86H6XmjAnNaK/UH2UM8mgjwFduQ00xLnN0pMtxdfzFGAOiVBsY/TTVAC2nA/uqm
	 V6+CJsfE08Ft9Yu/Wlm9jCiboSxbda5PZ+vPFiAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 7.2 293/457] drm/nouveau/dmem: pin VRAM for the whole registered range
Date: Wed, 30 Sep 2026 17:26:38 +0200
Message-ID: <20260930152352.358237411@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junrui Luo <moonafterrain@outlook.com>

commit 64ca4cdd1031206424e6455f0ae4fb0560d8f46a upstream.

Commit c32287471077 ("gpu/drm/nouveau: enable THP support for GPU memory
migration") grew the device-private region that
nouveau_dmem_chunk_alloc() registers from DMEM_CHUNK_SIZE to
DMEM_CHUNK_SIZE * NR_CHUNKS, but left the VRAM buffer object backing that
region at DMEM_CHUNK_SIZE.

nouveau_dmem_page_addr() returns chunk->bo->offset plus the page's offset
within the registered region, so every page past the first chunk resolves
to VRAM outside the buffer object.

Size the buffer object to the region it backs.

Fixes: c32287471077 ("gpu/drm/nouveau: enable THP support for GPU memory migration")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Assisted-by: LLM
Cc: stable@vger.kernel.org
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patch.msgid.link/20260817-nouveau-fixes-v1-1-f518d0c735f3@outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_dmem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/nouveau/nouveau_dmem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dmem.c
@@ -339,8 +339,8 @@ nouveau_dmem_chunk_alloc(struct nouveau_
 	chunk->pagemap.ops = &nouveau_dmem_pagemap_ops;
 	chunk->pagemap.owner = drm->dev;
 
-	ret = nouveau_bo_new_pin(&drm->client, NOUVEAU_GEM_DOMAIN_VRAM, DMEM_CHUNK_SIZE,
-				 &chunk->bo);
+	ret = nouveau_bo_new_pin(&drm->client, NOUVEAU_GEM_DOMAIN_VRAM,
+				 DMEM_CHUNK_SIZE * NR_CHUNKS, &chunk->bo);
 	if (ret)
 		goto out_release;
 


