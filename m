Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B11039CD16;
	Fri,  7 Aug 2026 14:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114089; cv=none; b=u/a8ErertAzL2LpIvufqrj1VRJOAuagcHTVCn66KUGu8G1LpBjMCbIDV21b4xulBOc6VnzUSO+q+ZgYur/i+s10jy9Hj9bgPDEZJnMtP7zpe66F6xZ4QVNTE5L9YmEL3RRyCeGXe2nIukpiYNM/Eoc8uzkvyicd04i/nxhQPmo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114089; c=relaxed/simple;
	bh=LKY5O5WQK8FXJVTEugNkdvN5ws+uBuqPzdiJvBNGj8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mr/MNnjAjWepotiIlUYCGPfq4KCZXfaV0eyDoqJ2Ju7GK+fMgFLtJMJMcUapaDn3yEh1+2L7y2ek0/lq0rGjXXg9wYmXmAlJFirc7EtreAEuSXbY6nc16n5xL9F46URvKHFaFOT34u12YCyyZplyFaLhNbdLG2zwaoDfMY+sA0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MYvL4/n1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MYvL4/n1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72FCE1F000E9;
	Fri,  7 Aug 2026 14:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114088;
	bh=zQaQ6qJaAEL4hR31KrW96Myfv70Z6c76XaUhxRIGcQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MYvL4/n1NzwBvmbagV91lQGCyoOT1kkC4vb9pA/ocRgR7zWW5CARyVcTknON++y8k
	 27i7uDMmJFWOKexRweqVLjuknANENs4qxlVTrIKuL6OxpZ7TvWLsr6TaKKkGpuDMo4
	 aRMZhiKi3w3JUKeHjoD21jbiC6n0X2hOHNLbd4uU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Farhan Ali <alifm@linux.ibm.com>
Subject: [PATCH 6.12 141/337] KVM: s390: pci: Reject adapter interrupt forwarding if already enabled
Date: Fri,  7 Aug 2026 16:35:44 +0200
Message-ID: <20260807143421.590195550@linuxfoundation.org>
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

commit 8fa01be5a6149404adb82c0979a78f6347edd3ef upstream.

The MPCIFC instruction doesn't allow registering adapter interrupts without
first unregistering. So reject any request to enable interrupt forwarding
if its already enabled for the zPCI device. This also fixes overwriting and
thus leaking resources when the ioctl is called multiple times for the same
device.

Fixes: 3c5a1b6f0a18 ("KVM: s390: pci: provide routines for enabling/disabling interrupt forwarding")
Cc: stable@vger.kernel.org
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kvm/pci.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/s390/kvm/pci.c
+++ b/arch/s390/kvm/pci.c
@@ -239,6 +239,10 @@ static int kvm_s390_pci_aif_enable(struc
 	if (zdev->gisa == 0)
 		return -EINVAL;
 
+	/* AIF already enabled for the device */
+	if (zdev->kzdev->fib.fmt0.aibv != 0)
+		return -EINVAL;
+
 	kvm = zdev->kzdev->kvm;
 	msi_vecs = min_t(unsigned int, fib->fmt0.noi, zdev->max_msi);
 


