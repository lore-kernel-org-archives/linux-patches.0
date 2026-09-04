Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 386EC369204;
	Fri,  4 Sep 2026 06:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502415; cv=none; b=WlB2rsS3RzEcYnkNQqDiKAwuaghOJdAYoYC3vlPYkPM4VcuE4BLaIghGv31QsM+9nceCiemFy6KnWXB4UBM+XHEb1//9/cNiswb1daZywIvSrS9gkkRdThkTAEEUxQDazn5EbE4/mHhVw/UVueZAbzFO0fIZResWAHOBzezVXcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502415; c=relaxed/simple;
	bh=HThubp7/sOFV2/TGxo3dZ+zbIs6jV97ZIOVtm6oFYBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SqvkwfbuxER4xiqIg3pxAW0P0WYd7Et6Sw6Y+9s3A4JZ1KOnrWyG7cPHWra0qDVuNM6+TkyuHfiHB7MdDNklRTfSiied3g1g0D2406qdoo5ET1mjNUwuoJdZXvNbTkT2X1FPSo1t4dOWtOF7k5xy/9iQGoLg+pBG5Wp8hHHteLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JTBtuiyc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JTBtuiyc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88E131F00A3D;
	Fri,  4 Sep 2026 06:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502414;
	bh=XiNWmUAziwRW9kLyYg2nSpaVJbe/zVf0qGIcuR/FhLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JTBtuiycUmZ7yUgPFTR9gowfZ3V7bJGZEK77cxLRWRVTqH6M6VUfAJuE8pCTxTRdJ
	 ez8xFgJNSIgxguscrw7GB0E+n5HZq9nJvjSFZgorbbfTMm/5eFio/G4XVpwRa20Gx5
	 D2y27tQ/gjBDP8xYur3MWn1aRGhJz4Gh961n72XM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Airlie <airlied@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.12 199/403] nouveau/gem: reserve the bo in the info ioctl around the vma lookup
Date: Fri,  4 Sep 2026 07:00:02 +0200
Message-ID: <20260904045739.379726314@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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
 


