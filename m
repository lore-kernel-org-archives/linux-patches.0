Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43661C68AE;
	Tue, 27 Aug 2024 14:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770110; cv=none; b=TuJmO8hXJlm/A92yYmK2tFO6x4TmeOudlMgZV4aXJiaY5Grd3sErrBFS1CeNsnInrEBL+rztg8ZJdVSnuWZ+a24lJnbFJXi9ZF1lnEppICdiqolnLwS4MqLNB8gIhAuT8WW0lju6guux+zYqz4Hq3cqHySKluKoU+fri3XK5abI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770110; c=relaxed/simple;
	bh=SMT3xHBrSIRblYImAMh12G/OzNy6T39+exZcJ7Kc59g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=koiCRKWtVyLASdW/VkzJOwiDIAZyRayPjkI6kY+71/tvr9M4pfocdu1P9l/NyEUwq71zSrlAhX3NywUkULxbR8jC1jCJH8xRw82dgjUOyLgSD62D3cOAYr47Nm2HBKlPMVvzAtl88HauOfDJMr7VBPqRkncRAFllFT+V35sb8j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qL/kUERa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qL/kUERa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C9AC4AF14;
	Tue, 27 Aug 2024 14:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770110;
	bh=SMT3xHBrSIRblYImAMh12G/OzNy6T39+exZcJ7Kc59g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qL/kUERan9zFVb3QrWH6YbUGnylKMT12p+YQToRB9WO9uRDRjro2xYmnmG5umZhL4
	 0rqHdklwUJEH5AIbghOcZcCSzH3Ghh+jUz31Y1YI63Q1DqSDffzbbMB7jNwmyeDlkp
	 MaWx7kpqPaciO2HjbeiL9c4TwHIFNhZfj+UXrnL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <dg573847474@gmail.com>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 131/341] IB/hfi1: Fix potential deadlock on &irq_src_lock and &dd->uctxt_lock
Date: Tue, 27 Aug 2024 16:36:02 +0200
Message-ID: <20240827143848.402150006@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengfeng Ye <dg573847474@gmail.com>

[ Upstream commit 2f19c4b8395ccb6eb25ccafee883c8cfbe3fc193 ]

handle_receive_interrupt_napi_sp() running inside interrupt handler
could introduce inverse lock ordering between &dd->irq_src_lock
and &dd->uctxt_lock, if read_mod_write() is preempted by the isr.

          [CPU0]                                        |          [CPU1]
hfi1_ipoib_dev_open()                                   |
--> hfi1_netdev_enable_queues()                         |
--> enable_queues(rx)                                   |
--> hfi1_rcvctrl()                                      |
--> set_intr_bits()                                     |
--> read_mod_write()                                    |
--> spin_lock(&dd->irq_src_lock)                        |
                                                        | hfi1_poll()
                                                        | --> poll_next()
                                                        | --> spin_lock_irq(&dd->uctxt_lock)
                                                        |
                                                        | --> hfi1_rcvctrl()
                                                        | --> set_intr_bits()
                                                        | --> read_mod_write()
                                                        | --> spin_lock(&dd->irq_src_lock)
<interrupt>                                             |
   --> handle_receive_interrupt_napi_sp()               |
   --> set_all_fastpath()                               |
   --> hfi1_rcd_get_by_index()                          |
   --> spin_lock_irqsave(&dd->uctxt_lock)               |

This flaw was found by an experimental static analysis tool I am
developing for irq-related deadlock.

To prevent the potential deadlock, the patch use spin_lock_irqsave()
on &dd->irq_src_lock inside read_mod_write() to prevent the possible
deadlock scenario.

Signed-off-by: Chengfeng Ye <dg573847474@gmail.com>
Link: https://lore.kernel.org/r/20230926101116.2797-1-dg573847474@gmail.com
Acked-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/chip.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 0814291a04120..9b542f7c6c115 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -13185,15 +13185,16 @@ static void read_mod_write(struct hfi1_devdata *dd, u16 src, u64 bits,
 {
 	u64 reg;
 	u16 idx = src / BITS_PER_REGISTER;
+	unsigned long flags;
 
-	spin_lock(&dd->irq_src_lock);
+	spin_lock_irqsave(&dd->irq_src_lock, flags);
 	reg = read_csr(dd, CCE_INT_MASK + (8 * idx));
 	if (set)
 		reg |= bits;
 	else
 		reg &= ~bits;
 	write_csr(dd, CCE_INT_MASK + (8 * idx), reg);
-	spin_unlock(&dd->irq_src_lock);
+	spin_unlock_irqrestore(&dd->irq_src_lock, flags);
 }
 
 /**
-- 
2.43.0



