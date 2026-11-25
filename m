Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622518;
	b=N2cZTBt6TY0yCVTRudIsvO5MXgItb9gzTShWEf8O5GUO2AWpuD1UjUfHyBsqCWqYSR2K
	 eEb5FUUWbZ4mIl4kRNY1gFMnW0ioDbirMwch/z6wW0VdNOyxjdxTUbuDAJ4ulxHe2eAqg
	 cJUBIDjvKegNdPVC0sbzFnZtdrc5uJSjA6Ua0/df+1nNKdyiekRQArI9Gt/axYoBgqpv/
	 VNsKgHYSt77o8gucusvD1I8BIs+S6at0knpabwH98nKL1QlsWA4LsvsRSzP9CENLUUQFi
	 gDQrMK3Za+ABN2Sq4jtXXseKRK1bf+hEDefA1QWhUunufYts3MWWzh8wz7RV+vgM38w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622518;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VQn51ISb0C/dluUBbUKAbwh0B2RiFiU/Lk1XGjrOmW4=;
	b=MhYwb9bW6lkdUqe0QVG3iPpcYsr20CdttyIse3V2mUvMYcUB38j0rPVPceqprgH32/KQ
	 9kMQejhPnstylM4QKs8fZCjxQ+q4gi0QGQmjsRYe3JXG9a/LrtYTGXh82monoNOkX+wOS
	 szJl4QAltY84EpIQPvqmXDD7apklbLWzZOPMqsXoDUZkvDlTgd3iW7SQPxdIKPQsxaiAv
	 svG+i3yq/MzblCECm8Jt1/JRfNeTX9JEDkmgspbkXxW68pvdwNB5aa1Gir3iE++TtFTKZ
	 7ZtBz7TwXvi03TDU5o9ygHaDt/x8dsTsGs+Tr/cCsoT3zBLR5rnRFszmBztwBKd50NQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sIJg1H+d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC98B606A321;
	Wed, 25 Nov 2026 16:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sIJg1H+d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55D411F000C6;
	Wed, 25 Nov 2026 16:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622517;
	bh=VQn51ISb0C/dluUBbUKAbwh0B2RiFiU/Lk1XGjrOmW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sIJg1H+dodN4XPdefGiAmNPutT1pLNxKfAwjVwgTLZ39X0GnK8p4ZM2b/ThLI/LXr
	 zZAPahRLPrRXzWAAeDcz9Gi0FHseUY6TSl+LgPaWbBCrm78F5+0JMgYi6gMlToVa1x
	 R8Kk9tJtKuXJMW0GiHdZMTOk3PERS6ai1mxHqxdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muchun Song <muchun.song@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 563/990] mm/memory_hotplug: fix missing rollback in __add_pages()
Date: Wed, 25 Nov 2026 15:32:10 +0100
Message-ID: <20261125143835.285323757@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Dropped the fourth params->pgmap argument from the __remove_pages() rollback call, since this tree's __remove_pages() takes only three arguments. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memory_hotplug.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 9fdfb2d317654..5172401788bd0 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -389,6 +389,7 @@ EXPORT_SYMBOL_GPL(pfn_to_online_page);
 int __add_pages(int nid, unsigned long pfn, unsigned long nr_pages,
 		struct mhp_params *params)
 {
+	const unsigned long start_pfn = pfn;
 	const unsigned long end_pfn = pfn + nr_pages;
 	unsigned long cur_nr_pages;
 	int err;
@@ -422,8 +423,10 @@ int __add_pages(int nid, unsigned long pfn, unsigned long nr_pages,
 				   SECTION_ALIGN_UP(pfn + 1) - pfn);
 		err = sparse_add_section(nid, pfn, cur_nr_pages, altmap,
 					 params->pgmap);
-		if (err)
+		if (err) {
+			__remove_pages(start_pfn, pfn - start_pfn, altmap);
 			break;
+		}
 		cond_resched();
 	}
 	vmemmap_populate_print_last();
-- 
2.53.0



