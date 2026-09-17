Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32090390230;
	Thu, 17 Sep 2026 15:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660379; cv=none; b=ViPurmvHHHm14iMl3mLjnbNCe55RxXPUt9AR9OoBVTzZpUQPYL9n4MD9q6aGh9B44R6wHmGZ7DgTxnGzMzaKCSD1v+QLN8LO+FsiRzFrUQOdIefjfInhvULt+SXY6COr1Xz4JGm+jzq4OOuIcLXbNQKV8UXkVTnROm6vS08XrsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660379; c=relaxed/simple;
	bh=pBO1rBTV+zuTJF5PLl2oJ9MCM7onsJWMLzlDnFibwu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pH9X72+kvSBpDZsC02wd+k/Z1K4kBmziVCZanOq7lIX3rgvml23oShDmvRY1K4gbllb7w6/f0pGg7/sLWLGhE8DcJ4Sio73Ol5Dr0+HGAaNujGIUAGcNAxGKxXTPdpK3GrkFRDCcEnzgM4CVprcN2An4b5CjOKmnkS8bnhswcvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QMEL3Gu2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QMEL3Gu2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86ACC1F000FF;
	Thu, 17 Sep 2026 15:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660378;
	bh=Zqwy2B1KxIMOfgAhjZaEDA/Qazr9u76yyDYmUiHaUD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QMEL3Gu2PsCvSdVpBIdN5phapCgK8QSBa0R1qhoDnzTtm/KsSaz+VVCylmnGw0Hjd
	 bdmwXUaQAhfDQL4TetKOb3gJdk3S1y0q+3/PvVCNXQOyabBV3mXU0cCbclbIZtaxoV
	 mSKUCl1+LWw0+7awot4e4JX4lyOSAlHRGsOxoC7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	leixiang <leixiang@kylinos.cn>,
	Amit Machhiwal <amachhiw@linux.ibm.com>,
	Vaibhav Jain <vaibhav@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 7.2 571/733] KVM: PPC: Book3S HV: Set irqfd->producer only on success
Date: Thu, 17 Sep 2026 16:14:39 +0100
Message-ID: <20260917151406.580642069@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: leixiang <leixiang@kylinos.cn>

commit 1144454ea22290d7c6998a2af6239e5995476afc upstream.

Set irqfd->producer only after kvmppc_set_passthru_irq() succeeds to
avoid leaving a dangling pointer on failure. The bypass manager does
not register a failed producer, so the pointer is never cleared.

Fixes: c57875f5f9be ("KVM: PPC: Book3S HV: Enable IRQ bypass")
Suggested-by: Sean Christopherson <seanjc@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: leixiang <leixiang@kylinos.cn>
Reviewed-by: Amit Machhiwal <amachhiw@linux.ibm.com>
Reviewed-by: Vaibhav Jain <vaibhav@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260709055755.31297-1-leixiang@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kvm/book3s_hv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -6124,12 +6124,12 @@ static int kvmppc_irq_bypass_add_produce
 	struct kvm_kernel_irqfd *irqfd =
 		container_of(cons, struct kvm_kernel_irqfd, consumer);
 
-	irqfd->producer = prod;
-
 	ret = kvmppc_set_passthru_irq(irqfd->kvm, prod->irq, irqfd->gsi);
 	if (ret)
 		pr_info("kvmppc_set_passthru_irq (irq %d, gsi %d) fails: %d\n",
 			prod->irq, irqfd->gsi, ret);
+	else
+		irqfd->producer = prod;
 
 	return ret;
 }


