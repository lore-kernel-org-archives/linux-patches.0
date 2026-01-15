Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE50386334;
	Thu, 15 Jan 2026 17:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498283; cv=none; b=ZAql8Jaz0375m/lkPZzALczA3Hvc3pTRKE3DT+9QP2lkxSydquUu5EnktP56lt4zQPHgEO7YegVWxm4L0udmsquxemurfANOMYPLpDsbi0GWA6zmnyCe2JQY8W6uYu041VwUkJUshknKrDFzmysyIVxo+ilEU+130oJkB5Bx0T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498283; c=relaxed/simple;
	bh=2M92dzv2+YvWzaNubJSJ4yz4Qzrirao0ugkXa8BtQXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iCfjd/vfz73hJ6vYmuzO4Z8fa1PyOMHX+x4Zfgr2+Om2NPChgj8lvj5lfrNpUPKM3J4BkHgaKhx6X/S3FnNMeZhVpOU1Q7p5i37Wuyf7ErXcbBxujhvTa9KpWbyTmcMzgraMVksqgOHmXru43iUdS1nin48AisXcNHzByy6mOrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eYHW+gJ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eYHW+gJ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49759C116D0;
	Thu, 15 Jan 2026 17:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498283;
	bh=2M92dzv2+YvWzaNubJSJ4yz4Qzrirao0ugkXa8BtQXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eYHW+gJ7e15F3bXkTUTl9FJztJNFSBh8BsRfuNMO83Vq+iOpooHPUgl6HKQFoC6TO
	 mIY7xtYBxcqQR7NaITNKVSIptjREyWRKHq46Fpk4QbHyTlRueQVTJU9hIK0HNnt/2T
	 mFyacAd52aCjV5YsZUw3XL5sEuA+RY/ZQXcVWnCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 350/554] smc91x: fix broken irq-context in PREEMPT_RT
Date: Thu, 15 Jan 2026 17:46:56 +0100
Message-ID: <20260115164258.896176262@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yeoreum Yun <yeoreum.yun@arm.com>

[ Upstream commit 6402078bd9d1ed46e79465e1faaa42e3458f8a33 ]

When smc91x.c is built with PREEMPT_RT, the following splat occurs
in FVP_RevC:

[   13.055000] smc91x LNRO0003:00 eth0: link up, 10Mbps, half-duplex, lpa 0x0000
[   13.062137] BUG: workqueue leaked atomic, lock or RCU: kworker/2:1[106]
[   13.062137]      preempt=0x00000000 lock=0->0 RCU=0->1 workfn=mld_ifc_work
[   13.062266] C
** replaying previous printk message **
[   13.062266] CPU: 2 UID: 0 PID: 106 Comm: kworker/2:1 Not tainted 6.18.0-dirty #179 PREEMPT_{RT,(full)}
[   13.062353] Hardware name:  , BIOS
[   13.062382] Workqueue: mld mld_ifc_work
[   13.062469] Call trace:
[   13.062494]  show_stack+0x24/0x40 (C)
[   13.062602]  __dump_stack+0x28/0x48
[   13.062710]  dump_stack_lvl+0x7c/0xb0
[   13.062818]  dump_stack+0x18/0x34
[   13.062926]  process_scheduled_works+0x294/0x450
[   13.063043]  worker_thread+0x260/0x3d8
[   13.063124]  kthread+0x1c4/0x228
[   13.063235]  ret_from_fork+0x10/0x20

This happens because smc_special_trylock() disables IRQs even on PREEMPT_RT,
but smc_special_unlock() does not restore IRQs on PREEMPT_RT.
The reason is that smc_special_unlock() calls spin_unlock_irqrestore(),
and rcu_read_unlock_bh() in __dev_queue_xmit() cannot invoke
rcu_read_unlock() through __local_bh_enable_ip() when current->softirq_disable_cnt becomes zero.

To address this issue, replace smc_special_trylock() with spin_trylock_irqsave().

Fixes: 342a93247e08 ("locking/spinlock: Provide RT variant header: <linux/spinlock_rt.h>")
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20251217085115.1730036-1-yeoreum.yun@arm.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/smsc/smc91x.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/smsc/smc91x.c b/drivers/net/ethernet/smsc/smc91x.c
index 813ea941b91a..c63783516202 100644
--- a/drivers/net/ethernet/smsc/smc91x.c
+++ b/drivers/net/ethernet/smsc/smc91x.c
@@ -515,15 +515,7 @@ static inline void  smc_rcv(struct net_device *dev)
  * any other concurrent access and C would always interrupt B. But life
  * isn't that easy in a SMP world...
  */
-#define smc_special_trylock(lock, flags)				\
-({									\
-	int __ret;							\
-	local_irq_save(flags);						\
-	__ret = spin_trylock(lock);					\
-	if (!__ret)							\
-		local_irq_restore(flags);				\
-	__ret;								\
-})
+#define smc_special_trylock(lock, flags)	spin_trylock_irqsave(lock, flags)
 #define smc_special_lock(lock, flags)		spin_lock_irqsave(lock, flags)
 #define smc_special_unlock(lock, flags) 	spin_unlock_irqrestore(lock, flags)
 #else
-- 
2.51.0



