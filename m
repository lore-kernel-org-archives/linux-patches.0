Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA81187321;
	Mon, 12 Aug 2024 16:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479894; cv=none; b=W+OflGtvKdTe6fSTOyRqVQFzjQFh1lW4QgtaSaRQX9Qgz6Szhy2QkaJYnbqz2PqaK3xVJ54iBAgv9Bn6u1tMVAEbu/Mq51wGBzOHLyeuyt5Sb345XFpN6zpaNLZmXq0rezIYa2FBUQHh8jEnM2BXJysi9dZMteecwXU8+XHfCQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479894; c=relaxed/simple;
	bh=5OJsJN+c2FtTkLSQClpFLJLNwP50RHG1kXQOcuHTCWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RHbghhYA9yEBbOCVGdEBVmoo0LstsCj8Hf3aM980Ud4Wl4XoZJeUD0/7dKnDlwBLP4+44pAMdeQPsRQfgUUyPBLTQD8Fs1M55OMgLYxhUz5Pwc6XZgDsmQ3eluJjBP1vO3Jso+HgII/TPg3SyMxJ+9nLiNgnY11+Rxabo9GAMkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nV9k4yaR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nV9k4yaR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0056C32782;
	Mon, 12 Aug 2024 16:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479894;
	bh=5OJsJN+c2FtTkLSQClpFLJLNwP50RHG1kXQOcuHTCWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nV9k4yaR16/qyMsbdQ4gIU79LnCfBYlkrz/k4jSDfLEVuurTHlMEIjblx9nNOTlHl
	 3FMX+Ih807QbZpTzSGyX6AcaVG+OXUZI72WK5AjstQhw0A7aJyZMVNXCIn15YUF59A
	 79pUi0xP4tkj9Vvr1YMm9fldyzeUQJ1o3JjxDVuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Simon Horman <horms@kernel.org>,
	Krishneil Singh <krishneil.k.singh@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 033/263] idpf: fix memory leaks and crashes while performing a soft reset
Date: Mon, 12 Aug 2024 18:00:34 +0200
Message-ID: <20240812160147.810653957@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

From: Alexander Lobakin <aleksander.lobakin@intel.com>

[ Upstream commit f01032a2ca099ec8d619aaa916c3762aa62495df ]

The second tagged commit introduced a UAF, as it removed restoring
q_vector->vport pointers after reinitializating the structures.
This is due to that all queue allocation functions are performed here
with the new temporary vport structure and those functions rewrite
the backpointers to the vport. Then, this new struct is freed and
the pointers start leading to nowhere.

But generally speaking, the current logic is very fragile. It claims
to be more reliable when the system is low on memory, but in fact, it
consumes two times more memory as at the moment of running this
function, there are two vports allocated with their queues and vectors.
Moreover, it claims to prevent the driver from running into "bad state",
but in fact, any error during the rebuild leaves the old vport in the
partially allocated state.
Finally, if the interface is down when the function is called, it always
allocates a new queue set, but when the user decides to enable the
interface later on, vport_open() allocates them once again, IOW there's
a clear memory leak here.

Just don't allocate a new queue set when performing a reset, that solves
crashes and memory leaks. Readd the old queue number and reopen the
interface on rollback - that solves limbo states when the device is left
disabled and/or without HW queues enabled.

Fixes: 02cbfba1add5 ("idpf: add ethtool callbacks")
Fixes: e4891e4687c8 ("idpf: split &idpf_queue into 4 strictly-typed queue structures")
Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Krishneil Singh <krishneil.k.singh@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://patch.msgid.link/20240806220923.3359860-2-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_lib.c | 30 +++++++++++-----------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_lib.c b/drivers/net/ethernet/intel/idpf/idpf_lib.c
index f1ee5584e8fa2..32b6f0d52e3c5 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_lib.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_lib.c
@@ -1337,9 +1337,8 @@ static void idpf_rx_init_buf_tail(struct idpf_vport *vport)
 /**
  * idpf_vport_open - Bring up a vport
  * @vport: vport to bring up
- * @alloc_res: allocate queue resources
  */
-static int idpf_vport_open(struct idpf_vport *vport, bool alloc_res)
+static int idpf_vport_open(struct idpf_vport *vport)
 {
 	struct idpf_netdev_priv *np = netdev_priv(vport->netdev);
 	struct idpf_adapter *adapter = vport->adapter;
@@ -1352,11 +1351,9 @@ static int idpf_vport_open(struct idpf_vport *vport, bool alloc_res)
 	/* we do not allow interface up just yet */
 	netif_carrier_off(vport->netdev);
 
-	if (alloc_res) {
-		err = idpf_vport_queues_alloc(vport);
-		if (err)
-			return err;
-	}
+	err = idpf_vport_queues_alloc(vport);
+	if (err)
+		return err;
 
 	err = idpf_vport_intr_alloc(vport);
 	if (err) {
@@ -1541,7 +1538,7 @@ void idpf_init_task(struct work_struct *work)
 	np = netdev_priv(vport->netdev);
 	np->state = __IDPF_VPORT_DOWN;
 	if (test_and_clear_bit(IDPF_VPORT_UP_REQUESTED, vport_config->flags))
-		idpf_vport_open(vport, true);
+		idpf_vport_open(vport);
 
 	/* Spawn and return 'idpf_init_task' work queue until all the
 	 * default vports are created
@@ -1900,9 +1897,6 @@ int idpf_initiate_soft_reset(struct idpf_vport *vport,
 		goto free_vport;
 	}
 
-	err = idpf_vport_queues_alloc(new_vport);
-	if (err)
-		goto free_vport;
 	if (current_state <= __IDPF_VPORT_DOWN) {
 		idpf_send_delete_queues_msg(vport);
 	} else {
@@ -1974,17 +1968,23 @@ int idpf_initiate_soft_reset(struct idpf_vport *vport,
 
 	err = idpf_set_real_num_queues(vport);
 	if (err)
-		goto err_reset;
+		goto err_open;
 
 	if (current_state == __IDPF_VPORT_UP)
-		err = idpf_vport_open(vport, false);
+		err = idpf_vport_open(vport);
 
 	kfree(new_vport);
 
 	return err;
 
 err_reset:
-	idpf_vport_queues_rel(new_vport);
+	idpf_send_add_queues_msg(vport, vport->num_txq, vport->num_complq,
+				 vport->num_rxq, vport->num_bufq);
+
+err_open:
+	if (current_state == __IDPF_VPORT_UP)
+		idpf_vport_open(vport);
+
 free_vport:
 	kfree(new_vport);
 
@@ -2213,7 +2213,7 @@ static int idpf_open(struct net_device *netdev)
 	idpf_vport_ctrl_lock(netdev);
 	vport = idpf_netdev_to_vport(netdev);
 
-	err = idpf_vport_open(vport, true);
+	err = idpf_vport_open(vport);
 
 	idpf_vport_ctrl_unlock(netdev);
 
-- 
2.43.0



