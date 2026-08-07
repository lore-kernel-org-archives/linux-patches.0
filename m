Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A283AAF54;
	Fri,  7 Aug 2026 15:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117195; cv=none; b=serHPhUW+vL3hrmk033Bow6jwOj911fE4pwZVHit5vnFRi/ufDfC2uKoh4UIITfSd/YresXigo+xyvzSatCbKYGnT5KkGnPkcCJwEJir1MUwDPZjss3siZX2wMEYEUynjwT97/DHt7s5ZlzModKNzG42VuaGp5/j5G2y+fLBAyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117195; c=relaxed/simple;
	bh=2S5aK2T+6hFhKXqQhUXU65jY8fVclngYcrqYnS4IpVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KR+n8IfOldfxBWZWmUXFsHFoIePZHyzMuI3h4tICLvROF/HtTj/FreWUe4tqPh4z1dj1JIgUKd5VpCeNNHwbHcOIFPg0FpWF6pVhhYseYirOrtrp3YToDWC6Ew2Q8NZ0Zbzjit+NkpBHS2SOOB9JgJ+i69OUWm4nARxlpAkcjsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mnULwq5C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mnULwq5C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7796F1F000E9;
	Fri,  7 Aug 2026 15:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117194;
	bh=nYL4M5R4pUVydx9/8Io4tscNFOiFUvD1fT2Tn7vW3DA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mnULwq5CtNV7AIZ6pMcOoxU/emYAQ38oxAmSFjE42TykbfZafLbxWILexKH2a/DMQ
	 SCqhV+4aEZ3A+GH1z4XjE5e4u89feSIcYgX7UEV9arAzt41WQrwAyIT9Ot+/gqbe9z
	 rnsSkNUjBkXBUAkq2mgzRZgztCagUcx+n1RM/HHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Farhan Ali <alifm@linux.ibm.com>
Subject: [PATCH 7.1 233/438] KVM: s390: pci: Fix NULL dereference on AIBV allocation failure
Date: Fri,  7 Aug 2026 16:37:09 +0200
Message-ID: <20260807143432.972293396@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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
@@ -317,6 +317,11 @@ static int kvm_s390_pci_aif_enable(struc
 				    AIRQ_IV_GUESTVEC,
 				    phys_to_virt(fib->fmt0.aibv));
 
+	if (!zdev->aibv) {
+		rc = -ENOMEM;
+		goto free_aisb;
+	}
+
 	spin_lock_irq(&aift->gait_lock);
 	gaite = aift->gait + zdev->aisb;
 
@@ -366,6 +371,9 @@ static int kvm_s390_pci_aif_enable(struc
 	airq_iv_release(zdev->aibv);
 	zdev->aibv = NULL;
 
+free_aisb:
+	airq_iv_free_bit(aift->sbv, zdev->aisb);
+	zdev->aisb = 0;
 unlock:
 	if (pcount > 0)
 		unaccount_mem(zdev->kzdev, pcount);


