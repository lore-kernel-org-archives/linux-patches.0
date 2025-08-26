Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 125A134AB0C;
	Tue, 26 Aug 2025 13:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216027; cv=none; b=bTy8ZlNYMFOA77ncwoBQX8QEaT7LIppXagRQrKkF+Y1kHc3jSoSK505uvcVmNylWZhmhzMXRSuxRLwKgpiFhg0yI7oXThl/q0k0maLRy8E+q/CT/wOQ8Y4krJQyxOoWy0FS25Wdge1vDUxHnBWp3Fh1eoRDMddCl7Gxr3Tu28FM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216027; c=relaxed/simple;
	bh=HAjiWDkJU2DVOJh3Pwf+AACOHaiEa3vRgflXi8Ysyyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AIPctDOaUdCC3yferWfEjlqGXaU9LFDXGQRRhv4KMdaniM7QAgFFTzhFDLthi+9s04sBjMUA/cPhHxU9evwvd3XOYxpTl2D65txdwh/iCZpZRYIm1gQGG9FMHyIZsjhcIAsHCWerHzURoKqpNAj0NYrEilYmUrC9/fqgavUSY1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xEWsv2Rg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xEWsv2Rg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A7DAC4CEF1;
	Tue, 26 Aug 2025 13:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216026;
	bh=HAjiWDkJU2DVOJh3Pwf+AACOHaiEa3vRgflXi8Ysyyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xEWsv2RgXCvvAdC8htMING1vsiwoMDC1ltPnnOHdIJ/K7gnK2qg466bw/TIjhyG/U
	 17//dwm7U3EyGzFFl95PrZ48K/gjmQcWYfS1H1cVhjJQIFRSoNlfhtVjiebR36T0Ig
	 W05PBvQBKFBKKDVIldr0kSK3CqpJJMcRydorRRaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Borisov <nborisov@suse.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 229/644] XArray: Add calls to might_alloc()
Date: Tue, 26 Aug 2025 13:05:20 +0200
Message-ID: <20250826110952.089712134@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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
index a91e3d90df8a..549f222a2a6f 100644
--- a/include/linux/xarray.h
+++ b/include/linux/xarray.h
@@ -15,6 +15,7 @@
 #include <linux/kconfig.h>
 #include <linux/kernel.h>
 #include <linux/rcupdate.h>
+#include <linux/sched/mm.h>
 #include <linux/spinlock.h>
 #include <linux/types.h>
 
@@ -585,6 +586,7 @@ static inline void *xa_store_bh(struct xarray *xa, unsigned long index,
 {
 	void *curr;
 
+	might_alloc(gfp);
 	xa_lock_bh(xa);
 	curr = __xa_store(xa, index, entry, gfp);
 	xa_unlock_bh(xa);
@@ -611,6 +613,7 @@ static inline void *xa_store_irq(struct xarray *xa, unsigned long index,
 {
 	void *curr;
 
+	might_alloc(gfp);
 	xa_lock_irq(xa);
 	curr = __xa_store(xa, index, entry, gfp);
 	xa_unlock_irq(xa);
@@ -686,6 +689,7 @@ static inline void *xa_cmpxchg(struct xarray *xa, unsigned long index,
 {
 	void *curr;
 
+	might_alloc(gfp);
 	xa_lock(xa);
 	curr = __xa_cmpxchg(xa, index, old, entry, gfp);
 	xa_unlock(xa);
@@ -713,6 +717,7 @@ static inline void *xa_cmpxchg_bh(struct xarray *xa, unsigned long index,
 {
 	void *curr;
 
+	might_alloc(gfp);
 	xa_lock_bh(xa);
 	curr = __xa_cmpxchg(xa, index, old, entry, gfp);
 	xa_unlock_bh(xa);
@@ -740,6 +745,7 @@ static inline void *xa_cmpxchg_irq(struct xarray *xa, unsigned long index,
 {
 	void *curr;
 
+	might_alloc(gfp);
 	xa_lock_irq(xa);
 	curr = __xa_cmpxchg(xa, index, old, entry, gfp);
 	xa_unlock_irq(xa);
@@ -769,6 +775,7 @@ static inline int __must_check xa_insert(struct xarray *xa,
 {
 	int err;
 
+	might_alloc(gfp);
 	xa_lock(xa);
 	err = __xa_insert(xa, index, entry, gfp);
 	xa_unlock(xa);
@@ -798,6 +805,7 @@ static inline int __must_check xa_insert_bh(struct xarray *xa,
 {
 	int err;
 
+	might_alloc(gfp);
 	xa_lock_bh(xa);
 	err = __xa_insert(xa, index, entry, gfp);
 	xa_unlock_bh(xa);
@@ -827,6 +835,7 @@ static inline int __must_check xa_insert_irq(struct xarray *xa,
 {
 	int err;
 
+	might_alloc(gfp);
 	xa_lock_irq(xa);
 	err = __xa_insert(xa, index, entry, gfp);
 	xa_unlock_irq(xa);
@@ -856,6 +865,7 @@ static inline __must_check int xa_alloc(struct xarray *xa, u32 *id,
 {
 	int err;
 
+	might_alloc(gfp);
 	xa_lock(xa);
 	err = __xa_alloc(xa, id, entry, limit, gfp);
 	xa_unlock(xa);
@@ -885,6 +895,7 @@ static inline int __must_check xa_alloc_bh(struct xarray *xa, u32 *id,
 {
 	int err;
 
+	might_alloc(gfp);
 	xa_lock_bh(xa);
 	err = __xa_alloc(xa, id, entry, limit, gfp);
 	xa_unlock_bh(xa);
@@ -914,6 +925,7 @@ static inline int __must_check xa_alloc_irq(struct xarray *xa, u32 *id,
 {
 	int err;
 
+	might_alloc(gfp);
 	xa_lock_irq(xa);
 	err = __xa_alloc(xa, id, entry, limit, gfp);
 	xa_unlock_irq(xa);
@@ -947,6 +959,7 @@ static inline int xa_alloc_cyclic(struct xarray *xa, u32 *id, void *entry,
 {
 	int err;
 
+	might_alloc(gfp);
 	xa_lock(xa);
 	err = __xa_alloc_cyclic(xa, id, entry, limit, next, gfp);
 	xa_unlock(xa);
@@ -980,6 +993,7 @@ static inline int xa_alloc_cyclic_bh(struct xarray *xa, u32 *id, void *entry,
 {
 	int err;
 
+	might_alloc(gfp);
 	xa_lock_bh(xa);
 	err = __xa_alloc_cyclic(xa, id, entry, limit, next, gfp);
 	xa_unlock_bh(xa);
@@ -1013,6 +1027,7 @@ static inline int xa_alloc_cyclic_irq(struct xarray *xa, u32 *id, void *entry,
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



