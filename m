Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F16628E0;
	Fri,  7 Aug 2026 15:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116060; cv=none; b=n6la6uUwBNgALRo05V9oxUeIOfWGa7dsvpWAo08BR4qj3RVQY0cms/6n6KJged/vW7+idVYzDc+N++QKA0fMdWNm5WboPLOlEQLh86iO/tldAeW+T/ZW1HGNKTE5fO/9zBQfx8jzlRmLWZKjbr3vxhvwViZc7rOVD75x73mfe3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116060; c=relaxed/simple;
	bh=yF8ColQjCUk3Bdgplf/X+SkzXtaTpFd0D2E8KhnARh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ubBohHzcrodfOGk4phJpTJLjNTmK10wi8L4JOUdFRa70eHATMjKkfrAH2nPSza+yTqZojrRzqmOgfrHBeo11K8p7F3KPgrZMo/rt67u7NVg9Gg6146bSbLHAVTnDM1EjXvnuHqk3BLVifF/yTTIlVRFsfbI6MEj2sAkuUVZGxzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WjWG9TZi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WjWG9TZi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C97181F000E9;
	Fri,  7 Aug 2026 15:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116059;
	bh=z5T79WvF1YDNEcLbIFgXcYO6zfqiiQc9JtMnecAFOeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WjWG9TZiWwlIsTPNP5pNjNs+dNLeq6RFGq9tE5S65WvdKhcMhMJwVBl/pqXamUraQ
	 yMWZay7zTqb2AQf077RCUJmWE/rawlq3fUa4J5BvM2xlApofvr4bBeASnE+XmWD/nU
	 5vl6cDE/BdJn1KVD6Pdzh4fBtPcgVFrPTe1hm7xE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Farhan Ali <alifm@linux.ibm.com>
Subject: [PATCH 6.6 097/261] KVM: s390: pci: Reject adapter interrupt forwarding if already enabled
Date: Fri,  7 Aug 2026 16:37:34 +0200
Message-ID: <20260807143417.476996286@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


