Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54923381EB5;
	Sat, 12 Sep 2026 07:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199151; cv=none; b=Jcl1+UhDdLHxnFQKZHXqPEnha1L2uCrt3TWmNQKtHJn1ddGxmeTyc11/mRKXrTDJhjmbGWsOUgGZsJXfp6x4vjJYqOLRPTOKCed1zxccq0Ko8nFBosHUvZcxQWTBTA/zQwGDOP/XZ7fEGfyLeAXQdNUrflIXYyQFQ1okL/6gU8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199151; c=relaxed/simple;
	bh=+CkRAL4bwO3ol+Msc2vgzTddGZmn//S8krZ9P6o05tY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s1gO2bBa4q0/OpK1xZFoUFF4Cah3FfwALL0EczD3rZHPqBRy7FVvETgFFbOenm4K4n2RQ0J9z/ZBHgtrRff37fzxRIMhKnqWu4PIeYdWp9UWr5YpermmGwejsibS2aLqZwbkdAtnJjjurE92esae/EyAITbvkQ/yoKAPMeNSZoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mSfM748J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mSfM748J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D6351F00898;
	Sat, 12 Sep 2026 07:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199149;
	bh=PfDGyfH2xsM7rUANKvQ00AB0luUiWqNev87ALzbE2pI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mSfM748Jpisa1Vz2oTcvQ4d//fJq+PMEyUEHEGAi5TwXoGULUS24mFVPsUb5KiMYB
	 nAMQRjvjnQpsM2ro9rfVQSRCarrppL/TGRzvV+CwwQe+5r1cCL2Hjb5On2FkJZHyzY
	 6I3CGZBvUMbXKuv5bIwPEktiFJqOPmrbYYlu6EtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0526/1815] bpf: Reject arena frees below the arena base
Date: Sat, 12 Sep 2026 08:37:56 +0200
Message-ID: <20260912065701.237581432@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>

[ Upstream commit b5a71cb2db6d84ac0042549dcec266b18429d41e ]

bpf_arena_free_pages() accepts scalar arena addresses. The runtime
masks the address to the low 32 bits and reconstructs a full user
address from the arena base before returning the range to the arena
free tree.

When the scalar value is below the low 32 bits of the arena base,
full_uaddr falls below user_vm_start. The existing upper-end clipping
then turns this into an out-of-range free-tree offset. A later
allocation can reuse that offset and return an address below the arena
mapping.

Reject such frees before computing the clipped range.

Fixes: 317460317a02a ("bpf: Introduce bpf_arena.")
Signed-off-by: Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Link: https://lore.kernel.org/bpf/20260717-c10-031-public-bpf-next-v2-b4-v2-1-54b555443a7c@mails.tsinghua.edu.cn
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/arena.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
index 80b7b8a694464..97a5d8d212955 100644
--- a/kernel/bpf/arena.c
+++ b/kernel/bpf/arena.c
@@ -853,6 +853,8 @@ static void arena_free_pages(struct bpf_arena *arena, long uaddr, long page_cnt,
 	uaddr &= PAGE_MASK;
 	kaddr = bpf_arena_get_kern_vm_start(arena) + uaddr;
 	full_uaddr = clear_lo32(arena->user_vm_start) + uaddr;
+	if (full_uaddr < arena->user_vm_start)
+		return;
 	uaddr_end = min(arena->user_vm_end, full_uaddr + (page_cnt << PAGE_SHIFT));
 	if (full_uaddr >= uaddr_end)
 		return;
-- 
2.53.0



