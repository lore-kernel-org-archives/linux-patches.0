Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E0183AEB29;
	Sat, 17 Oct 2026 16:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255612; cv=none; b=SbkgGg4T6P0Uv/AnPAB2QUJvoIy1L5KopSMuC4CF9i+e0yBdF2F1KdHp8RlASukj/w9J+a0mbsRPBiNjjDUX7QpRq8/Fbl/fBI/FnZkCzkJVAM/jPZdMvlOunn3IgEYxm1Op6kdZv8J0jQ8+4sh/Uja7f2PetdnsxLpPlOA5Fr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255612; c=relaxed/simple;
	bh=BhJSGrC7a1jXt2y932AmXFNP6sqCbM7IzsISIbxM0t4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PGV45kAjc+TRi2SZtoxhNEvKEO+OUn8jf27/VgpE9PjiFKEh6tWLaWu112mYMDsDDI5eaRpYDUuRTKCx5tvbNxkRR/MvLHEpK18QZwlhjWqUpH8Aqg7rng86itSP+QJISlGVjnOS2IuP8Q4tsqwmNFtaRPpGuwAvr6tmywo2dfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DbUIT2IY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DbUIT2IY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AE871F000C4;
	Sat, 17 Oct 2026 16:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255610;
	bh=+QdSPJodRtEeVJvqTg9hOKzats25SFhY20QACJI2008=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DbUIT2IYILx7rpYveG0RGwrp7ZVPm3o7jWyKVSe/iPhELZybYlh4uFvWxCrHDRMN3
	 8Es5LswoW3EdQ90f1EKy1XIlMm7CmtdGbgSU1v0u85mmhv66ZaERW93FZL47sZQE8n
	 8gfLAwnA/edpJ9UVx9rGKrCb58YP43yt5pbHK1dc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 831/869] KVM: SEV: Drop FOLL_WRITE for encrypted region registration
Date: Sat, 17 Oct 2026 18:01:12 +0200
Message-ID: <20261017160058.182996344@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Pankaj Gupta <pankaj.gupta@amd.com>

[ Upstream commit ee1a586dd1fa2f245b3b753a3e44d9263a49240b ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/sev.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 02d2bd78f8e7b..c086040ef11d1 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2719,8 +2719,12 @@ int sev_mem_enc_register_region(struct kvm *kvm,
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
-- 
2.53.0



