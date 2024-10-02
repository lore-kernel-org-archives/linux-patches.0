Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A041D0B8C;
	Wed,  2 Oct 2024 14:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880607; cv=none; b=SKUzf9csPvVrK9Mgi1XpwgAwKwb9g84EuzFGWqXVYBJzfS6RaEm0EBqywqPUDeiQGts1uyeZ52v07dc5zhgTxXOLSfrIdLYUwpBFvR8jwZnnbrRw/IfaVKXirkgaxh1vSiqLc75my+0JbpXoL/D+4lk/Ldopen6yWYzTEjTfq2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880607; c=relaxed/simple;
	bh=0PQoHr5p3xRgya4FU8fGTymv1IRlDIOU6zvcC/tyJMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dvKbxEjBoycNMaek9ZkL6tqscSM2+4pyf41Ci4B6cnZBSRz6MhLWn+aqo5xGCW6SqktIQqccnFW9yiaJ97f9tW0dzYW9sA+uBOlP9veKmeLRD+RVl6HXZfQgSaAzLdkdZcmO0sR9hphXvsPLXo5gB1wh/R6puGBTW8bwLS6e4e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WaLxVSeL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WaLxVSeL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EBD1C4CEC2;
	Wed,  2 Oct 2024 14:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880606;
	bh=0PQoHr5p3xRgya4FU8fGTymv1IRlDIOU6zvcC/tyJMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WaLxVSeLRfO4x68fiLY2xHoTomYsECsOot92aq+L0ngvGLRtQ3lxJLgjf5oa9CnqN
	 wRPfOtwGuF+TsgwTDH9ixLY5feF1Ndt8w05+0vEnhTVyuDtS01tVIHSqzWFK4K1cZ1
	 7dwxYlXnWxSzW3fk5wiU1fTp4EL1zubsMM7TRGec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kairui Song <kasong@tencent.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 517/538] lib/xarray: introduce a new helper xas_get_order
Date: Wed,  2 Oct 2024 15:02:36 +0200
Message-ID: <20241002125812.853836033@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kairui Song <kasong@tencent.com>

commit a4864671ca0bf51c8e78242951741df52c06766f upstream.

It can be used after xas_load to check the order of loaded entries.
Compared to xa_get_order, it saves an XA_STATE and avoid a rewalk.

Added new test for xas_get_order, to make the test work, we have to export
xas_get_order with EXPORT_SYMBOL_GPL.

Also fix a sparse warning by checking the slot value with xa_entry instead
of accessing it directly, as suggested by Matthew Wilcox.

[kasong@tencent.com: simplify comment, sparse warning fix, per Matthew Wilcox]
  Link: https://lkml.kernel.org/r/20240416071722.45997-4-ryncsn@gmail.com
Link: https://lkml.kernel.org/r/20240415171857.19244-4-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 6758c1128ceb ("mm/filemap: optimize filemap folio adding")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/xarray.h |    6 ++++++
 lib/test_xarray.c      |   34 ++++++++++++++++++++++++++++++++++
 lib/xarray.c           |   49 +++++++++++++++++++++++++++++++------------------
 3 files changed, 71 insertions(+), 18 deletions(-)

--- a/include/linux/xarray.h
+++ b/include/linux/xarray.h
@@ -1548,6 +1548,7 @@ void xas_create_range(struct xa_state *)
 
 #ifdef CONFIG_XARRAY_MULTI
 int xa_get_order(struct xarray *, unsigned long index);
+int xas_get_order(struct xa_state *xas);
 void xas_split(struct xa_state *, void *entry, unsigned int order);
 void xas_split_alloc(struct xa_state *, void *entry, unsigned int order, gfp_t);
 #else
