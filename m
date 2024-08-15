Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B5F1494C5;
	Thu, 15 Aug 2024 13:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729894; cv=none; b=OKEMdCZdN3oe4y2nWH9qfCcsGIxfIFlIJ6d+lmtwCvk7iS80OdGGcD6Z7fmyaWOMpH2tFHIQGv/Io7+P6bdHwv0hKg9rcOZv3EB4BsFFFDDgAe1Bi99ZLbqU9rvRb69BDgFkUg0XrbsZvVTxUouNXGKGCwZPm0tEbUyNt5w2Rfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729894; c=relaxed/simple;
	bh=5qUfZVGyKCbJLrXcYFbLpN7vK2xxZfBnMP3ZEtAIBE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E7gV0B4oHA3mWn1LURqP77JEuVP9U0BX2WEAcy6abrWP1iVU0itgtNaaOlOGljFDafklcSSbVqd4USRg1xDE1Fo8wmEvFiKZDRR+AnS6rG91LVK5EAKeg8eg9jPYxphJqNjl6pvJuqYRi02ldFd/S5pbiLFc0JnkWsMESxTcS1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MP/MAKSp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MP/MAKSp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA5AC32786;
	Thu, 15 Aug 2024 13:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729894;
	bh=5qUfZVGyKCbJLrXcYFbLpN7vK2xxZfBnMP3ZEtAIBE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MP/MAKSp1c2dyclLqrDAOkL6i7C9BEGtN7ItcEgAYrBEdl/JSdwNHpgXq4XJ5ljd7
	 xPDnpH/1DL1dMhuUV1OGY34afndVorKiFsB/0YmLQL9Uyyie6lxslnQFFQfGjnYjl0
	 3c/QD00t/VyZrnjT5wygEqBpT85L9O6Uq/+7SayU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 5.15 241/484] RDMA/iwcm: Fix a use-after-free related to destroying CM IDs
Date: Thu, 15 Aug 2024 15:21:39 +0200
Message-ID: <20240815131950.711723641@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -369,8 +369,10 @@ EXPORT_SYMBOL(iw_cm_disconnect);
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
@@ -440,7 +442,7 @@ static void destroy_cm_id(struct iw_cm_i
 		iwpm_remove_mapping(&cm_id->local_addr, RDMA_NL_IWCM);
 	}
 
-	(void)iwcm_deref_id(cm_id_priv);
+	return iwcm_deref_id(cm_id_priv);
 }
 
 /*
@@ -451,7 +453,8 @@ static void destroy_cm_id(struct iw_cm_i
  */
 void iw_destroy_cm_id(struct iw_cm_id *cm_id)
 {
-	destroy_cm_id(cm_id);
+	if (!destroy_cm_id(cm_id))
+		flush_workqueue(iwcm_wq);
 }
 EXPORT_SYMBOL(iw_destroy_cm_id);
 
@@ -1035,7 +1038,7 @@ static void cm_work_handler(struct work_
 		if (!test_bit(IWCM_F_DROP_EVENTS, &cm_id_priv->flags)) {
 			ret = process_event(cm_id_priv, &levent);
 			if (ret)
-				destroy_cm_id(&cm_id_priv->id);
+				WARN_ON_ONCE(destroy_cm_id(&cm_id_priv->id));
 		} else
 			pr_debug("dropping event %d\n", levent.event);
 		if (iwcm_deref_id(cm_id_priv))


