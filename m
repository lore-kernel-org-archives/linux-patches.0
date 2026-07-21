Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8AD8439336;
	Tue, 21 Jul 2026 21:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669893; cv=none; b=EXcFDTepPaxs8yoNpdM04PH3aJ/wheCUHZSEZDQIkJbQlhHIU7Iqst4gvJwxA7bfv7bI6oscVqXOUhOvLX+bEgftl6eq38VN++yg1BQtpK8YiHVHHhGd2jvQorLdbjb6NY2JBDKBRaFvWVYnTFW9mUN9RJvkM+lPonVcvccCLdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669893; c=relaxed/simple;
	bh=hz5AHbONJ1ZKJ2aeufdd45RFkvB3Ef78X7GiX5arBBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OfDJWmHjk4Ata2XTP1GJfrk3c+q19Jhrqkhh6cwkrO6Nd2KwNkN3gIb/SfMpzyd6PoIZIu65FvNU3KvJuYC8GIX8c4aOsmIgxwe9yKfQSkfK0a9UlS1Y5ciDxLlZH+gwD+/4WkziyLbRBRmn8ocRI6SxtjS3RxckMmd3uTF2kTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h/rxcoSf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h/rxcoSf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 205DC1F00A3A;
	Tue, 21 Jul 2026 21:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669891;
	bh=4rb8EBDQPGHnn5Zy0wDbd+e/2np3jRTcBXkn1+RM9Bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h/rxcoSfgpPE4nfvDQZVfv1pXU1z17MRW4XkbNZAwZ54LRhtVNTtI6fw/CBtztaw/
	 TI1gjAhdtsr3XcVxcm0wicB85SDJ/J8+aSQ3oh02sm9OEVhK4LAl7PXD9a6Z74Er76
	 JnDFlAHu54E5b6LNhOBCi+Gu3mDsE9xId9YzcbXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhan Ali <alifm@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 6.1 0726/1067] KVM: s390: pci: Fix handling of AIF enable without AISB
Date: Tue, 21 Jul 2026 17:22:07 +0200
Message-ID: <20260721152440.829577044@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


