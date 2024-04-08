Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FCA97C0B2;
	Mon,  8 Apr 2024 13:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583247; cv=none; b=dsSrj3mykKhUnPrtE6h94N9bAoyq92PxxPuaECYnk7HucuTzn+NkOkeJz/rnge/9PbMyCghSGRKIAhz7mkm34o57uXUCpwD/K+wvZndE/cwjeEWNeHZADuvzW2zqHKzqPLzBk4E0aYxB3ayIs9kClawSF/olJsX/q6NzNldFgao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583247; c=relaxed/simple;
	bh=0yKxoTfYwGNQ1/EU1bR3e0iwCrvpxJDaoRiRGuBNq4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jfLEUVSGnKFbL9xBvYPJcZ3+euaaYgAE9yzkFw6CEA6i3ewh53oQclO7xgXM+MDedFvEuUX+wND2Ntjh9HRb3zhIWCol+O8zRuAWlw0m4iVlM1/wfu3JKd4rW+x6idJjs9ooT1VXPzTBMhIM0NSfhmkBtmvgTYzpbUHhceCFrL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jip5hf5S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jip5hf5S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE803C433F1;
	Mon,  8 Apr 2024 13:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583247;
	bh=0yKxoTfYwGNQ1/EU1bR3e0iwCrvpxJDaoRiRGuBNq4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jip5hf5SRHItgvdPEci0ACxVBTNP+EhDG/JFzXh3vNInqYejlcyE2fbtknOq2QyL6
	 T/1RFiYO6uWnY6+F4b/GnYn3Mq+SZrOUp9pJ6fu/gazq7w+LOMfVU1rlinaalFcQVv
	 9jvnH5lR9NEken6nFLY9MLUz6a4guMcHg3hVk04w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Airlie <airlied@redhat.com>,
	Danilo Krummrich <dakr@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 156/273] nouveau/uvmm: fix addr/range calcs for remap operations
Date: Mon,  8 Apr 2024 14:57:11 +0200
Message-ID: <20240408125314.120769578@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

[ Upstream commit be141849ec00ef39935bf169c0f194ac70bf85ce ]

dEQP-VK.sparse_resources.image_rebind.2d_array.r64i.128_128_8
was causing a remap operation like the below.

op_remap: prev: 0000003fffed0000 00000000000f0000 00000000a5abd18a 0000000000000000
op_remap: next:
op_remap: unmap: 0000003fffed0000 0000000000100000 0
op_map: map: 0000003ffffc0000 0000000000010000 000000005b1ba33c 00000000000e0000

This was resulting in an unmap operation from 0x3fffed0000+0xf0000, 0x100000
which was corrupting the pagetables and oopsing the kernel.

Fixes the prev + unmap range calcs to use start/end and map back to addr/range.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Fixes: b88baab82871 ("drm/nouveau: implement new VM_BIND uAPI")
Cc: Danilo Krummrich <dakr@redhat.com>
Signed-off-by: Danilo Krummrich <dakr@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240328024317.2041851-1-airlied@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_uvmm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_uvmm.c b/drivers/gpu/drm/nouveau/nouveau_uvmm.c
index 0a0a11dc9ec03..ee02cd833c5e4 100644
--- a/drivers/gpu/drm/nouveau/nouveau_uvmm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_uvmm.c
@@ -812,15 +812,15 @@ op_remap(struct drm_gpuva_op_remap *r,
 	struct drm_gpuva_op_unmap *u = r->unmap;
 	struct nouveau_uvma *uvma = uvma_from_va(u->va);
 	u64 addr = uvma->va.va.addr;
-	u64 range = uvma->va.va.range;
+	u64 end = uvma->va.va.addr + uvma->va.va.range;
 
 	if (r->prev)
 		addr = r->prev->va.addr + r->prev->va.range;
 
 	if (r->next)
-		range = r->next->va.addr - addr;
+		end = r->next->va.addr;
 
-	op_unmap_range(u, addr, range);
+	op_unmap_range(u, addr, end - addr);
 }
 
 static int
-- 
2.43.0



