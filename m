Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4F91F4275;
	Tue, 21 Jan 2025 18:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482703; cv=none; b=EjxYtjdgkD4gSfSvwG2vcrN2hPtVImN1mZdiE0skfiXY5omWQ2GH8iDhf004sUmXAY4MzJxHh0WEk1VmXNz4A95VJWIrFoIfBmbaMcbNeWXDTFtC4p8KjJg6UIBTMN1/QTJjWxdSzDYyO0lB6qLLrzI2XgGLZrIVuTVlQnqWhCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482703; c=relaxed/simple;
	bh=WPtl9qLesxiNmG3LXvmt3m81cHPKaiHfFJJ2Y5x5Xs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SBGLSm7YfGOoa2bZbTF3oYUbJ7OnuxsyEn+NTlwyNh7Jhj1hJ27E/mI6Do7EzV+rCcz8ZYcuhLZhVZQtoLeQcIciikIDjdO96uGITJW4cmOAAb9EpUmbAiDbaXxQWU2nsVJmAonq+1FYwHRT7a7yB4EBUN96V3IfidnMq9q7vxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TxLhllJs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TxLhllJs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42762C4CEDF;
	Tue, 21 Jan 2025 18:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482703;
	bh=WPtl9qLesxiNmG3LXvmt3m81cHPKaiHfFJJ2Y5x5Xs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TxLhllJsuKUnWgXRViI8Qn4dAC31aS+rEBKSkI4wyrAojpHIMfnuA+fjHJgjaYu9z
	 Ayg9iO2C0wzThtzURYSZF//YIsrOR6n0MMl9O3VEWr9IrQfMhk6X2OJ3CDKSoEWVx8
	 wA14r2oy9G0I+hCAjxjushn4SNE5uUnyId3FVnSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Krcka <krckatom@amazon.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.1 45/64] irqchip/gic-v3-its: Dont enable interrupts in its_irq_set_vcpu_affinity()
Date: Tue, 21 Jan 2025 18:52:44 +0100
Message-ID: <20250121174523.272309618@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174521.568417761@linuxfoundation.org>
References: <20250121174521.568417761@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1967,7 +1967,7 @@ static int its_irq_set_vcpu_affinity(str
 	if (!is_v4(its_dev->its))
 		return -EINVAL;
 
-	guard(raw_spinlock_irq)(&its_dev->event_map.vlpi_lock);
+	guard(raw_spinlock)(&its_dev->event_map.vlpi_lock);
 
 	/* Unmap request? */
 	if (!info)


