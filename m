Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208246;
	b=MUiK1ZWONRW3kfWy8Zn12bl4LYPMhqAMslx6eoM5xYErN/chJggt1LUDcH8zSkYCCO0t
	 F5Pub2CrxAv8RCsz/y+Rs5RLbwEqFMkFDyVXKiIXmmz8kdmF87SWi19I3JjYEf9EZd4u+
	 qLabCRjlg9FPp/mCkJBQxJ5k4ZdhtBZQorb6A/U8rHmVFTdTFEr/Swr8Uj0bIBVLyH2f3
	 +oQ8P5JUREt/tDnpekVuI6KLknAH94lezGJeO/n4+c5gVmi4nA4IyY/jwnfcgGv2P24b/
	 SxpERlCccRMCDnU25EPiCATCLU680m7koF6QoNZXSIqEXiXENIU2mUZzWmyru7KPheQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208246;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kSp4anslJ0S/4ic+UCkPQDI6lTuXWR9Bubkjocgo6yU=;
	b=jCPVq/f7sSXLrVLz0DrYTWEuZYuse2PwnUfEMqSCWUQlow6JrS3Nn0oF7JgaukMYdUvw
	 zckuls7wQtP1YiyW/WWFQ9XTOFCeocs37X7UwkPas3NrXdI8W2eao5G7Tye47t4h0AYWK
	 2u4RKLpzWzML9h6JqvD/M3uD3gDkLLMEMVOpIZKnbpiWUS/LXnoen3dHH46B8B12CuDgz
	 rXPTLOxaflRULszUHKFVmI2tAqaC/H4JBAQ5Svp8eg0T98EDnLCoOT9e0CL5yeQP5KjPh
	 VdNYI5W76PzlsZW15JdxZjF47JXcNi7OV4A5N5lU12pvMdJtHfNta0G0A6ckzaeXvww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ylk9/znm";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E80606A31A;
	Wed, 28 Oct 2026 17:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ylk9/znm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C391F01825;
	Wed, 28 Oct 2026 17:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208246;
	bh=kSp4anslJ0S/4ic+UCkPQDI6lTuXWR9Bubkjocgo6yU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ylk9/znm/qcW182v8tNGC9IH19XpatKKx1oyDZGTRv7RWj0K2NLsC1RZiwuzuuVaK
	 rreH+qiI7uruVaUKioG3Y/K9byE/CT0mzjSqplvCD8AigyV8q2ebkIDlUbAW60gE6F
	 Ye1I1R60dGnxDUajCneoK0fzzEK2ka5j4F/YrZSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Airlie <airlied@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 009/516] nouveau/gem: reserve the bo in the info ioctl around the vma lookup
Date: Wed, 28 Oct 2026 17:52:41 +0100
Message-ID: <20261028170003.748893606@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

[ Upstream commit 5e17160d41d92823f3379c1982e1369680c5ce4d ]

In the non-uvmm path, there could be a race between the info lookup
finding the vma, and the gem close path closing the vma leading
to a use-after-free.

Spotted with the help of Opus 4.6.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Fixes: e758a3111914 ("drm/nouveau: fixup gem_info ioctl to return client-specific bo virtual")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260612020658.3176270-1-airlied@gmail.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
[ adapted VMM and UVMM handling to the legacy direct VMM selection and condition. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_gem.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_gem.c b/drivers/gpu/drm/nouveau/nouveau_gem.c
index 6e84616311369..e8c02dea16b01 100644
--- a/drivers/gpu/drm/nouveau/nouveau_gem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_gem.c
@@ -227,11 +227,20 @@ nouveau_gem_info(struct drm_file *file_priv, struct drm_gem_object *gem,
 		rep->domain = NOUVEAU_GEM_DOMAIN_VRAM;
 	rep->offset = nvbo->offset;
 	if (vmm->vmm.object.oclass >= NVIF_CLASS_VMM_NV50) {
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
 	}
 
 	rep->size = nvbo->bo.mem.num_pages << PAGE_SHIFT;
-- 
2.53.0



