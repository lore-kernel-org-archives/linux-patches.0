Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F0854F96;
	Thu, 30 Nov 2023 16:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lrnGekIq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D72FC433C8;
	Thu, 30 Nov 2023 16:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701362029;
	bh=p2oQLXMWab32OW/2e2S3krIwSAIdXTr9X/s3enOzUac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lrnGekIqf53ttLNvx/1Ka1ikXN/nz13+BdIdbJvI4BUb0djiSoXwneBm0ZELQaoTe
	 Xy+1h+9pjm/BNmt+xcmuBn4M37SJyAjzkK3AgdLyNmlyRpRr4pm+ZmCuuYgpC0Ft31
	 NQW51wxibEt3RwQjPjvzV28KoxE3XbkeF0NocI7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawel Laszczak <pawell@cadence.com>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 5.15 59/69] usb: cdnsp: Fix deadlock issue during using NCM gadget
Date: Thu, 30 Nov 2023 16:22:56 +0000
Message-ID: <20231130162134.998237060@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162133.035359406@linuxfoundation.org>
References: <20231130162133.035359406@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawel Laszczak <pawell@cadence.com>

commit 58f2fcb3a845fcbbad2f3196bb37d744e0506250 upstream.

The interrupt service routine registered for the gadget is a primary
handler which mask the interrupt source and a threaded handler which
handles the source of the interrupt. Since the threaded handler is
voluntary threaded, the IRQ-core does not disable bottom halves before
invoke the handler like it does for the forced-threaded handler.

Due to changes in networking it became visible that a network gadget's
completions handler may schedule a softirq which remains unprocessed.
The gadget's completion handler is usually invoked either in hard-IRQ or
soft-IRQ context. In this context it is enough to just raise the softirq
because the softirq itself will be handled once that context is left.
In the case of the voluntary threaded handler, there is nothing that
will process pending softirqs. Which means it remain queued until
another random interrupt (on this CPU) fires and handles it on its exit
path or another thread locks and unlocks a lock with the bh suffix.
Worst case is that the CPU goes idle and the NOHZ complains about
unhandled softirqs.

Disable bottom halves before acquiring the lock (and disabling
interrupts) and enable them after dropping the lock. This ensures that
any pending softirqs will handled right away.

cc: stable@vger.kernel.org
Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://lore.kernel.org/r/20231108093125.224963-1-pawell@cadence.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdnsp-ring.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/cdns3/cdnsp-ring.c
+++ b/drivers/usb/cdns3/cdnsp-ring.c
@@ -1522,6 +1522,7 @@ irqreturn_t cdnsp_thread_irq_handler(int
 	unsigned long flags;
 	int counter = 0;
 
+	local_bh_disable();
 	spin_lock_irqsave(&pdev->lock, flags);
 
 	if (pdev->cdnsp_state & (CDNSP_STATE_HALTED | CDNSP_STATE_DYING)) {
@@ -1534,6 +1535,7 @@ irqreturn_t cdnsp_thread_irq_handler(int
 			cdnsp_died(pdev);
 
 		spin_unlock_irqrestore(&pdev->lock, flags);
+		local_bh_enable();
 		return IRQ_HANDLED;
 	}
 
@@ -1550,6 +1552,7 @@ irqreturn_t cdnsp_thread_irq_handler(int
 	cdnsp_update_erst_dequeue(pdev, event_ring_deq, 1);
 
 	spin_unlock_irqrestore(&pdev->lock, flags);
+	local_bh_enable();
 
 	return IRQ_HANDLED;
 }


