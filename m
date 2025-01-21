Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE94E571;
	Tue, 21 Jan 2025 18:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482519; cv=none; b=LEubbVCQU5o8AB+kRz/ZN03a2UfisjCgo8c+jXkNffLEVx7HtSMaHyp9bNdn7sn2+w88EdDiIXwBmJ0ZN5R6Oh7QfYstdzsMW5ynqtpFrfYLk2abdD3BZIaduqMLSK0yAdA3ASotUNQAQzYGdq34uqEEeIO0qJxXZclaRt8YNM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482519; c=relaxed/simple;
	bh=pi65KeYSigxJKd68xXc1nA6gragK6Bsw6+IUx7Fd22c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bR9J4/LLI20SrXnGotE9mBLN2XvtFKMX38LRrmg+qZp6FCA9w8LYBq/ots54NHTenj5os4ngYTkCQWAD6m1a85U1jynRfj05vTm7kdvRPNRTvZ+eLllCIfMju0ml7vAK3MPw+h2bCB0BJLTRbwSW1/aR6/NsLtaSmqxkYDUJG+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X6jpQ8Wt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X6jpQ8Wt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F50C4CEDF;
	Tue, 21 Jan 2025 18:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482519;
	bh=pi65KeYSigxJKd68xXc1nA6gragK6Bsw6+IUx7Fd22c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X6jpQ8WtBcN0tfKoZoo64LXkpY5D9m9NSfLFKjjycnItHdXH8iFD6ZF9gZVwKQfku
	 28TZzeT/SlypPp8Gd7B5FOsMUAo4IXmuX/GQpi717VIGl506NUse55B5+em1rdQoy+
	 QOkhhq+kXmMbwzlfgMRzVs5E97nIfm9gTmrl2S84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Krcka <krckatom@amazon.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.12 105/122] irqchip/gic-v3-its: Dont enable interrupts in its_irq_set_vcpu_affinity()
Date: Tue, 21 Jan 2025 18:52:33 +0100
Message-ID: <20250121174537.088293653@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Krcka <krckatom@amazon.de>

commit 35cb2c6ce7da545f3b5cb1e6473ad7c3a6f08310 upstream.

The following call-chain leads to enabling interrupts in a nested interrupt
disabled section:

irq_set_vcpu_affinity()
  irq_get_desc_lock()
     raw_spin_lock_irqsave()   <--- Disable interrupts
  its_irq_set_vcpu_affinity()
     guard(raw_spinlock_irq)   <--- Enables interrupts when leaving the guard()
  irq_put_desc_unlock()        <--- Warns because interrupts are enabled

This was broken in commit b97e8a2f7130, which replaced the original
raw_spin_[un]lock() pair with guard(raw_spinlock_irq).

Fix the issue by using guard(raw_spinlock).

[ tglx: Massaged change log ]

Fixes: b97e8a2f7130 ("irqchip/gic-v3-its: Fix potential race condition in its_vlpi_prop_update()")
Signed-off-by: Tomas Krcka <krckatom@amazon.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20241230150825.62894-1-krckatom@amazon.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-gic-v3-its.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -1961,7 +1961,7 @@ static int its_irq_set_vcpu_affinity(str
 	if (!is_v4(its_dev->its))
 		return -EINVAL;
 
-	guard(raw_spinlock_irq)(&its_dev->event_map.vlpi_lock);
+	guard(raw_spinlock)(&its_dev->event_map.vlpi_lock);
 
 	/* Unmap request? */
 	if (!info)


