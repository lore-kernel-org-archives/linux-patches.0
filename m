Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6F322156D;
	Wed, 30 Jul 2025 09:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868454; cv=none; b=ZrDV3CZizXNw+7LrBUcYuwpv8tMS+k0LMtIEv2qHNYU0CdWys8+L2iI3Tle5XJc5iThYeAq+4ZkLOYyBO+s3/i/WmmZ0kImePL605JcRHVAFYGgAhE9PrAHYcmHnmcSUaSb17z6fmil61wt1vB9Cq0CgJs7kRhYsSrC1S0QR2aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868454; c=relaxed/simple;
	bh=dgipGGjt1gsRvWOooCeI1x/EXoX5ealCAEwEZ2KvCso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WDDbIGElo70bsvLob+Ms7OiC6QHvXVFrJfQWU4lFTf8mQdXdgSG1q21Diadhm4h8NB5ywqcdqwXiaDLKIfRFdprkMaGZTgeix3eafSeNESWeT1lSYsLlniZdVZx0hlxpQuTnF2sdMyCQORDcGVewzpNVN2BRv6FMrH+h9GJCA2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XqHQfSOP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XqHQfSOP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E067C4CEE7;
	Wed, 30 Jul 2025 09:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868454;
	bh=dgipGGjt1gsRvWOooCeI1x/EXoX5ealCAEwEZ2KvCso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XqHQfSOPyk9dTP27pJ9fffXcevEFmm+EKjyNkhdmOln/hWton2p1ypV/l/7oEJ/r/
	 KhXDspob/NBlspaPW9ucKK/FOFgVcBmi4irpgZeBtiKZQ0OWvolB+vlVdj7HEEL5sr
	 QLubvbYQWSSFHGpZjpDDQVzxI9qklLZIzN3onWhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nianyao Tang <tangnianyao@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Patrick Roy <roypat@amazon.co.uk>
Subject: [PATCH 6.6 69/76] arm64/cpufeatures/kvm: Add ARMv8.9 FEAT_ECBHB bits in ID_AA64MMFR1 register
Date: Wed, 30 Jul 2025 11:36:02 +0200
Message-ID: <20250730093229.542288382@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093226.854413920@linuxfoundation.org>
References: <20250730093226.854413920@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nianyao Tang <tangnianyao@huawei.com>

commit e8cde32f111f7f5681a7bad3ec747e9e697569a9 upstream.

Enable ECBHB bits in ID_AA64MMFR1 register as per ARM DDI 0487K.a
specification.

When guest OS read ID_AA64MMFR1_EL1, kvm emulate this reg using
ftr_id_aa64mmfr1 and always return ID_AA64MMFR1_EL1.ECBHB=0 to guest.
It results in guest syscall jump to tramp ventry, which is not needed
in implementation with ID_AA64MMFR1_EL1.ECBHB=1.
Let's make the guest syscall process the same as the host.

Signed-off-by: Nianyao Tang <tangnianyao@huawei.com>
Link: https://lore.kernel.org/r/20240611122049.2758600-1-tangnianyao@huawei.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ This fixes performance regressions introduced by commit 4117975672c4
  ("arm64: errata: Add newer ARM cores to the
  spectre_bhb_loop_affected() lists") for guests running on neoverse v2
  hardware, which supports ECBHB. ]
Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/cpufeature.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -364,6 +364,7 @@ static const struct arm64_ftr_bits ftr_i
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64mmfr1[] = {
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR1_EL1_ECBHB_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64MMFR1_EL1_TIDCP1_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR1_EL1_AFP_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR1_EL1_HCX_SHIFT, 4, 0),


