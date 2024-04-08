Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09CB77BAF0;
	Mon,  8 Apr 2024 13:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583175; cv=none; b=dxJHFN+UcLd9uWGk0yRJZHOrptxP/1uHhKpFG6DvY9Ow4Y2tnv+dZICDL127AL2EpVEbqMoTlGu857Ety/SnH9nOoNOEwS5X4jTqM3bNoIbmyBPFS16nw/PB6ONeRrd0Ie5ABBCP0mTFAicqyFWG5ZXOGaELqKeHw1NOK+1mCxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583175; c=relaxed/simple;
	bh=O5i9JM8XCHKJbwXWixY+uNXA6Yf1NYMtSQswOhoxCno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I8tGjUgQUkMaQW1/Q11m8WPjcMdJpr+3gR6tj1A6mLnYosLAfSx+8kCUauN0xY6Hs17aG0Ctqt9Hicx8j6bHOyDTNbo9UyCayWlCTD3eDfVVNiYVmFL86s/cAyfR4+PXtsb0SNVZdYC+DO8UylpjzAeb+Tnj4JQUZv3Nwjd6BPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m7VsrrAN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m7VsrrAN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C634C433C7;
	Mon,  8 Apr 2024 13:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583174;
	bh=O5i9JM8XCHKJbwXWixY+uNXA6Yf1NYMtSQswOhoxCno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m7VsrrANhbldsq1gSgbdaB76IzF2TCzCn8TjPkq0ed7AxVKkHESxT7vdzZzzJIPkx
	 q3C+sYEiJWsBO6PQUxt3q+XAg1qiYXSGIZx6vI3i4XCSsE/3LPtxKhzdaTaIL27RQP
	 TNfqtDjaisj1N4sqfA3as5eUo2ikTns0Vvm6aYXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Airlie <airlied@redhat.com>,
	Danilo Krummrich <dakr@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 166/252] nouveau/uvmm: fix addr/range calcs for remap operations
Date: Mon,  8 Apr 2024 14:57:45 +0200
Message-ID: <20240408125311.806399110@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index aae780e4a4aa3..2bbcdc649e862 100644
--- a/drivers/gpu/drm/nouveau/nouveau_uvmm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_uvmm.c
@@ -804,15 +804,15 @@ op_remap(struct drm_gpuva_op_remap *r,
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



