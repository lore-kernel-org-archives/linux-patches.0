Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05523AFCF0;
	Sat, 17 Oct 2026 16:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255877; cv=none; b=gmJbyZXeDeU2h27EGclGPxriFLVa8b6FPbNY7lnaZZMAOEBrVTMCeW3qfcRRs5dbAmDXLqbGTqd55yrKHzdHOJTMOwHHMucaqS6tLVsJQ5CpMw5tdysC5cXUmufYYgZ3edQMPLcoY1vYQ7om3mwAUyEQo0FhU/W5VPiyGXOONVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255877; c=relaxed/simple;
	bh=NsFO61jN+XnFU8JIAryN/DQ3gHLw8R3jeA0Mh7014po=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r5nmVPUStDNz64cf/DwCX2+P4jZk9N82Bf5iEzNTqCl+LAg7yV12Uennz61ASv65zVL2WdOlFe8CEbYTe0DMKeWYugX3VdT4ifgnFZehaELvqxHtL0XDAGOBqKkMlSaOuVvFR+U1ec5dCNH3nhW+9tJyMwdUxVorhBxXssdlz10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=upKlKeJU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="upKlKeJU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 519D91F000C4;
	Sat, 17 Oct 2026 16:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255875;
	bh=Q3DvDkj+L06z6srK/RwCmU1Wj/UR1z0qvnrIoNEv684=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=upKlKeJUZy2ri0pFh42u0/M65Wr0DmUkmAXl7Zmvi8dSFrO0KxZWOs1mZOGYL3Kev
	 h6+ztWvJVPeVrck4Z5eJgVXTU1u2eqbPmeW14bfpPGBSWQtOXl3dGmHL9F+A5bp30D
	 1oEInYL0fXLZWfENycbvevlrOeLG8cNQVI/YRdQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Schlameuss <schlameuss@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0050/1674] kvm: s390: Reject memory region operations for ucontrol VMs
Date: Sat, 17 Oct 2026 17:38:42 +0200
Message-ID: <20261017160432.422797646@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Christoph Schlameuss <schlameuss@linux.ibm.com>

[ Upstream commit 7816e58967d0e6cadce05c8540b47ed027dc2499 ]

This change rejects the KVM_SET_USER_MEMORY_REGION and
KVM_SET_USER_MEMORY_REGION2 ioctls when called on a ucontrol VM.
This is necessary since ucontrol VMs have kvm->arch.gmap set to 0 and
would thus result in a null pointer dereference further in.
Memory management needs to be performed in userspace and using the
ioctls KVM_S390_UCAS_MAP and KVM_S390_UCAS_UNMAP.

Also improve s390 specific documentation for KVM_SET_USER_MEMORY_REGION
and KVM_SET_USER_MEMORY_REGION2.

[ Backport to 6.6.y: omitted KVM_SET_USER_MEMORY_REGION2 documentation
  because that ioctl is absent from 6.6.y. ]

Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Fixes: 27e0393f15fc ("KVM: s390: ucontrol: per vcpu address spaces")
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20240624095902.29375-1-schlameuss@linux.ibm.com
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
[frankja@linux.ibm.com: commit message spelling fix, subject prefix fix]
Message-ID: <20240624095902.29375-1-schlameuss@linux.ibm.com>
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/virt/kvm/api.rst | 6 ++++++
 arch/s390/kvm/kvm-s390.c       | 3 +++
 2 files changed, 9 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 21a7578142a18..0f7177c7653bd 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1363,6 +1363,12 @@ Instead, an abort (data abort if the cause of the page-table update
 was a load or a store, instruction abort if it was an instruction
 fetch) is injected in the guest.
 
+S390:
+^^^^^
+
+Returns -EINVAL if the VM has the KVM_VM_S390_UCONTROL flag set.
+Returns -EINVAL if called on a protected VM.
+
 4.36 KVM_SET_TSS_ADDR
 ---------------------
 
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 0e948d598b6a0..c0d8c59bb2cb1 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -5769,6 +5769,9 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 {
 	gpa_t size;
 
+	if (kvm_is_ucontrol(kvm))
+		return -EINVAL;
+
 	/* When we are protected, we should not change the memory slots */
 	if (kvm_s390_pv_get_handle(kvm))
 		return -EINVAL;
-- 
2.53.0



