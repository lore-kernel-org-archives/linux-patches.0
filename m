Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1FC53B27D1;
	Wed, 23 Sep 2026 14:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174583; cv=none; b=KxfEf/h/1D1EBaaxwsX/qa+uy1/6HuKlpPniaRDgefqVnkRgiCv5S1LwFymNauSGDa85vEOBqVdrXnGhMzkpQ+inD4+l1+ek7Xtc+h5UseOmxHzHwsRJzdC/LIJm+AMx+Ea9GmjvhncEJZBpqtvBChjEAYQ72JLdPdlMz7LOasw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174583; c=relaxed/simple;
	bh=Q5LRsB3ZrlSN/Nwpm3TX/GLtSTX/499aBFzC52lwW1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uOrKHRKU7tDzGAT7e0+hFUARMePY1Q8LZJi11LbWwCDRNoVKTN4Xdq/9IB4eO/K5FldCRKUku+dUvT7W+6ZPtdX6c6P/GHiXOF/jOJx6dS/NDr/PZd16l7hp6tsg41h5E7JJ6HvMPuyEHtLefcH3hjaYTgDP0mi0cTWAMUiFyLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ypq60Nn4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ypq60Nn4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5F301F000FF;
	Wed, 23 Sep 2026 14:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174582;
	bh=yZrbfIKo38t4kxJB1Bm3BSpU9AVQv0tmI3NoztNMvrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ypq60Nn4YBedfWjyCv5imhowtDazerYeQtksvbOsnQJAk3rA2JfSoO2WNpJ2u3wl/
	 LSJ3BOMfhzR/zPq51Avch7feWOvPNXTN60RyU56jH3FKoVTnxr4LFFaLByNu2IfEDu
	 I+Dvf9MAGlGyKOGxA5dK8x5CSsW+PGHJkzD/IzAM=
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
Subject: [PATCH 6.18 161/398] KVM: PPC: Book3S HV: fix secure device page leak on uv_page_in() failure
Date: Wed, 23 Sep 2026 16:03:55 +0200
Message-ID: <20260923140647.608850248@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 03f8c34fa0a20..01ab5c653d7c1 100644
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



