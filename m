Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E280917AA6
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:25:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64EF5C433C8;
	Wed,  9 Aug 2023 11:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580342;
	bh=TUZ1rWQUcs8XCRhOo3RezvnaYoDZBgFg8qyRmLkNMh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QkjWVxBlQNVPDOvoyPvNM/1TRf7PU64OnAqjcMzst57u3n+yXBmANUPQwBzTyTWLN
	 mvTlpmjApK1C1XGOA1ejkfobiacGU0YHDoq6Z0LUPW+qLzdwLnaXBgR4gXOVJQBdLC
	 vrQ8zxBp4SZkUzmWyrRflBKJMfIdtuLUnDJqzhr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 315/323] powerpc/mm/altmap: Fix altmap boundary check
Date: Wed,  9 Aug 2023 12:42:33 +0200
Message-ID: <20230809103712.492443030@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

[ Upstream commit 6722b25712054c0f903b839b8f5088438dd04df3 ]

altmap->free includes the entire free space from which altmap blocks
can be allocated. So when checking whether the kernel is doing altmap
block free, compute the boundary correctly, otherwise memory hotunplug
can fail.

Fixes: 9ef34630a461 ("powerpc/mm: Fallback to RAM if the altmap is unusable")
Signed-off-by: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20230724181320.471386-1-aneesh.kumar@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/init_64.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/powerpc/mm/init_64.c b/arch/powerpc/mm/init_64.c
index a5091c0347475..aff86679af961 100644
--- a/arch/powerpc/mm/init_64.c
+++ b/arch/powerpc/mm/init_64.c
@@ -266,8 +266,7 @@ void __ref vmemmap_free(unsigned long start, unsigned long end,
 	start = _ALIGN_DOWN(start, page_size);
 	if (altmap) {
 		alt_start = altmap->base_pfn;
-		alt_end = altmap->base_pfn + altmap->reserve +
-			  altmap->free + altmap->alloc + altmap->align;
+		alt_end = altmap->base_pfn + altmap->reserve + altmap->free;
 	}
 
 	pr_debug("vmemmap_free %lx...%lx\n", start, end);
-- 
2.40.1



