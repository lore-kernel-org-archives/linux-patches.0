Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C262442B17;
	Mon, 17 Aug 2026 15:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979909; cv=none; b=eB6mbbpaxggLH8/zbRh5ZQ0T77NjBEiJvH8pUoI21qsLiVor9wonF4hXsyYZnARF9fXI6VgYxh0it/QL5/9I3KBv9F7BKVYIuU3a+V7Rr9lHWG7CKUd3DzpnA0sfi5TW6IfmIfH5b1uLWxsHnh1QzqGXsYZjzABsd6gIWed8Eao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979909; c=relaxed/simple;
	bh=cPExOP8ltOLY32naILBXvtQjrn3FDSE8XrKdNEdm9jM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oQTEhCT9nlKRX2lxGza317BvkmHCrdyeSafCnF43Hh9Srv6R+sN02C/uG3CM1V5ueh5CW8n6Iy8Wog+l2cdUp23YE3GBWPSBINNqi08cwyr1XVBhWc6u1EEdeaQzV5NGB1kGh+Kvyz64AK7rJ8+VENhOsGlAeq7rNm+8b2g8d6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R15pY1q5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R15pY1q5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D1321F000E9;
	Mon, 17 Aug 2026 15:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979908;
	bh=SYz22I/IfTEt18UiJCbWkf2hPvEAk1/Y07aY0riM768=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R15pY1q5baEX2qolJ+AQTWZDjeF96jcXelZIS71qWvoc6PORo54EsyutMsC+Lnoan
	 zniSnEhAEdApBRoKur0IEL1KNmTr5O/I+3sO3rMc395TBJM/sWl6yLzOJz7dDr+jYG
	 dChrIiwrcE+7OhL5fUjooDBUpOoYkYYg5zANS7yo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Farhan Ali <alifm@linux.ibm.com>
Subject: [PATCH 6.1 388/609] KVM: s390: pci: Reject adapter interrupt forwarding if already enabled
Date: Mon, 17 Aug 2026 15:31:24 +0200
Message-ID: <20260817132557.233101694@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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
 


