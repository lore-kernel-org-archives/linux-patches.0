Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FAFB28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 13:56:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D518C433D2;
	Mon, 30 Jan 2023 13:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675086991;
	bh=7PESLxxDozXNuZeqjgN7jyFJ9OLFxz7MrVtkncdlevQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K+tCqmGoEJIIYcurMvM9gtPOvN6afSuP/uRReJ8yF2XvGq/bBhShZIaojYa8dUj8m
	 d34WEhp2e37qKGpoS+BtAfwysogNc0bEwVJTmYMvAOndcKPHPRtVi9N7ln77gDuMqn
	 PQn0GNYcWiJ6JbHC6UZIo9Y2J0TD1g+aEpfWhysE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tonghao Zhang <tong@infragraf.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yhs@fb.com>,
	John Fastabend <john.fastabend@gmail.com>,
	KP Singh <kpsingh@kernel.org>,
	Stanislav Fomichev <sdf@google.com>,
	Hao Luo <haoluo@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Hou Tao <houtao1@huawei.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 063/313] bpf: hash map, avoid deadlock with suitable hash mask
Date: Mon, 30 Jan 2023 14:48:18 +0100
Message-Id: <20230130134339.607002421@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tonghao Zhang <tong@infragraf.org>

[ Upstream commit 9f907439dc80e4a2fcfb949927b36c036468dbb3 ]

The deadlock still may occur while accessed in NMI and non-NMI
context. Because in NMI, we still may access the same bucket but with
different map_locked index.

For example, on the same CPU, .max_entries = 2, we update the hash map,
with key = 4, while running bpf prog in NMI nmi_handle(), to update
hash map with key = 20, so it will have the same bucket index but have
different map_locked index.

To fix this issue, using min mask to hash again.

Fixes: 20b6cc34ea74 ("bpf: Avoid hashtab deadlock with map_locked")
Signed-off-by: Tonghao Zhang <tong@infragraf.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Song Liu <song@kernel.org>
Cc: Yonghong Song <yhs@fb.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Stanislav Fomichev <sdf@google.com>
Cc: Hao Luo <haoluo@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Hou Tao <houtao1@huawei.com>
Acked-by: Yonghong Song <yhs@fb.com>
Acked-by: Hou Tao <houtao1@huawei.com>
Link: https://lore.kernel.org/r/20230111092903.92389-1-tong@infragraf.org
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/hashtab.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index f39ee3e05589..c4811984fafa 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -152,7 +152,7 @@ static inline int htab_lock_bucket(const struct bpf_htab *htab,
 {
 	unsigned long flags;
 
-	hash = hash & HASHTAB_MAP_LOCK_MASK;
+	hash = hash & min_t(u32, HASHTAB_MAP_LOCK_MASK, htab->n_buckets - 1);
 
 	preempt_disable();
 	if (unlikely(__this_cpu_inc_return(*(htab->map_locked[hash])) != 1)) {
@@ -171,7 +171,7 @@ static inline void htab_unlock_bucket(const struct bpf_htab *htab,
 				      struct bucket *b, u32 hash,
 				      unsigned long flags)
 {
-	hash = hash & HASHTAB_MAP_LOCK_MASK;
+	hash = hash & min_t(u32, HASHTAB_MAP_LOCK_MASK, htab->n_buckets - 1);
 	raw_spin_unlock_irqrestore(&b->raw_lock, flags);
 	__this_cpu_dec(*(htab->map_locked[hash]));
 	preempt_enable();
-- 
2.39.0



