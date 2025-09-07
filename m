Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0956A15D5B6;
	Sun,  7 Sep 2025 20:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276135; cv=none; b=mU0r9RIWE6PFHn5NpKa4seNfzoQhUdiKt/xaQa3aVoyOO243ubAA9zer7RJ8rWrx1+FVvkBfYRp/7aYzcJOflYbG1ALz1B/U8BGcgOFrLez1TP6I5tR11R1ib6c0UK2oJGfuVsglZa0GUW3WjYQdNQ4uFketqJ3xwtCTYbInOAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276135; c=relaxed/simple;
	bh=lWU9TgQwgJtVJ2J3qfhoLQhxruOfomTrHgxUxF33wbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FbVno9Rgz9gqJygcYbO5PHSpfNKYoSXp4tGfb0Guyz6YJmx38JeT49PIw1hxg64IFuLC5GXVdy7Sh86R2G9uyLw+6jh+VUhgZHfKWamR8kjcRyyLjaaYN7Dg/qKIyVcvo8pJurJTRvOshmucfqWTROEcnpKerR/MfdIw9YxRl/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ShKf2rkv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ShKf2rkv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E3F2C4CEF0;
	Sun,  7 Sep 2025 20:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276134;
	bh=lWU9TgQwgJtVJ2J3qfhoLQhxruOfomTrHgxUxF33wbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ShKf2rkv6uD60dDdLytFPDKft0qRH8wU65JaUkReSX1Vfu9olesB9wLyibkbegAoe
	 APnSr2CbQWaMtvC979U7ZPOyGo3zO1N3YvsH1UHhCAnM1SRvgbs/gYfjsSymNurUsT
	 UZnWz38n5l589CyaJTVMBj16xIcro9c6biDawAkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 001/104] bpf: Add cookie object to bpf maps
Date: Sun,  7 Sep 2025 21:57:18 +0200
Message-ID: <20250907195607.706543012@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 12df58ad294253ac1d8df0c9bb9cf726397a671d ]

Add a cookie to BPF maps to uniquely identify BPF maps for the timespan
when the node is up. This is different to comparing a pointer or BPF map
id which could get rolled over and reused.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/r/20250730234733.530041-1-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h  | 1 +
 kernel/bpf/syscall.c | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index e9c1338851e34..2aaa1ed738303 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -260,6 +260,7 @@ struct bpf_map {
 	bool frozen; /* write-once; write-protected by freeze_mutex */
 	bool free_after_mult_rcu_gp;
 	s64 __percpu *elem_count;
+	u64 cookie; /* write-once */
 };
 
 static inline bool map_value_has_spin_lock(const struct bpf_map *map)
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index b145f3ef3695e..377bb60b79164 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -35,6 +35,7 @@
 #include <linux/rcupdate_trace.h>
 #include <linux/memcontrol.h>
 #include <linux/trace_events.h>
+#include <linux/cookie.h>
 
 #define IS_FD_ARRAY(map) ((map)->map_type == BPF_MAP_TYPE_PERF_EVENT_ARRAY || \
 			  (map)->map_type == BPF_MAP_TYPE_CGROUP_ARRAY || \
@@ -47,6 +48,7 @@
 #define BPF_OBJ_FLAG_MASK   (BPF_F_RDONLY | BPF_F_WRONLY)
 
 DEFINE_PER_CPU(int, bpf_prog_active);
+DEFINE_COOKIE(bpf_map_cookie);
 static DEFINE_IDR(prog_idr);
 static DEFINE_SPINLOCK(prog_idr_lock);
 static DEFINE_IDR(map_idr);
@@ -1152,6 +1154,10 @@ static int map_create(union bpf_attr *attr)
 	if (err < 0)
 		goto free_map;
 
+	preempt_disable();
+	map->cookie = gen_cookie_next(&bpf_map_cookie);
+	preempt_enable();
+
 	atomic64_set(&map->refcnt, 1);
 	atomic64_set(&map->usercnt, 1);
 	mutex_init(&map->freeze_mutex);
-- 
2.50.1



