Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DCFC1DDF5;
	Tue, 16 Jul 2024 15:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144555; cv=none; b=lvdmrnYG0+qdDbshiWVPghu7miGQSYs2VdaQY/wV7+IcN5iwV79OJcTu5MLuBMasejMyodRmAKyX4qkp0Za+htPSfBMSJOp9Zc1GgBNf6ivsqb26eAQtgYGVaIKEv+00s5A9VfauxzcsJprD66CNVl/5NEu6dya2hRA6c/s28FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144555; c=relaxed/simple;
	bh=JspTc1J5jFyN7Zu3YJHUw4vrDxUqr8kmqz/AITj/e9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gRLyVZdBGAPXlRa3hogWhRGrNPBcxSKt8rWCqHwIzg/GfLNW/uu0JWq66ygVZyEw0cKI2DZSjrR+ehA22cy11Y3fCdWQktO1f+RgRQliurglW2x8sfayllZzrl8mWldscsu4jcpdTZyS6HiLCWg+g6+JAfFWUOxnUV+Sau/f5vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I7+nK+Rr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I7+nK+Rr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A7AC116B1;
	Tue, 16 Jul 2024 15:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144554;
	bh=JspTc1J5jFyN7Zu3YJHUw4vrDxUqr8kmqz/AITj/e9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I7+nK+RrHhlyhUc9T0khM8S3houwLhC+axFuZt/VSzlUDVReUFxM43R57f7N8lHgb
	 14JMrfBFYBHVL8cCcZozZZOVzUyf07CDANi7LYW37gf5TFvG8vWYtL+BXy2S5y29o0
	 S5mDNBeZrvuTdnC3jIaPmaCFAmsUJuCGs0kH3ZGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Guralnik <michaelgur@nvidia.com>,
	Mark Zhang <markzhang@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 004/108] IB/core: Implement a limit on UMAD receive List
Date: Tue, 16 Jul 2024 17:30:19 +0200
Message-ID: <20240716152746.164130600@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152745.988603303@linuxfoundation.org>
References: <20240716152745.988603303@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3bd0dcde8576d..063707dd4fe37 100644
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



