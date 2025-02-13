Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67ABC26B0B4;
	Thu, 13 Feb 2025 15:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460385; cv=none; b=Dk16izTJ89P6IJUG6OD2N25euVJJFT8texOilNv5byivqoXOS4aG85rTcDf028E7ku9RlTU9bo5JQfT51TMxHGY77YOZlG2akTGGXy9Np3jX5LdPtfmThHUOfWNf3Vud51vGuSP6qrOU1Mk/vzLIxJ5HAGsKZeZAsiU2NZVzZf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460385; c=relaxed/simple;
	bh=+aBNxAQAw/0oHSnTrp+L3DfkBZFMFeJc0wW0Chd42Ko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PZmRl9LXOFfo/bVVjpt0OYealh+YMJiFtdbbagSE6GycGmTVcsfrXUdD6FxpFE460ec2E+vOIT/t0BmgoupCPD6sM5CCRAx8JEIav8LEWAGoSBx0Sq5ymwIA2Gv8bEcM8Zd31T0YORUeK6ajLonpE21iRJ+3GIyPo9ksbTaZWv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dAJ++fic; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dAJ++fic"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E4DC4CED1;
	Thu, 13 Feb 2025 15:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460384;
	bh=+aBNxAQAw/0oHSnTrp+L3DfkBZFMFeJc0wW0Chd42Ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dAJ++fic6lLPgyWniSUwKwd7KAm5rU7/JTTVAey/FaJMyVXUBN/69KSJLgRto4Pc8
	 UKWLoWMZa8tvcxXHMJFeNJxGX8q1TMQwi2RoM659VvkQVUMNSPak2IsGOeUniYEmh8
	 2pq9LoEOOXjtFzDqqA1uBlXfyj3/WGLf0zbHDNmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Christoph Schlameuss <schlameuss@linux.ibm.com>
Subject: [PATCH 6.6 095/273] KVM: s390: vsie: fix some corner-cases when grabbing vsie pages
Date: Thu, 13 Feb 2025 15:27:47 +0100
Message-ID: <20250213142411.096679716@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1335,8 +1335,14 @@ static struct vsie_page *get_vsie_page(s
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
 
@@ -1366,15 +1372,20 @@ static struct vsie_page *get_vsie_page(s
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
@@ -1467,7 +1478,9 @@ void kvm_s390_vsie_destroy(struct kvm *k
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


