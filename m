Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C606D38839E;
	Tue, 21 Jul 2026 20:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667023; cv=none; b=T46Y+0r0KLcVmycgC5lereA49c9ShFTz8xCAWqXn9j7anFj19bR5kZOC7FIvr7BNOzRgyC7vu11sTB6yYV/N+Bq2tIJqXw1PiH7YewztUbx5RBS1VZcAWYmgbovLQSZYICHmie8j/wHv0Vty9X50+Vr6J0EAb2k9yPaxqk0tXaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667023; c=relaxed/simple;
	bh=5opkV1vHE3G2lb2URGie1mA8jZuwBY325z04Dt3ryUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HvOF2ZtJkD3uPY05UZNauu9V32nQ6EsEgOafUpH/YZzTi7ACzOtr6ig+RdrOtHaih9scwKlr0Qu0yCGwp4V1ZmhHQr2MpGYnKSQEhb4saBgAPd2jLAawgzcPwYy6TVYZDL2UTYoPxfkTC6FXOVYwckHY7+9dcsG8FfpQMmZcZMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PBYObjZV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PBYObjZV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37BB61F000E9;
	Tue, 21 Jul 2026 20:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667022;
	bh=Tee7Iw/Q7Lh8UyVzs7kpKRkU5lC2wdIWWRef1BznEz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PBYObjZVEYO88V3vM08NhyJOQ3IURZpvQ5+kkKMH2LrC3kfZFJH/NMQGCVqMWLk1B
	 6N1vD5Ms7MBgUgHqEJ9PA5PVXJmBg2JHFiiKVR3fmUoMiuu7asl0sLMYpbLTU+oesa
	 7eMhUUDRG6jI9TMSItebIXCJ0oUcdMHKC7GldZSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhan Ali <alifm@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 6.6 0903/1266] KVM: s390: pci: Fix handling of AIF enable without AISB
Date: Tue, 21 Jul 2026 17:22:20 +0200
Message-ID: <20260721152502.051752446@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
@@ -302,9 +302,14 @@ static int kvm_s390_pci_aif_enable(struc
 
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
 


