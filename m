Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA14B33C1AD;
	Fri,  7 Aug 2026 14:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114094; cv=none; b=k2qrlvrAr+CX8U5qpXYs4/ztz6EDirp+ka9Pf9ioL6UMhlNge88EMfZjVmmVLl47hhBMwFfjrSiY3OOXOmIoQPWGnfuzQaCAdtgS1RIi2VbYfE5dp91UydqPIngIUqRg6JFs6wamo4mmMNFNg0gShJzYOO0mmN+ILQUrnFZ1QcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114094; c=relaxed/simple;
	bh=P01tsB8RPRiK1qs6R03uR4gtZfPWcaSvvcf0sKrhCjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EbiPisX3Qw1iPDFUvEa/3IYFuewDpTsS5pLidFO8wSWMSZ+RX/PrkqpVp1RZTvkZTkXHqPcx6MdXGVDRorudHoB5Q0WAP60ZAZjiTnE/DIIQMZjBnbtCF7ftAu4kJpUOGQS9JmcrlHnK3CmURTEsJKYN7/2UCAKYeWWWSf2ue+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aGxqPn31; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aGxqPn31"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 120BF1F000E9;
	Fri,  7 Aug 2026 14:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114093;
	bh=YtXstCFKvuM+m1Njj200MRW4p77wd7V1aoX+RtAjD54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aGxqPn318460ShWDySPZLWErDPGWF9T1WgvvxCoOeXoh9xDZjeUfjMmLdoaJ3fcl5
	 afX4RJu6Ay06eOivTTI+tuiUzD2918UQdW8EZM+ZNSCzRFYJY71M/lpqxnUZHt8ohM
	 xRBME/z6wL4q9+AtSHmE1VbkLZAeYuh9eqd57uFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Farhan Ali <alifm@linux.ibm.com>
Subject: [PATCH 6.12 142/337] KVM: s390: pci: Fix NULL dereference on AIBV allocation failure
Date: Fri,  7 Aug 2026 16:35:45 +0200
Message-ID: <20260807143421.614596991@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Farhan Ali <alifm@linux.ibm.com>

commit 8bf09b9b7d3232806df95f409581f8a9fd99a3fa upstream.

The airq_iv_create() can return NULL on failure, but the return value was
never checked. If it fails, zdev->aibv will be NULL and fail when
dereferenced in kvm_zpci_set_airq(). Add a NULL check and free the
previously allocated AISB bit and zdev->aisb on failure.

Fixes: 3c5a1b6f0a18 ("KVM: s390: pci: provide routines for enabling/disabling interrupt forwarding")
Cc: stable@vger.kernel.org
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kvm/pci.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/s390/kvm/pci.c
+++ b/arch/s390/kvm/pci.c
@@ -295,6 +295,11 @@ static int kvm_s390_pci_aif_enable(struc
 				    AIRQ_IV_GUESTVEC,
 				    phys_to_virt(fib->fmt0.aibv));
 
+	if (!zdev->aibv) {
+		rc = -ENOMEM;
+		goto free_aisb;
+	}
+
 	spin_lock_irq(&aift->gait_lock);
 	gaite = aift->gait + zdev->aisb;
 
@@ -331,6 +336,9 @@ static int kvm_s390_pci_aif_enable(struc
 	rc = kvm_zpci_set_airq(zdev);
 	return rc;
 
+free_aisb:
+	airq_iv_free_bit(aift->sbv, zdev->aisb);
+	zdev->aisb = 0;
 unlock:
 	mutex_unlock(&aift->aift_lock);
 unpin2:


