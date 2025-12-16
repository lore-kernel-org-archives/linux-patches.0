Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF63357704;
	Tue, 16 Dec 2025 12:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887252; cv=none; b=hf4NogCxLY0UFzSD1+iM4zAJXgsrnCJaQpMsieSIh8v2zCpcQpVjtP9nfICO0XgiJIrBMC0E1wAtyaseGXg/d6byYTJ7a0E0lGzApq775ollIbiRDzKUT4wfdAJVmeaccHTop8cQH8JBMoWQmJy1O9vESIqNJfzV0ubP9UFwWfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887252; c=relaxed/simple;
	bh=dB5Yuubj1APxhSpU1LFd1fF+EUDym56HDgsO9HMjLK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ej+LzQOIL7QjJkic7VvLkoR6fcT8NJhsUDUXTN3BbWA0okp5lcyh4mfS6XIP/skVSJKzcp1MnwRvuH1cBQYCg2p0zZWZO4ZLTVaPNrTmDduyvsKGA9Rg7jqPR0Zur9n08pARj9IqB/S5GiXqS2n9/cRFtfQaLIArylEDE4YP6FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qfi0pZk1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qfi0pZk1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97B13C4CEF1;
	Tue, 16 Dec 2025 12:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887252;
	bh=dB5Yuubj1APxhSpU1LFd1fF+EUDym56HDgsO9HMjLK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qfi0pZk11KI0osRLNCDYkx+yQWuiDlO1W8Qiw/7pSPHLLZtY9wECFrIBLZ16KwnoF
	 9k6FOERfai0BMovLbFqG+enGpgH5sCaQt3pzeK3ZmVod0sp/iP1ijAtXbik0lMclnm
	 Klw+EydZl21hAT28JzVMGuEA9iEISrTmoUD2MkKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c9b724fbb41cf2538b7b@syzkaller.appspotmail.com,
	Arnaud Lecomte <contact@arnaud-lcm.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 140/614] bpf: Fix stackmap overflow check in __bpf_get_stackid()
Date: Tue, 16 Dec 2025 12:08:27 +0100
Message-ID: <20251216111406.406397404@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaud Lecomte <contact@arnaud-lcm.com>

[ Upstream commit 23f852daa4bab4d579110e034e4d513f7d490846 ]

Syzkaller reported a KASAN slab-out-of-bounds write in __bpf_get_stackid()
when copying stack trace data. The issue occurs when the perf trace
 contains more stack entries than the stack map bucket can hold,
 leading to an out-of-bounds write in the bucket's data array.

Fixes: ee2a098851bf ("bpf: Adjust BPF stack helper functions to accommodate skip > 0")
Reported-by: syzbot+c9b724fbb41cf2538b7b@syzkaller.appspotmail.com
Signed-off-by: Arnaud Lecomte <contact@arnaud-lcm.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Acked-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/bpf/20251025192941.1500-1-contact@arnaud-lcm.com

Closes: https://syzkaller.appspot.com/bug?extid=c9b724fbb41cf2538b7b
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/stackmap.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index 5e9ad050333c2..2365541c81dd1 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -251,8 +251,8 @@ static long __bpf_get_stackid(struct bpf_map *map,
 {
 	struct bpf_stack_map *smap = container_of(map, struct bpf_stack_map, map);
 	struct stack_map_bucket *bucket, *new_bucket, *old_bucket;
+	u32 hash, id, trace_nr, trace_len, i, max_depth;
 	u32 skip = flags & BPF_F_SKIP_FIELD_MASK;
-	u32 hash, id, trace_nr, trace_len, i;
 	bool user = flags & BPF_F_USER_STACK;
 	u64 *ips;
 	bool hash_matches;
@@ -261,7 +261,8 @@ static long __bpf_get_stackid(struct bpf_map *map,
 		/* skipping more than usable stack trace */
 		return -EFAULT;
 
-	trace_nr = trace->nr - skip;
+	max_depth = stack_map_calculate_max_depth(map->value_size, stack_map_data_size(map), flags);
+	trace_nr = min_t(u32, trace->nr - skip, max_depth - skip);
 	trace_len = trace_nr * sizeof(u64);
 	ips = trace->ip + skip;
 	hash = jhash2((u32 *)ips, trace_len / sizeof(u32), 0);
@@ -390,15 +391,11 @@ BPF_CALL_3(bpf_get_stackid_pe, struct bpf_perf_event_data_kern *, ctx,
 		return -EFAULT;
 
 	nr_kernel = count_kernel_ip(trace);
+	__u64 nr = trace->nr; /* save original */
 
 	if (kernel) {
-		__u64 nr = trace->nr;
-
 		trace->nr = nr_kernel;
 		ret = __bpf_get_stackid(map, trace, flags);
-
-		/* restore nr */
-		trace->nr = nr;
 	} else { /* user */
 		u64 skip = flags & BPF_F_SKIP_FIELD_MASK;
 
@@ -409,6 +406,10 @@ BPF_CALL_3(bpf_get_stackid_pe, struct bpf_perf_event_data_kern *, ctx,
 		flags = (flags & ~BPF_F_SKIP_FIELD_MASK) | skip;
 		ret = __bpf_get_stackid(map, trace, flags);
 	}
+
+	/* restore nr */
+	trace->nr = nr;
+
 	return ret;
 }
 
-- 
2.51.0



