Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1814654B1BA;
	Mon, 31 Aug 2026 13:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183993; cv=none; b=C3N9Buk8NV0F8wyWfZwwBdsYdMZMQFBX2QUD4US2d4XL9zK2sBrySvd9BGEAjjbn9xs2cuZv2jtu+T4xgFzqh2VqcQREn6+PiaStTpEzbH2uXCqm8dOdDZ5h6hLXZSROPnrINYIoo3Fpo11KPBxTxHyGyoyuZHnIMjjdeYcvoc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183993; c=relaxed/simple;
	bh=/qJZCH69IOAmgKvszuJveQoaNZWswUi9Gu81IKYBQos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oi2ZSL9ny/pEf6vHO57TFtB++4ntGN7sZJj46rwzddVfgxGzVP8VMKPQn1Ns33eeebY2rVVg/MGQJtGbwsjUlGvitoWSkQHSgB7DvdNXvyHeJNg2clCSxwLahN7NTDfdM8VUbt2ipc9HWsXgqDWW8U7RLyI7CCvyol+0jNwUOjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xudzuwC7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xudzuwC7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 694AE1F00A3F;
	Mon, 31 Aug 2026 13:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183991;
	bh=zC0fmCjTnCOuCuxAd7fMWmgE3R9udRe0Y26n+r4AAMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xudzuwC7RKtAkgqEc6OOKTyZxSt9IepvWluIgRv813uJwZxHDhMvMa37dcrtRwQuj
	 Zt+DrWwwTYITMc3Wv0YCX6reYUW3/sphZE1JRJ7uSSSFfGT66kS9WdJ4wkb9CoG6n9
	 LVKQNCKJNuvDzYPLwx8nLMjxrXVzvoh2aQvOp+6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinu Kim <kimjw04271234@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 06/83] KVM: x86/mmu: Check write tracking in all address spaces
Date: Mon, 31 Aug 2026 15:33:42 +0200
Message-ID: <20260831133359.516177136@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.207714926@linuxfoundation.org>
References: <20260831133359.207714926@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



