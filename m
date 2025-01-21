Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02CA01F667C;
	Tue, 21 Jan 2025 17:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482225; cv=none; b=CCXNwM0hpxoZsIuc0+C2KIgnASvyoD1pNl7bAyvLEnrGvzqP/8D9bhhm/eRs7Ef+axGff23Ac2p4U+icTF/2IK8pFPfGD9lhRGUHFBZgiQl2xGLXbg/sv4B59JW1DoVfPGw3Ilu2mojuXw+5PUwvW5JEN5ZJmDwR8x/znKKipfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482225; c=relaxed/simple;
	bh=vJ2WiCiCtFuRWDjJsKeNTr6GEwjmH+qfTsCq0cXi2h8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n+GhdZZPUG7jrgnFM7kQqW16yf5sDPqzLgjv5Q2pvqWgURL2NtK4f37TYU2VtwDeFFfmMr/1x8tCU/s0zkPvLu7LZn+Knw6wSdYv5VxXyY43hWBv0Jd6akzXQ0GAg7dfpF7K5Vyfi9xBT07YWUhrYWLIlweBx7Mv7PIxahhqB98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1fWy4csg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1fWy4csg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80122C4CEDF;
	Tue, 21 Jan 2025 17:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482224;
	bh=vJ2WiCiCtFuRWDjJsKeNTr6GEwjmH+qfTsCq0cXi2h8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1fWy4csgBls67D5bOArWynCNLkoRDPOurR5jYt6sPVKQ7VXQygXf9MPVNdBcmKWWk
	 mRs8YXrqjttKdw1coRqREbj/8cwBRIkKIkW9z16L6GJIdY7zb9PTJXO6c4iUNomvwl
	 phNEZX5EIO/S6PbjPnJIFk0j2LZ9hj1c9q092TJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Krcka <krckatom@amazon.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.6 57/72] irqchip/gic-v3-its: Dont enable interrupts in its_irq_set_vcpu_affinity()
Date: Tue, 21 Jan 2025 18:52:23 +0100
Message-ID: <20250121174525.632955994@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174523.429119852@linuxfoundation.org>
References: <20250121174523.429119852@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1970,7 +1970,7 @@ static int its_irq_set_vcpu_affinity(str
 	if (!is_v4(its_dev->its))
 		return -EINVAL;
 
-	guard(raw_spinlock_irq)(&its_dev->event_map.vlpi_lock);
+	guard(raw_spinlock)(&its_dev->event_map.vlpi_lock);
 
 	/* Unmap request? */
 	if (!info)


