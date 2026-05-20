Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8511C36D4E1;
	Wed, 20 May 2026 17:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299803; cv=none; b=USFM8/JO9GB6KVJOUksJu/WAH2OQWVPot672ezzd7jXJGl0eXD4sjgT+l0B5lU7spqEceB/5vjszj4NvckSVBYWBDaoa5nqCEPU/d0nbuNh+LCxjAnoLJe/dV1D+azXF+2eE+Sg5swcE33loKRvLEewRjC6NihU1qlCb7n5TRMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299803; c=relaxed/simple;
	bh=n8ARWI7WQAHfQQoDL9r4gqlJn5Nt3KfeP0v+xfonZR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NB68gCEqYARc7Wl2nVvEdKjARkaphPT4o4q70vGORrVR4Ni+/msXawgWBOgC3ooNoj+oFgBVlYkFCA0m7DxjicJ3HBVEKw134+L701MW50gl0RtoHgByXiaRW3ewUeDJuoOq6O7/UN0Sas0GVinBJiOpLdXIgfHXj7UrKhxE664=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=npBrjNTZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="npBrjNTZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3BDA1F00893;
	Wed, 20 May 2026 17:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299802;
	bh=JaDkP2oZFujutY8gRkA0drzAHmzCfhqNf4OuY4QQmnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=npBrjNTZjXu9/5QFZNhYjDIj+ajJ0nCWO8zThhBZLARtEHuD9pVj34qWKWrlnk5f/
	 kUqGvnjL3s0glnBXG4pUc6HoZamh8e8sqZ2e0ZPoKQbm1uZRYrzvGr4olJqC3ptIqx
	 3tOLw5pWRujsQgX9p/fiG1d99neFdJsvxibDRE3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>
Subject: [PATCH 6.18 893/957] KVM: s390: pci: fix GAIT table indexing due to double-scaling pointer arithmetic
Date: Wed, 20 May 2026 18:22:56 +0200
Message-ID: <20260520162153.937797239@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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
@@ -3334,8 +3334,7 @@ static void aen_host_forward(unsigned lo
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
@@ -291,8 +291,7 @@ static int kvm_s390_pci_aif_enable(struc
 				    phys_to_virt(fib->fmt0.aibv));
 
 	spin_lock_irq(&aift->gait_lock);
-	gaite = (struct zpci_gaite *)aift->gait + (zdev->aisb *
-						   sizeof(struct zpci_gaite));
+	gaite = aift->gait + zdev->aisb;
 
 	/* If assist not requested, host will get all alerts */
 	if (assist)
@@ -358,8 +357,7 @@ static int kvm_s390_pci_aif_disable(stru
 	if (zdev->kzdev->fib.fmt0.aibv == 0)
 		goto out;
 	spin_lock_irq(&aift->gait_lock);
-	gaite = (struct zpci_gaite *)aift->gait + (zdev->aisb *
-						   sizeof(struct zpci_gaite));
+	gaite = aift->gait + zdev->aisb;
 	isc = gaite->gisc;
 	gaite->count--;
 	if (gaite->count == 0) {


