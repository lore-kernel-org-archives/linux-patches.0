Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A537B174CA
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:56:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 286F4C433C8;
	Wed,  9 Aug 2023 10:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578591;
	bh=sc06U4RR1eaFwU9DQlRlff9KWyeU+3QPspxLNzP20bs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v6eRkMSMkoH21i/TY/bxJL9rBlGwcYCJY2LNmb6Kw5Ho0HPVdFBqGKFsDf9xCn1ZR
	 Xo5dhTK7cs4OhQivNx9EDilTQkGwH60z2LGPktGadQlp7HtVZOsrjv9rkw3sOBWgX5
	 kY1eEdnnUMCsgZ1gGJsFQc2WMw8Qumcw5gL+VGs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 115/127] powerpc/mm/altmap: Fix altmap boundary check
Date: Wed,  9 Aug 2023 12:41:42 +0200
Message-ID: <20230809103640.420863136@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103636.615294317@linuxfoundation.org>
References: <20230809103636.615294317@linuxfoundation.org>
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
index fe1b83020e0df..0ec5b45b1e86a 100644
--- a/arch/powerpc/mm/init_64.c
+++ b/arch/powerpc/mm/init_64.c
@@ -314,8 +314,7 @@ void __ref vmemmap_free(unsigned long start, unsigned long end,
 	start = ALIGN_DOWN(start, page_size);
 	if (altmap) {
 		alt_start = altmap->base_pfn;
-		alt_end = altmap->base_pfn + altmap->reserve +
-			  altmap->free + altmap->alloc + altmap->align;
+		alt_end = altmap->base_pfn + altmap->reserve + altmap->free;
 	}
 
 	pr_debug("vmemmap_free %lx...%lx\n", start, end);
-- 
2.40.1



