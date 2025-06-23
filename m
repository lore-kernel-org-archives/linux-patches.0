Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F151C5D46;
	Mon, 23 Jun 2025 21:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714486; cv=none; b=CeKgiekohqMJN2Upsq6stPx/DEOQP5z4pSZv3bGTKE0fU4T4s9yYUNnQBIs1lToJ60gAR7OMQeAOYSaJWHzohPlvsgte5iadGr+YiIJsuAKMv5ioyiWeP8yk6rVRi4GtfAmw8ofzLcVvfg/akIbnvGCP/OKtN6HonqLgN7J/C58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714486; c=relaxed/simple;
	bh=JSFt5kXn19RdgDYWo34OaqHgDSNQNg4kF4mkik3x12A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aYkAvnWfWduOTeC4xYVfWwvvnLek7avio6kWJTI+Lxx6tFk1/EYbO2B9Eiw7cTd9yhDlq7O8m2McL1yps81fDN91P/ljUgXw9LkWrCCFv2wBgyeys+4hbUlF1AfrVMzaMKhYQGKNPHHcLM1a57SjdckgDahqBRcAoToRQE0PP3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pFqNT6oP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pFqNT6oP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89202C4CEEA;
	Mon, 23 Jun 2025 21:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714485;
	bh=JSFt5kXn19RdgDYWo34OaqHgDSNQNg4kF4mkik3x12A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pFqNT6oPZ0vN4UNtzRxquteEfdlpoKgRqAvNJ3kNYwKiD2hK054W1JJ0lwczA7eBl
	 oqLZWk/mEGiT9MPzF+fv3VxddJ7+i4Tn6zKu4f4vDIo/uAZwy0Et6g/d9uXjeUcL5+
	 oj+BBMexiCmzgSsp7de8hmcZEQRkwuRlBEN6gWwc=
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
Subject: [PATCH 6.12 132/414] KVM: s390: rename PROT_NONE to PROT_TYPE_DUMMY
Date: Mon, 23 Jun 2025 15:04:29 +0200
Message-ID: <20250623130645.354025731@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -317,7 +317,7 @@ enum prot_type {
 	PROT_TYPE_DAT  = 3,
 	PROT_TYPE_IEP  = 4,
 	/* Dummy value for passing an initialized value when code != PGM_PROTECTION */
-	PROT_NONE,
+	PROT_TYPE_DUMMY,
 };
 
 static int trans_exc_ending(struct kvm_vcpu *vcpu, int code, unsigned long gva, u8 ar,
@@ -333,7 +333,7 @@ static int trans_exc_ending(struct kvm_v
 	switch (code) {
 	case PGM_PROTECTION:
 		switch (prot) {
-		case PROT_NONE:
+		case PROT_TYPE_DUMMY:
 			/* We should never get here, acts like termination */
 			WARN_ON_ONCE(1);
 			break;
@@ -803,7 +803,7 @@ static int guest_range_to_gpas(struct kv
 			gpa = kvm_s390_real_to_abs(vcpu, ga);
 			if (!kvm_is_gpa_in_memslot(vcpu->kvm, gpa)) {
 				rc = PGM_ADDRESSING;
-				prot = PROT_NONE;
+				prot = PROT_TYPE_DUMMY;
 			}
 		}
 		if (rc)
@@ -961,7 +961,7 @@ int access_guest_with_key(struct kvm_vcp
 		if (rc == PGM_PROTECTION)
 			prot = PROT_TYPE_KEYC;
 		else
-			prot = PROT_NONE;
+			prot = PROT_TYPE_DUMMY;
 		rc = trans_exc_ending(vcpu, rc, ga, ar, mode, prot, terminate);
 	}
 out_unlock:


