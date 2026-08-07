Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12387313527;
	Fri,  7 Aug 2026 15:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117699; cv=none; b=JzY/BuBJTDqXaDOXcyzVxl3O5jnPbxQ1QWcPgKuZie7UAwQgvM2bR/2UczjLvylgYiPtD0nG0T6dWz8xAuVwv0KD7i4pM67cO/Ck6BANPodN9QHFQ75EzXxdlvacRAyuOIubAIIFhRIHObobI+xC4OMWYjo6wXtG6y6ztvCRWlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117699; c=relaxed/simple;
	bh=u6xChClO6BQUOpdF3dHD1hQLav5vBO0K8NM9mnkky9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ckKDM3wLCLjvE8ZoDms3fYHq0YHTdt4IdVL333i/HTkC7pbjkaThwdsc9twPHflWfiO4dm7sd4pOlntLlkdIardWs2EaOTb+KBN2QC1TvvDWoPz2ZO5cDGI4K9/f2hprs2OR7c47WHplw4rQEWhqeOQNcEfk6e/oqG573uDiIvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y+Lfa+oJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y+Lfa+oJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 280551F000E9;
	Fri,  7 Aug 2026 15:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117697;
	bh=NpjjO9LbZoWaJjTWRnKugktBdG8r10bKwA/PKZt6NrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y+Lfa+oJf5AuYF4fv9RlB9C+ps+3cHc2Vdut5EnzHXgnFAPwnNqACT+mnHCw6l7R5
	 M+lkGRnorNtb9ETePHuXo1OoSpcDtA7Da0pUowTTggLDLCwz/dP6xgDlpj5PAEyhwt
	 6OxmA5Ng3AGni+StfSIBRXaswFo4cmzJYf9Gkzxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zack.rusin@broadcom.com>,
	Ian Forbes <ian.forbes@broadcom.com>
Subject: [PATCH 7.1 411/438] drm/vmwgfx: drop dma_buf reference on foreign-fd prime import
Date: Fri,  7 Aug 2026 16:40:07 +0200
Message-ID: <20260807143436.727656885@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zack Rusin <zack.rusin@broadcom.com>

commit f739416dc555fa205a785e5135d73fa39b26f35d upstream.

ttm_prime_fd_to_handle() returns -ENOSYS when the imported fd's
dma_buf->ops do not match the ttm_object_device's ops, but does so
without releasing the reference acquired by dma_buf_get().  Any
unprivileged renderD client passing a non-vmwgfx prime fd through the
DRM_VMW_GB_SURFACE_REF{,_EXT} path leaks one dma_buf reference per
call and indefinitely pins the foreign exporter's GEM resources.

Funnel the error path through the existing dma_buf_put() so the
reference is always dropped.

Fixes: 65981f7681ab ("drm/ttm: Add a minimal prime implementation for ttm base objects")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4.7
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Reviewed-by: Ian Forbes <ian.forbes@broadcom.com>
Link: https://patch.msgid.link/20260505222728.519626-6-zack.rusin@broadcom.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vmwgfx/ttm_object.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/vmwgfx/ttm_object.c
+++ b/drivers/gpu/drm/vmwgfx/ttm_object.c
@@ -547,14 +547,17 @@ int ttm_prime_fd_to_handle(struct ttm_ob
 	if (IS_ERR(dma_buf))
 		return PTR_ERR(dma_buf);
 
-	if (dma_buf->ops != &tdev->ops)
-		return -ENOSYS;
+	if (dma_buf->ops != &tdev->ops) {
+		ret = -ENOSYS;
+		goto out;
+	}
 
 	prime = (struct ttm_prime_object *) dma_buf->priv;
 	base = &prime->base;
 	*handle = base->handle;
 	ret = ttm_ref_object_add(tfile, base, NULL, false);
 
+out:
 	dma_buf_put(dma_buf);
 
 	return ret;


