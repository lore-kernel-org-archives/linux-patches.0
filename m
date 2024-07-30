Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D921A76B4;
	Tue, 30 Jul 2024 17:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360489; cv=none; b=fAzABBcWkT11+DiiGcCkBZ0dlpnpAjGETm8u78mLlJKSIUGAiI0sS6PMI5VWA3GnGJsUoY8eefKC51L9HCqsN9iefpMQSSH00DPzCFKT+XQAdcAk5xe1X5tBHoayfSoIHosQVtrRXjIckzXfrCvsoYb3SubqeRMTx+8J/q5+iLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360489; c=relaxed/simple;
	bh=cLnBu0zbIEf1G/m7oWoBGuoA24TWAwhYLlgSejXeGQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oUiWh8IXYXzT3z0bcadfysdbjVQTlQzgfwrvL/64xY4dO9tdwxEXCQqcS35xFkb9466A3Bx42PFkqezl4uJiKp4Z6szAIJ/iDur0mM868UNHpzhcRzJ7h7+n0d7RAFl1MBGw6aWqTUasCSW+Uafu9H0c7S1tQ2WbkrAgTRJjQKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LXyQvE1B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LXyQvE1B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21F85C32782;
	Tue, 30 Jul 2024 17:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360489;
	bh=cLnBu0zbIEf1G/m7oWoBGuoA24TWAwhYLlgSejXeGQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LXyQvE1BjDAyZTRJG9he1qDJ/ZtlbuSE38A2Tg0vL5GCFOayZnnZwSjCzReVmwPi3
	 8PmyeQsl/7bwymDkXNaOAp47FC+jVx0/mVdJTTP0IlLaoQbs5wHajx6GQCV45cID9W
	 rojXuA0EW5hk6B2q7PDbs4cY1WlXTZ6ylEkdDug8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 6.10 714/809] RDMA/iwcm: Fix a use-after-free related to destroying CM IDs
Date: Tue, 30 Jul 2024 17:49:50 +0200
Message-ID: <20240730151753.135270092@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -368,8 +368,10 @@ EXPORT_SYMBOL(iw_cm_disconnect);
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
@@ -439,7 +441,7 @@ static void destroy_cm_id(struct iw_cm_i
 		iwpm_remove_mapping(&cm_id->local_addr, RDMA_NL_IWCM);
 	}
 
-	(void)iwcm_deref_id(cm_id_priv);
+	return iwcm_deref_id(cm_id_priv);
 }
 
 /*
@@ -450,7 +452,8 @@ static void destroy_cm_id(struct iw_cm_i
  */
 void iw_destroy_cm_id(struct iw_cm_id *cm_id)
 {
-	destroy_cm_id(cm_id);
+	if (!destroy_cm_id(cm_id))
+		flush_workqueue(iwcm_wq);
 }
 EXPORT_SYMBOL(iw_destroy_cm_id);
 
@@ -1034,7 +1037,7 @@ static void cm_work_handler(struct work_
 		if (!test_bit(IWCM_F_DROP_EVENTS, &cm_id_priv->flags)) {
 			ret = process_event(cm_id_priv, &levent);
 			if (ret)
-				destroy_cm_id(&cm_id_priv->id);
+				WARN_ON_ONCE(destroy_cm_id(&cm_id_priv->id));
 		} else
 			pr_debug("dropping event %d\n", levent.event);
 		if (iwcm_deref_id(cm_id_priv))


