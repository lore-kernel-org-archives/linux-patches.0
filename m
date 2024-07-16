Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9152ECA40;
	Tue, 16 Jul 2024 15:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144277; cv=none; b=Mi+F7fCOBLCV/5ISLDqRAeaII99K3urPObsSxzGZ2ufGGv1oOCLkgNAarqI4RhcQ5VzNTGE0ODk2tgMLDJgFqi5vKS1Xa5AiTpTLi4iMNdAm144xBDsMqEiD60oRBw/ozTWOfn31TUGJM+L+vb/dnwO6C0pNCdla9qyHaib/rmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144277; c=relaxed/simple;
	bh=VrkBDzKVtYmqUiBtvyhPo65cxArmOLwlauX2cD2cHE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fi9pohkNPa83rtTkJnMSuUIYb0wqnndhlmtvVOX7dNkl+c1gRI7XaxSj1/+STnbY/Mc/jaVZkKqBRinu4Pd77wsVcFXgmuFn5wgZU2leIvbDgHw5d0rb6U/Bx5dOVtALBFX57OwCEQBI9Ay4WVWX3NJYnnf0XIsiXD2xx8r1Fkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oSQQoCTI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oSQQoCTI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 149EBC116B1;
	Tue, 16 Jul 2024 15:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144277;
	bh=VrkBDzKVtYmqUiBtvyhPo65cxArmOLwlauX2cD2cHE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oSQQoCTIhcw6J3lU3Lfd4BBql+kbyL+rGWEJdA9uol6g7Mknv8/NMGez2Q8MsSByZ
	 BqXSGmtwcQ9SPpgf9OMOtKoUy64lgyFz+/2QnETN8nRQB6bJoJW5Cj7Eyl4LYk82Zi
	 k7xUb4w+0GLa4W9SgiwTRKO2uQ5EM4031Gfr3LsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Guralnik <michaelgur@nvidia.com>,
	Mark Zhang <markzhang@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 04/78] IB/core: Implement a limit on UMAD receive List
Date: Tue, 16 Jul 2024 17:30:36 +0200
Message-ID: <20240716152740.801678938@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152740.626160410@linuxfoundation.org>
References: <20240716152740.626160410@linuxfoundation.org>
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

From: Michael Guralnik <michaelgur@nvidia.com>

[ Upstream commit ca0b44e20a6f3032224599f02e7c8fb49525c894 ]

The existing behavior of ib_umad, which maintains received MAD
packets in an unbounded list, poses a risk of uncontrolled growth.
As user-space applications extract packets from this list, the rate
of extraction may not match the rate of incoming packets, leading
to potential list overflow.

To address this, we introduce a limit to the size of the list. After
considering typical scenarios, such as OpenSM processing, which can
handle approximately 100k packets per second, and the 1-second retry
timeout for most packets, we set the list size limit to 200k. Packets
received beyond this limit are dropped, assuming they are likely timed
out by the time they are handled by user-space.

Notably, packets queued on the receive list due to reasons like
timed-out sends are preserved even when the list is full.

Signed-off-by: Michael Guralnik <michaelgur@nvidia.com>
Reviewed-by: Mark Zhang <markzhang@nvidia.com>
Link: https://lore.kernel.org/r/7197cb58a7d9e78399008f25036205ceab07fbd5.1713268818.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/user_mad.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 390123f87658b..51ce5b7be0718 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -63,6 +63,8 @@ MODULE_AUTHOR("Roland Dreier");
 MODULE_DESCRIPTION("InfiniBand userspace MAD packet access");
 MODULE_LICENSE("Dual BSD/GPL");
 
+#define MAX_UMAD_RECV_LIST_SIZE 200000
+
 enum {
 	IB_UMAD_MAX_PORTS  = RDMA_MAX_PORTS,
 	IB_UMAD_MAX_AGENTS = 32,
@@ -113,6 +115,7 @@ struct ib_umad_file {
 	struct mutex		mutex;
 	struct ib_umad_port    *port;
 	struct list_head	recv_list;
+	atomic_t		recv_list_size;
 	struct list_head	send_list;
 	struct list_head	port_list;
 	spinlock_t		send_lock;
@@ -180,24 +183,28 @@ static struct ib_mad_agent *__get_agent(struct ib_umad_file *file, int id)
 	return file->agents_dead ? NULL : file->agent[id];
 }
 
-static int queue_packet(struct ib_umad_file *file,
-			struct ib_mad_agent *agent,
-			struct ib_umad_packet *packet)
+static int queue_packet(struct ib_umad_file *file, struct ib_mad_agent *agent,
+			struct ib_umad_packet *packet, bool is_recv_mad)
 {
 	int ret = 1;
 
 	mutex_lock(&file->mutex);
 
+	if (is_recv_mad &&
+	    atomic_read(&file->recv_list_size) > MAX_UMAD_RECV_LIST_SIZE)
+		goto unlock;
+
 	for (packet->mad.hdr.id = 0;
 	     packet->mad.hdr.id < IB_UMAD_MAX_AGENTS;
 	     packet->mad.hdr.id++)
 		if (agent == __get_agent(file, packet->mad.hdr.id)) {
 			list_add_tail(&packet->list, &file->recv_list);
+			atomic_inc(&file->recv_list_size);
 			wake_up_interruptible(&file->recv_wait);
 			ret = 0;
 			break;
 		}
-
+unlock:
 	mutex_unlock(&file->mutex);
 
 	return ret;
@@ -224,7 +231,7 @@ static void send_handler(struct ib_mad_agent *agent,
 	if (send_wc->status == IB_WC_RESP_TIMEOUT_ERR) {
 		packet->length = IB_MGMT_MAD_HDR;
 		packet->mad.hdr.status = ETIMEDOUT;
-		if (!queue_packet(file, agent, packet))
+		if (!queue_packet(file, agent, packet, false))
 			return;
 	}
 	kfree(packet);
@@ -284,7 +291,7 @@ static void recv_handler(struct ib_mad_agent *agent,
 		rdma_destroy_ah_attr(&ah_attr);
 	}
 
-	if (queue_packet(file, agent, packet))
+	if (queue_packet(file, agent, packet, true))
 		goto err2;
 	return;
 
@@ -409,6 +416,7 @@ static ssize_t ib_umad_read(struct file *filp, char __user *buf,
 
 	packet = list_entry(file->recv_list.next, struct ib_umad_packet, list);
 	list_del(&packet->list);
+	atomic_dec(&file->recv_list_size);
 
 	mutex_unlock(&file->mutex);
 
@@ -421,6 +429,7 @@ static ssize_t ib_umad_read(struct file *filp, char __user *buf,
 		/* Requeue packet */
 		mutex_lock(&file->mutex);
 		list_add(&packet->list, &file->recv_list);
+		atomic_inc(&file->recv_list_size);
 		mutex_unlock(&file->mutex);
 	} else {
 		if (packet->recv_wc)
-- 
2.43.0



