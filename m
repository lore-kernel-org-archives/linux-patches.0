Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59A17D3E0;
	Mon,  8 Apr 2024 13:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582690; cv=none; b=bkQjDVY05TfTt4OABce7v0nWAMjuJ5VLvCzlF9VJ7yyQHuRmA5cmSbLaCWfXF6Ivsa71h8Dy8mQ/ofNucfoPxb0Gy59iCJ+obOdJfHCr2e9wzObSI8QBrgT+whwbH6ctaCW4XasWPJEbZu1GPQzyY2m1knStf4NvYIx3j77zw2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582690; c=relaxed/simple;
	bh=rkzLRix5ibMLZMekAGAT1KgX7aL4nqHx9MkRoh8BByI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZETl9dyGzOAv3foGrzHtTjKrHamdJC63qa+AZ1TUZ5A4LHvgvIDZOY71RuWarkWB4Nqu38PoZIQDdlXs8t2QAmHXbVj3lKSpMX1RW+Wnwecg5aIp9ae1/3oxNifAJ1AkbH6JkytCCIrpBTSS1+BcvaMlkxTE49b2cO6/9NjheyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b8VrDprN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b8VrDprN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44704C433C7;
	Mon,  8 Apr 2024 13:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582690;
	bh=rkzLRix5ibMLZMekAGAT1KgX7aL4nqHx9MkRoh8BByI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b8VrDprNtitaHXfPV97KOo0jrz6PB9GfO/nTXCjz5o/isPC1qztayNgSHXWjuzR1/
	 tXXOa6zE3rVJWU7CRuKEE05K7t7y6/xIqkWfVNhprKcpOGmkFPXERI7ldwMsMTznAZ
	 RhoMA0YBg3/UrFvo7dDjakgqm4CI1OATN/I3hLsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Will Deacon <will@kernel.org>,
	Shaoqin Huang <shahuang@redhat.com>
Subject: [PATCH 6.8 096/273] KVM: arm64: Use TLBI_TTL_UNKNOWN in __kvm_tlb_flush_vmid_range()
Date: Mon,  8 Apr 2024 14:56:11 +0200
Message-ID: <20240408125312.280258650@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will@kernel.org>

commit 0f0ff097bf77663b8d2692e33d56119947611bb0 upstream.

Commit c910f2b65518 ("arm64/mm: Update tlb invalidation routines for
FEAT_LPA2") updated the __tlbi_level() macro to take the target level
as an argument, with TLBI_TTL_UNKNOWN (rather than 0) indicating that
the caller cannot provide level information. Unfortunately, the two
implementations of __kvm_tlb_flush_vmid_range() were not updated and so
now ask for an level 0 invalidation if FEAT_LPA2 is implemented.

Fix the problem by passing TLBI_TTL_UNKNOWN instead of 0 as the level
argument to __flush_s2_tlb_range_op() in __kvm_tlb_flush_vmid_range().

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Fixes: c910f2b65518 ("arm64/mm: Update tlb invalidation routines for FEAT_LPA2")
Signed-off-by: Will Deacon <will@kernel.org>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20240327124853.11206-4-will@kernel.org
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/hyp/nvhe/tlb.c |    3 ++-
 arch/arm64/kvm/hyp/vhe/tlb.c  |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/arch/arm64/kvm/hyp/nvhe/tlb.c
+++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
@@ -154,7 +154,8 @@ void __kvm_tlb_flush_vmid_range(struct k
 	/* Switch to requested VMID */
 	__tlb_switch_to_guest(mmu, &cxt, false);
 
-	__flush_s2_tlb_range_op(ipas2e1is, start, pages, stride, 0);
+	__flush_s2_tlb_range_op(ipas2e1is, start, pages, stride,
+				TLBI_TTL_UNKNOWN);
 
 	dsb(ish);
 	__tlbi(vmalle1is);
--- a/arch/arm64/kvm/hyp/vhe/tlb.c
+++ b/arch/arm64/kvm/hyp/vhe/tlb.c
@@ -171,7 +171,8 @@ void __kvm_tlb_flush_vmid_range(struct k
 	/* Switch to requested VMID */
 	__tlb_switch_to_guest(mmu, &cxt);
 
-	__flush_s2_tlb_range_op(ipas2e1is, start, pages, stride, 0);
+	__flush_s2_tlb_range_op(ipas2e1is, start, pages, stride,
+				TLBI_TTL_UNKNOWN);
 
 	dsb(ish);
 	__tlbi(vmalle1is);


