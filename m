Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 895A6280328;
	Tue, 27 May 2025 17:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368593; cv=none; b=g7Ut7nDvx2hIAuSrfZsxSaUWhUBanzUj0FGQ1PEexsAlvjXrGffJnV0kjtDuwzWaHWPS2Y9sibqGQPpU6DCl9XtDGj6fmIxZ6ik2iV7TXzVCxde1uw6tRvigjHzA4a4TI9KDWqAc/q3DnD8e2uCl+OAJCqaOkD81O+CUe/+z6v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368593; c=relaxed/simple;
	bh=7zYxIHp9+rwSBk+4JL8wNON/kNyDGVArUcuAj0Ijms4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o4cFm0TfVlpF8bEaYnuBlSj764suKedUsoxgzb1h+s6z2v9KcBroZKPCAfJyRtkwE68IeGkJK3i+5Eq1ss2AEcDh75sS7ZCWAd7CXUKuIPzcC5AMIlEs7Qz4PqjlpYsy3nE8xad63aooxRjglh4OrECk7Fa7FOot6CMzMv4Gmjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kl1wn5Rp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kl1wn5Rp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0316C4CEE9;
	Tue, 27 May 2025 17:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368593;
	bh=7zYxIHp9+rwSBk+4JL8wNON/kNyDGVArUcuAj0Ijms4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kl1wn5Rp63X5K3Vk+qTBxRcDL3l4PGcZWUsORMUVzX0LqeAZY52DTiTYikv6oHCcB
	 7PuxCievPDY3pbbLH9MlBaM1HUYq9vNvvdPc0kxJLUt8U7oGpzfz0Tj69j5AUq4/1X
	 VGLd5gRxj8jX645bQynC1ZmidTIfgygy7p/4ZzTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Yaxin <wang.yaxin@zte.com.cn>,
	xu xin <xu.xin16@zte.com.cn>,
	Kun Jiang <jiang.kun2@zte.com.cn>,
	Yang Yang <yang.yang29@zte.com.cn>,
	Balbir Singh <bsingharora@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.14 758/783] taskstats: fix struct taskstats breaks backward compatibility since version 15
Date: Tue, 27 May 2025 18:29:15 +0200
Message-ID: <20250527162543.990410801@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Yaxin <wang.yaxin@zte.com.cn>

commit 0bf2d838de1ffb6d0bb6f8d18a6ccc59b7d9a705 upstream.

Problem
========
commit 658eb5ab916d ("delayacct: add delay max to record delay peak")
  - adding more fields
commit f65c64f311ee ("delayacct: add delay min to record delay peak")
  - adding more fields
commit b016d0873777 ("taskstats: modify taskstats version")
 - version bump to 15

Since version 15 (TASKSTATS_VERSION=15) the new layout of the structure
adds fields in the middle of the structure, rendering all old software
incompatible with newer kernels and software compiled against the new
kernel headers incompatible with older kernels.

Solution
=========
move delay max and delay min to the end of taskstat, and bump
the version to 16 after the change

[wang.yaxin@zte.com.cn: adjust indentation]
  Link: https://lkml.kernel.org/r/202505192131489882NSciXV4EGd8zzjLuwoOK@zte.com.cn
Link: https://lkml.kernel.org/r/20250510155413259V4JNRXxukdDgzsaL0Fo6a@zte.com.cn
Fixes: f65c64f311ee ("delayacct: add delay min to record delay peak")
Signed-off-by: Wang Yaxin <wang.yaxin@zte.com.cn>
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Signed-off-by: Kun Jiang <jiang.kun2@zte.com.cn>
Reviewed-by: Yang Yang <yang.yang29@zte.com.cn>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/taskstats.h | 47 +++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 18 deletions(-)

diff --git a/include/uapi/linux/taskstats.h b/include/uapi/linux/taskstats.h
index 95762232e018..5929030d4e8b 100644
--- a/include/uapi/linux/taskstats.h
+++ b/include/uapi/linux/taskstats.h
@@ -34,7 +34,7 @@
  */
 
 
-#define TASKSTATS_VERSION	15
+#define TASKSTATS_VERSION	16
 #define TS_COMM_LEN		32	/* should be >= TASK_COMM_LEN
 					 * in linux/sched.h */
 
@@ -72,8 +72,6 @@ struct taskstats {
 	 */
 	__u64	cpu_count __attribute__((aligned(8)));
 	__u64	cpu_delay_total;
-	__u64	cpu_delay_max;
-	__u64	cpu_delay_min;
 
 	/* Following four fields atomically updated using task->delays->lock */
 
@@ -82,14 +80,10 @@ struct taskstats {
 	 */
 	__u64	blkio_count;
 	__u64	blkio_delay_total;
-	__u64	blkio_delay_max;
-	__u64	blkio_delay_min;
 
 	/* Delay waiting for page fault I/O (swap in only) */
 	__u64	swapin_count;
 	__u64	swapin_delay_total;
-	__u64	swapin_delay_max;
-	__u64	swapin_delay_min;
 
 	/* cpu "wall-clock" running time
 	 * On some architectures, value will adjust for cpu time stolen
@@ -172,14 +166,11 @@ struct taskstats {
 	/* Delay waiting for memory reclaim */
 	__u64	freepages_count;
 	__u64	freepages_delay_total;
-	__u64	freepages_delay_max;
-	__u64	freepages_delay_min;
+
 
 	/* Delay waiting for thrashing page */
 	__u64	thrashing_count;
 	__u64	thrashing_delay_total;
-	__u64	thrashing_delay_max;
-	__u64	thrashing_delay_min;
 
 	/* v10: 64-bit btime to avoid overflow */
 	__u64	ac_btime64;		/* 64-bit begin time */
@@ -187,8 +178,6 @@ struct taskstats {
 	/* v11: Delay waiting for memory compact */
 	__u64	compact_count;
 	__u64	compact_delay_total;
-	__u64	compact_delay_max;
-	__u64	compact_delay_min;
 
 	/* v12 begin */
 	__u32   ac_tgid;	/* thread group ID */
@@ -210,15 +199,37 @@ struct taskstats {
 	/* v13: Delay waiting for write-protect copy */
 	__u64    wpcopy_count;
 	__u64    wpcopy_delay_total;
-	__u64    wpcopy_delay_max;
-	__u64    wpcopy_delay_min;
 
 	/* v14: Delay waiting for IRQ/SOFTIRQ */
 	__u64    irq_count;
 	__u64    irq_delay_total;
-	__u64    irq_delay_max;
-	__u64    irq_delay_min;
-	/* v15: add Delay max */
+
+	/* v15: add Delay max and Delay min */
+
+	/* v16: move Delay max and Delay min to the end of taskstat */
+	__u64	cpu_delay_max;
+	__u64	cpu_delay_min;
+
+	__u64	blkio_delay_max;
+	__u64	blkio_delay_min;
+
+	__u64	swapin_delay_max;
+	__u64	swapin_delay_min;
+
+	__u64	freepages_delay_max;
+	__u64	freepages_delay_min;
+
+	__u64	thrashing_delay_max;
+	__u64	thrashing_delay_min;
+
+	__u64	compact_delay_max;
+	__u64	compact_delay_min;
+
+	__u64	wpcopy_delay_max;
+	__u64	wpcopy_delay_min;
+
+	__u64	irq_delay_max;
+	__u64	irq_delay_min;
 };
 
 
-- 
2.49.0



