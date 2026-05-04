Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6F475801;
	Mon,  4 May 2026 14:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903562; cv=none; b=s//XOHb7hQBnadlIsC5dGUUA+SQB1D6IzdwZ3dlJtvDaa3p/M61THch10D9DH2A9FPrxoOSW4rDVqyvw4ITFdiEC+ovC0Ewq7Ftj9Jws8NlML5rwp1vGAvmeDsOhAa5FDuLTgir6SaMASKroWXL5B9x6Zwct4tG5eNx3mZKbj3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903562; c=relaxed/simple;
	bh=u2cknzbc+ivl5t6mV3D2mFEwORpMrv+FZwtqY+JyBos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U0wdPCdiAhd8mbsSCCBzTN8GLn2CqQEcDjOyMJoAd22n3dXTT+r7pMzgRMMx5ifQMnybfWN3C99ZZBGZhZuM/m46q/XkiN0nGMqBqbbUxPfcD23AO/2YrnPGhdvxwuw/XN04etY3B7pSqvcnpTE4nK9g0A+bdZtPVbZnSjYHGCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fvUuo10C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fvUuo10C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B452C2BCB8;
	Mon,  4 May 2026 14:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903562;
	bh=u2cknzbc+ivl5t6mV3D2mFEwORpMrv+FZwtqY+JyBos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fvUuo10CBjEqEsmXsWnD7ZBfkk/9tBdatCwliVF9WAY2pitG956V87mp70aUBXJ89
	 1sMLy+A4n3d/hhyLxuF/l/Je2/DopW52is7vTAq3wg11MiSuL0XQJXTHUqtAiL4NvD
	 S+r9nuo2JZu1Cg5dhrxxw40coGLadn4NhrB+VSo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Zhao <chezhao@nvidia.com>,
	Parav Pandit <parav@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 7.0 275/307] IB/core: Fix zero dmac race in neighbor resolution
Date: Mon,  4 May 2026 15:52:40 +0200
Message-ID: <20260504135153.148481273@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Zhao <chezhao@nvidia.com>

commit 5e6de34d82b49cab9d8a42063e9cd0f22a4f31e5 upstream.

dst_fetch_ha() checks nud_state without holding the neighbor lock, then
copies ha under the seqlock. A race in __neigh_update() where nud_state
is set to NUD_REACHABLE before ha is written allows dst_fetch_ha() to
read a zero MAC address while the seqlock reports no concurrent writer.

netevent_callback amplifies this by waking ALL pending addr_req workers
when ANY neighbor becomes NUD_VALID. At scale (N peers resolving ARP
concurrently), the hit probability scales as N^2, making it near-certain
for large RDMA workloads.

N(A): neigh_update(A)                   W(A): addr_resolve(A)
 |                                       [sleep]
 | write_lock_bh(&A->lock)               |
 | A->nud_state = NUD_REACHABLE          |
 | // A->ha is still 0                   |
 |                                       [woken by netevent_cb() of
 |                                         another neighbour]
 |                                       | dst_fetch_ha(A)
 |                                       |   A->nud_state & NUD_VALID
 |                                       |   read_seqbegin(&A->ha_lock)
 |                                       |   snapshot = A->ha  /* 0 */
 |                                       |   read_seqretry(&A->ha_lock)
 |                                       |   return snapshot
 | seqlock(&A->ha_lock)
 | A->ha = mac_A     /* too late */
 | sequnlock(&A->ha_lock)
 | write_unlock_bh(&A->lock)

The incorrect/zero mac is read and programmed in the device QP while it
was not yet updated. This causes silent packet loss and eventual
RETRY_EXC_ERR.

Fix by holding the neighbor read lock across the nud_state check and
ha copy in dst_fetch_ha(), ensuring it synchronizes with
__neigh_update() which is updating while holding the write lock.

Cc: stable@vger.kernel.org
Fixes: 92ebb6a0a13a ("IB/cm: Remove now useless rcu_lock in dst_fetch_ha")
Link: https://patch.msgid.link/r/20260405-fix-dmac-race-v1-1-cfa1ec2ce54a@nvidia.com
Signed-off-by: Chen Zhao <chezhao@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/core/addr.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -321,11 +321,14 @@ static int dst_fetch_ha(const struct dst
 	if (!n)
 		return -ENODATA;
 
+	read_lock_bh(&n->lock);
 	if (!(n->nud_state & NUD_VALID)) {
+		read_unlock_bh(&n->lock);
 		neigh_event_send(n, NULL);
 		ret = -ENODATA;
 	} else {
 		neigh_ha_snapshot(dev_addr->dst_dev_addr, n, dst->dev);
+		read_unlock_bh(&n->lock);
 	}
 
 	neigh_release(n);


