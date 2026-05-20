Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6856B3FA5EB;
	Wed, 20 May 2026 18:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301608; cv=none; b=oIWBvxZcp+hI/KWgk8Jgeeb35Af6b7+9HsLhccZMfwzQGbnruh6hJoaOAQ6Ol9x2unONXHQ1YWpYwfRSO4qMQZKVE0jwZlB+2jMFjb8P9kjXZLVpsN8x213yC5KQgeXX1XDdLgScsm/UTyhGOdx8uWIv4Sair9w+9w7877WDs+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301608; c=relaxed/simple;
	bh=tOsD8sugrIc823wibGroUi8hzTUm3yOMvp8Rl9fuu2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m2rIfPR6giRmGmihnh1qsRFrhMaKbSLvUNqyfYi41sIvO3iQTJTueRADL9rar/eAM+27AHoLIO16WvOc+MK4+mMRa1qulzEJKTS/tD4gW/+JZZYK31cZBgGAGcLtUtMBVp4GesxLerESOBq8FdNh5NsW9kaJLIQU/a5VvzjAHqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j8AehUis; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j8AehUis"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB6E81F000E9;
	Wed, 20 May 2026 18:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301607;
	bh=trUw5WfNsftrJ64VPCPJyQMu8T9/apsMrhE/rIhOJZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j8AehUisqUYGZ3Glzoxw/1w2AHs5Fx5Q9kCbTofbojnzgHX8/omP04NL4C+ySMBor
	 n3xu742Q3HvxCa872LD7EXW0vxaLcqH5JpApoRahNEll1+YHclZbbHFiBvwFU5GEnx
	 G1QW0YgBLdM04HpL5ZRg1qE8G0KcV8d2ybCdDkNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>
Subject: [PATCH 6.12 620/666] KVM: s390: pci: fix GAIT table indexing due to double-scaling pointer arithmetic
Date: Wed, 20 May 2026 18:23:51 +0200
Message-ID: <20260520162124.710480355@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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
@@ -3329,8 +3329,7 @@ static void aen_host_forward(unsigned lo
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


