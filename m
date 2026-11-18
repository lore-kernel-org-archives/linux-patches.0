Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020608;
	b=z7aMrRGwPR0s1VRdFl8pDhblKnaUvvz6VssLU0LpjfUM8SAOsIofNt+KkwRj8wrQYi+g
	 buBV69VeyxgDhGnbugXLNeo/qF6IcWn1WLZPMwQV3LdlIpXVVrqK4fwRKZOGAKljN2mDb
	 4UCOOcFA8l8DSRJB6jAyRYlAsUf5O9VqpEN7nPe8D9lA8njjBumqYMS5SZErOMG1CxhfJ
	 Yck9GwMuL7MdjYYLwhyafeUnOwQyUAX9zVfWldl1JJsZJzOr9zXJkdZq1aOm/q+DtRDJe
	 2IBGFwgRiV7cn01jvAG2t5uI9ofVdO5bh+6gG6uY2UH9Vi+CPNhXyBbL9w2UdZ0OdWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020608;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x0owyecB+7uEyr359APnvTLJo2n88qhDI6aGt4vRIk4=;
	b=MKswTprtvmsBgafnc1b0XiDHIag2orqDuYwaQuIxO6iDOmOEU3iBq7xfV6Rti+oUl1zO
	 vyCkyrM69dqKV3m6Cw14lyzwhx+1GSrlG/d6lIDEzbES6ZAXsf1broVihUIC3rDDIv9EY
	 oSWxJNHu6sBjk131zkqCbKzj70d5Ubgq+LseP3StZZI9dkPS4nl43+C9BiNiEDeZhTMsa
	 d+R4sXqChUDxC1mkRov2RrIbULMN8bfiHLZfFPUrTeFh4UBCoxWJaE3SVTvkbzkio/h+3
	 ZGqxVDJw2nSN7clbTkB3au8kUkzNWl52mKAP2H90auyjvCleH8fx/C01p4Ns3OKK7bQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u6g7hFVG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B46B60A260F;
	Wed, 18 Nov 2026 16:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u6g7hFVG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D11491F000D3;
	Wed, 18 Nov 2026 16:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020608;
	bh=x0owyecB+7uEyr359APnvTLJo2n88qhDI6aGt4vRIk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u6g7hFVGoh00Inu0Khall73TjLCfcR/UDBmVGmhsjUdV7HBVN8POv8tbPQDDhd7CT
	 zOZTmjzEqAAEfiDZhdcsPZH3q1C+EEgbMaK8NmpQrZob9H+FAMpeHQuxHGarh/rdGv
	 MGrGyit5Te5HPIfrYnc6U8m7lE/2GfuHjLxp3qjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Praveen Kumar Kannoju <praveen.kannoju@oracle.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1972/2651] IB/mlx4: Avoid requeueing executing CM timeout work
Date: Wed, 18 Nov 2026 15:53:32 +0100
Message-ID: <20261118150357.448246703@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Praveen Kumar Kannoju <praveen.kannoju@oracle.com>

[ Upstream commit 9bcf45bfcaf83aed81b5fb12f0edf4c16e73e02e ]

id->scheduled_delete is set by schedule_delayed() itself.  It is used
in two cases after the RTU timeout support was added:

* A new id_map_entry is created, and a 60-second RTU timeout is
  scheduled.
* DREQ or REJ is received for an existing entry, and the normal
  30-second teardown timeout is scheduled or adjusted.

The following race is possible when the RTU timeout expires while a
DREQ or REJ is handled:

 CPU 0: timeout work                         CPU 1: DREQ/REJ handler
 --------------------                        -----------------------
 RTU timer expires
 timeout callback starts
 waits for id_map_lock                       takes id_map_lock

                                             calls schedule_delayed()
                                             calls mod_delayed_work()

                                             drops id_map_lock

 takes id_map_lock
 removes mapping
 frees id_map_entry

                                             requeued timeout runs
                                             accesses freed id_map_entry

mod_delayed_work() may requeue the work after the timeout callback has
started.  The original timeout callback then frees the id_map_entry,
leaving the requeued work with a dangling delayed_work pointer.

When a timeout is already scheduled, first cancel its pending work.  A
successful cancellation means the callback has not started and the
timeout can safely be scheduled again.  If cancellation fails, the
callback is executing and will free the entry after id_map_lock is
released; do not requeue it.

cancel_delayed_work() is deliberately used instead of
cancel_delayed_work_sync(), because the timeout callback may be waiting
for id_map_lock, which is held by the caller.

Fixes: fa09adf4231f ("IB/mlx4: Fix stale CM id_map entries when RTU is never received")
Signed-off-by: Praveen Kumar Kannoju <praveen.kannoju@oracle.com>
Link: https://patch.msgid.link/20261014121344.100048-1-praveen.kannoju@oracle.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx4/cm.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/infiniband/hw/mlx4/cm.c b/drivers/infiniband/hw/mlx4/cm.c
index 1e5e525fea733..810f95e55fda1 100644
--- a/drivers/infiniband/hw/mlx4/cm.c
+++ b/drivers/infiniband/hw/mlx4/cm.c
@@ -301,10 +301,20 @@ static void schedule_delayed(struct ib_device *ibdev, struct id_map_entry *id,
 	spin_lock_irqsave(&sriov->going_down_lock, flags);
 	/*make sure that there is no schedule inside the scheduled work.*/
 	if (!sriov->is_going_down || id->scheduled_delete) {
+		/*
+		 * Do not requeue timeout work that is already executing. The
+		 * timeout handler may be waiting for id_map_lock and will free
+		 * this entry after the caller releases it.
+		 */
+		if (id->scheduled_delete &&
+		    !cancel_delayed_work(&id->timeout))
+			goto out;
+
 		id->scheduled_delete = 1;
 		id->rtu_timeout = rtu_timeout;
 		mod_delayed_work(cm_wq, &id->timeout, timeout);
 	}
+out:
 	spin_unlock_irqrestore(&sriov->going_down_lock, flags);
 }
 
-- 
2.53.0



