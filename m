Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD3E38399A;
	Tue, 21 Jul 2026 17:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654069; cv=none; b=PTG+/9QKmmm2eQf/Z9mi8kk5FjMp5JhES6Lu1qFBa3tzp8tuLb6VfH05eSCdpcuk1YzaTsU6xTg7juwqlu6TJasHuG+hKy+CfA8SWvc+IqlLZcLPRso9ngNynH3m6o5nsM4szUSHwHvmW5j+1rMpleYU/dP2+NL8O2po4eQzaDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654069; c=relaxed/simple;
	bh=Wv6JrHJ1TbQ2B/Vt4GMk1BZCEmX/tDdylK0GZrV++7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tLQRiaUCyyaThR5MXGCUBDCbhC5xTvzjGeFXRtC1Wf+WW7mi7jUFi+8B0T46cI03QI9KHw+HyWsUKQnao1S7srilXUmKhHh1+lm3L8MroQ5egK1VG/rtt28+wodDOmxBMzPN3FGNpMP2TJvxf7Hlm4nI194RAS0dACT1yJnljIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kmrc/AkP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kmrc/AkP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A235D1F000E9;
	Tue, 21 Jul 2026 17:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654068;
	bh=c7PWxh0zyY41uDf1xXa670eWlgJae+eecHpBlM7c6iE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kmrc/AkPO/2kbh4/A47+ELlK3pwpIx+b+mnYOBrFS7KJfj4IQX0JC8LQSHZhBcxwq
	 xP0I1Iir1TMz5l1sNTjh0BObJa982p3K9PuQw8fFO0qqnz35lbF34WzHWJIeRWSR2A
	 AOj2Il58Rv2eCnI7pmayKOfwincPFRr+TlKYGRGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhan Ali <alifm@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 7.1 1563/2077] KVM: s390: pci: Fix handling of AIF enable without AISB
Date: Tue, 21 Jul 2026 17:20:36 +0200
Message-ID: <20260721152629.646084348@linuxfoundation.org>
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

From: Matthew Rosato <mjrosato@linux.ibm.com>

commit 3e3aa6da87d30a0064a17b836685cd43c90a3572 upstream.

When a guest seeks to register IRQs without a summary bit specified,
ensure that the associated GAITE then stores 0 for the guest AISB
location instead of virt_to_phys(page_address(NULL)).

Fixes: 3c5a1b6f0a18 ("KVM: s390: pci: provide routines for enabling/disabling interrupt forwarding")
Cc: stable@vger.kernel.org
Reviewed-by: Farhan Ali <alifm@linux.ibm.com>
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kvm/pci.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/arch/s390/kvm/pci.c
+++ b/arch/s390/kvm/pci.c
@@ -300,9 +300,14 @@ static int kvm_s390_pci_aif_enable(struc
 
 	gaite->gisc = fib->fmt0.isc;
 	gaite->count++;
-	gaite->aisbo = fib->fmt0.aisbo;
-	gaite->aisb = virt_to_phys(page_address(aisb_page) + (fib->fmt0.aisb &
-							      ~PAGE_MASK));
+	if (fib->fmt0.sum == 1) {
+		gaite->aisbo = fib->fmt0.aisbo;
+		gaite->aisb = virt_to_phys(page_address(aisb_page) +
+					   (fib->fmt0.aisb & ~PAGE_MASK));
+	} else {
+		gaite->aisbo = 0;
+		gaite->aisb = 0;
+	}
 	aift->kzdev[zdev->aisb] = zdev->kzdev;
 	spin_unlock_irq(&aift->gait_lock);
 


