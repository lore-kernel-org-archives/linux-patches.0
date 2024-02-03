Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E28125A9;
	Sat,  3 Feb 2024 04:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933425; cv=none; b=D6BxOMLDiA7lnjtQUmduDBCnMlfexIC/cnZRD05Jm2tJH5uo9pGR/iF1RftC0yOYFK70y3J4uykBYfS00uoIMaSUG7QOfLGkE0f9d7xsH4iwaQqlxbP5Bs6RiyHGN6RC1jQzDhFn+ivjN0w9VVW4b65R4CmkhK0sqG2FJRp0HXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933425; c=relaxed/simple;
	bh=YCuhGphGrfds1XBDInEH0/kv4t/0x/gqV4WjMbsbLWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=STOpZ4mqgG+flsjJXyp1cx55r0QaXhKWbbWkeDpYh2EJZrG4NiE6blsqxAWSeaySHxfHXFGdpNRxOlpj9HG4GRBuIPWKVM0GQqxMMkeLASb/eTj8IguVHtSszNN4GuBL3w2/LWKg100fnB62ceD5QrZ6s5hY0xwVGVxeojryrb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DMbjmprH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DMbjmprH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FA90C433C7;
	Sat,  3 Feb 2024 04:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933425;
	bh=YCuhGphGrfds1XBDInEH0/kv4t/0x/gqV4WjMbsbLWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DMbjmprHzUsmKuKmnkUA5LDBvozNjUBnDZyl7Y2zZv3wiGaWBo8+MM+YxXycJ1YSu
	 IdUOUXuW1rDWHB8o4tNbx2bM9xJrNTZ+N2Yx1Lw6FP0eB0ejcvD3+eBNm5BZrBqVjr
	 1A23Tm01ZarGrlmtLeXAmWM7cPMqre70hd3/20lY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 128/219] IB/ipoib: Fix mcast list locking
Date: Fri,  2 Feb 2024 20:05:01 -0800
Message-ID: <20240203035335.498037621@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vacek <neelx@redhat.com>

[ Upstream commit 4f973e211b3b1c6d36f7c6a19239d258856749f9 ]

Releasing the `priv->lock` while iterating the `priv->multicast_list` in
`ipoib_mcast_join_task()` opens a window for `ipoib_mcast_dev_flush()` to
remove the items while in the middle of iteration. If the mcast is removed
while the lock was dropped, the for loop spins forever resulting in a hard
lockup (as was reported on RHEL 4.18.0-372.75.1.el8_6 kernel):

    Task A (kworker/u72:2 below)       | Task B (kworker/u72:0 below)
    -----------------------------------+-----------------------------------
    ipoib_mcast_join_task(work)        | ipoib_ib_dev_flush_light(work)
      spin_lock_irq(&priv->lock)       | __ipoib_ib_dev_flush(priv, ...)
      list_for_each_entry(mcast,       | ipoib_mcast_dev_flush(dev = priv->dev)
          &priv->multicast_list, list) |
        ipoib_mcast_join(dev, mcast)   |
          spin_unlock_irq(&priv->lock) |
                                       |   spin_lock_irqsave(&priv->lock, flags)
                                       |   list_for_each_entry_safe(mcast, tmcast,
                                       |                  &priv->multicast_list, list)
                                       |     list_del(&mcast->list);
                                       |     list_add_tail(&mcast->list, &remove_list)
                                       |   spin_unlock_irqrestore(&priv->lock, flags)
          spin_lock_irq(&priv->lock)   |
                                       |   ipoib_mcast_remove_list(&remove_list)
   (Here, `mcast` is no longer on the  |     list_for_each_entry_safe(mcast, tmcast,
    `priv->multicast_list` and we keep |                            remove_list, list)
    spinning on the `remove_list` of   |  >>>  wait_for_completion(&mcast->done)
    the other thread which is blocked  |
    and the list is still valid on     |
    it's stack.)

Fix this by keeping the lock held and changing to GFP_ATOMIC to prevent
eventual sleeps.
Unfortunately we could not reproduce the lockup and confirm this fix but
based on the code review I think this fix should address such lockups.

crash> bc 31
PID: 747      TASK: ff1c6a1a007e8000  CPU: 31   COMMAND: "kworker/u72:2"
--
    [exception RIP: ipoib_mcast_join_task+0x1b1]
    RIP: ffffffffc0944ac1  RSP: ff646f199a8c7e00  RFLAGS: 00000002
    RAX: 0000000000000000  RBX: ff1c6a1a04dc82f8  RCX: 0000000000000000
                                  work (&priv->mcast_task{,.work})
    RDX: ff1c6a192d60ac68  RSI: 0000000000000286  RDI: ff1c6a1a04dc8000
           &mcast->list
    RBP: ff646f199a8c7e90   R8: ff1c699980019420   R9: ff1c6a1920c9a000
    R10: ff646f199a8c7e00  R11: ff1c6a191a7d9800  R12: ff1c6a192d60ac00
                                                         mcast
    R13: ff1c6a1d82200000  R14: ff1c6a1a04dc8000  R15: ff1c6a1a04dc82d8
           dev                    priv (&priv->lock)     &priv->multicast_list (aka head)
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 9e6967a40042..319d4288eddd 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -531,21 +531,17 @@ static int ipoib_mcast_join(struct net_device *dev, struct ipoib_mcast *mcast)
 		if (test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags))
 			rec.join_state = SENDONLY_FULLMEMBER_JOIN;
 	}
-	spin_unlock_irq(&priv->lock);
 
 	multicast = ib_sa_join_multicast(&ipoib_sa_client, priv->ca, priv->port,
-					 &rec, comp_mask, GFP_KERNEL,
+					 &rec, comp_mask, GFP_ATOMIC,
 					 ipoib_mcast_join_complete, mcast);
-	spin_lock_irq(&priv->lock);
 	if (IS_ERR(multicast)) {
 		ret = PTR_ERR(multicast);
 		ipoib_warn(priv, "ib_sa_join_multicast failed, status %d\n", ret);
 		/* Requeue this join task with a backoff delay */
 		__ipoib_mcast_schedule_join_thread(priv, mcast, 1);
 		clear_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags);
-		spin_unlock_irq(&priv->lock);
 		complete(&mcast->done);
-		spin_lock_irq(&priv->lock);
 		return ret;
 	}
 	return 0;
-- 
2.43.0



