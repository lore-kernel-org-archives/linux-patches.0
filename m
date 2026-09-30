Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B017A37A825;
	Wed, 30 Sep 2026 17:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791154; cv=none; b=NX3epHmGEt8MxrTYfmr1TX1lSmKZiLdBHWlBdRPuisqgeaMSp9NGzV2rA/Q9Hehrc2CcP3rit9gUe2CMb1vhZBy9OlMSpqJLBdled5/I35Ve1PusRt+zSuCw3OdfF4JqOufMEhyFGKqllZI8sn0I1ReWFMnqZz47qWIsCdWDmNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791154; c=relaxed/simple;
	bh=uWs9/OdgaEECdxVVlT0uoAzzk6ajlDLEtSFIpX8LJ1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e3l9hcGMahDOLxIYEDUaKR1AJ+xIP3MGFXe1Ed6n23byOria9fXTFBbfbBHj9o+X1OxS/G9DhQocxoHoY2RT7BmBIFc17oG9MRjbDlvJLyg+danP6dAydFPEs7s7cGPirzgoRfMaTaEAgwSLC3Tv1g5KHDPV/vTGzbc8lyyOv4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qNm4ibab; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qNm4ibab"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 139611F000FF;
	Wed, 30 Sep 2026 17:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791153;
	bh=3keyY2qccTF9pO4C9m8Pq0WpdxNsRNqn9NlVrZBiGOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qNm4ibabWPzXNamfQ5/NwTrlXW2kFDJ8xLgJPeu7CZHYvCew+dRGM6izpByYFA36L
	 jYba/iVgMIkx8EYyc+uW41+GLnBGLjow0zYVa4+LBzlMfg1fYv942tdUkWIxRhT76w
	 cN8fvqGXzSqxWBRgpQH6eGLhwvWieF6fB9QZEkoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 176/752] net: au1000: move free_irq out of the close-time spinlocked section
Date: Wed, 30 Sep 2026 17:20:46 +0200
Message-ID: <20260930152402.012133136@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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
index 9c1636222b99c..3232e9d5f5c3b 100644
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



