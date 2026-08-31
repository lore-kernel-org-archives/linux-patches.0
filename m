Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06FEA47CC97;
	Mon, 31 Aug 2026 13:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184735; cv=none; b=a0r7GjajX/UDhudcWVpFAG8i9jnzlvD2RqtJp/0k19xOknctrwPaclFfkVfCRsItRu9p9/VkiLPPSswZA44gJROgUkB+0DGRJR61pcxCQGy9AWFN36yQooUHfEtCR17PBKlo+5FlXljGMWGcTNWuLXSxFqt6KFspQvYRIUvh4+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184735; c=relaxed/simple;
	bh=EEMaq+hlw38/f6uZi1OOTr2CBz4KJjiVVaCqebd/C3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iFFXIFL8JpGhcanQJfk20KQSPjF01qqG9eSOgQ9Uxve676WkrMpetTCwgvL+G3ShIlM9m94TlU3xI1cEC+DvFPXttJGszWnB6g1UaTm/C6/nCcTmVSh6A/Ar5k0/J5d00/v4GPDt3NZCI/S3U/h2FA1vYIMSbEhXK+IhidAmXUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=poxFhVLX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="poxFhVLX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 624D91F00A3D;
	Mon, 31 Aug 2026 13:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184733;
	bh=gi95rRgcV9UIDUTdoLQw7kAuCO/H0epEwle+4LgidCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=poxFhVLXLETvAf30xqzKLSxoK17eVO4Dm0tfpu87j7pbpjDFWq1km/NZuRw04WQ02
	 JQHbT1M+YUCy2+KjZTRJwvLxeRCHGjs5MLhKtjMJ2poCQANO9BMQ1Ekjp4PQEIBD+J
	 90FIy+rzTLMjhxeYiKi8eOdMyNCKqbXqzST3vZ4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinu Kim <kimjw04271234@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 03/92] KVM: x86/mmu: Check write tracking in all address spaces
Date: Mon, 31 Aug 2026 15:34:01 +0200
Message-ID: <20260831133359.644516155@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.482388899@linuxfoundation.org>
References: <20260831133359.482388899@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ artem: adapt to 6.1's kvm_slot_page_track_is_active() and mode-indexed
  gfn_track[]; KVM_ADDRESS_SPACE_NUM is unconditionally 2 on x86 in 6.1,
  so the peer-slot lookup needs no guard ]
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/page_track.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index 2e09d1b6249f3..51d5a912c5539 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -171,14 +171,25 @@ void kvm_slot_page_track_remove_page(struct kvm *kvm,
 }
 EXPORT_SYMBOL_GPL(kvm_slot_page_track_remove_page);
 
-/*
- * check if the corresponding access on the specified guest page is tracked.
- */
+static bool __kvm_slot_page_track_is_active(const struct kvm_memory_slot *slot,
+					    gfn_t gfn,
+					    enum kvm_page_track_mode mode)
+{
+	int index;
+
+	if (!slot)
+		return false;
+
+	index = gfn_to_index(gfn, slot->base_gfn, PG_LEVEL_4K);
+	return !!READ_ONCE(slot->arch.gfn_track[mode][index]);
+}
+
+/* check if write access is tracked on the specified guest page. */
 bool kvm_slot_page_track_is_active(struct kvm *kvm,
 				   const struct kvm_memory_slot *slot,
 				   gfn_t gfn, enum kvm_page_track_mode mode)
 {
-	int index;
+	const struct kvm_memory_slot *other_slot;
 
 	if (WARN_ON(!page_track_mode_is_valid(mode)))
 		return false;
@@ -190,8 +201,13 @@ bool kvm_slot_page_track_is_active(struct kvm *kvm,
 	    !kvm_page_track_write_tracking_enabled(kvm))
 		return false;
 
-	index = gfn_to_index(gfn, slot->base_gfn, PG_LEVEL_4K);
-	return !!READ_ONCE(slot->arch.gfn_track[mode][index]);
+	BUILD_BUG_ON(KVM_ADDRESS_SPACE_NUM > 2);
+
+	if (__kvm_slot_page_track_is_active(slot, gfn, mode))
+		return true;
+
+	other_slot = __gfn_to_memslot(__kvm_memslots(kvm, slot->as_id ^ 1), gfn);
+	return __kvm_slot_page_track_is_active(other_slot, gfn, mode);
 }
 
 void kvm_page_track_cleanup(struct kvm *kvm)
-- 
2.53.0



