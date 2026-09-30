Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906A651A723;
	Wed, 30 Sep 2026 17:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789483; cv=none; b=QTi6yTkiWphVrPHs7IYN7S45CSwfY1F4buZ5gIey4ne/T/iNYIqayE3NFxLTVMkZCn3EP8t54Vaz9Sx74Hh+7azE41CMykRbCfGjt6kylnL0a0C1G9xlYj8VFrgQMbbhYucFzhYsOW/xwaRLjpEv1YYQio3Tv51EfT2ld83atSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789483; c=relaxed/simple;
	bh=h2hKG3dySfEghW47GkTAWKM/M9b3ma8Ro8ZyTNSyHXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QUuWt2s5NJjU7M/+IxCCT3Lg+q2rMR9g/ZruTMZdiKwIwaEDioIoqu8Hb92xMd3AG/tI1qX7UVSaskXyNVDCSOhUUZUie6o4ESm9eiINFysjyFXYc0yvsjQFxoUsTC6t0zqlPvYgjGPrt2yJn6eeZg/AChCDJyolDalqCj5VkfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z4cVxI5U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z4cVxI5U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9651E1F00898;
	Wed, 30 Sep 2026 17:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789482;
	bh=wkZ6fiKn7ktRs0uBsQMa6pPlGckQyhzCTtNqBJi+QTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z4cVxI5U11UT51H7PXDpmkdEcNNfp6aC5SzAkxKzioh5ElnFvih26GBQR+KvGkWhP
	 79p3fBrccZTegR5VN3rTLJdKm177KsmDAOP3VXYpZ0qFTPtayhJ7BUyOp8YKl6JaWX
	 C5IiQzlc8NhI+5d4veZ11esCczOb5yWmytGD4E4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 6.12 491/877] drm/nouveau: Fix gem reference leak in validate_init()
Date: Wed, 30 Sep 2026 17:23:22 +0200
Message-ID: <20260930152425.256728016@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit 5ea72f7b7139b123713a7983448f910bc4514d9e upstream.

On the ttm_bo_reserve() failure and "vma not found" error paths, the
loop breaks without adding the looked-up object to any validate list,
so the reference taken by drm_gem_object_lookup() is never released;
validate_fini() only walks the spliced lists.  Drop the reference
before breaking out on both paths.

Fixes: 19ca10d82e33bcfe ("drm/nouveau/gem: lookup VMAs for buffers referenced by pushbuf ioctl")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patch.msgid.link/20260916180202.2090231-1-vulab@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_gem.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/nouveau/nouveau_gem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_gem.c
@@ -522,6 +522,7 @@ retry:
 			if (unlikely(ret)) {
 				if (ret != -ERESTARTSYS)
 					NV_PRINTK(err, cli, "fail reserve\n");
+				drm_gem_object_put(gem);
 				break;
 			}
 		}
@@ -531,6 +532,7 @@ retry:
 			struct nouveau_vma *vma = nouveau_vma_find(nvbo, vmm);
 			if (!vma) {
 				NV_PRINTK(err, cli, "vma not found!\n");
+				drm_gem_object_put(gem);
 				ret = -EINVAL;
 				break;
 			}


