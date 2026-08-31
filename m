Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5629548D87C;
	Mon, 31 Aug 2026 13:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183507; cv=none; b=QXXbLMcn+U1UZPWKG3NEI6tjPnXu+ltXUbnyl2DRjyPfUwPqHbQuWue94q4DdgpbjAK1bP9CZNYyPL6fiiw99GCUeRBkLZBHs+KSJdWDkR3qEHVTYiL6g4hfZxBT6F3sA3ipU29RFixn898py8ZjvK8AsqlarTWjsl6XTgdMLnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183507; c=relaxed/simple;
	bh=Jkkr/RcpbFDBxCqUZLXoC7CWWK95PGTaIEpGh3cdfSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DQPtte2jNP65zLAFS0lxHjpNJQTPxwr7lHR5+Mw/ShSRQfd3mGXpotAbtrwjcyJCmaUATNhq9/D7eDtShFRlW+WymW+iv16cXyVG8SH58k+p8BeAuXXsc/9VU8rHxMcpd1egt2VHzB/zh1qpuogdcandovE4QtpqBosQGUHFMGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gr4Ve5bD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gr4Ve5bD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 768CB1F00A3D;
	Mon, 31 Aug 2026 13:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183505;
	bh=x54gOZL8ZyaLYvWP5XvqcnbXVu8BFRbiFH8MssxQoJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gr4Ve5bDOu7RUIGFk6wBsPAgz8u7tP47KtrVTZSXDcyq3I7FxlE7U41b+2k0ADnSq
	 H3hsNOQMUQ0DnNySI9wTRqShm34Exfy7hgMnznF8WuIP9MLIJlX/ZcZpe2h9sI+cOo
	 w8e6mnRkFna+0ZI54I9wIcwYNNZlfl0oDYucbsYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.2 21/71] KVM: SEV: Drop FOLL_WRITE for encrypted region registration
Date: Mon, 31 Aug 2026 15:33:46 +0200
Message-ID: <20260831133400.142862364@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.055927882@linuxfoundation.org>
References: <20260831133359.055927882@linuxfoundation.org>
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
@@ -2776,8 +2776,12 @@ int sev_mem_enc_register_region(struct k
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


