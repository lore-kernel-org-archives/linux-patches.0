Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3EA4156F0;
	Fri,  4 Sep 2026 05:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499294; cv=none; b=JGguobHnOAWwhAwMBq7788cThDTIuPFQ37dHGBS3So6GErlVMva6tUcuyk7PLeK7PqK2FY9szO6Llj4tF+IiD9Tw0olOdCiVbs7NZ0QAOxCOV7QWO6VdAZR2oAnVfeTQccfMqm9vsXdHqLI3NxnsjCbxXU3dM7DTN1FRIrkWaPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499294; c=relaxed/simple;
	bh=zWqxqi0JhcVO9rSBUASp+Y7X55HK0j3+wa2SNqpVfD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gn0BOiY9M0Y8DuB4XPzOcCFV3Dj6eWxtJLr+z9OOLRbH0usxcjGWESdD9q3Qml8gRMzWuCdcdBsOS+HNq+wOe5n3kOGeA5PMyzyfqZo+Vi36NRLO0aWaus6lZkXQuf6WjWtwhdKgku+2FTjKsxcPzphOI+PSl0T6yQo7TpNDjSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B76lZMf4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B76lZMf4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 866601F00A3D;
	Fri,  4 Sep 2026 05:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499293;
	bh=yrePAyOzfKS+S4avbK3GAs+ihMnBEYjNiOsGYmMF5mY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B76lZMf4zuvQYvyNLlNSx+BkmZtqlNAgpDoFlNs8Em9Wt/aqgrXLost6TE8qUqv+9
	 Z+QzAClsyTVWQrWsvvHd6xb62l+uhD4/7ftrjD6KV0361cSejJqKpJxH+gy70B0Zk0
	 zgnx5wC6daYa7i+d4787QNKjb/OAQhTiET5WTlik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Airlie <airlied@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 7.2 367/713] nouveau/gem: reserve the bo in the info ioctl around the vma lookup
Date: Fri,  4 Sep 2026 06:55:35 +0200
Message-ID: <20260904045812.056520443@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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
 


