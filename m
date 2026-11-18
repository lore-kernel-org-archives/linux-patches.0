Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018266;
	b=P2KhlROhsS7bD7kgg7lZRo1y3ahYSA5XJAVFbP8ywMfwsVAIDWlLwLS9YQEEtLbZw823
	 lwf9qGdNVYYmQQSvzOo0UyalLcUvPM5xa7Sr4z7/gBdkOWsszL0p+yo1d+kZQYYgFSmsg
	 HGtLbgIPmHJirKNyfyY7GI36yfLZypRROEYw5sMmZcY/QSttoPso07Dcl/oJ3OlNvYcRh
	 JpCiVpmv0ABC/8Hs8mY+gWLCS116JaHyIBuZeSjXZJmX3dhYohBCjkJcE5t720ayUbUNd
	 rb2imnUY1O1tSSGk0j8LGqMuus0x4BiqxHZlMRrimkFUzL2mM1OCEKmofB+KKW68UNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018266;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SAUayCc6V8GKgBYwKZ1VxlgPENEgjsyHLZYbjz8q8DY=;
	b=xEcNbi573E26qC7ftpODwMzxbAagHzJqAkuwNzBL6xzrvJ1raMiTtmQnw3gNFeefq1Ml
	 0yFkmLUugWxf63yo5EbTLrZiRke+f8sIpl9lx5iq41niN8Vk9RNoleRwYRVmMNSezZnfU
	 BBOrzmESNhII1oIJjb3QnvMv5e8SkjCQvdnyeMNx3nIM/2VlFvENbsVT9WaAKDfT2AlxC
	 9OzMUSYqy0xDCSeIOSGpKc/xN/yL3Hv38HgwmQuSuWp1zKXwhMagILIVah68cnh4bSzM2
	 uPTAeEGSL5l3QQqXST26CsoYpwOGadj98MhmYTc9GiuNbWj0hQz4qlrmQ1VJhky0fag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="VaWa/R7X";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38015606A31C;
	Wed, 18 Nov 2026 16:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VaWa/R7X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F8E1F000C4;
	Wed, 18 Nov 2026 16:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018266;
	bh=SAUayCc6V8GKgBYwKZ1VxlgPENEgjsyHLZYbjz8q8DY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VaWa/R7XMNxnOD909H2YrVGynymkimawveBeQnU0Hkn0wyCUIL2OsSbkVDPY+cjpy
	 QOkByifwHLg08cHeGW2o2vUBJbnnADFc0TWIx9iOqaBYS/0kIRk1n9zI/gkg9uqDW+
	 21WjATyxZZchhoRr35y+XTX+IMOvi4+KuP4tKzBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muchun Song <muchun.song@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1138/2651] mm/memory_hotplug: fix missing rollback in __add_pages()
Date: Wed, 18 Nov 2026 15:39:38 +0100
Message-ID: <20261118150328.977607361@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lance Yang <lance.yang@linux.dev>

[ Upstream commit c31bb839fb829958101250ee5acfa4f94fdb7ecd ]

__add_pages() returns on a sparse_add_section() failure without removing
the sections already added in the same request.

For memremap_pages(), the failed range is not counted in pgmap->nr_range,
so memunmap_pages() skips it. The sections already added in that range
retain their vmemmap mappings and subsection bits. Retrying a
section-aligned range can then fail with -EEXIST.

Save the initial PFN and remove [start_pfn, pfn) on failure. For a vmemmap
population failure, section_activate() already cleans up the current
section, so the rollback excludes it. If the first section fails,
__remove_pages() receives an empty range and does nothing.

Link: https://lore.kernel.org/all/BAD58999-1EDD-4A37-ABA0-DB1BD8AB3453@linux.dev/
Suggested-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Fixes: ba72b4c8cf60 ("mm/sparsemem: support sub-section hotplug")
Acked-by: Muchun Song <muchun.song@linux.dev>
Link: https://patch.msgid.link/20260930160432.5564-1-lance.yang@linux.dev
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memory_hotplug.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 226ab9cb078ad..0a4df6ba2d537 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -384,6 +384,7 @@ EXPORT_SYMBOL_GPL(pfn_to_online_page);
 int __add_pages(int nid, unsigned long pfn, unsigned long nr_pages,
 		struct mhp_params *params)
 {
+	const unsigned long start_pfn = pfn;
 	const unsigned long end_pfn = pfn + nr_pages;
 	unsigned long cur_nr_pages;
 	int err;
@@ -417,8 +418,11 @@ int __add_pages(int nid, unsigned long pfn, unsigned long nr_pages,
 				   SECTION_ALIGN_UP(pfn + 1) - pfn);
 		err = sparse_add_section(nid, pfn, cur_nr_pages, altmap,
 					 params->pgmap);
-		if (err)
+		if (err) {
+			__remove_pages(start_pfn, pfn - start_pfn, altmap,
+				       params->pgmap);
 			break;
+		}
 		cond_resched();
 	}
 	vmemmap_populate_print_last();
-- 
2.53.0



