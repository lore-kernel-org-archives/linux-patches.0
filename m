Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E1FF1CDFAC;
	Sun,  7 Sep 2025 20:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757275927; cv=none; b=OW87nKdoDR4JLb9Km/ia+3oSZHQqA5u2SAgaBMhG8VcgmbhfT9Qr8iNQjuwiO8uDH2eUcgOK633A/CV5Fr0FXlaf/lU5Iq+zvvREo7GnK8qJp8vQ1Q22tpzUvEJVBGAQ5j7F5qi8dYyV4biCFvYhbF4WALvkEOo4bIl7FOn3cPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757275927; c=relaxed/simple;
	bh=Qt8eTSViy+KfMiVdqoX3u4Hv3QVFKh7eCMTPnJFL088=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qPcwyRaQ3OYRuNh6iuqC2A1XhbtLVFsLpWYOVZ8c5FZK7m4NrKrElPzKZJRu0Exya9qINNa6yl2s98qHWpchl8el0XYsitBrgn1vYDtef4tYpZ48BYQLdJ6gpfGkFttqAQ+Kv/lP9KqU0v2i8xAbuy3GNWAWYHDCWw4HJKhg9lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EzJmXRPr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EzJmXRPr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 129D8C4CEF0;
	Sun,  7 Sep 2025 20:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757275927;
	bh=Qt8eTSViy+KfMiVdqoX3u4Hv3QVFKh7eCMTPnJFL088=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EzJmXRPrVeM5YH8f/idWxWqNTBCVlhIXBkN2XxOXOzR/qjZhB+pN55fepb8tLjEFR
	 QeL6+UUDlIISOeONCkYSktMq6Ea0KWlpFp0ui1FVdP83FqRa28Lep765lj1E5J+6p2
	 Kus4zs0Z8eFYu1rOkuim2J5C+rSkZ4TEOdNodk6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 01/64] bpf: Add cookie object to bpf maps
Date: Sun,  7 Sep 2025 21:57:43 +0200
Message-ID: <20250907195603.435311129@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195603.394640159@linuxfoundation.org>
References: <20250907195603.394640159@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4236de05a8e70..dd6a62134e7d1 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -200,6 +200,7 @@ struct bpf_map {
 	struct mutex freeze_mutex;
 	atomic64_t writecnt;
 	bool free_after_mult_rcu_gp;
+	u64 cookie; /* write-once */
 };
 
 static inline bool map_value_has_spin_lock(const struct bpf_map *map)
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 6f309248f13fc..6d4d08f57ad38 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -31,6 +31,7 @@
 #include <linux/bpf-netns.h>
 #include <linux/rcupdate_trace.h>
 #include <linux/memcontrol.h>
+#include <linux/cookie.h>
 
 #define IS_FD_ARRAY(map) ((map)->map_type == BPF_MAP_TYPE_PERF_EVENT_ARRAY || \
 			  (map)->map_type == BPF_MAP_TYPE_CGROUP_ARRAY || \
@@ -43,6 +44,7 @@
 #define BPF_OBJ_FLAG_MASK   (BPF_F_RDONLY | BPF_F_WRONLY)
 
 DEFINE_PER_CPU(int, bpf_prog_active);
+DEFINE_COOKIE(bpf_map_cookie);
 static DEFINE_IDR(prog_idr);
 static DEFINE_SPINLOCK(prog_idr_lock);
 static DEFINE_IDR(map_idr);
@@ -886,6 +888,10 @@ static int map_create(union bpf_attr *attr)
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



