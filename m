Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F139470838;
	Mon, 23 Jun 2025 21:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713047; cv=none; b=eqV7r1TXKMjc9V/ugMwbx5aHdfLGgBgfB7GMism97LGSpzb2Qy+vZjmKjnSthDvRlSRz/bCYLLKdTnPHFvpILvsBmB50TQ0OGVJRrVnQHoQAyGkRj+n3XRPQU7r4VQ8HBxJ7IUWZAlYmyk0RBQj2YhH9j5Eus3gBFy7c6d376SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713047; c=relaxed/simple;
	bh=UetWgWwNxH6ZtpxGj0QooftH/glfE7QiH1c/VQ9WLDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hKDi3DPbpuhpbWkcEAJXC5nhwNmrKOPOZSZJX5p1ZYAxSwrRSRZJ6lR3BiER8X3n5jhv17gQ+pM2gqWBQj3cLZi4MolcwYIevDk5jvGX6hdi/t6qo7QKM20yhjh6qEVBkqVkTOK2eUMexj2R+uC1umWBdraHQg5WZOUfbIg9XaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nS5jfZ3U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nS5jfZ3U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89265C4CEEA;
	Mon, 23 Jun 2025 21:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713046;
	bh=UetWgWwNxH6ZtpxGj0QooftH/glfE7QiH1c/VQ9WLDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nS5jfZ3Uq2dlTdyRJRG+xtT2OrG2gZOkW4k6VonaDrUR4ggb+18pyIlsImvNNO3El
	 VX5y4txxB7AVUrFtM96P8pdcKJ8/NIpR9uSJ7LKViOGZYcebt/MeOukBe/ZHdo7AzS
	 SQw+6dh4Qzgp1Vl9JjzycmTB3CycR8/TTT1ueeKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Narayana Murty N <nnmlinux@linux.ibm.com>,
	Vaibhav Jain <vaibhav@linux.ibm.com>,
	Ganesh Goudar <ganeshgr@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 185/222] powerpc/eeh: Fix missing PE bridge reconfiguration during VFIO EEH recovery
Date: Mon, 23 Jun 2025 15:08:40 +0200
Message-ID: <20250623130617.735165926@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 8b0e523b2abbe..301654971b32c 100644
--- a/arch/powerpc/kernel/eeh.c
+++ b/arch/powerpc/kernel/eeh.c
@@ -1723,6 +1723,8 @@ int eeh_pe_configure(struct eeh_pe *pe)
 	/* Invalid PE ? */
 	if (!pe)
 		return -ENODEV;
+	else
+		ret = eeh_ops->configure_bridge(pe);
 
 	return ret;
 }
-- 
2.39.5



