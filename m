Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B646B676;
	Mon, 23 Jun 2025 22:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717070; cv=none; b=NRmh5tyWqps5HscnYlPYZTSFtL4rshbi+efRJwx1pDWfOXzXczyLlXXZH47am21PZPmbFnOWQohpW37Fy/N/U3/o0bdD3bzYleoqueYGC9HKecSf//6IKmXn/wYIhEqYNFbLqgYfhicuSQPpS5FjukYpRgSBDfZOMhIrT3yNU/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717070; c=relaxed/simple;
	bh=w5VP1NNyut4C7ZnWQf0DGSnqOiTDeWQ/5VcRjX2CHZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WVY+F6UQvdv81p3Bk6XwwNsRQu6SvVojq58yO9KBZq+3b8ObBPlDq9QkqIrH6bG6Bm5K1X1lR+homObDcXBlS1uj5Wd5EaKq8jNkrZHf+2oNEdTWBm86NMvZNdhnaa5xJ4ZqoBSzzyKm9CN16iBct3pQ/B7RDgA59NzbMLn6aEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fgIXusV6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fgIXusV6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9144AC4CEEA;
	Mon, 23 Jun 2025 22:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717070;
	bh=w5VP1NNyut4C7ZnWQf0DGSnqOiTDeWQ/5VcRjX2CHZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fgIXusV6mg5q79PTjqbqYEjv525VQhNZl6pdcr7ZQICgM0lj1veTKkDUypSwMAEZQ
	 Y3+MUV7bgyDb77GuOEkatU1/IujRJymWk8xtwPSQNlXhbRpIFYuW/fCstxq5tfIQqO
	 PD6k8xFBt7LlfnC0vnlk00iN3AGsclwAJmvY4x38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>,
	kernel test robot <lkp@intel.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	David Hildenbrand <david@redhat.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Oscar Salvador <osalvador@suse.de>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	James Houghton <jthoughton@google.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 359/508] KVM: s390: rename PROT_NONE to PROT_TYPE_DUMMY
Date: Mon, 23 Jun 2025 15:06:44 +0200
Message-ID: <20250623130654.197059647@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

commit 15ac613f124e51a6623975efad9657b1f3ee47e7 upstream.

The enum type prot_type declared in arch/s390/kvm/gaccess.c declares an
unfortunate identifier within it - PROT_NONE.

This clashes with the protection bit define from the uapi for mmap()
declared in include/uapi/asm-generic/mman-common.h, which is indeed what
those casually reading this code would assume this to refer to.

This means that any changes which subsequently alter headers in any way
which results in the uapi header being imported here will cause build
errors.

Resolve the issue by renaming PROT_NONE to PROT_TYPE_DUMMY.

Link: https://lkml.kernel.org/r/20250519145657.178365-1-lorenzo.stoakes@oracle.com
Fixes: b3cefd6bf16e ("KVM: s390: Pass initialized arg even if unused")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Suggested-by: Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202505140943.IgHDa9s7-lkp@intel.com/
Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Acked-by: Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>
Acked-by: Yang Shi <yang@os.amperecomputing.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kvm/gaccess.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -490,7 +490,7 @@ enum prot_type {
 	PROT_TYPE_DAT  = 3,
 	PROT_TYPE_IEP  = 4,
 	/* Dummy value for passing an initialized value when code != PGM_PROTECTION */
-	PROT_NONE,
+	PROT_TYPE_DUMMY,
 };
 
 static int trans_exc_ending(struct kvm_vcpu *vcpu, int code, unsigned long gva, u8 ar,
@@ -506,7 +506,7 @@ static int trans_exc_ending(struct kvm_v
 	switch (code) {
 	case PGM_PROTECTION:
 		switch (prot) {
-		case PROT_NONE:
+		case PROT_TYPE_DUMMY:
 			/* We should never get here, acts like termination */
 			WARN_ON_ONCE(1);
 			break;
@@ -976,7 +976,7 @@ static int guest_range_to_gpas(struct kv
 			gpa = kvm_s390_real_to_abs(vcpu, ga);
 			if (kvm_is_error_gpa(vcpu->kvm, gpa)) {
 				rc = PGM_ADDRESSING;
-				prot = PROT_NONE;
+				prot = PROT_TYPE_DUMMY;
 			}
 		}
 		if (rc)
@@ -1134,7 +1134,7 @@ int access_guest_with_key(struct kvm_vcp
 		if (rc == PGM_PROTECTION)
 			prot = PROT_TYPE_KEYC;
 		else
-			prot = PROT_NONE;
+			prot = PROT_TYPE_DUMMY;
 		rc = trans_exc_ending(vcpu, rc, ga, ar, mode, prot, terminate);
 	}
 out_unlock:


