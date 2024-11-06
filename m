Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280E71DF73C;
	Wed,  6 Nov 2024 12:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895615; cv=none; b=lQreO0DnOd082vR/cvLQopjOPeGK8NswyTe5G+6aQwYSYFKkWtnbG966DMpcSprTBKZIdn4/b57G1Uruk0CluPHCg/EvmMwRijRVRPpW9yTcddZqtCGufRPkagCVjcG9YVIId7tJuSJU/d7o8E/UCNHd920KjsMYfZ/tseAx21k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895615; c=relaxed/simple;
	bh=HTMYDTmSsxo3jNrDgPbYgYwkMIRcpkn7hzUK7a6jkhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BfRMuTQdbTSo14g5Ni0yUjnLYlaVVjwOXBSwllE/y1beAdngTCA7IrleS0yu3vBSECNgwi1MMXMhM03TdoxkEK2dFLyMTcdzkfzM9FloFuHr+6NEtjgDYgAKIelBDEfAgG6cMFtI+kHmceuCQ0Qq4ffG//X7d1AIJDn5f/fUT+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t5m/OEhY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t5m/OEhY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C27C4CECD;
	Wed,  6 Nov 2024 12:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895615;
	bh=HTMYDTmSsxo3jNrDgPbYgYwkMIRcpkn7hzUK7a6jkhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t5m/OEhY0cy0cG+ImjUm8wkdzufn6Ebic2io7Xiv63I1M0uVRXTcKn9gmCiDgAvyJ
	 tYzcfkN2OjzbeUrkTcCGA10wSDs4DY9pYuAIrtXI+I2IppRgn5eFHAM5VKg5pA9gEF
	 9nlDq7bTZwEGJXw75OihtmhxRwT+4yTyDbZmR3Hg=
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
Subject: [PATCH 4.19 276/350] KVM: s390: Change virtual to physical address access in diag 0x258 handler
Date: Wed,  6 Nov 2024 13:03:24 +0100
Message-ID: <20241106120327.687039350@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -78,7 +78,7 @@ static int __diag_page_ref_service(struc
 	vcpu->stat.diagnose_258++;
 	if (vcpu->run->s.regs.gprs[rx] & 7)
 		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
-	rc = read_guest(vcpu, vcpu->run->s.regs.gprs[rx], rx, &parm, sizeof(parm));
+	rc = read_guest_real(vcpu, vcpu->run->s.regs.gprs[rx], &parm, sizeof(parm));
 	if (rc)
 		return kvm_s390_inject_prog_cond(vcpu, rc);
 	if (parm.parm_version != 2 || parm.parm_len < 5 || parm.code != 0x258)


