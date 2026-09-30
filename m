Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8EA64E021A;
	Wed, 30 Sep 2026 16:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786920; cv=none; b=qHFX+o/Jw7T4GcF/9P3inIfjUYRD5HblFFiQtHYvZpACmo+n9a2omNLBrgKvaNScL6uuywzy+XL3aEdtde7rrQJNwqiX+4DGYZ1Ub8IuCdu554EeAoha4mhoUAKM1T9NxIUtbFXfnMuFV5197yqk1c8XhekNHX1oQy6dYqQ6hB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786920; c=relaxed/simple;
	bh=KfLLucBRSHG40DKIrC/zp9GatmyQZIqkkBGQdQH5xNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ql/rn6VGSuRzdl3CYSCLR+OWtnnl5jk8YDCwbiU71ZCYMSUTqDGaM+L/tvTmwRwQRX9mQ2l4V1+lKFOHM2QvBpKejTYF3sDSmKhllhmLwp0LQKo3kJM/k6bqr2+R9cLLz7ChlI1X8gTIv8eS4YZBMSrDgYS4seIDoLOoJeg46Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VBDpoFYt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VBDpoFYt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 404BC1F000FF;
	Wed, 30 Sep 2026 16:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786918;
	bh=m/rsfo07LuvwGxuKKLJNzdD4BO0WHhaJc9f7JSuFib8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VBDpoFYtHXmIhmI26jrPI8V6Y/nU8LWTQRRiEd7P2ASFjxtpyP6tILnkOxpkjeKWl
	 6RanfKsGVhXZ0X996ikV2dhIP6O1gBGr5S2xLJpaB4VzK5E/ul0D6/0ebcP9mmMng3
	 8nEW7slYZ3dR7PAkgvNlCTbQL479Wp0TyVnY2c9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Vincent Donnefort <vdonnefort@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 047/457] KVM: arm64: Match hyp text by physical address in fix_host_ownership()
Date: Wed, 30 Sep 2026 17:22:32 +0200
Message-ID: <20260930152347.049816948@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fuad Tabba <fuad.tabba@linux.dev>

[ Upstream commit 5a8b505ede133fb30ca3b3a19d0db00c08237615 ]

On a non-hVHE host, fix_host_ownership_walker()'s test for PAGE_HYP_EXEC
never matches: KVM_PGTABLE_PROT_UX is cleared at map time and only PX is
reported on read-back. Hyp text is therefore donated rather than left
read-only in the host stage-2, and the instruction dump in
nvhe_hyp_panic_handler() reads a page the host has no access to.

Match the text by physical address instead, in a helper a later patch
reuses. A test on the permissions would leave any other executable
mapping host-readable too.

Fixes: 80cbfd7174f31 ("KVM: arm64: Honor UX/PX attributes for EL2 S1 mappings")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Tested-by: Vincent Donnefort <vdonnefort@google.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://patch.msgid.link/20260908110713.1540304-3-fuad.tabba@linux.dev
Signed-off-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h | 1 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 8 ++++++++
 arch/arm64/kvm/hyp/nvhe/setup.c               | 2 +-
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 29935c7da1dec..cab27f7bd423a 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -52,6 +52,7 @@ int __pkvm_host_test_clear_young_guest(u64 gfn, u64 nr_pages, bool mkold, struct
 int __pkvm_host_mkyoung_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu);
 
 bool addr_is_memory(phys_addr_t phys);
+bool addr_is_hyp_text(phys_addr_t phys);
 int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
 int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id);
 int kvm_host_prepare_stage2(void *pgt_pool_base);
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 4e329e39a695a..7a99361306426 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -443,6 +443,14 @@ bool addr_is_memory(phys_addr_t phys)
 	return !!find_mem_range(phys, &range);
 }
 
+bool addr_is_hyp_text(phys_addr_t phys)
+{
+	phys_addr_t start = ALIGN_DOWN(__hyp_pa(__hyp_text_start), PAGE_SIZE);
+	phys_addr_t end = PAGE_ALIGN(__hyp_pa(__hyp_text_end));
+
+	return phys >= start && phys < end;
+}
+
 static bool is_in_mem_range(u64 addr, struct kvm_mem_range *range)
 {
 	return range->start <= addr && addr < range->end;
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 75b00c3233102..1bdb952c662b1 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -217,7 +217,7 @@ static int fix_host_ownership_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	case PKVM_PAGE_OWNED:
 		set_hyp_state(page, PKVM_PAGE_OWNED);
 		/* hyp text is RO in the host stage-2 to be inspected on panic. */
-		if (prot == PAGE_HYP_EXEC) {
+		if (addr_is_hyp_text(phys)) {
 			set_host_state(page, PKVM_NOPAGE);
 			return host_stage2_idmap_locked(phys, PAGE_SIZE, KVM_PGTABLE_PROT_R);
 		} else {
-- 
2.53.0



