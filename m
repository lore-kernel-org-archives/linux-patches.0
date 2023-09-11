Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5894011715
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:09:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD435C433C8;
	Mon, 11 Sep 2023 15:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444993;
	bh=/Jyc2mXavUzc6+XlcvoqO87xhKkPOgaxIQ8O4z86v9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sis9Q90l/bD2ABjflVTPCUdZhRZ158b6nzRjOrqpkZNOAEsayl4GkrfePQ7cKRIhy
	 RhJVpf0bt7JoBG4FflAk9iL5PB96+BcrLLwHdftPw/1MLJpNf8eb0UOcQSuYrBTiyq
	 bT3r4DKcCvDTx4lr/Qzyctk/I/XAKggquqwWQTOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Daniel T. Lee" <danieltimlee@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 189/600] samples/bpf: fix bio latency check with tracepoint
Date: Mon, 11 Sep 2023 15:43:42 +0200
Message-ID: <20230911134639.200195593@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel T. Lee <danieltimlee@gmail.com>

[ Upstream commit 92632115fb57ff9e368f256913e96d6fd5abf5ab ]

Recently, a new tracepoint for the block layer, specifically the
block_io_start/done tracepoints, was introduced in commit 5a80bd075f3b
("block: introduce block_io_start/block_io_done tracepoints").

Previously, the kprobe entry used for this purpose was quite unstable
and inherently broke relevant probes [1]. Now that a stable tracepoint
is available, this commit replaces the bio latency check with it.

One of the changes made during this replacement is the key used for the
hash table. Since 'struct request' cannot be used as a hash key, the
approach taken follows that which was implemented in bcc/biolatency [2].
(uses dev:sector for the key)

[1]: https://github.com/iovisor/bcc/issues/4261
[2]: https://github.com/iovisor/bcc/pull/4691

Fixes: 450b7879e345 ("block: move blk_account_io_{start,done} to blk-mq.c")
Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
Link: https://lore.kernel.org/r/20230818090119.477441-7-danieltimlee@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/tracex3_kern.c | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/samples/bpf/tracex3_kern.c b/samples/bpf/tracex3_kern.c
index bde6591cb20c5..af235bd6615b1 100644
--- a/samples/bpf/tracex3_kern.c
+++ b/samples/bpf/tracex3_kern.c
@@ -11,6 +11,12 @@
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
 
+struct start_key {
+	dev_t dev;
+	u32 _pad;
+	sector_t sector;
+};
+
 struct {
 	__uint(type, BPF_MAP_TYPE_HASH);
 	__type(key, long);
@@ -18,16 +24,17 @@ struct {
 	__uint(max_entries, 4096);
 } my_map SEC(".maps");
 
-/* kprobe is NOT a stable ABI. If kernel internals change this bpf+kprobe
- * example will no longer be meaningful
- */
-SEC("kprobe/blk_mq_start_request")
-int bpf_prog1(struct pt_regs *ctx)
+/* from /sys/kernel/tracing/events/block/block_io_start/format */
+SEC("tracepoint/block/block_io_start")
+int bpf_prog1(struct trace_event_raw_block_rq *ctx)
 {
-	long rq = PT_REGS_PARM1(ctx);
 	u64 val = bpf_ktime_get_ns();
+	struct start_key key = {
+		.dev = ctx->dev,
+		.sector = ctx->sector
+	};
 
-	bpf_map_update_elem(&my_map, &rq, &val, BPF_ANY);
+	bpf_map_update_elem(&my_map, &key, &val, BPF_ANY);
 	return 0;
 }
 
@@ -49,21 +56,26 @@ struct {
 	__uint(max_entries, SLOTS);
 } lat_map SEC(".maps");
 
-SEC("kprobe/__blk_account_io_done")
-int bpf_prog2(struct pt_regs *ctx)
+/* from /sys/kernel/tracing/events/block/block_io_done/format */
+SEC("tracepoint/block/block_io_done")
+int bpf_prog2(struct trace_event_raw_block_rq *ctx)
 {
-	long rq = PT_REGS_PARM1(ctx);
+	struct start_key key = {
+		.dev = ctx->dev,
+		.sector = ctx->sector
+	};
+
 	u64 *value, l, base;
 	u32 index;
 
-	value = bpf_map_lookup_elem(&my_map, &rq);
+	value = bpf_map_lookup_elem(&my_map, &key);
 	if (!value)
 		return 0;
 
 	u64 cur_time = bpf_ktime_get_ns();
 	u64 delta = cur_time - *value;
 
-	bpf_map_delete_elem(&my_map, &rq);
+	bpf_map_delete_elem(&my_map, &key);
 
 	/* the lines below are computing index = log10(delta)*10
 	 * using integer arithmetic
-- 
2.40.1



