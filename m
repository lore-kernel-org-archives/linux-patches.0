Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299B94C0424;
	Wed, 30 Sep 2026 19:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797010; cv=none; b=pmlIuzdhZTiLNwcuIjRarxTunrRXHxzep3wVNCHgf/FMdKZLXrk4v9VFPt/fDPxnj0Tln6LVXfQ4I/TZ8x88g3DIuuN4LxA3gMZXb0Jcn+KJTVxh63f/QETD5EAhHtBDrPUfXm95k9qoKqIraw3zqe2Iv56axhEeGc9J2wP3tyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797010; c=relaxed/simple;
	bh=onD2mWjGnRUVUrmSL47quxqmBKKr6n4HNvdTNuZMGZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HRxbJNB6yhw3qD1RYUaiV/uqiSI5AQYXMDYWiJmWEbR/wbJQ7iwDB2oGkzeLi0soxhmsd5VVl2U7Pq9SadnM5vb0OAGybiuyk27J1pNeHZ+iiKx3nKMZTML4TLnLDDf+FDxvSQ8schbzeHyt7I7hzNbW027lbnJxfytP8G8fdGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XAGtMTi/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XAGtMTi/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F2C91F000FF;
	Wed, 30 Sep 2026 19:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797009;
	bh=XWxq2FQsrSkty+KnvNG+XMAQJhCWKNmFZov0wn8g6T0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XAGtMTi/PrykrP6zPlQ1Z6YT0QDRII+rbCoTfV6o7I3o1+2N56JHACfgnGNz1fiJK
	 lvE3ImCzgA7codv/BRWfkGaprUMYG2g+oJFb77HG3Y4BWTfe5B1FebowgKdto1Z3bh
	 SQCXf6njgpHYhhQHgvmf2ENJ5XFeYY24DNcM+/JY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 6.6 1115/1193] drm/nouveau: Fix gem reference leak in validate_init()
Date: Wed, 30 Sep 2026 17:29:59 +0200
Message-ID: <20260930152459.002737310@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -516,6 +516,7 @@ retry:
 			if (unlikely(ret)) {
 				if (ret != -ERESTARTSYS)
 					NV_PRINTK(err, cli, "fail reserve\n");
+				drm_gem_object_put(gem);
 				break;
 			}
 		}
@@ -525,6 +526,7 @@ retry:
 			struct nouveau_vma *vma = nouveau_vma_find(nvbo, vmm);
 			if (!vma) {
 				NV_PRINTK(err, cli, "vma not found!\n");
+				drm_gem_object_put(gem);
 				ret = -EINVAL;
 				break;
 			}


