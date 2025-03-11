Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C641A5BA4;
	Tue, 11 Mar 2025 15:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706800; cv=none; b=sTQsm5ZiBKjTqAVRQ7xi2FPTU4x9QtFGwrJVAqrrws7vq/xLa7V+nqEcVsSN18KdgOYh8kqnTX8sjBhJftCjSq2bs/mdumvA69HI9gBrZb8iwDomEL5l4v0RYo7RZbuKMFrRE0rLwLxfl9Qlp769Ngie9k2Cm+asLN6v/yOWSPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706800; c=relaxed/simple;
	bh=GIxytDoFBcafkV8wGFs01uTHgYNWPTLDjAShGlgqRD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tZYDpR/eT+ffODzto7deDzfT681K46PF/CIK9ke2paKyvjf2lcZHd60mtSd2U1Al7ca3gSqqrOGxXX0U//Y0uF0+x+hw/nuMjx/AdG06GNu5xoezCWOIg6zgTBTTBhnQ0vJ7w1VpUq9lea1rX9UNigiWKWnAabi1E3WlmkCBspI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=llUCANty; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="llUCANty"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD00FC4CEEA;
	Tue, 11 Mar 2025 15:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706800;
	bh=GIxytDoFBcafkV8wGFs01uTHgYNWPTLDjAShGlgqRD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=llUCANtywTqdg85e/nCtyLoE5Rtp1pNtqGXRMF2P79pdv6KSYUkpMvslwouDq7Cc5
	 qaQ5ehyd3AKE4JT9sigrEM4ft280GQaEeB9GST+N+CA2U2cudjsnapnPYcotsGJbMD
	 6lWpNJ7dxFnaxkU07gulFSkEZoAWnlC2ARySPNsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Christoph Schlameuss <schlameuss@linux.ibm.com>
Subject: [PATCH 5.10 171/462] KVM: s390: vsie: fix some corner-cases when grabbing vsie pages
Date: Tue, 11 Mar 2025 15:57:17 +0100
Message-ID: <20250311145805.110998296@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand <david@redhat.com>

commit 5f230f41fdd9e799f43a699348dc572bca7159aa upstream.

We try to reuse the same vsie page when re-executing the vsie with a
given SCB address. The result is that we use the same shadow SCB --
residing in the vsie page -- and can avoid flushing the TLB when
re-running the vsie on a CPU.

So, when we allocate a fresh vsie page, or when we reuse a vsie page for
a different SCB address -- reusing the shadow SCB in different context --
we set ihcpu=0xffff to trigger the flush.

However, after we looked up the SCB address in the radix tree, but before
we grabbed the vsie page by raising the refcount to 2, someone could reuse
the vsie page for a different SCB address, adjusting page->index and the
radix tree. In that case, we would be reusing the vsie page with a
wrong page->index.

Another corner case is that we might set the SCB address for a vsie
page, but fail the insertion into the radix tree. Whoever would reuse
that page would remove the corresponding radix tree entry -- which might
now be a valid entry pointing at another page, resulting in the wrong
vsie page getting removed from the radix tree.

Let's handle such races better, by validating that the SCB address of a
vsie page didn't change after we grabbed it (not reuse for a different
SCB; the alternative would be performing another tree lookup), and by
setting the SCB address to invalid until the insertion in the tree
succeeded (SCB addresses are aligned to 512, so ULONG_MAX is invalid).

These scenarios are rare, the effects a bit unclear, and these issues were
only found by code inspection. Let's CC stable to be safe.

Fixes: a3508fbe9dc6 ("KVM: s390: vsie: initial support for nested virtualization")
Cc: stable@vger.kernel.org
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Tested-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Message-ID: <20250107154344.1003072-2-david@redhat.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kvm/vsie.c |   25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -1316,8 +1316,14 @@ static struct vsie_page *get_vsie_page(s
 	page = radix_tree_lookup(&kvm->arch.vsie.addr_to_page, addr >> 9);
 	rcu_read_unlock();
 	if (page) {
-		if (page_ref_inc_return(page) == 2)
-			return page_to_virt(page);
+		if (page_ref_inc_return(page) == 2) {
+			if (page->index == addr)
+				return page_to_virt(page);
+			/*
+			 * We raced with someone reusing + putting this vsie
+			 * page before we grabbed it.
+			 */
+		}
 		page_ref_dec(page);
 	}
 
@@ -1347,15 +1353,20 @@ static struct vsie_page *get_vsie_page(s
 			kvm->arch.vsie.next++;
 			kvm->arch.vsie.next %= nr_vcpus;
 		}
-		radix_tree_delete(&kvm->arch.vsie.addr_to_page, page->index >> 9);
+		if (page->index != ULONG_MAX)
+			radix_tree_delete(&kvm->arch.vsie.addr_to_page,
+					  page->index >> 9);
 	}
-	page->index = addr;
-	/* double use of the same address */
+	/* Mark it as invalid until it resides in the tree. */
+	page->index = ULONG_MAX;
+
+	/* Double use of the same address or allocation failure. */
 	if (radix_tree_insert(&kvm->arch.vsie.addr_to_page, addr >> 9, page)) {
 		page_ref_dec(page);
 		mutex_unlock(&kvm->arch.vsie.mutex);
 		return NULL;
 	}
+	page->index = addr;
 	mutex_unlock(&kvm->arch.vsie.mutex);
 
 	vsie_page = page_to_virt(page);
@@ -1448,7 +1459,9 @@ void kvm_s390_vsie_destroy(struct kvm *k
 		vsie_page = page_to_virt(page);
 		release_gmap_shadow(vsie_page);
 		/* free the radix tree entry */
-		radix_tree_delete(&kvm->arch.vsie.addr_to_page, page->index >> 9);
+		if (page->index != ULONG_MAX)
+			radix_tree_delete(&kvm->arch.vsie.addr_to_page,
+					  page->index >> 9);
 		__free_page(page);
 	}
 	kvm->arch.vsie.page_count = 0;


