Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89C03BE642;
	Wed, 30 Sep 2026 18:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793427; cv=none; b=Sw1R5vM8rlOy6bqMDQis9xzaM2RULRoyWd2c5hJCRn/bvZ64FJqh+Zi7HcD0StvERfV0Sk+rs/FxbzO2QJVhOlk7he37lWs4gxSSa1dVW/bJi3+zuKYgPgqp9S9evaHhqGLhx8Wz0vn72hq+EBC9ID3rX9Gkb630inDj2ueaE0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793427; c=relaxed/simple;
	bh=qWE45HUE6biqIiQ381ETpcTg536ITjLnjVhTwX+2KXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J9X3b5uPOSJNSI6diIqecnYsDairZdXIb5DfL8z9uotnQaGQJ59krigYrg4u+bmx6rXdBjrfEaKGD++rSeFlcKKZg51XelWo6gdKgY6SGDIRzAimUoLAFR2Sec9cIkplOzbaMey7GjqcLZEQ2YJhoAIr8WAtNyUong5HOCXapas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E3Is1wED; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E3Is1wED"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 205481F00898;
	Wed, 30 Sep 2026 18:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793426;
	bh=pIUr2a4H7NaLX5c+ps0OyVtC7V30pnoCqDCFi/N6Bik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E3Is1wEDLvfdY+ZdkY5Q13vHBr7osVDhqRQWsY+u8QIWx5jDwgu7omyejwWlSl3hE
	 Mh1qNIHDMud52CcYnBuuuHSjyaE2rHChFNcHGlZEuUBxCucRR4np9CSwd+K6xkrV7b
	 fg0rRpFHHG1fzvX02tElp/586JXqNiBBAv9DyMTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 6.18 250/395] drm/nouveau: Fix gem reference leak in validate_init()
Date: Wed, 30 Sep 2026 17:28:32 +0200
Message-ID: <20260930152346.074940802@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


