Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89DD8574091;
	Mon, 31 Aug 2026 13:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184135; cv=none; b=jHUCdi6csgr0D0fOg7gj8j3G2JXfYzRZbpNA9Th+tUdJjz8/UEoaLBkxKG5SZXBdaVgCa4zl5LNb8P4blezFaMmdvH9JzdG0g2S++cOZS7jazON5TmVRR7ZnCLYeqeZ8Z9ZW7lY63fEstKUaOGNvTutXaltDw/+8nN3roxHhlYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184135; c=relaxed/simple;
	bh=Z+qLyLYgglfVAt0jry9Eu1QDTx7t/YHqoOh3IB5+CHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RzBevP1X1URqjOzmkHF3ve5dlQuEcRYEy1l6fS2YywJjeMImZlwa8xt41Laq02/GnlMMcB/IIgJGBQIj9Tb7OJH4oUgS/WfkotN+HrFAiVbbsRYE/ahcMCipYc8rZhCqeC55Lt/jvGCr4VsP4VC5MOTrH2FHD/H3iQzSZkmlEmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rHQQbFnQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rHQQbFnQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E37F01F00A3E;
	Mon, 31 Aug 2026 13:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184133;
	bh=3pS4dbfaPcajqzTjq75JwK/8efZslqsTetVbb8BsVt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rHQQbFnQXNOOhLwY0MHbEDsz73oDP5cgRrV0XZmK1Rh7ay6r87u2j6tlGsScUfd2k
	 431vp5EoxgtEF2ni1N1sIfi7rRQycJDIgRdNHTv3w3CyvoRV0aa8E5Q/Kk64/WUcNJ
	 PMo2xdBp7a4I460cZQl8F1D6qOnFK/ZOm6zRC79E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 40/83] KVM: SEV: Drop FOLL_WRITE for encrypted region registration
Date: Mon, 31 Aug 2026 15:34:16 +0200
Message-ID: <20260831133401.558326831@linuxfoundation.org>
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
@@ -2727,8 +2727,12 @@ int sev_mem_enc_register_region(struct k
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


