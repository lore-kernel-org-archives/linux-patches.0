Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91EC39B971;
	Fri, 15 May 2026 16:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860913; cv=none; b=HZxzC7B0Mc6ufRCaC9CbgeIxIK3oAgZntsSdGOQVK6e+JV7rAXDx/1jNvdtiCpL9E5WdF/EVJ9WCtqD7DEHlUcfUi9NbEBnYxpVb6Z4GSZtGjVXABd1ZJDfYQwrVJSftHkim01YQCRkvw3cSRv0fBQQQ0VeAEHBEBP6QKCiXRes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860913; c=relaxed/simple;
	bh=ZaNSzgP1sfhccuj8LBhr2Kl90KHnpYPUxSHpBTQ+lI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=siRnzP0JkGp/tboLOCG5XfABcYjswy7zaq5CWQQPCRrhgYqNVtEbf/x+wzNea6BmII/mw3oouuqAxnpQ+ewDsc5spI8fGROLDPLR2NgCtjEKarJqCdwS2Dsr2VOSFpJDxgQSbr3PVw9Xlk+C5gcaK6Nbu1da4vZv8yGqtGFrgt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QNqIDoKm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QNqIDoKm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40312C2BCB0;
	Fri, 15 May 2026 16:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860913;
	bh=ZaNSzgP1sfhccuj8LBhr2Kl90KHnpYPUxSHpBTQ+lI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QNqIDoKmtF/PLuY1qa8iYdtRHmGeqIt/QmMmAHJnP7l003ATPkVV4hIWCslXDo3qJ
	 CMfHM8N1GTV3i9sjmTqaFZeEM3edg7fW2jX4D3XsJcxlORaxChZCBZdUFj/U+C6b/P
	 iQNA3CH0Ab1vEvAADle/VIQmfYIQsLOE9PmLDQDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Zhao <chezhao@nvidia.com>,
	Parav Pandit <parav@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.6 128/474] IB/core: Fix zero dmac race in neighbor resolution
Date: Fri, 15 May 2026 17:43:57 +0200
Message-ID: <20260515154717.802163942@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


