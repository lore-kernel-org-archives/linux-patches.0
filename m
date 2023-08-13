Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8745B9446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:43:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EFA3C433C7;
	Sun, 13 Aug 2023 21:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691963033;
	bh=1cd9f9Nrl60F2vSrMupFiHB7YwJgpEozzReFfBxYsyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vOLp3ENEvtyAvENey2rvgyIiNhqK70nIEFJuqqqm7nH2b2RktlsyglIhYQDcTEfPT
	 QLREW/ICLQaOW68RI5RGnvd5fE+VbjCu5OmWsXKwsV26S/bTaBpriN+SboxguyQFwX
	 Bq8Sf1dFQ266tsjpQz+j+N6EZojD3aYUajFiFOq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Roman Stratiienko <r.stratiienko@gmail.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 5.15 09/89] drm/shmem-helper: Reset vma->vm_ops before calling dma_buf_mmap()
Date: Sun, 13 Aug 2023 23:19:00 +0200
Message-ID: <20230813211711.058012414@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211710.787645394@linuxfoundation.org>
References: <20230813211710.787645394@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Boris Brezillon <boris.brezillon@collabora.com>

commit 07dd476f6116966cb2006e25fdcf48f0715115ff upstream.

The dma-buf backend is supposed to provide its own vm_ops, but some
implementation just have nothing special to do and leave vm_ops
untouched, probably expecting this field to be zero initialized (this
is the case with the system_heap implementation for instance).
Let's reset vma->vm_ops to NULL to keep things working with these
implementations.

Fixes: 26d3ac3cb04d ("drm/shmem-helpers: Redirect mmap for imported dma-buf")
Cc: <stable@vger.kernel.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Reported-by: Roman Stratiienko <r.stratiienko@gmail.com>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Tested-by: Roman Stratiienko <r.stratiienko@gmail.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20230724112610.60974-1-boris.brezillon@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -591,7 +591,13 @@ int drm_gem_shmem_mmap(struct drm_gem_sh
 	int ret;
 
 	if (obj->import_attach) {
+		/* Reset both vm_ops and vm_private_data, so we don't end up with
+		 * vm_ops pointing to our implementation if the dma-buf backend
+		 * doesn't set those fields.
+		 */
 		vma->vm_private_data = NULL;
+		vma->vm_ops = NULL;
+
 		ret = dma_buf_mmap(obj->dma_buf, vma, 0);
 
 		/* Drop the reference drm_gem_mmap_obj() acquired.*/


