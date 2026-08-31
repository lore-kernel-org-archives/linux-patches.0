Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F3C47A0D1;
	Mon, 31 Aug 2026 13:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184472; cv=none; b=N7MxsYUbQHGPBB4n788v+OlYE42FwUjro4jLQH96x5R7tzdiAIxtSRjBWVfBem2fpjPyXEQ89zsoBPDqxxv6JwiZZGTdfxfUL2NJYTKLNrZAKiuREyDsUZtBrEaqen1lmUnGnOyDcUE8R1EtvWS7O08DcDHmy2HNJRWs/4ZzG1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184472; c=relaxed/simple;
	bh=LcQ+8QKbNNvxE2RH5Bq4hX+kbTHtDHYz0+GWyKR1/ME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sdXBn5K8JJvw8g+lu+9ydkPIT36/ZHeht3BIBqV2qCtC3okjc243/EedaQfezpowBVRnVvEWi270P/RbD0uClx3Y/okYOwgaXK8Kbc0AtVIxTZ2gFEzthQDrAotCpeZ7tujzk0pw63cJCM7Iv0StLGXVT6sdwWCTHC8TOxu6bt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=csd8bnMc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="csd8bnMc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92B511F000E9;
	Mon, 31 Aug 2026 13:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184471;
	bh=5HbCOmCz1JdemJf3zdkbTUn5Dj0aWfSmJPVW8vItUxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=csd8bnMcOWludm/KHQOzfVJsjO2+VzH0VZZpxy+Y5+4hGowJxz7GvYSu8xGPx4Zvu
	 Njzb6WIstfLk9VgTxySKcMBRc7F+4/z9+egKHktgVt+CxdFRmuDoWNCbfzengylZnd
	 KVHCBlsQrMbdpfGYLtPzxvHFres7KtiSx/BDMTNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinu Kim <kimjw04271234@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 02/91] KVM: x86/mmu: Check write tracking in all address spaces
Date: Mon, 31 Aug 2026 15:33:50 +0200
Message-ID: <20260831133359.585006212@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.468089036@linuxfoundation.org>
References: <20260831133359.468089036@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinu Kim <kimjw04271234@gmail.com>

commit 0f38453cdb2e17566ccb7c0f3dabd5bd21caca26 upstream.

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
[ artem: adapt to 6.6, which has neither KVM_MAX_NR_ADDRESS_SPACES nor
  kvm_arch_nr_memslot_as_ids(); use KVM_ADDRESS_SPACE_NUM instead. That
  macro is CONFIG_KVM_SMM-conditional in 6.6, so the guard on
  KVM_ADDRESS_SPACE_NUM > 1 around the peer-slot lookup is retained ]
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/page_track.c | 32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index c87da11f3a049..2615074a4bffe 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -117,13 +117,23 @@ void __kvm_write_track_remove_gfn(struct kvm *kvm,
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
@@ -131,8 +141,18 @@ bool kvm_gfn_is_write_tracked(struct kvm *kvm,
 	if (!kvm_page_track_write_tracking_enabled(kvm))
 		return false;
 
-	index = gfn_to_index(gfn, slot->base_gfn, PG_LEVEL_4K);
-	return !!READ_ONCE(slot->arch.gfn_write_track[index]);
+	BUILD_BUG_ON(KVM_ADDRESS_SPACE_NUM > 2);
+
+	if (__kvm_gfn_is_write_tracked(slot, gfn))
+		return true;
+
+	if (KVM_ADDRESS_SPACE_NUM > 1) {
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



