Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EACDC4C6E;
	Mon, 23 Jun 2025 13:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685499; cv=none; b=pjgvoSzBNvuVxr3gwpTU1hH/IA24B7CVk1qC4CMKm8e7b2+WPIEO3zWtAG2EWFDQEEb2NaS04pEmFulb2MRFEFHzRtNN2ULwPCQUEqLm/ixC1YAEMc2Pin0s9pawNvE3CnVC5esJW+DbQbjC9+xgNvNKltMuLju4I8174j6zrfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685499; c=relaxed/simple;
	bh=8XwaaIDzQF7K68/pboADPyLnQX++tQ69Zf2MN36JiJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CY0EOcpzeJ7LPjdvjnUGrtRxWgsiLLwmit9b3Nibd/odel1HH11AtWutJ6oq3cwyRVSJeM+OosTa5RTuQhYdO7yHfHQN9XU6kW6wzvTfIZvKBVghojd/5pwVAcpTzYXYJubmqPBqyC939jEYDeC6XjFu+SiN20g8BBY/XKCNBNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wpGvYSKZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wpGvYSKZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35306C4CEEA;
	Mon, 23 Jun 2025 13:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685498;
	bh=8XwaaIDzQF7K68/pboADPyLnQX++tQ69Zf2MN36JiJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wpGvYSKZdkf28mTe9sWFoxxOSghiSRos46SHRXv2jbipqQriEy7Lk0Wm8mPvh/izf
	 DDReC70nYgJt6RRYvuIlb2Ngh7SkwfP6UmnqXcp7LUcSGQ277BA5P8yZRz4KloqIFf
	 I3ps7cz0bCUaP/OoHrNyXVSRTG8KuEPUxS2orOcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 038/411] IB/cm: use rwlock for MAD agent lock
Date: Mon, 23 Jun 2025 15:03:02 +0200
Message-ID: <20250623130634.150041202@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jacob Moroni <jmoroni@google.com>

[ Upstream commit 4dab26bed543584577b64b36aadb8b5b165bf44f ]

In workloads where there are many processes establishing connections using
RDMA CM in parallel (large scale MPI), there can be heavy contention for
mad_agent_lock in cm_alloc_msg.

This contention can occur while inside of a spin_lock_irq region, leading
to interrupts being disabled for extended durations on many
cores. Furthermore, it leads to the serialization of rdma_create_ah calls,
which has negative performance impacts for NICs which are capable of
processing multiple address handle creations in parallel.

The end result is the machine becoming unresponsive, hung task warnings,
netdev TX timeouts, etc.

Since the lock appears to be only for protection from cm_remove_one, it
can be changed to a rwlock to resolve these issues.

Reproducer:

Server:
  for i in $(seq 1 512); do
    ucmatose -c 32 -p $((i + 5000)) &
  done

Client:
  for i in $(seq 1 512); do
    ucmatose -c 32 -p $((i + 5000)) -s 10.2.0.52 &
  done

Fixes: 76039ac9095f ("IB/cm: Protect cm_dev, cm_ports and mad_agent with kref and lock")
Link: https://patch.msgid.link/r/20250220175612.2763122-1-jmoroni@google.com
Signed-off-by: Jacob Moroni <jmoroni@google.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cm.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index c8a7fe5fbc233..96e00e86ebbf6 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -166,7 +166,7 @@ struct cm_port {
 struct cm_device {
 	struct kref kref;
 	struct list_head list;
-	spinlock_t mad_agent_lock;
+	rwlock_t mad_agent_lock;
 	struct ib_device *ib_device;
 	u8 ack_delay;
 	int going_down;
@@ -283,7 +283,7 @@ static struct ib_mad_send_buf *cm_alloc_msg(struct cm_id_private *cm_id_priv)
 	if (!cm_id_priv->av.port)
 		return ERR_PTR(-EINVAL);
 
-	spin_lock(&cm_id_priv->av.port->cm_dev->mad_agent_lock);
+	read_lock(&cm_id_priv->av.port->cm_dev->mad_agent_lock);
 	mad_agent = cm_id_priv->av.port->mad_agent;
 	if (!mad_agent) {
 		m = ERR_PTR(-EINVAL);
@@ -314,7 +314,7 @@ static struct ib_mad_send_buf *cm_alloc_msg(struct cm_id_private *cm_id_priv)
 	m->context[0] = cm_id_priv;
 
 out:
-	spin_unlock(&cm_id_priv->av.port->cm_dev->mad_agent_lock);
+	read_unlock(&cm_id_priv->av.port->cm_dev->mad_agent_lock);
 	return m;
 }
 
@@ -1310,10 +1310,10 @@ static __be64 cm_form_tid(struct cm_id_private *cm_id_priv)
 	if (!cm_id_priv->av.port)
 		return cpu_to_be64(low_tid);
 
-	spin_lock(&cm_id_priv->av.port->cm_dev->mad_agent_lock);
+	read_lock(&cm_id_priv->av.port->cm_dev->mad_agent_lock);
 	if (cm_id_priv->av.port->mad_agent)
 		hi_tid = ((u64)cm_id_priv->av.port->mad_agent->hi_tid) << 32;
-	spin_unlock(&cm_id_priv->av.port->cm_dev->mad_agent_lock);
+	read_unlock(&cm_id_priv->av.port->cm_dev->mad_agent_lock);
 	return cpu_to_be64(hi_tid | low_tid);
 }
 
@@ -4365,7 +4365,7 @@ static int cm_add_one(struct ib_device *ib_device)
 		return -ENOMEM;
 
 	kref_init(&cm_dev->kref);
-	spin_lock_init(&cm_dev->mad_agent_lock);
+	rwlock_init(&cm_dev->mad_agent_lock);
 	cm_dev->ib_device = ib_device;
 	cm_dev->ack_delay = ib_device->attrs.local_ca_ack_delay;
 	cm_dev->going_down = 0;
@@ -4481,9 +4481,9 @@ static void cm_remove_one(struct ib_device *ib_device, void *client_data)
 		 * The above ensures no call paths from the work are running,
 		 * the remaining paths all take the mad_agent_lock.
 		 */
-		spin_lock(&cm_dev->mad_agent_lock);
+		write_lock(&cm_dev->mad_agent_lock);
 		port->mad_agent = NULL;
-		spin_unlock(&cm_dev->mad_agent_lock);
+		write_unlock(&cm_dev->mad_agent_lock);
 		ib_unregister_mad_agent(mad_agent);
 		ib_port_unregister_client_groups(ib_device, i,
 						 cm_counter_groups);
-- 
2.39.5



