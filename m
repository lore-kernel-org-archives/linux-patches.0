Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062265;
	b=VRw1xGGyAZGXor/qbKgs4eUFMppCuO5jn3Pu1XAIQ35s7y4Rw1YClvoRhPUpt+2/KRNT
	 XL5nPfeeWaRs+YvEYmcOI6IzwaADFz3O/tQRAvKqiZ5owRRu4nKTN7QDjjchfMl7jp0MU
	 KhauQEXm2NBV/5zJWwB8zIPNAgBITUShSfWHt8QiL4tReNwgfuQz1VmuEBzm4ACLzgCLM
	 CSQ3QPFuQsBANJ15qJl2BARDmo9Yn1FX2MB9iiptSq7Xftf5ojMuk+a1uSt3MY2EVWaWF
	 iTFU3GL+2YmPwk4RKe6ed5AXJJtrC5mWBEC7bVCQ47OYJua1zMVrN0ryoc0hEC9AR2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062265;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7mkd0VTOGhj0ZqShrdcwysK0GuvMxvWiEBdrVgOROOk=;
	b=Sa0fFsmWzAxaR690+6taSnTRdCRCubjoHF/moSyfPgsFeLUFqM1XRh0yUCz62+jJFjUg
	 wieekbJaYH6DkSvMlk7Hjf1Fq+IRisr8bG5VfA+i3oeDIGVQTb5JgLE8sI4YBqwCeiTUR
	 WYd5UmVIawAtnvzDFk7jMxzjg9KugDmQxnotFeCHQgD+KKd0pYvpW6zJN5od+Pb/IRcre
	 q5pgp2j+hqXJFVbhhFTTrXQoE/J3nmdz4DdN9ECp9HvWJ3Sv+VmUvnSaInLU2XMMNJK9z
	 uTRckuXFdYKECP7sa/6CNr8CoaZ2pA9VeFlrRvHMI5h7kEwdffhi+7CkedW5oRdU85g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eGItANqt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B2E8606A334;
	Sat,  7 Nov 2026 14:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eGItANqt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B56F71F0089F;
	Sat,  7 Nov 2026 14:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062265;
	bh=7mkd0VTOGhj0ZqShrdcwysK0GuvMxvWiEBdrVgOROOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eGItANqtiS+9arqvZslkkfIKf1Nzv7KRggqKfaWl1wg5qeyTT19sedWU2g5Ppy0fb
	 QfleAH2SceKvh5qbT3r6Px0K/6hp8ft5OWw+ZK8ntyosMGX0irKEKnVWLyww3NQrQ8
	 qtWy7NKhCgGLk/DSVTlchT5po7d4bBTSmSCdsTUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1208/1536] xen/privcmd: Only claim ioreqs matching an ioeventfd
Date: Sat,  7 Nov 2026 08:53:44 -0500
Message-ID: <20261107135031.682714955@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koichiro Den <den@valinux.co.jp>

[ Upstream commit 908019e5999161ca89da310c05ddbf7fc89c129e ]

The ioeventfd handler shares its event channel with the userspace device
model. It must only claim requests that match a registered ioeventfd.
Other requests are left for userspace.

ioeventfd_interrupt() currently marks every MMIO write INPROCESS before
looking for a match. For an unmatched request it drops the lock and
restores READY. Userspace may see INPROCESS and skip it. Restoring READY
does not send another notification. If userspace handles the request at
the same time, the READY store may overwrite its state.

Find a matching ioeventfd before changing the request state.

The lock now protects only the ioeventfd list. Use explicit virt_*mb()
barriers for the ioreq shared with Xen.

Fixes: f0d7db7b3324 ("xen: privcmd: Add support for ioeventfd")
Cc: stable@vger.kernel.org
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20260821084112.2374949-1-den@valinux.co.jp>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/privcmd.c | 47 +++++++++++++++++--------------------------
 1 file changed, 18 insertions(+), 29 deletions(-)

diff --git a/drivers/xen/privcmd.c b/drivers/xen/privcmd.c
index 115b54c3805b0..c562e6df49cc7 100644
--- a/drivers/xen/privcmd.c
+++ b/drivers/xen/privcmd.c
@@ -1179,51 +1179,40 @@ static irqreturn_t ioeventfd_interrupt(int irq, void *dev_id)
 	struct privcmd_kernel_ioreq *kioreq = port->kioreq;
 	struct ioreq *ioreq = &kioreq->ioreq[port->vcpu];
 	struct privcmd_kernel_ioeventfd *kioeventfd;
-	unsigned int state = STATE_IOREQ_READY;
+	bool matched = false;
 
-	if (ioreq->state != STATE_IOREQ_READY ||
-	    ioreq->type != IOREQ_TYPE_COPY || ioreq->dir != IOREQ_WRITE)
+	if (ioreq->state != STATE_IOREQ_READY)
 		return IRQ_NONE;
 
-	/*
-	 * We need a barrier, smp_mb(), here to ensure reads are finished before
-	 * `state` is updated. Since the lock implementation ensures that
-	 * appropriate barrier will be added anyway, we can avoid adding
-	 * explicit barrier here.
-	 *
-	 * Ideally we don't need to update `state` within the locks, but we do
-	 * that here to avoid adding explicit barrier.
-	 */
+	/* Xen publishes the request before changing its state to READY. */
+	virt_rmb();
 
-	spin_lock(&kioreq->lock);
-	ioreq->state = STATE_IOREQ_INPROCESS;
+	if (ioreq->type != IOREQ_TYPE_COPY || ioreq->dir != IOREQ_WRITE)
+		return IRQ_NONE;
 
+	spin_lock(&kioreq->lock);
 	list_for_each_entry(kioeventfd, &kioreq->ioeventfds, list) {
 		if (ioreq->addr == kioeventfd->addr + VIRTIO_MMIO_QUEUE_NOTIFY &&
 		    ioreq->size == kioeventfd->addr_len &&
 		    (ioreq->data & QUEUE_NOTIFY_VQ_MASK) == kioeventfd->vq) {
+			/* Finish reading the request before claiming it. */
+			virt_mb();
+			ioreq->state = STATE_IOREQ_INPROCESS;
 			eventfd_signal(kioeventfd->eventfd);
-			state = STATE_IORESP_READY;
+			matched = true;
 			break;
 		}
 	}
 	spin_unlock(&kioreq->lock);
 
-	/*
-	 * We need a barrier, smp_mb(), here to ensure writes are finished
-	 * before `state` is updated. Since the lock implementation ensures that
-	 * appropriate barrier will be added anyway, we can avoid adding
-	 * explicit barrier here.
-	 */
-
-	ioreq->state = state;
-
-	if (state == STATE_IORESP_READY) {
-		notify_remote_via_evtchn(port->port);
-		return IRQ_HANDLED;
-	}
+	if (!matched)
+		return IRQ_NONE;
 
-	return IRQ_NONE;
+	/* Publish the response only after signaling the eventfd. */
+	virt_wmb();
+	ioreq->state = STATE_IORESP_READY;
+	notify_remote_via_evtchn(port->port);
+	return IRQ_HANDLED;
 }
 
 static void ioreq_free(struct privcmd_kernel_ioreq *kioreq)
-- 
2.53.0



