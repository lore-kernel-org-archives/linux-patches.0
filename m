Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFED31AC43B;
	Thu, 15 Aug 2024 14:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731430; cv=none; b=lUtq/yGRyMxn/662WrUxWOcJCCSaebWBlqBHOAyFF8+7HIV/Q0kDZ4S93tkMiLX+PTFYXMnDPQAhGXJUjYm5zLQhbXGTj5L5ot1YHiU/7vMH3gnGJqo8aTmpQmmKsvDINSvdVhjjo/XG5q9d3RvbI6Zo4UtbMbBUJSecfp4ujzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731430; c=relaxed/simple;
	bh=kex94yE6BRNVIFB61MkaH7IgxTttb7UqxJFpmsI4taI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EgmbdhgYcigrTedKVLOVor7mVI4ewvqTFPK4xTqHwEYsvLAJbtTr6M07XajeFKOuxAjXghp8fnY0Nf+ULUacqzX+rddyJa7jkTEpMWQcL5PNoroBRPzQHM7CWJ+ulPor59GxV36ChAklCjAjjF19SQkhc0AeHdXmOrD7BlIph5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l3bu7rHF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l3bu7rHF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A7D0C4AF0F;
	Thu, 15 Aug 2024 14:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731429;
	bh=kex94yE6BRNVIFB61MkaH7IgxTttb7UqxJFpmsI4taI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l3bu7rHFNpn7HnpweUQD7ueDSF+4P45QUVNQvrCJ4uVafy4mPh2bkozDc8IgYAFo5
	 G4FUWVJNEvFgERpDyzTPVzAUQRzh3nf0Bd0k6j/UQ08+r2IpCQoRvT4sNW/S8UjIxM
	 nGYrkiAAGf6NZTeDzBoQiwyJCTrGUEipWuffrWNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 5.4 125/259] RDMA/iwcm: Fix a use-after-free related to destroying CM IDs
Date: Thu, 15 Aug 2024 15:24:18 +0200
Message-ID: <20240815131907.622429238@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

From: Bart Van Assche <bvanassche@acm.org>

commit aee2424246f9f1dadc33faa78990c1e2eb7826e4 upstream.

iw_conn_req_handler() associates a new struct rdma_id_private (conn_id) with
an existing struct iw_cm_id (cm_id) as follows:

        conn_id->cm_id.iw = cm_id;
        cm_id->context = conn_id;
        cm_id->cm_handler = cma_iw_handler;

rdma_destroy_id() frees both the cm_id and the struct rdma_id_private. Make
sure that cm_work_handler() does not trigger a use-after-free by only
freeing of the struct rdma_id_private after all pending work has finished.

Cc: stable@vger.kernel.org
Fixes: 59c68ac31e15 ("iw_cm: free cm_id resources on the last deref")
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20240605145117.397751-6-bvanassche@acm.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/core/iwcm.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/infiniband/core/iwcm.c
+++ b/drivers/infiniband/core/iwcm.c
@@ -370,8 +370,10 @@ EXPORT_SYMBOL(iw_cm_disconnect);
  *
  * Clean up all resources associated with the connection and release
  * the initial reference taken by iw_create_cm_id.
+ *
+ * Returns true if and only if the last cm_id_priv reference has been dropped.
  */
-static void destroy_cm_id(struct iw_cm_id *cm_id)
+static bool destroy_cm_id(struct iw_cm_id *cm_id)
 {
 	struct iwcm_id_private *cm_id_priv;
 	struct ib_qp *qp;
@@ -441,7 +443,7 @@ static void destroy_cm_id(struct iw_cm_i
 		iwpm_remove_mapping(&cm_id->local_addr, RDMA_NL_IWCM);
 	}
 
-	(void)iwcm_deref_id(cm_id_priv);
+	return iwcm_deref_id(cm_id_priv);
 }
 
 /*
@@ -452,7 +454,8 @@ static void destroy_cm_id(struct iw_cm_i
  */
 void iw_destroy_cm_id(struct iw_cm_id *cm_id)
 {
-	destroy_cm_id(cm_id);
+	if (!destroy_cm_id(cm_id))
+		flush_workqueue(iwcm_wq);
 }
 EXPORT_SYMBOL(iw_destroy_cm_id);
 
@@ -1036,7 +1039,7 @@ static void cm_work_handler(struct work_
 		if (!test_bit(IWCM_F_DROP_EVENTS, &cm_id_priv->flags)) {
 			ret = process_event(cm_id_priv, &levent);
 			if (ret)
-				destroy_cm_id(&cm_id_priv->id);
+				WARN_ON_ONCE(destroy_cm_id(&cm_id_priv->id));
 		} else
 			pr_debug("dropping event %d\n", levent.event);
 		if (iwcm_deref_id(cm_id_priv))


