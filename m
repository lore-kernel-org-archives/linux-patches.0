Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF46B346A08;
	Sat, 12 Sep 2026 12:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215762; cv=none; b=dvhNaXgH7wT/5TFAhnjE6MuefWY/3hDArcXmmAc61O0QtR0e73ChZr/C37394VKnlA17nfFFawWZe3+s/0/fykhr2iQm6/i1lubxyxQ+Z8hscTFB/4G0Udg6RWeWo+jTRBDueKhlwCiE3rkNjzGIvevg5/wZjWiZ68diDtEfPIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215762; c=relaxed/simple;
	bh=X3q5BNwEI3xD49Ur1iEKaz3wrU3gvt0IEphg8ahkTlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IeKDnpwUjflsTA0g0vOLoX1XcaFOrsRQOj+22ZP244yXm0E9CZAlV+oSqxosNStkXm5DgjUqdpO9RBlgvzHCIYlDCEOquFYrlKd1C0Y1dH/YpGiRCMuWduxEf1rb1SKT8VVuz+5PDnI0QEhmeQ72i1ZaTT8RjuR8LwbGYAbIS/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aFPzLD+v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aFPzLD+v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 895691F000FF;
	Sat, 12 Sep 2026 12:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215761;
	bh=JdX6MShiPvrH8zhLvPKsiIqA704lU2qm9Dphjy+Amx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aFPzLD+vrPonUutJ6N6GITlsfPaRdLXqF6VOig0RoEvHge0ZkMob5r7fS1f1ibOdL
	 QivxWS5kJrvVK9GuuPy2ZSaEhDVFvBvVb+JCPJykaY0lIHMkP9JqA0tNhnQSWvDS7g
	 B//n80vbpvCxSVvW3dTma2b1jlkwvxr/8mkE2cEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0597/1376] bpf: Reject arena frees below the arena base
Date: Sat, 12 Sep 2026 08:50:23 +0200
Message-ID: <20260912065620.838914967@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index 187e4871b74b3..c62c6f261ca07 100644
--- a/kernel/bpf/arena.c
+++ b/kernel/bpf/arena.c
@@ -523,6 +523,8 @@ static void arena_free_pages(struct bpf_arena *arena, long uaddr, long page_cnt)
 	uaddr = (u32)uaddr;
 	uaddr &= PAGE_MASK;
 	full_uaddr = clear_lo32(arena->user_vm_start) + uaddr;
+	if (full_uaddr < arena->user_vm_start)
+		return;
 	uaddr_end = min(arena->user_vm_end, full_uaddr + (page_cnt << PAGE_SHIFT));
 	if (full_uaddr >= uaddr_end)
 		return;
-- 
2.53.0



