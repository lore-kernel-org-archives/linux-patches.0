Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C14A69D09;
	Wed, 21 Feb 2024 13:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521277; cv=none; b=ml7/Td7M4X8wAzjjYRJOJH8R9fZt0J5hI460GHhlH9W2hR2780loguDpQmc1s5fOmmUlnD0JOU2owjXj3menY9+g54pSig2bIwWd33BjytuFfyUwkO1EdbNOlXyZA+mNX2tJPaIQ98cMCJXg9lOK1in9SdewuyMl3qtTJ5NLDbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521277; c=relaxed/simple;
	bh=/7ePqoOkCgebyyS2VfmypzqDY/C9RQJ/N8tM+dpZE80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g23ry5TgvfuzZuQGvMaWJNJ3CUKhjkh9Lv/PItio3+VGeCaf5/uewhudfgCek3KOo0TLnxlcbu1fmKPePIoCGGHlytLYa1DdFBH/MIzh0hAcbzJgIMg2vH4dXveZma88Ot9deusmyMsIxvl9kqlmA05pxVp+T1RiLKe2Hv+YnI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bH70GHWQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bH70GHWQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4766C433F1;
	Wed, 21 Feb 2024 13:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521277;
	bh=/7ePqoOkCgebyyS2VfmypzqDY/C9RQJ/N8tM+dpZE80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bH70GHWQqJNK1t2QvjtAqRxjHc6WqMtZKAPBwDKfnyrrUe2l04Y7wWinWwYvhHYUH
	 6xhrTca6MQdM1SxyUeyU0DN9tXtcwuFH7QhZWq58C35xVZAvSPh8NKOtxe3l6p19QA
	 vMeR/ExI3XO6cxrsXDne0i+g5LYPjehIpX9Y91MA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 069/202] KVM: s390: fix setting of fpc register
Date: Wed, 21 Feb 2024 14:06:10 +0100
Message-ID: <20240221125934.053618896@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit b988b1bb0053c0dcd26187d29ef07566a565cf55 ]

kvm_arch_vcpu_ioctl_set_fpu() allows to set the floating point control
(fpc) register of a guest cpu. The new value is tested for validity by
temporarily loading it into the fpc register.

This may lead to corruption of the fpc register of the host process:
if an interrupt happens while the value is temporarily loaded into the fpc
register, and within interrupt context floating point or vector registers
are used, the current fp/vx registers are saved with save_fpu_regs()
assuming they belong to user space and will be loaded into fp/vx registers
when returning to user space.

test_fp_ctl() restores the original user space / host process fpc register
value, however it will be discarded, when returning to user space.

In result the host process will incorrectly continue to run with the value
that was supposed to be used for a guest cpu.

Fix this by simply removing the test. There is another test right before
the SIE context is entered which will handles invalid values.

This results in a change of behaviour: invalid values will now be accepted
instead of that the ioctl fails with -EINVAL. This seems to be acceptable,
given that this interface is most likely not used anymore, and this is in
addition the same behaviour implemented with the memory mapped interface
(replace invalid values with zero) - see sync_regs() in kvm-s390.c.

Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/kvm-s390.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 92041d442d2e..bc700cb9fc53 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2995,10 +2995,6 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 
 	vcpu_load(vcpu);
 
-	if (test_fp_ctl(fpu->fpc)) {
-		ret = -EINVAL;
-		goto out;
-	}
 	vcpu->run->s.regs.fpc = fpu->fpc;
 	if (MACHINE_HAS_VX)
 		convert_fp_to_vx((__vector128 *) vcpu->run->s.regs.vrs,
@@ -3006,7 +3002,6 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 	else
 		memcpy(vcpu->run->s.regs.fprs, &fpu->fprs, sizeof(fpu->fprs));
 
-out:
 	vcpu_put(vcpu);
 	return ret;
 }
-- 
2.43.0



