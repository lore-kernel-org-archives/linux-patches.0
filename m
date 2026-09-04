Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767EC30C366;
	Fri,  4 Sep 2026 05:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501049; cv=none; b=q1GGrUvjiDIYPKf6jjcb7eVMaidFw7aJQ05s/apzhpfUpPQgl5lqvGC3Vh/+RSBrqU66zEFsqmfAjcdfT4K8V8tMSIvyIP93OYKCgwYeWSLKS6opE86gKwfHfUiGdbcudz1ZMowjDbcUAGg4yaBeArDOBART9OrOdSVWIeb2zUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501049; c=relaxed/simple;
	bh=2YjJmcecKSCP+QWDzwZLpmrNbp+GoWD0rS3KM5ccJgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dhr8vZUFxGtiN7+4ArA+nWkDn0b68nptxQkJ42EUccRLk9kULVrvkdbqvBDHVI0xk5oj3UDPvLXjOvRSCuQUteF1vkELK8Msj1TQorPGM4Dyca2HwhpLXcvPV/NPC/92DIxEySgSpmDj8tz+s5Z7YEHUySTXZM7Vk6Lh3LYMWdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vDbYhYHx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vDbYhYHx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 897F11F00A3E;
	Fri,  4 Sep 2026 05:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501048;
	bh=VutGDTeEUntzLKVmslcTYkpknwYINk42ifM7IB0juPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vDbYhYHxL8zRkFA2gQXlwhVhHFlqDC9crNKho3pped3VIw3r/HEa0vzr+/VcD5nYv
	 oiWd0+hVbDdnZxBYoWmN063/GEtS09m5LWqZfRyAcW/KG/liePan+8lsCJ6BpbidCZ
	 Qy1AwOUt9jHGX0QCunDPLl/hPNtAkcZQMuKHWwMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Airlie <airlied@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.18 273/552] nouveau/gem: reserve the bo in the info ioctl around the vma lookup
Date: Fri,  4 Sep 2026 06:57:10 +0200
Message-ID: <20260904045756.164305349@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Dave Airlie <airlied@redhat.com>

commit 5e17160d41d92823f3379c1982e1369680c5ce4d upstream.

In the non-uvmm path, there could be a race between the info lookup
finding the vma, and the gem close path closing the vma leading
to a use-after-free.

Spotted with the help of Opus 4.6.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Fixes: e758a3111914 ("drm/nouveau: fixup gem_info ioctl to return client-specific bo virtual")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260612020658.3176270-1-airlied@gmail.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_gem.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nouveau_gem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_gem.c
@@ -313,11 +313,20 @@ nouveau_gem_info(struct drm_file *file_p
 	rep->offset = nvbo->offset;
 	if (vmm->vmm.object.oclass >= NVIF_CLASS_VMM_NV50 &&
 	    !nouveau_cli_uvmm(cli)) {
+		int ret;
+
+		ret = ttm_bo_reserve(&nvbo->bo, false, false, NULL);
+		if (ret)
+			return ret;
+
 		vma = nouveau_vma_find(nvbo, vmm);
-		if (!vma)
+		if (!vma) {
+			ttm_bo_unreserve(&nvbo->bo);
 			return -EINVAL;
+		}
 
 		rep->offset = vma->addr;
+		ttm_bo_unreserve(&nvbo->bo);
 	} else
 		rep->offset = 0;
 


