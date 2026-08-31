Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F664A386F;
	Mon, 31 Aug 2026 13:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183750; cv=none; b=tMB79mwftlazu2p36Sv70TtJPrLtYgqLmTTOdgfcYPUwDKXCPgUfK0xssYP1xmj/S47XIDuWKWpI8kOkv1phQoxCHG5bEe306qR/dmsMz1AA+AE30CKMZnCJEklH3Z254FZAxcMTTXU6v1r17k9YmjC2vp72aw7a7S5RtD5BRic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183750; c=relaxed/simple;
	bh=EtWtYA+lSA1slEIGZPcDVLW/k2qxL9q22dB54AOrE1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hzJhGuL6T5nqRZ7bZlXvv+L5N+2U8KVg198iKhV6JHp3GSqW/+u73zCtkrwQN9k3hFsS4i4fpbsu02UK2vn5JWbXZoG0EOiFErF/O8FVlzoiwXI5oPTZlYVHHOG3YfnMnyQF6XZaK5N9xAL8h0BVhp8UxaKwfmUdp+9+dJBvfCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G1CfXc6V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G1CfXc6V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F9731F000E9;
	Mon, 31 Aug 2026 13:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183748;
	bh=R5yHiEuDb0DBe2zuVEMAFPiLavlLS7fFD/y7ObiUKWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G1CfXc6VDULlyX33A/lKMuXiCyIvCPlvrdqLQ7TB7q4NPRs+6igkMBQpcGXhk/Wq5
	 H7pAy7jZoGoDmGcpr3hGLZYexvzALsLKfxQqyvB6PUP6KUuhTrzgniCzLcXHYy9xCY
	 bHzszgHrN2VYDpKk/e57Q4tj7wkXs3i+9X1edo+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.1 29/76] KVM: SEV: Drop FOLL_WRITE for encrypted region registration
Date: Mon, 31 Aug 2026 15:34:01 +0200
Message-ID: <20260831133400.830707885@linuxfoundation.org>
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

From: Pankaj Gupta <pankaj.gupta@amd.com>

commit ee1a586dd1fa2f245b3b753a3e44d9263a49240b upstream.

When pinning SEV guest memory, drop FOLL_WRITE and rely on FOLL_LONGTERM
to break CoW, as *KVM* doesn't actually to the memory using the GUP'd
pages.  Omitting FOLL_WRITE fixes a regression when using file-backed guest
memory that was introduced when KVM (correctly) added FOLL_LONG (e.g. to
ensure anonymous memory is migrated out of MIGRATE_CMA/ZONE_MOVABLE before
a long term pin).

Unfortunately, as of commits:

  8ac268436e6d ("mm/gup: disallow FOLL_LONGTERM GUP-nonfast writing to file-backed mappings")
  a6e79df92e4a ("mm/gup: disallow FOLL_LONGTERM GUP-fast writing to file-backed mappings")

GUP uses FOLL_LONGTERM as a canary of sorts to detect pins that are likely
to be problematic, and disallows WRITE+LONGTERM pins for file-backed memory.
As a result, backing SEV+ guests with file-backed memory, e.g. virtio-pmem,
fails due to the disallowed FOLL_LONGTERM+FOLL_WRITE combination.

Note, in the past, FOLL_WRITE was required to trigger CoW unsharing, to
prevent replacing the page in the (primary MMU's) page tables during a
later write fault after already having pinned a (shared) page in
MAP_PRIVATE mappings.  FOLL_LONGTERM does that nowadays, even without
FOLL_WRITE (see gup_must_unshare()).

Fixes: 7e066cb9b71a ("KVM: SEV: Use long-term pin when registering encrypted memory regions")
Cc: stable@vger.kernel.org
Suggested-by: "David Hildenbrand (Arm)" <david@kernel.org>
Link: https://lore.kernel.org/all/ad784f05-b36c-4e91-9f17-4c5b826735d0@kernel.org/
Signed-off-by: Pankaj Gupta <pankaj.gupta@amd.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Link: https://patch.msgid.link/20260715063626.65899-1-pankaj.gupta@amd.com
[sean: massage changelog, add comment about CoW unsharing]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2771,8 +2771,12 @@ int sev_mem_enc_register_region(struct k
 	if (!region)
 		return -ENOMEM;
 
+	/*
+	 * Do NOT specify FOLL_WRITE, as KVM isn't using the pinned pages to
+	 * write memory, and FOLL_LONGTERM itself triggers CoW unshare.
+	 */
 	region->pages = sev_pin_memory(kvm, range->addr, range->size, &region->npages,
-				       FOLL_WRITE | FOLL_LONGTERM);
+				       FOLL_LONGTERM);
 	if (IS_ERR(region->pages)) {
 		ret = PTR_ERR(region->pages);
 		goto e_free;


