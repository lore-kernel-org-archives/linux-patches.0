Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2125F3CAE99;
	Thu, 17 Sep 2026 17:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666442; cv=none; b=Nl/2+gC6aAOSNoDPnajWVijtdQnq4UJCdQno+xiFgV+3TIy8Rp4P9xkmXSMVoB2xa20ufD13sY3uZTnba8om1CDaht0PoZgjzUZ2Boiw0CVEmBdBtBJki+jGiN4OfGwiyUYmnnejQck/pfgC3L2g2G8CThTRS1th4Y/gRndKsmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666442; c=relaxed/simple;
	bh=42yC6Eziqvnbcnet8+RKg1y4k3Hj6cceL24CtMv0vQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vA2aaz2RNdI53nFLOAofJuLQwTBix3+gW0Pm391S+sy4rUPlcYcDTTjc7YyQOXK95ho4S6UJMh/8fvJq2byHAeBX9hwA46cx+ZapWpgAIDoVeyI3dhCD5K+XcSiGDUvhNWa8Nj1RUIm7SNBQNsSRPuGy7BRRhPnH2FroPU/L7Do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gQZtXnTn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gQZtXnTn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A091F00893;
	Thu, 17 Sep 2026 17:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666441;
	bh=hHtG/abmciHDu1PUyyLkGJ7LD0KlSwat3g9csiuaIN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gQZtXnTnhqeCttgaLrN8ZbZ/id2raUb7I8LZ2VyQMquAewSaDm/SaV8RmDbesWEtb
	 JFoFlYmVqDhIc9ooaUq49UdBUCnmmrtboSXTucjfibkJxtsw+CwENqwnjfvK1MxoC0
	 iMnFnvqJ7hGh2tgd3P6glIFoy5eODkp/bsq2E1RQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	leixiang <leixiang@kylinos.cn>,
	Amit Machhiwal <amachhiw@linux.ibm.com>,
	Vaibhav Jain <vaibhav@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.18 1039/1250] KVM: PPC: Book3S HV: Set irqfd->producer only on success
Date: Thu, 17 Sep 2026 16:13:54 +0100
Message-ID: <20260917151620.237845509@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6125,12 +6125,12 @@ static int kvmppc_irq_bypass_add_produce
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


