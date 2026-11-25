Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621194;
	b=aHdiTD5aKnG1YWvA09PSL1DTs4YC0/u0XnmZFuv075jSgvyYxghQgfNAHQApMgFVz2TB
	 Z7F+SnPMJIgR4cBqGs29/0q1qA5PJxpUnIRx6R6T443WWNBWm+aygKm7HGLcWya7xoQMo
	 rNOSkhbzUoykoEsZlIdP48AeGoQzeCQQ3HYncJ0m1F/45h62JwgKl/Zp7OXkRjZZsd6Lw
	 VbPEAk5CjizL8Vt+vmYjbQ/6aP98/FzntaEoivEoV63qaEMI0DX75SzbHqCnwHu88RlCB
	 jXh68FDorCIGH5yE5kCSPC3A/VgQx/3+Qg0rw85q0pxkb3H2hMnIdoj46NIAorkAsvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621194;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2OXStm23vrsC8S0ldMgVwq91wnmhDGMovozHuG3uvNY=;
	b=Z3kfQ/02mJZjxPQCtwTQFxenCR5UB3EgcG5UHVuGNmhYUsntiQScZI5qgC4Vz1LSQOrl
	 GGEDL1kjGQjhPM68RTPHykaYGu9MAgRtRGH+plPRPiyJvQ3DnGCQeFLMRdDILKDdCSHia
	 pr1fOazV9zNbnK9rWmMvsdssEczjffBWOpQ3u8KW2D9pLGquVetTlAgvOImFQ8QerrgdV
	 F7dqkMVtADdHKtLns5e+evLF4ZgMWeXB95TvKR6dAO0Xe/ua22d03VCBBuPdbdr636RfB
	 0TBbgagMPuweqp0BuV6Rxb4AIdXLRT6rFa4WFEDQIlFkC3BuVzqF4UplwHyI+cjVKBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AYz7l1Mr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7276606A69D;
	Wed, 25 Nov 2026 15:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AYz7l1Mr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98FED1F000ED;
	Wed, 25 Nov 2026 15:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621194;
	bh=2OXStm23vrsC8S0ldMgVwq91wnmhDGMovozHuG3uvNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AYz7l1Mr3lK5+69S1hjpkI1T/sjkMyVHcz1kgWEscOLsIkKC81tYrLDKetFuQ/qF+
	 zF72Ei1lBIUJCS0tbM9J5D4pPMx8MXWqDVCLqQo/r8by2uDEUciURs3xsEm3UqcFCk
	 9AFv0gOTFAI2RargJLGcAiYSBZiLRSxaKuYuQLbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 114/990] bpf: Refuse an arena mmap() longer than max_entries pages
Date: Wed, 25 Nov 2026 15:24:41 +0100
Message-ID: <20261125143824.757819469@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 1e01345b87f13c354687360cb81ed2a521ff2b13 ]

arena_map_alloc() puts max_entries free pages in the range tree of an
arena. But the arena kfuncs check their arguments against user_vm_start and
user_vm_end. Without map_extra, arena_map_mmap() takes both from the first
vma. This vma can be up to 4 GiB long. Then arena_free_pages() also marks
pages as free that were never in the range tree. Thus max_entries does not
limit the memory of the arena, but these pages are inside kern_vm.

Refuse an mmap() longer than max_entries pages with -E2BIG. With map_extra
this limit exists already. libbpf always maps max_entries pages. Replace
both SZ_4G checks with this limit, because it is at most 4 GiB.

Fixes: 317460317a02 ("bpf: Introduce bpf_arena.")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261101190535.1454146-6-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/arena.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
index d1f0a7222d941..b3c70596c576e 100644
--- a/kernel/bpf/arena.c
+++ b/kernel/bpf/arena.c
@@ -333,7 +333,7 @@ static unsigned long arena_get_unmapped_area(struct file *filp, unsigned long ad
 
 	if (pgoff)
 		return -EINVAL;
-	if (len > SZ_4G)
+	if (len > (u64)map->max_entries * PAGE_SIZE)
 		return -E2BIG;
 
 	/* if user_vm_start was specified at arena creation time */
@@ -381,7 +381,7 @@ static int arena_map_mmap(struct bpf_map *map, struct vm_area_struct *vma)
 		return -EBUSY;
 
 	/* Earlier checks should prevent this */
-	if (WARN_ON_ONCE(vma->vm_end - vma->vm_start > SZ_4G || vma->vm_pgoff))
+	if (WARN_ON_ONCE(vma_pages(vma) > map->max_entries || vma->vm_pgoff))
 		return -EFAULT;
 
 	if (remember_vma(arena, vma))
-- 
2.53.0



