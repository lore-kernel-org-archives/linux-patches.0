Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40F273D4111;
	Wed, 21 Jan 2026 18:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020536; cv=none; b=pP97tcFHwvZzIrKm/8ExGUHt3ZRsQxY25c4FTsonD1J5KabfuGTBVl/7m84cS+wTIZ2QM/eC5Ua1mfsvN0DqEsP+Cjpdw5SnrE70x42kUjj4ADS5zKqtWKzcFsWJnZ/ODgTF0RE/ln/gTbTG50I6j5DBVUuQc+rtbvIrIbyo3VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020536; c=relaxed/simple;
	bh=qhdoHBjkx6DVtOFeN2BPuKgZ3mRDQMDGfB4/NV3IhwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eBVF39gH2DdeBmTvlf9mwsfPvdPjwjArdUgXTANc72Kh3B/Fcge5oFTN4kJPQcrV1AhgBkqTZ/SloxbxR37lQErDv8hTaxeQcUVUEDmoMANR+vhiAxabIpF22R3t35vlURbDFmkuH75Z/mXNJdlMV8MB/mR6rVaOaq9CqobT9wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KZ3vp+fm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KZ3vp+fm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77B3FC4CEF1;
	Wed, 21 Jan 2026 18:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020536;
	bh=qhdoHBjkx6DVtOFeN2BPuKgZ3mRDQMDGfB4/NV3IhwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KZ3vp+fmorxKldOskhs50FHV1v/2HPYJ5eYUYdk0ct1SQPN4rUjAb60HQEYNDKhaY
	 bEiZz+r9osmIR894yUSr1JUTs8eVczgkx94XLvcK6i4XS0F5md8aUp31htHX2FHEs3
	 MyHj3Jn63GOk5k5g/Xv3hbjxw0UhBtt7LmdWZtLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	David Hildenbrand <david@redhat.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Alistair Popple <apopple@nvidia.com>,
	Andy Lutomirski <luto@kernel.org>,
	Borislav Betkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jann Horn <jannh@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Michal Hocko <mhocko@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Robin Murohy <robin.murphy@arm.com>,
	Thomas Gleinxer <tglx@linutronix.de>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	Yi Lai <yi1.lai@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 188/198] x86/mm: use pagetable_free()
Date: Wed, 21 Jan 2026 19:16:56 +0100
Message-ID: <20260121181425.323370020@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Baolu <baolu.lu@linux.intel.com>

commit bf9e4e30f3538391745a99bc2268ec4f5e4a401e upstream.

The kernel's memory management subsystem provides a dedicated interface,
pagetable_free(), for freeing page table pages.  Updates two call sites to
use pagetable_free() instead of the lower-level __free_page() or
free_pages().  This improves code consistency and clarity, and ensures the
correct freeing mechanism is used.

Link: https://lkml.kernel.org/r/20251022082635.2462433-7-baolu.lu@linux.intel.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robin Murohy <robin.murphy@arm.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Vasant Hegde <vasant.hegde@amd.com>
Cc: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Yi Lai <yi1.lai@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/init_64.c        |    2 +-
 arch/x86/mm/pat/set_memory.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1031,7 +1031,7 @@ static void __meminit free_pagetable(str
 		free_reserved_pages(page, nr_pages);
 #endif
 	} else {
-		__free_pages(page, order);
+		pagetable_free(page_ptdesc(page));
 	}
 }
 
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -429,7 +429,7 @@ static void cpa_collapse_large_pages(str
 
 	list_for_each_entry_safe(ptdesc, tmp, &pgtables, pt_list) {
 		list_del(&ptdesc->pt_list);
-		__free_page(ptdesc_page(ptdesc));
+		pagetable_free(ptdesc);
 	}
 }
 


