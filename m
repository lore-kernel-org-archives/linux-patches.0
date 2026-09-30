Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28EC3CFF66;
	Wed, 30 Sep 2026 19:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795672; cv=none; b=Kw9BzJgI8zStGCSx6N5IYXv432bHk5BlFHpSu7xSk0jpIT1rLyBGq/NfwzetAi+IzwT4YxBAxkNXubFXnKS0QM2GuPhur6tLU5CS9mt0K5g5gAVCP1sGfO7KoaZm1Nu9a1G8ueTyxp23kuFTLQ148PkHW//7QbQe2Dcid/dfQcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795672; c=relaxed/simple;
	bh=gz3ajJP2L0Y8gev54mJ1LJan9sRaTK8CgpKl7hPWN1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AFCeGnO1ysVtwGKOfzQxmoEParMD/NwPgHVGM9FtTUQy2RC9NfwvYUTglmK9y85q8Pj7vWcOphCNlIc+US/K0qAhjSN9xSFBluHrIB6/WdSBR0okI9Ivb6MpO7I8m6soCWEd3rfllFoKCEgQCt7Ouxhle5DtFMu7gJArVvDqGkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CKBviVqS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CKBviVqS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10F361F000FF;
	Wed, 30 Sep 2026 19:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795671;
	bh=h5PBLdyIzVUVUmVb2ofogszytzF2jwxD5CcOZYknqxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CKBviVqSIln02jp3/aITKfwaG7Qr7JEM2NIjCdJ4eGyS9pMN488sL0W04CWJ+LTC1
	 kiMVkQ83caDouFSkj7+blFFY+b7A4sW6NSrz7oo4JpbUyduhKXLE7ngyzzCXk54P01
	 lZRuI20KrYbRQPFma2alYNKmg/ryZX9ceLWULFs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	leixiang <leixiang@kylinos.cn>,
	Amit Machhiwal <amachhiw@linux.ibm.com>,
	Vaibhav Jain <vaibhav@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.6 0642/1193] KVM: PPC: Book3S HV: Set irqfd->producer only on success
Date: Wed, 30 Sep 2026 17:22:06 +0200
Message-ID: <20260930152448.509599946@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5790,12 +5790,12 @@ static int kvmppc_irq_bypass_add_produce
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