@@ -1555,6 +1556,11 @@ static inline int xa_get_order(struct xa
 {
 	return 0;
 }
+
+static inline int xas_get_order(struct xa_state *xas)
+{
+	return 0;
+}
 
 static inline void xas_split(struct xa_state *xas, void *entry,
 		unsigned int order)
--- a/lib/test_xarray.c
+++ b/lib/test_xarray.c
@@ -1756,6 +1756,39 @@ static noinline void check_get_order(str
 	}
 }
 
+static noinline void check_xas_get_order(struct xarray *xa)
+{
+	XA_STATE(xas, xa, 0);
+
+	unsigned int max_order = IS_ENABLED(CONFIG_XARRAY_MULTI) ? 20 : 1;
+	unsigned int order;
+	unsigned long i, j;
+
+	for (order = 0; order < max_order; order++) {
+		for (i = 0; i < 10; i++) {
+			xas_set_order(&xas, i << order, order);
+			do {
+				xas_lock(&xas);
+				xas_store(&xas, xa_mk_value(i));
+				xas_unlock(&xas);
+			} while (xas_nomem(&xas, GFP_KERNEL));
+
+			for (j = i << order; j < (i + 1) << order; j++) {
+				xas_set_order(&xas, j, 0);
+				rcu_read_lock();
+				xas_load(&xas);
+				XA_BUG_ON(xa, xas_get_order(&xas) != order);
+				rcu_read_unlock();
+			}
+
+			xas_lock(&xas);
+			xas_set_order(&xas, i << order, order);
+			xas_store(&xas, NULL);
+			xas_unlock(&xas);
+		}
+	}
+}
+
 static noinline void check_destroy(struct xarray *xa)
 {
 	unsigned long index;
@@ -1805,6 +1838,7 @@ static int xarray_checks(void)
 	check_reserve(&xa0);
 	check_multi_store(&array);
 	check_get_order(&array);
+	check_xas_get_order(&array);
 	check_xa_alloc();
 	check_find(&array);
 	check_find_entry(&array);
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -1750,39 +1750,52 @@ unlock:
 EXPORT_SYMBOL(xa_store_range);
 
 /**
- * xa_get_order() - Get the order of an entry.
- * @xa: XArray.
- * @index: Index of the entry.
+ * xas_get_order() - Get the order of an entry.
+ * @xas: XArray operation state.
+ *
+ * Called after xas_load, the xas should not be in an error state.
  *
  * Return: A number between 0 and 63 indicating the order of the entry.
  */
-int xa_get_order(struct xarray *xa, unsigned long index)
+int xas_get_order(struct xa_state *xas)
 {
-	XA_STATE(xas, xa, index);
-	void *entry;
 	int order = 0;
 
-	rcu_read_lock();
-	entry = xas_load(&xas);
-
-	if (!entry)
-		goto unlock;
-
-	if (!xas.xa_node)
-		goto unlock;
+	if (!xas->xa_node)
+		return 0;
 
 	for (;;) {
-		unsigned int slot = xas.xa_offset + (1 << order);
+		unsigned int slot = xas->xa_offset + (1 << order);
 
 		if (slot >= XA_CHUNK_SIZE)
 			break;
-		if (!xa_is_sibling(xas.xa_node->slots[slot]))
+		if (!xa_is_sibling(xa_entry(xas->xa, xas->xa_node, slot)))
 			break;
 		order++;
 	}
 
-	order += xas.xa_node->shift;
-unlock:
+	order += xas->xa_node->shift;
+	return order;
+}
+EXPORT_SYMBOL_GPL(xas_get_order);
+
+/**
+ * xa_get_order() - Get the order of an entry.
+ * @xa: XArray.
+ * @index: Index of the entry.
+ *
+ * Return: A number between 0 and 63 indicating the order of the entry.
+ */
+int xa_get_order(struct xarray *xa, unsigned long index)
+{
+	XA_STATE(xas, xa, index);
+	int order = 0;
+	void *entry;
+
+	rcu_read_lock();
+	entry = xas_load(&xas);
+	if (entry)
+		order = xas_get_order(&xas);
 	rcu_read_unlock();
 
 	return order;


