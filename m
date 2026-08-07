Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B7937206E;
	Fri,  7 Aug 2026 15:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115173; cv=none; b=SVH65PLVhyB3Jpp6KazOgwWPvW0xfKOPDxzV/tuPe1NFeYsACPGYc7CDrvOUOud2RMy2LUbditdn2PTjfv09p80d1SDRO5R8nOxrIgdIB6UUoFlccbttN1tj66FP3V9plkVtr5iAD32CZdUzMXmiZe6A1C30KD0yCoCOon7OwSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115173; c=relaxed/simple;
	bh=cDZ5lyb6UzLH3PJwSGPpymrMyqojoF8CJ8Owc/asNGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RENCmTjyf78uHDI/cfG2EZCwzi4siPuyOqqHtZfgcAiBhz2ZJrax7bj4XZ3+lPJFYVQXCidIyO1OzMfkoS46r3GFj4G4Ksnf+iqLLtIQUVV0jb1d0hmSVWs3BXWFDt60EwdcqRv7UZ1OQoZ/KwM1+NX+LbyLtk4CMOmvSmEAwEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gn2k2xVP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gn2k2xVP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C35E51F00A3E;
	Fri,  7 Aug 2026 15:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115169;
	bh=mXHk6px2hn1upq6IvqkN/mS5yXv/CQs+jgKD9LR1D4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gn2k2xVPr2H5bBKqxvrVfscj/4XhRVGa1bAeCnANqHV7J5FRcs5QNKBwAZ1iBau1X
	 XVFbNlDWkK/ELY4s+Pa8ivWASAvaD47Cw45HHvu3+vieNn5spXd/gDUYhFLe4NQjx6
	 Ldp7N4deazaio/AJefV7tm0F3oRMYXErmmcjSZks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Farhan Ali <alifm@linux.ibm.com>
Subject: [PATCH 6.18 180/396] KVM: s390: pci: Reject adapter interrupt forwarding if already enabled
Date: Fri,  7 Aug 2026 16:35:40 +0200
Message-ID: <20260807143428.178000579@linuxfoundation.org>
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
@@ -238,6 +238,10 @@ static int kvm_s390_pci_aif_enable(struc
 	if (zdev->gisa == 0)
 		return -EINVAL;
 
+	/* AIF already enabled for the device */
+	if (zdev->kzdev->fib.fmt0.aibv != 0)
+		return -EINVAL;
+
 	kvm = zdev->kzdev->kvm;
 	msi_vecs = min_t(unsigned int, fib->fmt0.noi, zdev->max_msi);
 


