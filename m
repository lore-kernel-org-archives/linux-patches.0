Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE96D389104;
	Wed, 30 Sep 2026 17:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787651; cv=none; b=K+c7WSbWkY/RuWcZ/M2WHmILhPVy78B2DafvN4hRVBAnU3AUogCN28CF4B6A3yVQN+bgCHvoIHIibq9zKScggPA+RWbF1DEayg9EVoyiIZuCBkHO+Dp+qdhbBNPPF0DNcWu4GX1Ph6so2ht4Ym2QJc2+VpoAvs9K+pqgSxkzEaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787651; c=relaxed/simple;
	bh=5Jp5Rp/Hn6rpv0ywLr4u6gCdQ4w+WcN6WBpt5fppzVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RakuPV8EKXNcWad9xoa2t8/tWaRa6Bqq0Y2xhVsgOm0V3gKBJGmlGFF9prN7SKmWzOCVDGwYAj7Dy/LzNgbINxlYBvpJ67ji3+jl2WyEYTMlh0x3cdrZYn+lf6aI39sj897Hvr+vSumQBmrqjI6gsXQVBvrnu5PETDub6EbkeHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HCPfVMhe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HCPfVMhe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D81021F000FF;
	Wed, 30 Sep 2026 17:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787650;
	bh=RprvPyRvTJ+XPnrsJi5TbnN8/pqRxWOLkrKlBStSBdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HCPfVMheO+7zYNu452p9wCQ8crzTF+Z0cz0CkDzQiHR6JuK0xFqIpzgKRMWjJFb5G
	 hFulUa8YcrNkyCJwpzrLr69R+yR2ckasd6cHV6Sey+2kfpfe2boRt7iXZi2oOozeci
	 PRvmxY2P16TNSlA9CC7mNafUIWR02SRsqZPdhjZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 7.2 298/457] drm/nouveau: Fix gem reference leak in validate_init()
Date: Wed, 30 Sep 2026 17:26:43 +0200
Message-ID: <20260930152352.464100844@linuxfoundation.org>
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


