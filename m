Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57880306744;
	Fri,  7 Aug 2026 15:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115180; cv=none; b=GXwzbwckwn1gsiQTMBpzbQEKrxhLn0156Rl2booWsJuJ1oGIhuCMkn6/JhYNu0QEHRZhfwtlw71eDI5eh0v3o2ztVCkT1j3c9MDa9N3uhiMlxPrc6RuubWMB7w7wRwf4kqAsk0xsG7UGWqaUipAcXPY1pQ/os+6CJdNHkUlXxSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115180; c=relaxed/simple;
	bh=ukUZEwEnFnU4qvrFcfEsmxpd2chZTgWa4XrfKqQoCPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gt7dccR4QRzC/0H8aIyKj/9+AE571lqKgx+qNPP6CUiPgRcKa1mzpxVSkNkMAdrazHqpZHC2TOATIPVTe1Zz1cApYAH8PaE0nh9/r4rmpSr1spa5RxX3UFA8w2QY6flJXuP1VqPnkM1PDhuxf74aAIBwfAx1QNVi+m6TIUZDaQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MBSqd5fz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MBSqd5fz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BFFE1F00ADE;
	Fri,  7 Aug 2026 15:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115177;
	bh=U7hOPgKalxgAWQb/qq6B1UOaeTd8H+W6cKXG1x5ihSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MBSqd5fzSWx4wyfp6UURg+MIV3trt+ifnd3vUgI46fKbYdaNyEtL9bMqL6RqaPzLr
	 rRnNBst2kOC6bKupqdAmM++PoAeoU+3HvyRXqbgW9w87TFogO44pUTgw8djYV/BC1D
	 HLAUC8p9DeWQorsu0+lDQutC8p5uAixMRAg1FetM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Farhan Ali <alifm@linux.ibm.com>
Subject: [PATCH 6.18 183/396] KVM: s390: pci: Fix NULL dereference on AIBV allocation failure
Date: Fri,  7 Aug 2026 16:35:43 +0200
Message-ID: <20260807143428.239433497@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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
@@ -318,6 +318,11 @@ static int kvm_s390_pci_aif_enable(struc
 				    AIRQ_IV_GUESTVEC,
 				    phys_to_virt(fib->fmt0.aibv));
 
+	if (!zdev->aibv) {
+		rc = -ENOMEM;
+		goto free_aisb;
+	}
+
 	spin_lock_irq(&aift->gait_lock);
 	gaite = aift->gait + zdev->aisb;
 
@@ -354,6 +359,9 @@ static int kvm_s390_pci_aif_enable(struc
 	rc = kvm_zpci_set_airq(zdev);
 	return rc;
 
+free_aisb:
+	airq_iv_free_bit(aift->sbv, zdev->aisb);
+	zdev->aisb = 0;
 unlock:
 	if (pcount > 0)
 		unaccount_mem(zdev->kzdev, pcount);


