Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA09D1E47AC;
	Mon, 21 Oct 2024 10:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507333; cv=none; b=aGH5/x2cEa+Wu8vewjG3ksM+Nmi0WdTEgdpD/PYOUCIqb7+kLtjrkf08C16uTPhog9Z6XY5n/KH+TUJ+L3+9Z2JtnsUGJe2nz62CbInr8sPGBUyCJMtRR6NaU6wzo6f1lfbnCFCBdB4zk6dwZYymW2BstKK/Q/wncPw4sgL58qQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507333; c=relaxed/simple;
	bh=KujQDZ2XR6B7FHYORg2ORFWLPInrqRyW9aVEIV9SGhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J2SmEayU/8LjceypjFCcZFLzz4m/TeLUh8t3IWpA6ftlTKuwkLBcgvDkfB9tOQeTbbjy+Shyb1MhJsLskT2zHses3BWPysmNmod8f9RDumGrm9PAKVDvpEdnYxlXstmCU3wc6cvH+1U52zrjd42reTNATwe4N1DLgSUKcsxap+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TzeZYZ15; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TzeZYZ15"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BCADC4CEC3;
	Mon, 21 Oct 2024 10:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507333;
	bh=KujQDZ2XR6B7FHYORg2ORFWLPInrqRyW9aVEIV9SGhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TzeZYZ15wo954zraqcTolqJNgYqoxR7YyKJA8zdc98Itp67tF2E2KlGvgr3KhfBIB
	 ZQBhSGS76tR8VJ3vKrNVAYJdULQaC8E82PIKqG9cjEAteBebyTUML+yC0sWoGZ5eGH
	 Pqb1DIVprgZNl0Dm8XUSUFh8xpOnpNhOidzodKU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasily Gorbik <gor@linux.ibm.com>,
	Michael Mueller <mimu@linux.ibm.com>,
	Nico Boehr <nrb@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>
Subject: [PATCH 6.1 42/91] KVM: s390: Change virtual to physical address access in diag 0x258 handler
Date: Mon, 21 Oct 2024 12:24:56 +0200
Message-ID: <20241021102251.463461813@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102249.791942892@linuxfoundation.org>
References: <20241021102249.791942892@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Michael Mueller <mimu@linux.ibm.com>

commit cad4b3d4ab1f062708fff33f44d246853f51e966 upstream.

The parameters for the diag 0x258 are real addresses, not virtual, but
KVM was using them as virtual addresses. This only happened to work, since
the Linux kernel as a guest used to have a 1:1 mapping for physical vs
virtual addresses.

Fix KVM so that it correctly uses the addresses as real addresses.

Cc: stable@vger.kernel.org
Fixes: 8ae04b8f500b ("KVM: s390: Guest's memory access functions get access registers")
Suggested-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Link: https://lore.kernel.org/r/20240917151904.74314-3-nrb@linux.ibm.com
Acked-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kvm/diag.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/kvm/diag.c
+++ b/arch/s390/kvm/diag.c
@@ -77,7 +77,7 @@ static int __diag_page_ref_service(struc
 	vcpu->stat.instruction_diagnose_258++;
 	if (vcpu->run->s.regs.gprs[rx] & 7)
 		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
-	rc = read_guest(vcpu, vcpu->run->s.regs.gprs[rx], rx, &parm, sizeof(parm));
+	rc = read_guest_real(vcpu, vcpu->run->s.regs.gprs[rx], &parm, sizeof(parm));
 	if (rc)
 		return kvm_s390_inject_prog_cond(vcpu, rc);
 	if (parm.parm_version != 2 || parm.parm_len < 5 || parm.code != 0x258)


