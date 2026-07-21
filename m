Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C3335A393;
	Tue, 21 Jul 2026 15:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648982; cv=none; b=txB4TOZi4JijGYsrvD4V6nXIEQROfsAwPftK/TgQ4yNWoZ52h4iKy6X8BwQEVV4hjTkURgyaOYRSWSlvXW3TsSGomXBP/dZsSwbQ6mto3PmUQVo7mKpAZTm4skGys0N7ESX+L6qmH0SVsQgBKzOziFDYTLVe8GUjwJJOknF5IXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648982; c=relaxed/simple;
	bh=NvTyUkTX7vyVqP+3OsACvHi8hEXMbW5xodLsDWumLC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OV1BT/yS2U2FOt5QtUt66i239sOnftqGIjG11IzVccQyi5EGFzmmEI3ZRUcSQGFIl06+lrCnHSVLEzr8vnu+2sniG/kzbQ8yzbvNMItkTbx7u6dK6L7kDcd37C4tqPLk2AHQSxfUJrqB/prf8NhPUrXEvTBd6DcpK5CkeoKqeps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zh6nARlG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zh6nARlG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A05B1F00A3A;
	Tue, 21 Jul 2026 15:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648980;
	bh=TT0j2L+QjwjiJbqWJ183QONFRDw9jU2AlJjCdOwPfj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zh6nARlGIhc2Vm20HDc3aEOlNc1AczYbl3PT+hbuae+pnBuyt6qdOYz4rsIn6aZZk
	 L6iiSUaZl0QOmbI2EB98RFL2Wcqvowris+6ewwutu3ewLrqCo7OscZzyoOmgJMxOWx
	 CSwn+MALf4hFnSf2yud9WdOnSi2+/acVBsUdllkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Matlack <dmatlack@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0403/2077] liveupdate: Use refcount_t for FLB reference counts
Date: Tue, 21 Jul 2026 17:01:16 +0200
Message-ID: <20260721152602.222841854@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Matlack <dmatlack@google.com>

[ Upstream commit d2850ff2f8c5acda4c1097aa53c006a75b091f2c ]

Use refcount_t instead of a raw integer to keep track of references on
incoming and outgoing FLBs. Using refcount_t provides protection from
overflow, underflow, and other issues.

Fixes: cab056f2aae7 ("liveupdate: luo_flb: introduce File-Lifecycle-Bound global state")
Signed-off-by: David Matlack <dmatlack@google.com>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Link: https://lore.kernel.org/r/20260423174032.3140399-2-dmatlack@google.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/liveupdate.h  |  3 ++-
 kernel/liveupdate/luo_flb.c | 22 ++++++++++------------
 2 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
index 30c5a39ff9e9c2..8d3bbc35c828b8 100644
--- a/include/linux/liveupdate.h
+++ b/include/linux/liveupdate.h
@@ -12,6 +12,7 @@
 #include <linux/kho/abi/luo.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
+#include <linux/refcount.h>
 #include <linux/rwsem.h>
 #include <linux/types.h>
 #include <uapi/linux/liveupdate.h>
@@ -175,7 +176,7 @@ struct liveupdate_flb_ops {
  * @retrieved: True once the FLB's retrieve() callback has run.
  */
 struct luo_flb_private_state {
-	long count;
+	refcount_t count;
 	u64 data;
 	void *obj;
 	struct mutex lock;
diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
index 00f5494812c4ab..59c5f31ab76740 100644
--- a/kernel/liveupdate/luo_flb.c
+++ b/kernel/liveupdate/luo_flb.c
@@ -111,7 +111,7 @@ static int luo_flb_file_preserve_one(struct liveupdate_flb *flb)
 	struct luo_flb_private *private = luo_flb_get_private(flb);
 
 	scoped_guard(mutex, &private->outgoing.lock) {
-		if (!private->outgoing.count) {
+		if (!refcount_read(&private->outgoing.count)) {
 			struct liveupdate_flb_op_args args = {0};
 			int err;
 
@@ -126,8 +126,10 @@ static int luo_flb_file_preserve_one(struct liveupdate_flb *flb)
 			}
 			private->outgoing.data = args.data;
 			private->outgoing.obj = args.obj;
+			refcount_set(&private->outgoing.count, 1);
+		} else {
+			refcount_inc(&private->outgoing.count);
 		}
-		private->outgoing.count++;
 	}
 
 	return 0;
@@ -138,8 +140,7 @@ static void luo_flb_file_unpreserve_one(struct liveupdate_flb *flb)
 	struct luo_flb_private *private = luo_flb_get_private(flb);
 
 	scoped_guard(mutex, &private->outgoing.lock) {
-		private->outgoing.count--;
-		if (!private->outgoing.count) {
+		if (refcount_dec_and_test(&private->outgoing.count)) {
 			struct liveupdate_flb_op_args args = {0};
 
 			args.flb = flb;
@@ -178,7 +179,7 @@ static int luo_flb_retrieve_one(struct liveupdate_flb *flb)
 	for (int i = 0; i < fh->header_ser->count; i++) {
 		if (!strcmp(fh->ser[i].name, flb->compatible)) {
 			private->incoming.data = fh->ser[i].data;
-			private->incoming.count = fh->ser[i].count;
+			refcount_set(&private->incoming.count, fh->ser[i].count);
 			found = true;
 			break;
 		}
@@ -208,12 +209,8 @@ static int luo_flb_retrieve_one(struct liveupdate_flb *flb)
 static void luo_flb_file_finish_one(struct liveupdate_flb *flb)
 {
 	struct luo_flb_private *private = luo_flb_get_private(flb);
-	u64 count;
 
-	scoped_guard(mutex, &private->incoming.lock)
-		count = --private->incoming.count;
-
-	if (!count) {
+	if (refcount_dec_and_test(&private->incoming.count)) {
 		struct liveupdate_flb_op_args args = {0};
 
 		if (!private->incoming.retrieved) {
@@ -652,12 +649,13 @@ void luo_flb_serialize(void)
 	guard(rwsem_read)(&luo_register_rwlock);
 	list_private_for_each_entry(gflb, &luo_flb_global.list, private.list) {
 		struct luo_flb_private *private = luo_flb_get_private(gflb);
+		long count = refcount_read(&private->outgoing.count);
 
-		if (private->outgoing.count > 0) {
+		if (count > 0) {
 			strscpy(fh->ser[i].name, gflb->compatible,
 				sizeof(fh->ser[i].name));
 			fh->ser[i].data = private->outgoing.data;
-			fh->ser[i].count = private->outgoing.count;
+			fh->ser[i].count = count;
 			i++;
 		}
 	}
-- 
2.53.0



