Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C98503BF4;
	Mon, 31 Aug 2026 13:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183726; cv=none; b=P6xlX2+Gwa01d+b3aDt6E8MhaQNGLmhhZh3QKqLYmtrp4CPrTWAQGpJl3DVyAmLhNTglP5dieit67CdAM11KyrJib2KsbRS1ezm10UWgX/prf+ze7ivdRmSMy1buUDAFATccET2YRgDhyPL6Vpp7M/EXMhoFEPp/ON/VqscMdAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183726; c=relaxed/simple;
	bh=vMm7UUb0Mnr6ccdNQWHISyFs+xeiZ36VCO57Wrz8nz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e83G+s2opwBm6w7uhHmbrJtOoAPaZcB4Hf+Y1SwH3dXFPm3knabVzG/zL01rjbcO3asc7zjXXo/58gX2evDfWY6qF21NQ+XV4QXBjfaexxxZcujVVpxJG/i+FJ5b3DNJbed7IRZ0UhAUEUd4kqqd+Xg0gcITZa5y6W7pzYSfqtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DJtWehpR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DJtWehpR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B8561F00ACA;
	Mon, 31 Aug 2026 13:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183725;
	bh=xMKAe1SD028aL2Yey44yr5vTwzZP8Uo+++VFvvbBd8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DJtWehpRkr1SYXOe05dlo7sNmYhsulsGLgTc+IsKi3JxAy8mYhF98It3X2bMjWAMD
	 gXKtyQj9HTu+uydO6eac8F74jxfIYntgrLG+zueESwqlykwBetG2pv71lxttNFvKTL
	 TYsylD3zvwPVys7anz3X3blxKTiijUweQoKmAUVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinu Kim <kimjw04271234@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 04/76] KVM: x86/mmu: Check write tracking in all address spaces
Date: Mon, 31 Aug 2026 15:33:36 +0200
Message-ID: <20260831133359.401437472@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.185608553@linuxfoundation.org>
References: <20260831133359.185608553@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinu Kim <kimjw04271234@gmail.com>

[ Upstream commit 0f38453cdb2e17566ccb7c0f3dabd5bd21caca26 ]

kvm_gfn_is_write_tracked() checks only the supplied memslot, but page
tracking is per-address-space and shadow pages are shared across all
address spaces.  With SMM, a GFN can therefore be write-tracked in one
address space and appear untracked through the other.

Check the supplied slot first, then the slot for the other address space.
This ensures all callers honor write tracking regardless of the active
address space.  In particular, it prevents mmu_try_to_unsync_pages() from
marking an upper-level shadow page unsync and eventually triggering the
BUG in pte_list_remove().

Fixes: 699023e23965 ("KVM: x86: add SMM to the MMU role, support SMRAM address space")
Assisted-by: Codex:GPT-5
Signed-off-by: Jinu Kim <kimjw04271234@gmail.com>
Message-ID: <20260721103512.2136240-2-kimjw04271234@gmail.com>
[invert direction of the conditional. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/page_track.c | 32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index 1b17b12393a8c..7e8195a311bb0 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -130,13 +130,23 @@ void __kvm_write_track_remove_gfn(struct kvm *kvm,
 	kvm_mmu_gfn_allow_lpage(slot, gfn);
 }
 
-/*
- * check if the corresponding access on the specified guest page is tracked.
- */
+static bool __kvm_gfn_is_write_tracked(const struct kvm_memory_slot *slot,
+				       gfn_t gfn)
+{
+	int index;
+
+	if (!slot)
+		return false;
+
+	index = gfn_to_index(gfn, slot->base_gfn, PG_LEVEL_4K);
+	return !!READ_ONCE(slot->arch.gfn_write_track[index]);
+}
+
+/* check if write access is tracked on the specified guest page.  */
 bool kvm_gfn_is_write_tracked(struct kvm *kvm,
 			      const struct kvm_memory_slot *slot, gfn_t gfn)
 {
-	int index;
+	const struct kvm_memory_slot *other_slot;
 
 	if (!slot)
 		return false;
@@ -144,8 +154,18 @@ bool kvm_gfn_is_write_tracked(struct kvm *kvm,
 	if (!kvm_page_track_write_tracking_enabled(kvm))
 		return false;
 
-	index = gfn_to_index(gfn, slot->base_gfn, PG_LEVEL_4K);
-	return !!READ_ONCE(slot->arch.gfn_write_track[index]);
+	BUILD_BUG_ON(KVM_MAX_NR_ADDRESS_SPACES > 2);
+
+	if (__kvm_gfn_is_write_tracked(slot, gfn))
+		return true;
+
+	if (kvm_arch_nr_memslot_as_ids(kvm) > 1) {
+		other_slot = __gfn_to_memslot(__kvm_memslots(kvm, slot->as_id ^ 1), gfn);
+		if (__kvm_gfn_is_write_tracked(other_slot, gfn))
+			return true;
+	}
+
+	return false;
 }
 
 #ifdef CONFIG_KVM_EXTERNAL_WRITE_TRACKING
-- 
2.53.0



