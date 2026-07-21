Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5D03998AF;
	Tue, 21 Jul 2026 17:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654049; cv=none; b=F+a+MZwo/oolqFQMNsu2VG9FV92jysa5670bh4NMJjyCfs2CPTVFMXYT2lfT/5bRsh4YVyD2y9XlpeSdM78asm+6VgxlRNV4VvcZJP2b1BsZpW4JTXgVuOmENgmmvSzif7rNr8d2Mj5moxuzLM2gYEMohKmUEPRZQEAliI0hwwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654049; c=relaxed/simple;
	bh=bX2OD0LajoDvwPADYWBrN1TQhxxQNbAGUc2R1crcGFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YLOC6zbQYBfzLCw1TPhZ7wrNvpuPMOme63QyKNaV1lcASudFntq6Eb42Rmwy5wQzjmiyI+rS2HXvfT+lT7a6W76FUKs/ns80so0uwe6D64ivfTCf8mSkNV0G0IrmGTCL2GM70cCtVfsEV58/X7YsBN1mLgLbKpjDigHC470NJfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YxQW+FgC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YxQW+FgC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F3041F00A3D;
	Tue, 21 Jul 2026 17:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654047;
	bh=fCDLt7mf0SgyybMN9ylGTnIbVHiSPOEqjPBf7fS2DFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YxQW+FgCNRSlxIAir3cF/aWkxatZENRdIW9oPAJEEvqUG1NxeCqoSDwNX2R6I8GI2
	 TL/fHxQBaJCIG/RAJZ7baHj6KnUpXcUdzsY4aV+9p+gTQ9/n9ljs3ehGdruqgpSojm
	 d9t+ZHaXb5l5fZDLQ3/QTQVhFVxBw+UZl2dQftSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 7.1 1556/2077] KVM: s390: Initialize KVM_S390_GET_CMMA_BITS memory
Date: Tue, 21 Jul 2026 17:20:29 +0200
Message-ID: <20260721152629.479728178@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Christian Borntraeger <borntraeger@linux.ibm.com>

commit c7dda3d0f869dc97223448a06c9a2e5235928e48 upstream.

kvm_s390_get_cmma_bits() allocates its output buffer with vmalloc(),
which does not zero the returned pages:

	values = vmalloc(args->count);

In the non-peek (migration) path, dat_get_cmma() reports a byte count
spanning from the first to the last dirty page, but __dat_get_cmma_pte()
writes values[gfn - start] only for pages whose CMMA dirty bit is set.
The walk uses DAT_WALK_IGN_HOLES, so clean and unmapped pages that lie
between two dirty pages within the reported span are visited but never
store their byte.  Those gaps (up to KVM_S390_MAX_BIT_DISTANCE pages
each) stay uninitialized yet fall inside [0, count) and are copied out
by copy_to_user(), disclosing stale kernel memory to user space.

Before the switch to the new gmap implementation the buffer was fully
populated for every gfn in the span, so no uninitialized bytes were
exposed; the dirty-only walk introduced the leak.

Use vzalloc() so the gaps read back as zero.

Fixes: e38c884df921 ("KVM: s390: Switch to new gmap")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20260611105036.11491-1-borntraeger@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kvm/kvm-s390.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2252,7 +2252,7 @@ static int kvm_s390_get_cmma_bits(struct
 		return 0;
 	}
 
-	values = vmalloc(args->count);
+	values = vzalloc(args->count);
 	if (!values)
 		return -ENOMEM;
 


