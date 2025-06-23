Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3C51F7580;
	Mon, 23 Jun 2025 22:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716879; cv=none; b=GzH0Jzt20peRlitrYwKpVRXRwPYz8WOIB420GCYL+UMmkr7SCupU/Ds1r6Asv5yX82DqGVflaEO0oYWhf4aKC12poif5L5Elor3R2gXA2dpyzQ4Jash0qgMFw4MqnbZZDTaz5uICNfiFqznN5ifk9RErjn9inQDKrpoJmCYIk3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716879; c=relaxed/simple;
	bh=9r+gqi+K89YsxmJ9qZlNPZ6300rWFobtRQKxipHexvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WBNNGMFS5/OY36XkLq5QRNCvzu6qTT2PEqv2fVV/ptae1z0zCrSAnrpIVMHmfEjhMhIIkMHmHiLqQPUoK4LXFYwBBIJfNUr+Y8SdvIsXWcpNL5A6Jhvi8tGa2ZU94hUwK7tObtVmhazp+RCoxzzEmVj5tBvGE8xH8IH6f4kfW6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AbyzyzUU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AbyzyzUU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23C01C4CEEA;
	Mon, 23 Jun 2025 22:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716879;
	bh=9r+gqi+K89YsxmJ9qZlNPZ6300rWFobtRQKxipHexvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AbyzyzUUORFK/TK+iT153MaR5NNfBpb/VtVOE3kTSvmGj2ZSvppR47rsz3sIXRb9j
	 7NFqml1o1iVmmQ+iJ5J5kpmtZ0Wh6imo0IkY815xieGa2w6y8GCiLYbBWYptQ/oV58
	 ZAaTAB9TcW/bKuARkQ/eEEu0wyKGCG14wytAla1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Narayana Murty N <nnmlinux@linux.ibm.com>,
	Vaibhav Jain <vaibhav@linux.ibm.com>,
	Ganesh Goudar <ganeshgr@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 294/414] powerpc/eeh: Fix missing PE bridge reconfiguration during VFIO EEH recovery
Date: Mon, 23 Jun 2025 15:07:11 +0200
Message-ID: <20250623130649.360190184@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Narayana Murty N <nnmlinux@linux.ibm.com>

[ Upstream commit 33bc69cf6655cf60829a803a45275f11a74899e5 ]

VFIO EEH recovery for PCI passthrough devices fails on PowerNV and pseries
platforms due to missing host-side PE bridge reconfiguration. In the
current implementation, eeh_pe_configure() only performs RTAS or OPAL-based
bridge reconfiguration for native host devices, but skips it entirely for
PEs managed through VFIO in guest passthrough scenarios.

This leads to incomplete EEH recovery when a PCI error affects a
passthrough device assigned to a QEMU/KVM guest. Although VFIO triggers the
EEH recovery flow through VFIO_EEH_PE_ENABLE ioctl, the platform-specific
bridge reconfiguration step is silently bypassed. As a result, the PE's
config space is not fully restored, causing subsequent config space access
failures or EEH freeze-on-access errors inside the guest.

This patch fixes the issue by ensuring that eeh_pe_configure() always
invokes the platform's configure_bridge() callback (e.g.,
pseries_eeh_phb_configure_bridge) even for VFIO-managed PEs. This ensures
that RTAS or OPAL calls to reconfigure the PE bridge are correctly issued
on the host side, restoring the PE's configuration space after an EEH
event.

This fix is essential for reliable EEH recovery in QEMU/KVM guests using
VFIO PCI passthrough on PowerNV and pseries systems.

Tested with:
- QEMU/KVM guest using VFIO passthrough (IBM Power9,(lpar)Power11 host)
- Injected EEH errors with pseries EEH errinjct tool on host, recovery
  verified on qemu guest.
- Verified successful config space access and CAP_EXP DevCtl restoration
  after recovery

Fixes: 212d16cdca2d ("powerpc/eeh: EEH support for VFIO PCI device")
Signed-off-by: Narayana Murty N <nnmlinux@linux.ibm.com>
Reviewed-by: Vaibhav Jain <vaibhav@linux.ibm.com>
Reviewed-by: Ganesh Goudar <ganeshgr@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20250508062928.146043-1-nnmlinux@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/eeh.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/kernel/eeh.c b/arch/powerpc/kernel/eeh.c
index 83fe99861eb17..ca7f7bb2b4786 100644
--- a/arch/powerpc/kernel/eeh.c
+++ b/arch/powerpc/kernel/eeh.c
@@ -1509,6 +1509,8 @@ int eeh_pe_configure(struct eeh_pe *pe)
 	/* Invalid PE ? */
 	if (!pe)
 		return -ENODEV;
+	else
+		ret = eeh_ops->configure_bridge(pe);
 
 	return ret;
 }
-- 
2.39.5



