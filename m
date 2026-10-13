Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84BD741D11F;
	Tue, 13 Oct 2026 12:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895559; cv=none; b=M0GPHA9Omie2xVAARy7IjfQYqBKCf82ofyigQhgNTKYjIWG+Vc1STB9FV8rbu3owTvfhT9sRB+mEADvI+rNl2IgOMDMvGSmnEs1a3gRF3TMa/ItUMxJR8Nte3psTcudI6K/jBfG0qDmpj7LCoToUM0GSyfhT5ZNzqHGPgPYUrM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895559; c=relaxed/simple;
	bh=2OWak/a6SdkWKc2N0GeJaW/V8OxKw2POiWiBHZn8PFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UHYa7OaWJC04WR4BbgLh9mKxhNXWLbiGyxaJtnid2qfCfJncTWYZe+12Dm59egz8G9QemIFSaGiyqGZZtvEcxX/3DA5jhOvKt5KRnpzsgQSIXeW7l1eX9EI3vi75XWbBIDRmvhmdYrnqKbENMLNrX0uZwJfC1jdUQCiziDbVDbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hVicyinN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hVicyinN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6EAE1F000FF;
	Tue, 13 Oct 2026 12:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895558;
	bh=YgxunlG5qAGU6cYnaNMHGa44aVMigtpUsOkT0Ww7otg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hVicyinNs4gKWdsbDe50QmhUw4dKnTXeNxoMzM+UM/tiaayb7XNBdf2Ei5aDqxIL7
	 WQPV2SYYJHiAA8oqfiNHDRvtpO6wOrZZ8fjW9+w5Y5Q+ibJ0Quzp3B+vzwZpSbiiom
	 bjq9Un/B9Lmb+13r0N0i0kuBZj6VcvozBNbkVqjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 313/497] KVM: arm64: Apply the fine-grained UNDEFs without FEAT_FGT
Date: Tue, 13 Oct 2026 13:38:00 +0200
Message-ID: <20261013112915.332065425@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fuad Tabba <fuad.tabba@linux.dev>

[ Upstream commit 4bdd2b3a708c1feb701cb8b62feb8ad2fd77bb07 ]

FGUs don't actually require hardware support, so don't gate fgt trap
config insertion on FGT. This is the only action required to allow FGUs
always, as kvm_calculate_traps() already computes the FGU bits with or
without FEAT_FGT.

This also fixes a spurious WARN when a TLBI OS is run on a guest in vEL1
without FEAT_TLBIOS on non FEAT_FGT hardware. In this configuration the
course-grained HCR_EL2.TTLBOS trap reaches the handler handle_tlbi_el1(),
which expects an EL1 TLBI only from vEL2. With FGUs enabled the UNDEF
will be injected without needing the specific handler.

Fixes: f5a5a406b4b8b ("KVM: arm64: Propagate and handle Fine-Grained UNDEF bits")
Cc: stable@vger.kernel.org
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Wei-Lin Chang <weilin.chang@arm.com>
Link: https://patch.msgid.link/20260929090031.3829185-2-fuad.tabba@linux.dev
[oliver: Take Wei-Lin's suggested changelog]
Signed-off-by: Oliver Upton <oupton@kernel.org>
[ sashal: adapted the in-loop hardware-check removal to the pre-loop goto check_mcb and its unused label. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 364beb6f27a1d..3d0c786ffa5df 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -1981,9 +1981,6 @@ int __init populate_nv_trap_config(void)
 	kvm_info("nv: %ld coarse grained trap handlers\n",
 		 ARRAY_SIZE(encoding_to_cgt));
 
-	if (!cpus_have_final_cap(ARM64_HAS_FGT))
-		goto check_mcb;
-
 	for (int i = 0; i < ARRAY_SIZE(encoding_to_fgt); i++) {
 		const struct encoding_to_trap_config *fgt = &encoding_to_fgt[i];
 		union trap_config tc;
@@ -2014,7 +2011,6 @@ int __init populate_nv_trap_config(void)
 	kvm_info("nv: %ld fine grained trap handlers\n",
 		 ARRAY_SIZE(encoding_to_fgt));
 
-check_mcb:
 	for (int id = __MULTIPLE_CONTROL_BITS__; id < __COMPLEX_CONDITIONS__; id++) {
 		const enum cgt_group_id *cgids;
 
-- 
2.53.0



