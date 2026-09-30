Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD0C355819;
	Wed, 30 Sep 2026 19:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796155; cv=none; b=TafNW94xbBZ4yPBIh2oJVtrWsix11zCQXH5KS8bdhbDnGZIDE190oL+BrsM+bYfS5PsF1Key2fPTCs0ngJosexs5pACDxBR/78ejqVSr3xLDyBd9LZrTvpd8Bc9oJ1qDu6ULM5e4blF6sigylDg6U8NrFpBg2yuP8DtDMHscj3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796155; c=relaxed/simple;
	bh=hNHmYqGCb5tFkI3ZNX9CvZIWEFQJyazT49LDJOddA84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V8nxAnwineg46bbtlwnrJZhE1Q/GWsrtqSh70yHGbzL/0SIS/O7AZfdprUqwb1tnSjZDHAQrOMXWhmWmNowX0JGnO3Zl8qx3t7SSv2oZmbVU2IfYuk9iv6CHJdImQSIlaWtbAM5WWb8MctNwHv5sNVOaZjrdfeZerhqKLK0eFd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dnpQIRYk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dnpQIRYk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 900A11F000FF;
	Wed, 30 Sep 2026 19:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796154;
	bh=1xJ5OiyMNmyqYPTQxGnsgeYPIv0JQViJbYl8p5uRAuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dnpQIRYktD35lfhsSxw0FH+dgADqNCX7AcaV0TMXAnfTaAQ4Ai4QZJe2NgaqgG2aL
	 ViJrkauxeXoykwWtmaR6BaC3gerXktMzog+7cmM7WJY5tIDi8v5v4aL/IbF0bVcA1K
	 EzQ8zMtg+EddcLQRXCaWuQCw1De1KgzxmMavoeGM=
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
Subject: [PATCH 6.6 0814/1193] KVM: PPC: Book3S HV: fix secure device page leak on uv_page_in() failure
Date: Wed, 30 Sep 2026 17:24:58 +0200
Message-ID: <20260930152452.330677705@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e2d6f9327f778..4fb617d110a11 100644
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



