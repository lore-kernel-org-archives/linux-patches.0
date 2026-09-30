Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F356519913;
	Wed, 30 Sep 2026 17:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788497; cv=none; b=f+pzZZaxtj5kcxkmx419migrGOsOSc3a8Os2L3jq2noocZ+M3V4ndEas9+cNEB+1SU0OS0Tioo2Q6QojJvICcRe1XfPIaGeDVohB2dcJGe+uyOLLzqkrm1heIhjuXCEPy9t1PhBk1EpLQlT8tQ3Zom1MZd9V8BfNZUq7E/GYuKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788497; c=relaxed/simple;
	bh=R49AKWyipv1kxSoH59jD9s0iXmMaZ3WgJ9d7Ex7O9Ds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bMrZ+ljr417z6ME5ay9vUv/3ufW87OEEff74fcQ5P9evOnu/7+AsDkpiggyimLSEM4kfIG/w6O/OCARI+1wFRT0T3nieVJrsb6RdSNfQZkyu9vSpD5jY2jfCbVzvWTDfu3MK1nHWCBYixrRuaocKoEHkM6Js2QkvwgR54aJ6mEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2VmzVwr9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2VmzVwr9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B3061F000FF;
	Wed, 30 Sep 2026 17:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788495;
	bh=XW10zTMLLcK9/PsacG8/Kb2b8Xkl/KU0tPkUNPjvlEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2VmzVwr9qWd7J0SpXBcPoc16mNCOAi6pHvITiEwH5WnTN96OY/DBcVScLpADCycaE
	 c965QvIGTEvzjlX5PRimcuTcPntW23+Nf4RKautOmFFn+kUU3A6FlhcWePhEW3rvU/
	 H88X1fLejqp4+NCbITD+n9lbUhO60BzbzLfE4R5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	R Nageswara Sastry <rnsastry@linux.ibm.com>,
	Amit Machhiwal <amachhiw@linux.ibm.com>,
	Gautam Menghani <gautam@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 144/877] KVM: PPC: Book3S HV: fix secure device page leak on uv_page_in() failure
Date: Wed, 30 Sep 2026 17:17:35 +0200
Message-ID: <20260930152417.833689283@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Machhiwal <amachhiw@linux.ibm.com>

[ Upstream commit 0a416ee20bcccddf91ca5b63696a23b9d11d73aa ]

In kvmppc_svm_page_in(), if uv_page_in() fails after
kvmppc_uvmem_get_page() has succeeded, the secure device page is never
released.  kvmppc_uvmem_get_page() sets a bit in kvmppc_uvmem_bitmap,
allocates a kvmppc_uvmem_page_pvt struct, marks the GFN as
KVMPPC_GFN_UVMEM_PFN, and calls zone_device_page_init() which sets
refcount=1 and locks the page.  The subsequent goto out_finalize skips
the *mig.dst assignment, so migrate_vma_finalize() is a no-op for the
page, and none of those resources are ever reclaimed.

Each occurrence permanently consumes one entry from the firmware-bounded
secure memory pool (kvmppc_uvmem_bitmap), leaks pvt, and leaves the GFN
marked as secure — making it unusable for the lifetime of the VM.

The twin __kvmppc_svm_page_out() already handles the analogous uv_page_out()
failure correctly with unlock_page(dpage); __free_page(dpage).  Apply
the same pattern here: unlock_page() followed by put_page(), which
chains through free_zone_device_folio() into kvmppc_uvmem_folio_free()
to clear the bitmap bit, free pvt, and reset the GFN state.

Reachable whenever uv_page_in() returns an error (e.g. UV pool
exhaustion) on any POWER9/10 + Ultravisor/PEF system.

Fixes: ca9f4942670c ("KVM: PPC: Book3S HV: Support for running secure guests")
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Tested-by: R Nageswara Sastry <rnsastry@linux.ibm.com>
Signed-off-by: Amit Machhiwal <amachhiw@linux.ibm.com>
Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_hv_uvmem.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index 92f33115144b2..7ea0c58622274 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -779,8 +779,11 @@ static int kvmppc_svm_page_in(struct vm_area_struct *vma,
 		if (spage) {
 			ret = uv_page_in(kvm->arch.lpid, pfn << page_shift,
 					gpa, 0, page_shift);
-			if (ret)
+			if (ret) {
+				unlock_page(dpage);
+				put_page(dpage);
 				goto out_finalize;
+			}
 		}
 	}
 
-- 
2.53.0



