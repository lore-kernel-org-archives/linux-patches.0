Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF44B22DFA7;
	Tue, 26 Aug 2025 14:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217598; cv=none; b=M6RLcmmc48wFyI77gEs6iCzjcEouVSIj6/Mo7/D5v4hkKW07UQAGzoehTQR0J7L6lN3M1cEv4q71uvbbtovfBjcmuBU1IkbJ7xeubTeiw1OqFl9kJSi+kqJhnCYqHAPxGvxOmD2ZHIO709JHx/cBLgiDhA4Oas42OsbumISU0DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217598; c=relaxed/simple;
	bh=GakCd+xnFUoxoyuis0s/ZK2T7uR/E6MpSKGqN3UYLI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lDANimOrHKKWNj6UzjVAmE0kZSUo1DNndqirvGjpQRbM3kdVVdH2AludcyIXbZjCQtShvb9c+46GmhE4gArT4kzJOlJXOYZ+CTr73y2ch6S5A40h774+91UNYQZ/CSGvYcmUgs7LB6BjBuyRt7TTaT6s/6WSbzRERVPi7K4o3gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jFIbpMHs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jFIbpMHs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 442B7C113D0;
	Tue, 26 Aug 2025 14:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217598;
	bh=GakCd+xnFUoxoyuis0s/ZK2T7uR/E6MpSKGqN3UYLI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jFIbpMHsV5u0gV1xMuD4LyEQ0BKteMuH+3prA3K76ThrP4ZMzKPxsFjguTroxiMm4
	 HPUPKDpsRT34hoB5f+uaDN9/TACzEH2PGi+hRqOCE6/TzJzCL7nl+JnEDzXvzRMDMs
	 8GnRf+35IESYRuhgFUtzAsrXHqK7FJ8eWOsxniQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Borisov <nborisov@suse.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 172/523] XArray: Add calls to might_alloc()
Date: Tue, 26 Aug 2025 13:06:22 +0200
Message-ID: <20250826110928.708792261@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 1dd685c414a7b9fdb3d23aca3aedae84f0b998ae ]

Catch bogus GFP flags deterministically, instead of occasionally
when we actually have to allocate memory.

Reported-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Stable-dep-of: 99765233ab42 ("NFS: Fixup allocation flags for nfsiod's __GFP_NORETRY")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/xarray.h         | 15 +++++++++++++++
 tools/include/linux/sched/mm.h |  2 ++
 2 files changed, 17 insertions(+)

diff --git a/include/linux/xarray.h b/include/linux/xarray.h
index 92c0160b3352..05c025c5c100 100644
--- a/include/linux/xarray.h
+++ b/include/linux/xarray.h
@@ -15,6 +15,7 @@
 #include <linux/kconfig.h>
 #include <linux/kernel.h>
 #include <linux/rcupdate.h>
+#include <linux/sched/mm.h>
 #include <linux/spinlock.h>
 #include <linux/types.h>
 
