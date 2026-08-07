Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3FB846EC60;
	Fri,  7 Aug 2026 15:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117183; cv=none; b=bVrIOUR7iZ+TXV34WOhVDHKtGSoDOBLKHD2NQAEo1UYNG4ijRmXa9q72UqisbvpdrwK3RLNThYfGa0VeiIRKfg66ib1NSacyL6/h856JyhWqbkC7A3q8kRkmFUpYcESGU6o+kQNR7ECgd4ORQWKt30e75QnvywwVKFrT8ICXUAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117183; c=relaxed/simple;
	bh=rS80fCPxNgnuGMxnyDxQ/onIkAdDPsj3UOaY0ob1JxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gwK+FrAg6J2YOWETgzSFwJzJyw5XIsFoW/97e7OyK9K66A5Aq7r6o4Pmd4aWhP4ePrs+3/lUreIe8tYQxozZDvS7FfvdJZMc2AdoDQ7veDNDaSdIMJmA6uJLCDZyKNN8yMuZMjyTeMZHowH3GGZvrxwdlhK0kKhZUV3YjdsKONY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YQHCzkc8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YQHCzkc8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C2731F000E9;
	Fri,  7 Aug 2026 15:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117182;
	bh=B6MpF5bTITrb24ZcxZSFdZYr4OJucYrDTk8MZlzyRDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YQHCzkc8l6o1Cr2jnxFTYsH67EhU7kSwTKoofuB3vSb2LeDlWXnkHeyKe0nyBxcLA
	 cLMDgORTjdJyGDPvw8luCGzsgI0uy7iuuzthdstiysiugc2UeZUZErGPXujWP6kA+R
	 sO5dA92gh9PAA1++fr4oTKz2USnSoG6Q1i00bqgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Farhan Ali <alifm@linux.ibm.com>
Subject: [PATCH 7.1 229/438] KVM: s390: pci: Reject adapter interrupt forwarding if already enabled
Date: Fri,  7 Aug 2026 16:37:05 +0200
Message-ID: <20260807143432.885553899@linuxfoundation.org>
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
@@ -237,6 +237,10 @@ static int kvm_s390_pci_aif_enable(struc
 	if (zdev->gisa == 0)
 		return -EINVAL;
 
+	/* AIF already enabled for the device */
+	if (zdev->kzdev->fib.fmt0.aibv != 0)
+		return -EINVAL;
+
 	kvm = zdev->kzdev->kvm;
 	msi_vecs = min_t(unsigned int, fib->fmt0.noi, zdev->max_msi);
 


