Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54FC7185A;
	Sat, 13 Jan 2024 09:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UeU4QjE3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6AC0C433C7;
	Sat, 13 Jan 2024 09:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705139827;
	bh=Vqyo80m/S1p2ph4Jo2X46Rd0KT0wNGGJ8PRTN5rvrjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UeU4QjE3wKRCtCCFMIO9+wvcv86b/1BtWr4zgmgNNk4+rxBXPsRRwLORCVYDXfVkZ
	 AGpPk8ncKiDmq6J0PRDUgMMZpKWBGtjLBomDqtz0gbgP7wqsR7rhxQs3X1tk7t8GdY
	 eNIQXEVj6lqj4+45h+V8Ji1aamXIMHF6Sb3sHNAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Suraj Jitindar Singh <surajjs@amazon.com>
Subject: [PATCH 5.4 36/38] net/dst: use a smaller percpu_counter batch for dst entries accounting
Date: Sat, 13 Jan 2024 10:50:12 +0100
Message-ID: <20240113094207.556743428@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240113094206.455533180@linuxfoundation.org>
References: <20240113094206.455533180@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit cf86a086a18095e33e0637cb78cda1fcf5280852 upstream.

percpu_counter_add() uses a default batch size which is quite big
on platforms with 256 cpus. (2*256 -> 512)

This means dst_entries_get_fast() can be off by +/- 2*(nr_cpus^2)
(131072 on servers with 256 cpus)

Reduce the batch size to something more reasonable, and
add logic to ip6_dst_gc() to call dst_entries_get_slow()
before calling the _very_ expensive fib6_run_gc() function.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
Cc: <stable@vger.kernel.org> # 5.4.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/dst_ops.h |    4 +++-
 net/core/dst.c        |    8 ++++----
 net/ipv6/route.c      |    3 +++
 3 files changed, 10 insertions(+), 5 deletions(-)

--- a/include/net/dst_ops.h
+++ b/include/net/dst_ops.h
@@ -53,9 +53,11 @@ static inline int dst_entries_get_slow(s
 	return percpu_counter_sum_positive(&dst->pcpuc_entries);
 }
 
+#define DST_PERCPU_COUNTER_BATCH 32
 static inline void dst_entries_add(struct dst_ops *dst, int val)
 {
-	percpu_counter_add(&dst->pcpuc_entries, val);
+	percpu_counter_add_batch(&dst->pcpuc_entries, val,
+				 DST_PERCPU_COUNTER_BATCH);
 }
 
 static inline int dst_entries_init(struct dst_ops *dst)
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -81,11 +81,11 @@ void *dst_alloc(struct dst_ops *ops, str
 {
 	struct dst_entry *dst;
 
-	if (ops->gc && dst_entries_get_fast(ops) > ops->gc_thresh) {
+	if (ops->gc &&
+	    !(flags & DST_NOCOUNT) &&
+	    dst_entries_get_fast(ops) > ops->gc_thresh) {
 		if (ops->gc(ops)) {
-			printk_ratelimited(KERN_NOTICE "Route cache is full: "
-					   "consider increasing sysctl "
-					   "net.ipv[4|6].route.max_size.\n");
+			pr_notice_ratelimited("Route cache is full: consider increasing sysctl net.ipv6.route.max_size.\n");
 			return NULL;
 		}
 	}
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3218,6 +3218,9 @@ static int ip6_dst_gc(struct dst_ops *op
 	int entries;
 
 	entries = dst_entries_get_fast(ops);
+	if (entries > rt_max_size)
+		entries = dst_entries_get_slow(ops);
+
 	if (time_after(rt_last_gc + rt_min_interval, jiffies) &&
 	    entries <= rt_max_size)
 		goto out;