@@ -583,6 +584,7 @@ static inline void *xa_store_bh(struct xarray *xa, unsigned long index,
 {
 	void *curr;
 
+	might_alloc(gfp);
 	xa_lock_bh(xa);
 	curr = __xa_store(xa, index, entry, gfp);
 	xa_unlock_bh(xa);
@@ -609,6 +611,7 @@ static inline void *xa_store_irq(struct xarray *xa, unsigned long index,
 {
 	void *curr;
 
+	might_alloc(gfp);
 	xa_lock_irq(xa);
 	curr = __xa_store(xa, index, entry, gfp);
 	xa_unlock_irq(xa);
@@ -684,6 +687,7 @@ static inline void *xa_cmpxchg(struct xarray *xa, unsigned long index,
 {
 	void *curr;
 
+	might_alloc(gfp);
 	xa_lock(xa);
 	curr = __xa_cmpxchg(xa, index, old, entry, gfp);
 	xa_unlock(xa);
@@ -711,6 +715,7 @@ static inline void *xa_cmpxchg_bh(struct xarray *xa, unsigned long index,
 {
 	void *curr;
 
+	might_alloc(gfp);
 	xa_lock_bh(xa);
 	curr = __xa_cmpxchg(xa, index, old, entry, gfp);
 	xa_unlock_bh(xa);
@@ -738,6 +743,7 @@ static inline void *xa_cmpxchg_irq(struct xarray *xa, unsigned long index,
 {
 	void *curr;
 
+	might_alloc(gfp);
 	xa_lock_irq(xa);
 	curr = __xa_cmpxchg(xa, index, old, entry, gfp);
 	xa_unlock_irq(xa);
@@ -767,6 +773,7 @@ static inline int __must_check xa_insert(struct xarray *xa,
 {
 	int err;
 
+	might_alloc(gfp);
 	xa_lock(xa);
 	err = __xa_insert(xa, index, entry, gfp);
 	xa_unlock(xa);
@@ -796,6 +803,7 @@ static inline int __must_check xa_insert_bh(struct xarray *xa,
 {
 	int err;
 
+	might_alloc(gfp);
 	xa_lock_bh(xa);
 	err = __xa_insert(xa, index, entry, gfp);
 	xa_unlock_bh(xa);
@@ -825,6 +833,7 @@ static inline int __must_check xa_insert_irq(struct xarray *xa,
 {
 	int err;
 
+	might_alloc(gfp);
 	xa_lock_irq(xa);
 	err = __xa_insert(xa, index, entry, gfp);
 	xa_unlock_irq(xa);
@@ -854,6 +863,7 @@ static inline __must_check int xa_alloc(struct xarray *xa, u32 *id,
 {
 	int err;
 
+	might_alloc(gfp);
 	xa_lock(xa);
 	err = __xa_alloc(xa, id, entry, limit, gfp);
 	xa_unlock(xa);
@@ -883,6 +893,7 @@ static inline int __must_check xa_alloc_bh(struct xarray *xa, u32 *id,
 {
 	int err;
 
+	might_alloc(gfp);
 	xa_lock_bh(xa);
 	err = __xa_alloc(xa, id, entry, limit, gfp);
 	xa_unlock_bh(xa);
@@ -912,6 +923,7 @@ static inline int __must_check xa_alloc_irq(struct xarray *xa, u32 *id,
 {
 	int err;
 
+	might_alloc(gfp);
 	xa_lock_irq(xa);
 	err = __xa_alloc(xa, id, entry, limit, gfp);
 	xa_unlock_irq(xa);
@@ -945,6 +957,7 @@ static inline int xa_alloc_cyclic(struct xarray *xa, u32 *id, void *entry,
 {
 	int err;
 
+	might_alloc(gfp);
 	xa_lock(xa);
 	err = __xa_alloc_cyclic(xa, id, entry, limit, next, gfp);
 	xa_unlock(xa);
@@ -978,6 +991,7 @@ static inline int xa_alloc_cyclic_bh(struct xarray *xa, u32 *id, void *entry,
 {
 	int err;
 
+	might_alloc(gfp);
 	xa_lock_bh(xa);
 	err = __xa_alloc_cyclic(xa, id, entry, limit, next, gfp);
 	xa_unlock_bh(xa);
@@ -1011,6 +1025,7 @@ static inline int xa_alloc_cyclic_irq(struct xarray *xa, u32 *id, void *entry,
 {
 	int err;
 
+	might_alloc(gfp);
 	xa_lock_irq(xa);
 	err = __xa_alloc_cyclic(xa, id, entry, limit, next, gfp);
 	xa_unlock_irq(xa);
diff --git a/tools/include/linux/sched/mm.h b/tools/include/linux/sched/mm.h
index c8d9f19c1f35..967294b8edcf 100644
--- a/tools/include/linux/sched/mm.h
+++ b/tools/include/linux/sched/mm.h
@@ -1,4 +1,6 @@
 #ifndef _TOOLS_PERF_LINUX_SCHED_MM_H
 #define _TOOLS_PERF_LINUX_SCHED_MM_H
 
+#define might_alloc(gfp)	do { } while (0)
+
 #endif  /* _TOOLS_PERF_LINUX_SCHED_MM_H */
-- 
2.39.5



