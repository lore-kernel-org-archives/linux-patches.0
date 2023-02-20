Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA9E63B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:49:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C37DC433D2;
	Mon, 20 Feb 2023 13:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676900959;
	bh=4N92YWnJCZTpAIiRhDQrD/WHS/UTCKxHd7nBhoJEIdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rGtbOFfA8QLc2uskXI8+TMykk8lBRhAlLcywpm43FlKtcV+8MWC2I8FKTpnZl0HmL
	 3mowzrohTzvcI8dowJiPtkqahO3igcRLPQRkvd2UtN/npBwX/3m64mT6xepb46jNvu
	 1yhc+gBWZ28vjFpRhxKiL5K18EdiCCLKTNHYEefo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Brian Foster <bfoster@redhat.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 5.4 105/156] xfs: factor out a xfs_defer_create_intent helper
Date: Mon, 20 Feb 2023 14:35:49 +0100
Message-Id: <20230220133606.897909739@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

commit e046e949486ec92d83b2ccdf0e7e9144f74ef028 upstream.

Create a helper that encapsulates the whole logic to create a defer
intent.  This reorders some of the work that was done, but none of
that has an affect on the operation as only fields that don't directly
interact are affected.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_defer.c |   39 +++++++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 16 deletions(-)

--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -178,6 +178,23 @@ static const struct xfs_defer_op_type *d
 	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
 };
 
+static void
+xfs_defer_create_intent(
+	struct xfs_trans		*tp,
+	struct xfs_defer_pending	*dfp,
+	bool				sort)
+{
+	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
+	struct list_head		*li;
+
+	if (sort)
+		list_sort(tp->t_mountp, &dfp->dfp_work, ops->diff_items);
+
+	dfp->dfp_intent = ops->create_intent(tp, dfp->dfp_count);
+	list_for_each(li, &dfp->dfp_work)
+		ops->log_item(tp, dfp->dfp_intent, li);
+}
+
 /*
  * For each pending item in the intake list, log its intent item and the
  * associated extents, then add the entire intake list to the end of
@@ -187,17 +204,11 @@ STATIC void
 xfs_defer_create_intents(
 	struct xfs_trans		*tp)
 {
-	struct list_head		*li;
 	struct xfs_defer_pending	*dfp;
-	const struct xfs_defer_op_type	*ops;
 
 	list_for_each_entry(dfp, &tp->t_dfops, dfp_list) {
-		ops = defer_op_types[dfp->dfp_type];
-		dfp->dfp_intent = ops->create_intent(tp, dfp->dfp_count);
 		trace_xfs_defer_create_intent(tp->t_mountp, dfp);
-		list_sort(tp->t_mountp, &dfp->dfp_work, ops->diff_items);
-		list_for_each(li, &dfp->dfp_work)
-			ops->log_item(tp, dfp->dfp_intent, li);
+		xfs_defer_create_intent(tp, dfp, true);
 	}
 }
 
@@ -427,17 +438,13 @@ xfs_defer_finish_noroll(
 		}
 		if (error == -EAGAIN) {
 			/*
-			 * Caller wants a fresh transaction, so log a
-			 * new log intent item to replace the old one
-			 * and roll the transaction.  See "Requesting
-			 * a Fresh Transaction while Finishing
-			 * Deferred Work" above.
+			 * Caller wants a fresh transaction, so log a new log
+			 * intent item to replace the old one and roll the
+			 * transaction.  See "Requesting a Fresh Transaction
+			 * while Finishing Deferred Work" above.
 			 */
-			dfp->dfp_intent = ops->create_intent(*tp,
-					dfp->dfp_count);
 			dfp->dfp_done = NULL;
-			list_for_each(li, &dfp->dfp_work)
-				ops->log_item(*tp, dfp->dfp_intent, li);
+			xfs_defer_create_intent(*tp, dfp, false);
 		} else {
 			/* Done with the dfp, free it. */
 			list_del(&dfp->dfp_list);


