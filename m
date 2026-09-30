Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB044FB9AF;
	Wed, 30 Sep 2026 16:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786677; cv=none; b=NRipv8In7IhMqAM4gzf6k9ABaAuvv8NUzm+rDuScJMDuxw2hJ3HM/pX22v48IFpyl3yrvPPrhisHckc0y1makiF8u+PFpkriQMb+D2FCSbgqEYNphFAHyuAkPrHUCXNtZg1aqR0XPpb5FJ9cVi/JuKZjL+jwNqchOg2EhsxatHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786677; c=relaxed/simple;
	bh=bau7rDC9agaVgspRbpRxjkhdpMC4/7BstIwul926TFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fWdapt/4nXJe3PfMjss4sFIITk+ZJsPSbJS81leJVzlEiIM9PKPjh7FvRkM5zbSx4RxUrgI6jHX9yZZZSTrn8x80ogdgnIhc2AzyMzFKm8eslAPm/CmcVBiix5j3ArR4KiZlnsaz84PpmvUeon58zq57Vv3aWZDgDaeXDrj74wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pL7K7ikR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pL7K7ikR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B79981F000FF;
	Wed, 30 Sep 2026 16:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786676;
	bh=hw74K3xmdKVW9F7xupKxgwx+5IYInvdGRTuN6QKgrLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pL7K7ikRtBzwWVY6VQwjAfmzlDBIehJOgKn6C4JcAb17OMF8pH8yMb/Ftl/vvwZvS
	 N15ybmCX1gJXzkOSALcu4RaLcai0WoVch2FA6KQc8hAX68dIdRxSLeWJMPJ9Dvytwx
	 pM/iksdqj3/WDZwI4I2PrWgA8cgM6I3HNUp73a/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 6.1 946/982] drm/nouveau: Fix gem reference leak in validate_init()
Date: Wed, 30 Sep 2026 17:28:02 +0200
Message-ID: <20260930152437.056564772@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


