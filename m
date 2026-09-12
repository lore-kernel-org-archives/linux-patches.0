Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7DC47C11A;
	Sat, 12 Sep 2026 13:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220303; cv=none; b=E4Y6PMUw9Md9wBdgENEMgIYX538z2UUZpICTS6/lUNMSQJPkADd+Z+igI+T76SkbZ3ufGdvJdHKFF43ixEt5x9lXuHQtJbPEguklKU4WqFhtQdtFRhI6KPti2bpIUKPHb6ja2Jx1ybsj9MFBwVc6cJeEm/L68DH4+wPBIXiekkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220303; c=relaxed/simple;
	bh=ZTDcd4vFfyQdLk8GwGVYe34rAuZfzxVZi+SgcqYTLqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bUvCTsU9ySSADLcNX2UumiaadLNTIMtT1Rohq5WzG4HZKfctQj1bXUlJCfOqjkCp9qKXe9pBtv5Z8AWN5CRUOYDgd5x21NdfE7HHNpjF0+xk7JNDyDUmsYiABu4Yqg20ksogRdoxZgcQs8uiVw9V+El6AinSo+DbrTV45sYLTLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tSMIdMUA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tSMIdMUA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E309D1F00893;
	Sat, 12 Sep 2026 13:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220302;
	bh=KPlpTEWBWhg1AljKFyu1csJOI/RwtjDzzB44lisFOv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tSMIdMUAgiBCfhipai/hWz7sG/aNV62PcffXloOZUC3jyZku13OQQ+NuqDw4jxQDI
	 KKHndS0ESmQTtmBk5xQHYGtkNQXiUjolixGjUc6PqM84ob74jPCazau/WatRLLZGdg
	 4ClCyzg44+tSIUOMiZKt9qUEVk6e+V6tHXx4CdTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Airlie <airlied@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.6 0148/1424] nouveau/gem: reserve the bo in the info ioctl around the vma lookup
Date: Sat, 12 Sep 2026 08:43:00 +0200
Message-ID: <20260912065610.612244568@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
@@ -307,11 +307,20 @@ nouveau_gem_info(struct drm_file *file_p
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
 


