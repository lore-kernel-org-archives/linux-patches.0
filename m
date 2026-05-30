Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E782FDC5E;
	Sat, 30 May 2026 17:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162077; cv=none; b=C92ja0XmECITmJ2Nv/Y/uKnnDe5WiuTtlgApANszmMF+z/cOZrphsxIisIt2/s3h+yWBPwSxcDLcETvdOlUCtUNFRliZJaSy24BR+FQPO2ruBSha4RzwKGVFu8qMb4g/9tL9i3BHDN0wM8s3/MM7aKwgnQJGbB5ZeLf15zjQXHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162077; c=relaxed/simple;
	bh=cKTdGdIxUXsA0D8sI88/qSXZ4tYKMmvJWUEPf1TA0wk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VC1cb8MQN67U+tAEpFnmLm/JkHL15GqZmucgbp0jXbxQMbcrwRoQvQxkIkeNUG1z6ucoF5AZsqh/koBvBd+Es7IEum0+aScUNTeT8Fajhu4Z+wZk/Lnhy+DL1N8MbVdcC3eAEQDx8/mN1lKEw7EwrvAqYoQgLURbZ28YbO0SX3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EUBcW4bu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EUBcW4bu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7DE11F00893;
	Sat, 30 May 2026 17:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162076;
	bh=OFJ7y9VyUW6kMiUHiVTaGJy8jb+JBmnA8Q48DzWOvc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EUBcW4busNPZ0PsUdO7eqdtwOAftodQ4biJGb+oF3zAWCen3ziiWGAQiV+Kqix85D
	 b/zajotvT0pdD5aaWOu+ttwab0vun60+ghuNUhdFz8pSGeBDeVr1Xa/1Z3SPW1CAK3
	 BK7lc3wn8R/iC8IGDNeYXddzYUBaxycC4ABdSKys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>
Subject: [PATCH 6.1 813/969] KVM: s390: pci: fix GAIT table indexing due to double-scaling pointer arithmetic
Date: Sat, 30 May 2026 18:05:37 +0200
Message-ID: <20260530160323.083598536@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Junrui Luo <moonafterrain@outlook.com>

commit 16d990a15491cf76cd6eef0846e1b4100e63261a upstream.

kvm_s390_pci_aif_enable(), kvm_s390_pci_aif_disable(), and
aen_host_forward() index the GAIT by manually multiplying the index
with sizeof(struct zpci_gaite).

Since aift->gait is already a struct zpci_gaite pointer, this
double-scales the offset, accessing element aisb*16 instead of aisb.

This causes out-of-bounds accesses when aisb >= 32 (with
ZPCI_NR_DEVICES=512)

Fix by removing the erroneous sizeof multiplication.

Fixes: 3c5a1b6f0a18 ("KVM: s390: pci: provide routines for enabling/disabling interrupt forwarding")
Fixes: 73f91b004321 ("KVM: s390: pci: enable host forwarding of Adapter Event Notifications")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kvm/interrupt.c |    3 +--
 arch/s390/kvm/pci.c       |    6 ++----
 2 files changed, 3 insertions(+), 6 deletions(-)

--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -3323,8 +3323,7 @@ static void aen_host_forward(unsigned lo
 	struct zpci_gaite *gaite;
 	struct kvm *kvm;
 
-	gaite = (struct zpci_gaite *)aift->gait +
-		(si * sizeof(struct zpci_gaite));
+	gaite = aift->gait + si;
 	if (gaite->count == 0)
 		return;
 	if (gaite->aisb != 0)
--- a/arch/s390/kvm/pci.c
+++ b/arch/s390/kvm/pci.c
@@ -292,8 +292,7 @@ static int kvm_s390_pci_aif_enable(struc
 				    phys_to_virt(fib->fmt0.aibv));
 
 	spin_lock_irq(&aift->gait_lock);
-	gaite = (struct zpci_gaite *)aift->gait + (zdev->aisb *
-						   sizeof(struct zpci_gaite));
+	gaite = aift->gait + zdev->aisb;
 
 	/* If assist not requested, host will get all alerts */
 	if (assist)
@@ -359,8 +358,7 @@ static int kvm_s390_pci_aif_disable(stru
 	if (zdev->kzdev->fib.fmt0.aibv == 0)
 		goto out;
 	spin_lock_irq(&aift->gait_lock);
-	gaite = (struct zpci_gaite *)aift->gait + (zdev->aisb *
-						   sizeof(struct zpci_gaite));
+	gaite = aift->gait + zdev->aisb;
 	isc = gaite->gisc;
 	gaite->count--;
 	if (gaite->count == 0) {


