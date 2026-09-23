Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614BC38D6A2;
	Wed, 23 Sep 2026 14:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173373; cv=none; b=WOxXJSZRxjpJOQIa2zQbgYZko9UXpTohu4zuvJCvcCIlD18VyxqMsy7ZS/yAMhW9ZDUabg68rQZ8OuaR/Nzjgj2gpQD8DyassSTfBwKozgaV4hMOKtBmT38XbAN29GONiO7l1dPUJ1qA/aoQ9kZzZbkAPMeYOstd7ehwiaYMlE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173373; c=relaxed/simple;
	bh=oy/j5IJhKRrXs6KTVtwYkVoZgOiliLsgdmD+8cxaryI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=txSBAncDNXKhiIWVErpv5iD7RQwJVqCKNTzVD8N20iHhO8ZcQMXW428pmVEuUUvVlomE8NteeO+/ab099wREyVVWf6ROb9KGAO3vCYzTletV3ZEGKmKeQq1/dKgkUaa8y4BWKmGHHkbZ26vRItgA9sOXx3DYhpN63gJBb5C5APc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MRm339eo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MRm339eo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA11D1F000FF;
	Wed, 23 Sep 2026 14:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173372;
	bh=KrzS9HN2fxSqw4XDBRXyMn4QNHyilYzwZzZdSEpR8mE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MRm339eokL+H/5t3xLFcE1RWW9i9rEa3CHs/3VuVLv/QIlZYYZqhyDn35dOaBuh1j
	 z2DmHGpkvLiZcetXVreWqAka/4dry+TAHzH6IgfygLNU1Vplrl4P7fyVLG/U+8SpUD
	 +iAJC5vfr7nTOpbSHMFJ9xHwykPS7CbYZaAQIDvw=
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
Subject: [PATCH 7.2 191/438] KVM: PPC: Book3S HV: fix secure device page leak on uv_page_in() failure
Date: Wed, 23 Sep 2026 16:03:32 +0200
Message-ID: <20260923140649.711299085@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 5fbb95d90e996..463aef870c4eb 100644
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



