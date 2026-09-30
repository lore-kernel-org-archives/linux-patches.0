Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D6B4FE2FE;
	Wed, 30 Sep 2026 15:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783595; cv=none; b=OOkW8xBoXQEBxWwupy9BsE43GASytcn3dnqvDL82uWdszyQc72X07r6djZXHjMUxDTOCR9nGjveU8KnNHcYZxYldzHTIUxwVIlJU0r5hvlg+y+DOZqxASddL+PsQxNQfvB4xJ6/FSoTKi/SqIHcEz4/LoP7AfMNhOrPP7jK5YU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783595; c=relaxed/simple;
	bh=ngD/KWG6hJlBHhPbCsNR+pcO+f/ToPrGiwQND/yAXqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ldzi/1UWc7/uYQq6yPyqHgwRrTey8gso8o5ZGYRt2v6zSFXOri6GNHuN7exS6LSs8mB5JYdmMzIvAMYrJVKWQMb2n2+Ybqa159bK8bj/oOT3ssFaO0ePVRA4oWSsK222+I7v3ZBbDzf0rn1+gEyiI/qBECER6mKIfotc4I1hTdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eeTuXF4R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eeTuXF4R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F38561F000FF;
	Wed, 30 Sep 2026 15:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783591;
	bh=heNJmPVrT51X2jfUu4vC3J13Fuv8dORlTiAe3uPtP4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eeTuXF4RejVN2FKAdtFA4YQIkTadNTTxja8Ecz0mnWFJovS4sTclY1PYej8XPGNzb
	 HZqu+b6n5tJ+2AUS2Oc40HuZS/JzwWGp1LHzLQDuuqvfbgv0DeN45hL3WTVr78V5/d
	 fi2OVNl7i3eMtGb2Tt6JUkRsevaYUVwEH5bXizCo=
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
Subject: [PATCH 5.10 408/595] KVM: PPC: Book3S HV: fix secure device page leak on uv_page_in() failure
Date: Wed, 30 Sep 2026 17:25:01 +0200
Message-ID: <20260930152356.451929901@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5f6b3f80023de..296d910a7075d 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -770,8 +770,11 @@ static int kvmppc_svm_page_in(struct vm_area_struct *vma,
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



