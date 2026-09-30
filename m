Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3B950B8C6;
	Wed, 30 Sep 2026 15:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782726; cv=none; b=Nn3VeSfnCsxk3LSaYdZEfuHvwtce1GIukRw2UNByCCJCqTyou1eJfRa28Qm1nOLDdKeAOGKQKoyyJCDndlONPxeEerrPb4fKWDyCtjdEpt/CYVFG51/cZGVLnXN+vQ3swEPwszA18I/vE6+M6RE9ZBqtgLWEdaDK/MEKGXxfnHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782726; c=relaxed/simple;
	bh=IBxnHGVqeVQ8j5eaTo1T3r+dEP3txI034bACb6FQbks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=okgM0FPtmNsqq+gLthBxH0XzGeudGCKALy9p1ddu01vrgLSt5MRj2nDlnZzr8opYJIgO6Q31BbuPTHin5mJj28RwFnrcFkwAjl/8YQ8v6Q6AYAD/Keh4zLM0r8BrQNoQWtH6LWdWrQHmyS6DHbPYIC/Uw22GSBInCnZY91Xux0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J7CPghCq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J7CPghCq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20B521F00898;
	Wed, 30 Sep 2026 15:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782720;
	bh=oQ/AjHrtI+uHB8Trs7dC+kkO+Y3AoBRj2lz3MIpH9ik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J7CPghCqLV95n+cn+WmbA9F228CxnfF0DTODxrPQdx3XnfjdsGiPwiF2F1b6MdBUX
	 kD5i1alLCrkUmtKesPXjt7cnlc3a0cShrf02uOguQNlYRrOXe67L/f5BHumdFveon6
	 Ppbs8+eX1QowjVmJJJTrKv/lh84bUQjtK5ImR0tM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 145/595] net: au1000: move free_irq out of the close-time spinlocked section
Date: Wed, 30 Sep 2026 17:20:38 +0200
Message-ID: <20260930152350.851831992@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit f48763beab4eea41fc480c9702ec6eebe8d75e4f ]

au1000_close() calls free_irq() while aup->lock is still held with
spin_lock_irqsave(). free_irq() can sleep because it takes the IRQ
descriptor request mutex, so it does not belong inside the close-time
spinlocked section.

This was found by our static analysis tool and then confirmed by manual
review of the in-tree au1000_close() .ndo_stop path. The reviewed path
keeps aup->lock held across the MAC reset, queue stop and
free_irq(dev->irq, dev).

A directed runtime validation kept that ndo_stop carrier and the same
free_irq(dev->irq, dev) operation under the driver lock. Lockdep reported
"BUG: sleeping function called from invalid context" and "Invalid wait
context" while free_irq() was taking desc->request_mutex, with
au1000_close() and free_irq() on the stack.

Drop aup->lock before freeing the IRQ. The protected close-time work still
stops the device and queue before IRQ teardown, but the sleepable IRQ core
path now runs outside the spinlocked section.

Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260619151816.1144289-1-runyu.xiao@seu.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/au1000_eth.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/au1000_eth.c b/drivers/net/ethernet/amd/au1000_eth.c
index 19e195420e243..d3ad4716d72ac 100644
--- a/drivers/net/ethernet/amd/au1000_eth.c
+++ b/drivers/net/ethernet/amd/au1000_eth.c
@@ -943,9 +943,10 @@ static int au1000_close(struct net_device *dev)
 	/* stop the device */
 	netif_stop_queue(dev);
 
+	spin_unlock_irqrestore(&aup->lock, flags);
+
 	/* disable the interrupt */
 	free_irq(dev->irq, dev);
-	spin_unlock_irqrestore(&aup->lock, flags);
 
 	return 0;
 }
-- 
2.53.0



