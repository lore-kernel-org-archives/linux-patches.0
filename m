Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9526511225;
	Wed, 30 Sep 2026 18:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792523; cv=none; b=DD1LUGxGlQ1pH/Tpxv2rVVjS4L8gTAgqVSqm2IvFp0+OM3jXA0CXxc6yTuo9udVL5sv+5/eIXNcOAyGb/Sh3ZDAaW4motBBnqMD6DoQi4TFym2D+1iROMS2Dcp9X8egluAAifPCTILiBvJgHrXBzNDhBjUPTJK8a20YKJLifiZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792523; c=relaxed/simple;
	bh=WVdeZWkcUlMDf+UR6vShYGVWDsdKmQP4Ml+xrgaBXps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mquHT6MwCeoZHr9IXVeaIO20uypYodeLNF+o6SLqrfdXbREuHLFqSzLnQjQnKNITLAX0rTPLd0fRj5NzMsLmBLQjJSJjCYxSzFQTLmNrtIKzlkFKk7CGCUYCk0VICcHwW7Iq1bbxBCbXGPUBADoGI6jdV/skNXdT4KTRt0CaXXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QRx+KB4L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QRx+KB4L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69E001F000FF;
	Wed, 30 Sep 2026 18:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792522;
	bh=2Zw01a76ANtO/XHMkTMSGWBetINsCdXYWGneMG0dGrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QRx+KB4LtBzhxhRZjwCDiSwWbLzc6G4F8lobxDu58Ec0e5gCUcGWeM4y79hsqF4yI
	 OADZbGKPAsrzVmRNwbi7Lr66nP37lvDfLL8i+TiGlwGBxaFjCjWzaXtUAWySGNjO6T
	 GDknAAZgqDXi+RnH7ZuJvcR9pNoWKPx+lx7Xc3xc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lai Jiangshan <laijs@linux.alibaba.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Kenta Akagi <k@mgml.me>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 684/752] KVM: X86: Remove useless code to set role.gpte_is_8_bytes when role.direct
Date: Wed, 30 Sep 2026 17:29:14 +0200
Message-ID: <20260930152413.043236603@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lai Jiangshan <laijs@linux.alibaba.com>

commit 41e35604eaff2266ba8523787ebe99c5ca4c4045 upstream.

role.gpte_is_8_bytes is unused when role.direct; there is no
point in changing a bit in the role, the value that was set
when the MMU is initialized is just fine.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
Message-Id: <20211118110814.2568-14-jiangshanlai@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Kenta Akagi <k@mgml.me>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/mmu.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 9f193b1620a95..f6ad81b5e6377 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2093,8 +2093,6 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	role = vcpu->arch.mmu->mmu_role.base;
 	role.level = level;
 	role.direct = direct;
-	if (role.direct)
-		role.gpte_is_8_bytes = true;
 	role.access = access;
 	if (!direct_mmu && vcpu->arch.mmu->root_level <= PT32_ROOT_LEVEL) {
 		quadrant = gaddr >> (PAGE_SHIFT + (PT64_PT_BITS * level));
-- 
2.53.0



