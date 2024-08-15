Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B987118D639;
	Thu, 15 Aug 2024 13:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728730; cv=none; b=gTyfOYNqHdkO0IyaFDizGLKh1U0MiZJG7qT4unZKBh8KaFbnUcNcnpB1MYqBot3yJyreGaDgN2Al/R9bUcckF+DpmGOhbgCxloBbvvXORcGhjjKZuNtLbGMGvxwDFkuuPrtIEybvgHmu4cBaT5OlpZ92aW385gUn3Ks5DiM2OSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728730; c=relaxed/simple;
	bh=z12jLhsFRoBR8onRFLYQ25efagApp/ZoW/+ze5hFAOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SwCY5SvpAWwPm1iTM8SwXbu85C4kLnsU0Mt692V88TUcsBKVatMek8Al7gkNTRzPV9tjidbCsUcOkS/HYGWymdZztlAa0bBc1vZ8hjmajs72FAr4Rqj9c9GfWgZLpMJCHrONrvnxWXfdS59IAOAI8wZ/bO0RFYKtYfdB59ZEQaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XjNG+v5p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XjNG+v5p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDA6BC32786;
	Thu, 15 Aug 2024 13:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728730;
	bh=z12jLhsFRoBR8onRFLYQ25efagApp/ZoW/+ze5hFAOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XjNG+v5pJQKPVOSBnKuXuDw0XqmgoRrxk75bh7+rqsFpgxqSN5D3DZ/tU94ZFN7kl
	 ka4nFssv+1EcDXUyqhRrkS9zOz+lv/Yfvu607QIyIrV0ng7DV84aHOGEr8t2WdQGo6
	 65sdWgLb6aRT9ECcAuCG60fzpDminST9zyoFZsiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 4.19 092/196] RDMA/iwcm: Fix a use-after-free related to destroying CM IDs
Date: Thu, 15 Aug 2024 15:23:29 +0200
Message-ID: <20240815131855.602324415@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
 	unsigned long flags;
@@ -438,7 +440,7 @@ static void destroy_cm_id(struct iw_cm_i
 		iwpm_remove_mapping(&cm_id->local_addr, RDMA_NL_IWCM);
 	}
 
-	(void)iwcm_deref_id(cm_id_priv);
+	return iwcm_deref_id(cm_id_priv);
 }
 
 /*
@@ -449,7 +451,8 @@ static void destroy_cm_id(struct iw_cm_i
  */
 void iw_destroy_cm_id(struct iw_cm_id *cm_id)
 {
-	destroy_cm_id(cm_id);
+	if (!destroy_cm_id(cm_id))
+		flush_workqueue(iwcm_wq);
 }
 EXPORT_SYMBOL(iw_destroy_cm_id);
 
@@ -1022,7 +1025,7 @@ static void cm_work_handler(struct work_
 		if (!test_bit(IWCM_F_DROP_EVENTS, &cm_id_priv->flags)) {
 			ret = process_event(cm_id_priv, &levent);
 			if (ret)
-				destroy_cm_id(&cm_id_priv->id);
+				WARN_ON_ONCE(destroy_cm_id(&cm_id_priv->id));
 		} else
 			pr_debug("dropping event %d\n", levent.event);
 		if (iwcm_deref_id(cm_id_priv))


