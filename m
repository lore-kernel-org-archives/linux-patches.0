Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E287519DFC;
	Wed, 30 Sep 2026 18:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792594; cv=none; b=plAJY1+FL/NZEluw4xHHhqQEHAT2nVDUCEWa2D9IN+5dsCdcxsBzRCLJP2Fm3R638XsEph0/CJ2cTNWCFOVjbgR9XI79DWEBpq/Vx5/54v4klAGQ2yI2iGQ4ZwAVL8h9boUQDJGlvKpawx/XOOxJrb1qVzmzeP3tThzGBinUFDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792594; c=relaxed/simple;
	bh=jLNaIzG1a6Yzu0I5QA5o7M6xrMhOLhYa8kLAoo/tK38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r5/g0yVtdwP7ji9pQWmACKoosMo7a+5pPeM+jDGmSYDw1RzO0vVv5RM2ZfFbTHHP90+QMBsf8g287jpq7NjkKGRt/ZuW7XdHdDjWMQ9nDAYmYyv4ynyPA87WX1oir3adxHZd9fgP7lY9q83iYpO2Aisn6Agxzu+h/3j7/LtOTQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NlgTiiC9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NlgTiiC9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC5E01F000FF;
	Wed, 30 Sep 2026 18:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792593;
	bh=N9HlOWYLpvD52+otzFReYJ6l70xc8gQa/gA7YhYjS0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NlgTiiC90y7fzh+7KQDBVaEQlSFYRdkoeKiyFZWDsmbDkZNuaQYtg1QJX78UhQT42
	 pDjxm5EJUvxifwGa7iXKRM3xVNI8f1Px/IFO/tRdWsTf4AMwighyZsf57U0UyRhN2Y
	 KsBQnw39XlpvEBxSSJk4LFyzy2Xfn8YJXDzok3Is=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 5.15 711/752] drm/nouveau: Fix gem reference leak in validate_init()
Date: Wed, 30 Sep 2026 17:29:41 +0200
Message-ID: <20260930152413.616217066@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -471,6 +471,7 @@ retry:
 			if (unlikely(ret)) {
 				if (ret != -ERESTARTSYS)
 					NV_PRINTK(err, cli, "fail reserve\n");
+				drm_gem_object_put(gem);
 				break;
 			}
 		}
@@ -480,6 +481,7 @@ retry:
 			struct nouveau_vma *vma = nouveau_vma_find(nvbo, vmm);
 			if (!vma) {
 				NV_PRINTK(err, cli, "vma not found!\n");
+				drm_gem_object_put(gem);
 				ret = -EINVAL;
 				break;
 			}


