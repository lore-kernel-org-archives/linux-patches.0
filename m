Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40F5384CED;
	Sat, 17 Oct 2026 16:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254407; cv=none; b=h5WihNskl4yu6Ny7n2MBPAj0IgeBNHfJn1/BvxJeIwMXfwOP/nkbgjMwCT89lbmXiHGuTbv0B7Ao2dFrWJC9I/qLPgOmzQLhT6nJVA2IOLE9PKrhVTwPmsGuE5yuoZOCKRZ2RE0dRrTMiD+mch9f874dyOiSySd4uOxUvLKqPz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254407; c=relaxed/simple;
	bh=IElImc1xjP01/ULOzQXtk/tfQlSuepre7sqzuGznJpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NP8KfCKfC8duRF9S09WxTAxiiN4/ot9dlx5Gylwgy6x06ZNMEESYPjAG8emyTJOprxXUIrZz/CGkE2BYUFUpW4MQ+alKeSiVuU+iGOcxmjwydaAgt1Mzq2cKjlHOm2C5HLcqgVXYdwNRM8slcKx+fs6MmIJeVsI3qqlJukWmJnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=107vdq6g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="107vdq6g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0276D1F000C4;
	Sat, 17 Oct 2026 16:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254406;
	bh=yl3kqknNpQp4YbchvSLo9bcUiUSdatouqP0LXAxy4Ak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=107vdq6g2ke5cL6sUdGpzMwM6vZkV3zGprVPAoKkeLyRfVBc4Z6hwIuYP8ltjwl4E
	 bJGdFKT7+O63NE20vn4hbdqI058uua4mBW9WSKoCJFP+Q2QebrLP6ChiMF6pVvRSjN
	 WmqeR+7DlsCeAS3JwxKwWWk0G1RdS8mt0Fl4cBNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 437/869] netfs: Use a folio_queue allocation and free functions
Date: Sat, 17 Oct 2026 17:54:38 +0200
Message-ID: <20261017160048.342744268@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit eb1181594417dafad0f75808ead71f6d5170c1ea ]

Provide and use folio_queue allocation and free functions to combine the
allocation, initialisation and stat (un)accounting steps that are repeated
in several places.

Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://lore.kernel.org/r/20241216204124.3752367-4-dhowells@redhat.com
cc: Jeff Layton <jlayton@kernel.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: dbd6f56d975b ("netfs: Fix netfs_create_write_req() to handle async cache object creation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/buffered_read.c | 12 +++---------
 fs/netfs/misc.c          | 38 ++++++++++++++++++++++++++++++++++----
 include/linux/netfs.h    |  5 +++++
 3 files changed, 42 insertions(+), 13 deletions(-)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index ec78ad094cf4a..e0822ecabb342 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -131,11 +131,9 @@ static ssize_t netfs_prepare_read_iterator(struct netfs_io_subrequest *subreq)
 			struct folio_queue *tail = rreq->buffer_tail, *new;
 			size_t added;
 
-			new = kmalloc(sizeof(*new), GFP_NOFS);
+			new = netfs_folioq_alloc(GFP_NOFS);
 			if (!new)
 				return -ENOMEM;
-			netfs_stat(&netfs_n_folioq);
-			folioq_init(new);
 			new->prev = tail;
 			tail->next = new;
 			rreq->buffer_tail = new;
@@ -363,11 +361,9 @@ static int netfs_prime_buffer(struct netfs_io_request *rreq)
 	struct folio_batch put_batch;
 	size_t added;
 
-	folioq = kmalloc(sizeof(*folioq), GFP_KERNEL);
+	folioq = netfs_folioq_alloc(GFP_KERNEL);
 	if (!folioq)
 		return -ENOMEM;
-	netfs_stat(&netfs_n_folioq);
-	folioq_init(folioq);
 	rreq->buffer = folioq;
 	rreq->buffer_tail = folioq;
 	rreq->submitted = rreq->start;
@@ -440,12 +436,10 @@ static int netfs_create_singular_buffer(struct netfs_io_request *rreq, struct fo
 {
 	struct folio_queue *folioq;
 
-	folioq = kmalloc(sizeof(*folioq), GFP_KERNEL);
+	folioq = netfs_folioq_alloc(GFP_KERNEL);
 	if (!folioq)
 		return -ENOMEM;
 
-	netfs_stat(&netfs_n_folioq);
-	folioq_init(folioq);
 	folioq_append(folioq, folio);
 	BUG_ON(folioq_folio(folioq, 0) != folio);
 	BUG_ON(folioq_folio_order(folioq, 0) != folio_order(folio));
diff --git a/fs/netfs/misc.c b/fs/netfs/misc.c
index 8bdacbf15226c..fbd239e6d3114 100644
--- a/fs/netfs/misc.c
+++ b/fs/netfs/misc.c
@@ -9,6 +9,38 @@
 #include <linux/rmap.h>
 #include "internal.h"
 
+/**
+ * netfs_folioq_alloc - Allocate a folio_queue struct
+ * @gfp: Allocation constraints
+ *
+ * Allocate, initialise and account the folio_queue struct.
+ */
+struct folio_queue *netfs_folioq_alloc(gfp_t gfp)
+{
+	struct folio_queue *fq;
+
+	fq = kmalloc(sizeof(*fq), gfp);
+	if (fq) {
+		netfs_stat(&netfs_n_folioq);
+		folioq_init(fq);
+	}
+	return fq;
+}
+EXPORT_SYMBOL(netfs_folioq_alloc);
+
+/**
+ * netfs_folioq_free - Free a folio_queue struct
+ * @folioq: The object to free
+ *
+ * Free and unaccount the folio_queue struct.
+ */
+void netfs_folioq_free(struct folio_queue *folioq)
+{
+	netfs_stat_d(&netfs_n_folioq);
+	kfree(folioq);
+}
+EXPORT_SYMBOL(netfs_folioq_free);
+
 /*
  * Make sure there's space in the rolling queue.
  */
@@ -88,8 +120,7 @@ struct folio_queue *netfs_delete_buffer_head(struct netfs_io_request *wreq)
 
 	if (next)
 		next->prev = NULL;
-	netfs_stat_d(&netfs_n_folioq);
-	kfree(head);
+	netfs_folioq_free(head);
 	wreq->buffer = next;
 	return next;
 }
@@ -112,8 +143,7 @@ void netfs_clear_buffer(struct netfs_io_request *rreq)
 				folio_put(folio);
 			}
 		}
-		netfs_stat_d(&netfs_n_folioq);
-		kfree(p);
+		netfs_folioq_free(p);
 	}
 }
 
diff --git a/include/linux/netfs.h b/include/linux/netfs.h
index f8e0d9fa745a2..5180292bd2d10 100644
--- a/include/linux/netfs.h
+++ b/include/linux/netfs.h
@@ -21,6 +21,7 @@
 
 enum netfs_sreq_ref_trace;
 typedef struct mempool_s mempool_t;
+struct folio_queue;
 
 /**
  * folio_start_private_2 - Start an fscache write on a folio.  [DEPRECATED]
@@ -455,6 +456,10 @@ void netfs_end_io_write(struct inode *inode);
 int netfs_start_io_direct(struct inode *inode);
 void netfs_end_io_direct(struct inode *inode);
 
+/* Miscellaneous APIs. */
+struct folio_queue *netfs_folioq_alloc(gfp_t gfp);
+void netfs_folioq_free(struct folio_queue *folioq);
+
 /**
  * netfs_inode - Get the netfs inode context from the inode
  * @inode: The inode to query
-- 
2.53.0



