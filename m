Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C63F43F86F4;
	Wed, 20 May 2026 18:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300912; cv=none; b=WVLZ27+jQCACu45EESc69ULEw6nuHwEpfx6FbP68AmZ/aXyodUS2l8f+zBBQEqEV2fm+gZL4BgGwj0KGz/AX8ai39wNo/8QkaNtwvvgGKzVbmPZs4mxa2Q2nxJtJZfH6ueCInlBKa2iwUgXtHsli9cMPrioTkQBVTJCUojRuJ+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300912; c=relaxed/simple;
	bh=E7PbBoF1v4vxY6Iq0P9hRAXtTzarxGzSXfTqLTWFFds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mOku7PY6C/xyEDY1fMoFwK826S5IA+eYzDNE2nIxrkQrv5LDswO3LKu/AKHhBl4U97gAwW9YJT6gYQGpZ9xGh/5RbRKiHK7I/G9wuI3/keec69nW31yh8zDgm4/GxskHXgpluZAsNZir3p/UArwn1ztD25okGhLro2NQd627MgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FdgPgz8x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FdgPgz8x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 386441F000E9;
	Wed, 20 May 2026 18:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300911;
	bh=Nt331yx9qXOf+Qn8uz/q5SdRezOS7KgbKtBopyJYRzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FdgPgz8x+KpyTKADP8JSsCF3TTduy4pFBk5V5F17GzD/2ehCAgOelxa59A5rpJQvU
	 +Cu4RQyKvbp+pwq0pFd/iW6w6QS2QQs3vTIfHLfEhjRYbgJXbL61e9fCmJTHale5EP
	 hIBUOGpNUtLo5eqfp+FlO04bXud0OYsX7HKJ7ej4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Puranjay Mohan <puranjay@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 356/666] bpf: Validate node_id in arena_alloc_pages()
Date: Wed, 20 May 2026 18:19:27 +0200
Message-ID: <20260520162118.949951126@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Puranjay Mohan <puranjay@kernel.org>

[ Upstream commit 2845989f2ebaf7848e4eccf9a779daf3156ea0a5 ]

arena_alloc_pages() accepts a plain int node_id and forwards it through
the entire allocation chain without any bounds checking.

Validate node_id before passing it down the allocation chain in
arena_alloc_pages().

Fixes: 317460317a02 ("bpf: Introduce bpf_arena.")
Signed-off-by: Puranjay Mohan <puranjay@kernel.org>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Link: https://lore.kernel.org/r/20260417152135.1383754-1-puranjay@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/arena.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
index 4ce6786d39351..187e4871b74b3 100644
--- a/kernel/bpf/arena.c
+++ b/kernel/bpf/arena.c
@@ -438,6 +438,10 @@ static long arena_alloc_pages(struct bpf_arena *arena, long uaddr, long page_cnt
 	u32 uaddr32;
 	int ret, i;
 
+	if (node_id != NUMA_NO_NODE &&
+	    ((unsigned int)node_id >= nr_node_ids || !node_online(node_id)))
+		return 0;
+
 	if (page_cnt > page_cnt_max)
 		return 0;
 
-- 
2.53.0



