Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FCCC1E2618;
	Mon, 21 Oct 2024 10:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507115; cv=none; b=IHHykEz1z/VyF3qPcX06xeTiQwlJe97KKk7LAtG+PzgdshzPKl+9SqrK95qaH5ay2DL17uhhE5B3ehjy7KCdGy/oFDpLhOkHivGObG6EkMTV70qnJdlRA1puak1hq7EtTgKyNkbl38qmhWhpdX0oLUUFiP4a14Wf3cobeT0V+74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507115; c=relaxed/simple;
	bh=VPoYP1lKs7I6bksYYSffqL7ZUN2jjRmivbzfBcpt64o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=clB8UQv0RHEVk5cvjT1WDNKH5/hJCHrXE1neSbarKsp+YixiktFBt5KQPYtI5qHsJ5cI8c96KH1+oYAYiwHc7kTQuwk0wZAWxmfKvSCMB+bS0p4LwgCVhOjnToasm+8CISG82FEh1mXmafjW5IA99IS3LC0b7TgFPpXJnL5ueDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZGf739Dt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZGf739Dt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 694F2C4CEE5;
	Mon, 21 Oct 2024 10:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507114;
	bh=VPoYP1lKs7I6bksYYSffqL7ZUN2jjRmivbzfBcpt64o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZGf739Dtxg1exkvB4+Gk5zYxYHE6Eou+ENw6ri20VsEoWwWUV8xkkSnFFMZJlOqw9
	 L3jEqn+tshxDdmy73oSlJ3V4E2U8fqXSV8KBUYldGiG4EM6YcPe3Lmp2BYia0yuL23
	 cxILj92XoV/5Tmh5C0YS7k7/Zob1n9f2fdzyOWuE=
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
Subject: [PATCH 6.6 053/124] KVM: s390: Change virtual to physical address access in diag 0x258 handler
Date: Mon, 21 Oct 2024 12:24:17 +0200
Message-ID: <20241021102258.781321336@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


