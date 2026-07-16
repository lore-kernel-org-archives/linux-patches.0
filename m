Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A473161AD;
	Thu, 16 Jul 2026 14:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210872; cv=none; b=TfY/0AqFs4obF/VxH0SFp6hhrI3NBBDy3t65adVFT7ux2gj1NvlRTGnntH7LfTR0CYCyJwWcFWErtMvkftZytzTtPTvOc1WuYWlFGlD+H88q4aGeS0nCNpKJJ60D15RVCMSkEsqiQfJWdQByxkTXyulAVEBlYmL/rwr1jLJwQ4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210872; c=relaxed/simple;
	bh=+m65FkVTIB5JAk8UEQvkBTUz1Tdltl9aRdEC2wEXRp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lAOTS0nuFsC71nLs4w/+2bRTPS+2AKhNZtuLsHTU8e0He6CKgH8KWE5cYG+tM6DKEf1hOfLfqkTvkt8FEfvGEdaEiMIV9L1lb6bThaTB6A4RqWAhqhfob0PhN4E61t//eH/DgMU5kvbMisW/NLjEoK/+snnQyuEXMYi+E8foXwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z2cdBhJH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z2cdBhJH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F7891F000E9;
	Thu, 16 Jul 2026 14:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210870;
	bh=bPb6g+4/cE1/QiKnhj7UTjwgqe/+v2WjaqEjKycJEOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z2cdBhJHirRGlNPIiFeRBNRUYDwa5qsvE1NQ1sdOlhS5+IudGSjYHV6ruP1EUn9x+
	 pkqy6/Wdk6Hn/EaDz7To/xHEzzvqtoUrrC4NKavMEgbGyGw/cJ9pyVEK7ioZYtVVRX
	 qVNVsl0cBEQLZ8E4FkUIv0U97LrHZtL1cNwOVxN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 185/480] netpoll: fix a use-after-free on shutdown path
Date: Thu, 16 Jul 2026 15:28:52 +0200
Message-ID: <20260716133048.730307384@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

commit 45f1458a85017a023f138b22ac5c76abd477db42 upstream.

There is a use-after-free error on netpoll, which is clearly detected by
KASAN.

      BUG: KASAN: slab-use-after-free in _raw_spin_lock_irqsave+0x3b/0x80
      Read of size 1 at addr ... by task kworker/9:1
      Workqueue: events queue_process
      Call Trace:
       skb_dequeue+0x1e/0xb0
       queue_process+0x2c/0x600
       process_scheduled_works+0x4b6/0x850
       worker_thread+0x414/0x5a0
      Allocated by task 242:
       __netpoll_setup+0x201/0x4a0
       netpoll_setup+0x249/0x550
       enabled_store+0x32f/0x380
      Freed by task 0:
       kfree+0x1b7/0x540
       rcu_core+0x3f8/0x7a0

The problem happens when there is a pending TX worker running in
parallel with the cleanup path.

This is what happens on netpoll shutdown path:

1) __netpoll_cleanup() is called
2) set dev->npinfo to NULL
3) call_rcu() with rcu_cleanup_netpoll_info()
  3.1) rcu_cleanup_netpoll_info() tries to cancel all workers with
       cancel_delayed_work(), but doesn't wait for the worker to finish
4) and kfree(npinfo);

Because 3.1) doesn't really cancel the work, as the comment says "we
can't call cancel_delayed_work_sync here, as we are in softirq", the TX
worker can run after 4).

Tl;DR: queue_process() is not an RCU reader, it reaches npinfo through
the work item via container_of().

Use disable_delayed_work_sync() to ensure the worker is completely
stopped and prevent any future re-arming attempts. Once npinfo is set
to NULL, senders will bail out and not queue new work. The disable flag
ensures any in-flight re-arming attempts also fail silently.

In the future, we can do the cleanup inline here without needing the
npinfo->rcu rcu_head, but that is net-next material.

Cc: stable@vger.kernel.org
Fixes: 38e6bc185d95 ("netpoll: make __netpoll_cleanup non-block")
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20260625-netpoll_rcu_fix-v2-1-0748ffac1e98@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/netpoll.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -812,14 +812,6 @@ static void rcu_cleanup_netpoll_info(str
 			container_of(rcu_head, struct netpoll_info, rcu);
 
 	skb_queue_purge(&npinfo->txq);
-
-	/* we can't call cancel_delayed_work_sync here, as we are in softirq */
-	cancel_delayed_work(&npinfo->tx_work);
-
-	/* clean after last, unfinished work */
-	__skb_queue_purge(&npinfo->txq);
-	/* now cancel it again */
-	cancel_delayed_work(&npinfo->tx_work);
 	kfree(npinfo);
 }
 
@@ -843,6 +835,7 @@ static void __netpoll_cleanup(struct net
 			ops->ndo_netpoll_cleanup(np->dev);
 
 		RCU_INIT_POINTER(np->dev->npinfo, NULL);
+		disable_delayed_work_sync(&npinfo->tx_work);
 		call_rcu(&npinfo->rcu, rcu_cleanup_netpoll_info);
 	}
 


