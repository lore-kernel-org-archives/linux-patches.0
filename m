Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E842A18661A;
	Tue, 10 Sep 2024 09:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961641; cv=none; b=UwZZthmewwr8Dt31kmOH1lkYIlaDADFq2Zyq2N4H2DCVsKwDb/lY1nh1VP7Q63c9XYJCeE1gnJTUVM0RA1vwh9DJZQr9Cb1D/SaPDXzMaVZNYVrmo+vCklUgcrHAC6KUN7Sbu0/u+X4V7ZdKG6Aubv5RVsYO9kyJBUHa72TGeEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961641; c=relaxed/simple;
	bh=uaCwZVd1uLOK8OXh1NXqLbeHAR+5Ra8yPG/1HD7sK+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DEqErk4Tql9ATQm8BjCk6n+Q4/xuQyscxfnneAzmNbztV8RDezOE7FqlVVJT+VHDqUXeUXrTEyisEJrPYvIineJKuzF2c7Zkfwg4RfJggbDXfYzc/g5ylkrukpQsdZk4aHm8fUXmt3r5Y05atwjVF6zRt/LLK4fgKlQcXzIoBZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X7wR07Nz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X7wR07Nz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FF07C4CEC3;
	Tue, 10 Sep 2024 09:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961640;
	bh=uaCwZVd1uLOK8OXh1NXqLbeHAR+5Ra8yPG/1HD7sK+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X7wR07NzSIAP13Ge3fbC7N2LEp5MtCaSIVBo1dFXg6/TPBqEuS2FYUO8ITMXoZn6H
	 U0XSy8ttXiQklZ01RDhyREbbk6KP5mJcyacNpqVhTMjCsusD/kjy8zzA/S56yrWhDu
	 He3ZsKqW3O2rna4N2mdiCZrgtT9+hiLDhpH/iEaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziwei Xiao <ziweixiao@google.com>,
	Praveen Kaligineedi <pkaligineedi@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 111/375] gve: Add adminq mutex lock
Date: Tue, 10 Sep 2024 11:28:28 +0200
Message-ID: <20240910092626.132753281@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

From: Ziwei Xiao <ziweixiao@google.com>

[ Upstream commit 1108566ca509e67aa8abfbf914b1cd31e9ff51f8 ]

We were depending on the rtnl_lock to make sure there is only one adminq
command running at a time. But some commands may take too long to hold
the rtnl_lock, such as the upcoming flow steering operations. For such
situations, it can temporarily drop the rtnl_lock, and replace it for
these operations with a new adminq lock, which can ensure the adminq
command execution to be thread-safe.

Signed-off-by: Ziwei Xiao <ziweixiao@google.com>
Reviewed-by: Praveen Kaligineedi <pkaligineedi@google.com>
Reviewed-by: Harshitha Ramamurthy <hramamurthy@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20240625001232.1476315-2-ziweixiao@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve.h        |  1 +
 drivers/net/ethernet/google/gve/gve_adminq.c | 22 +++++++++++---------
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index ae1e21c9b0a5..ca7fce17f2c0 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -724,6 +724,7 @@ struct gve_priv {
 	union gve_adminq_command *adminq;
 	dma_addr_t adminq_bus_addr;
 	struct dma_pool *adminq_pool;
+	struct mutex adminq_lock; /* Protects adminq command execution */
 	u32 adminq_mask; /* masks prod_cnt to adminq size */
 	u32 adminq_prod_cnt; /* free-running count of AQ cmds executed */
 	u32 adminq_cmd_fail; /* free-running count of AQ cmds failed */
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index 8ca0def176ef..2e0c1eb87b11 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -284,6 +284,7 @@ int gve_adminq_alloc(struct device *dev, struct gve_priv *priv)
 			    &priv->reg_bar0->adminq_base_address_lo);
 		iowrite32be(GVE_DRIVER_STATUS_RUN_MASK, &priv->reg_bar0->driver_status);
 	}
+	mutex_init(&priv->adminq_lock);
 	gve_set_admin_queue_ok(priv);
 	return 0;
 }
@@ -511,28 +512,29 @@ static int gve_adminq_issue_cmd(struct gve_priv *priv,
 	return 0;
 }
 
-/* This function is not threadsafe - the caller is responsible for any
- * necessary locks.
- * The caller is also responsible for making sure there are no commands
- * waiting to be executed.
- */
 static int gve_adminq_execute_cmd(struct gve_priv *priv,
 				  union gve_adminq_command *cmd_orig)
 {
 	u32 tail, head;
 	int err;
 
+	mutex_lock(&priv->adminq_lock);
 	tail = ioread32be(&priv->reg_bar0->adminq_event_counter);
 	head = priv->adminq_prod_cnt;
-	if (tail != head)
-		// This is not a valid path
-		return -EINVAL;
+	if (tail != head) {
+		err = -EINVAL;
+		goto out;
+	}
 
 	err = gve_adminq_issue_cmd(priv, cmd_orig);
 	if (err)
-		return err;
+		goto out;
 
-	return gve_adminq_kick_and_wait(priv);
+	err = gve_adminq_kick_and_wait(priv);
+
+out:
+	mutex_unlock(&priv->adminq_lock);
+	return err;
 }
 
 /* The device specifies that the management vector can either be the first irq
-- 
2.43.0



