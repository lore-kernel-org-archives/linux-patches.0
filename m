Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2DE1F3D56;
	Tue, 21 Jul 2026 17:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654093; cv=none; b=oiuScuqc6x7LTRZT4oitnDBlN/zxFJd7QkoW0U2MOymZQzFetp7W8ODOgM6p3RueBeTTtdpqLDy+37/1P9VLmvH8x2zJpeTjfcuEUtjMFmOMlxN3rHUuTKzYWhDHqMqS2/wEQZ71jzcRq0euautMwI6ZGM3yyPPBv4ByP8X5bDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654093; c=relaxed/simple;
	bh=biAZEN44KVSCoQpUT9nioR3ecwqcrnDCt/V4E1lV4qw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f+uyxYuhir/E9vv1ifBKtMnXDbeARN5F4NRF81XLLxXPhxdAhJbJOPSncgPwEvc5wXUGY7AE8+2Pg/A92tEK+JDKBR/qTIYSYqFL5mgi9IsivYG5azvMOCXem0nPFrCM71UNnmjlP6M/8X6G/B93JWFxbuRJACExT7Pn6XLd3nI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wNYycolJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wNYycolJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 944891F000E9;
	Tue, 21 Jul 2026 17:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654092;
	bh=gsrvAevDMgIP5/btLWc6PIuyOAf0OUaATT2eFJueygE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wNYycolJcmiuQsdmOGcINbDAoct4yaU6n5hqsHB7Z7NbhO2vJvaKtEGU3SlKDy3E2
	 rn8HR9L9t++M3ZcWjYqhEQN43Q3FCzyxcA+F87pMmztEeB7L+jWrc4M2IharJTWZzZ
	 d1t7OUxy4AbTDZJtTZfQk8hW3SL1b6mgvrIylf0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	leixiang <leixiang@kylinos.cn>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.1 1567/2077] KVM: x86: Nullify irqfd->producer if updating IRTE for bypass fails
Date: Tue, 21 Jul 2026 17:20:40 +0200
Message-ID: <20260721152629.740759208@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: leixiang <leixiang@kylinos.cn>

commit ed446e8aa894883c08892cfee69782fdf8f6c3ca upstream.

Nullify irqfd->producer if updating the IRTE for bypass fails, as leaving a
dangling pointer will result in a use-after-free if the irqfd is reachable
through KVM's routing, but the producer is freed separately.  E.g. for VFIO
PCI, the producer is embedded in struct "vfio_pci_irq_ctx" and freed when
the vector is disabled, which can happen independent of routing updates.

Fixes: 77e1b8332d1d ("KVM: x86: Decouple device assignment from IRQ bypass")
Cc: stable@vger.kernel.org
Signed-off-by: leixiang <leixiang@kylinos.cn>
Link: https://patch.msgid.link/1782119051448443.14545.seg@mailgw.kylinos.cn
[sean: drop PPC change, massage changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/irq.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -488,8 +488,10 @@ int kvm_arch_irq_bypass_add_producer(str
 
 	if (irqfd->irq_entry.type == KVM_IRQ_ROUTING_MSI) {
 		ret = kvm_pi_update_irte(irqfd, &irqfd->irq_entry);
-		if (ret)
+		if (ret) {
 			kvm->arch.nr_possible_bypass_irqs--;
+			irqfd->producer = NULL;
+		}
 	}
 	spin_unlock_irq(&kvm->irqfds.lock);
 


