Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE26200A6
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:01:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63677C433C8;
	Fri, 21 Jul 2023 19:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966083;
	bh=LaEyb9vcB7T6440XTo/7lsQLT09KSILezOXRjabMYxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aVbDcZhL7/g2Udnu6pD6Fig8NoiDrBZ+4GP4eVCmCikYYm1l6KhmD0Qlrb2DoFpFX
	 +1X3ktR2qQm2z1jbrt8+jxdMPtahXBjBGaNPYmHwUSrAKwf0cKv3j9ooMnGd94Y/Yb
	 nvq1WZ2fFQucsO4xSCg/lYU+WDkhNH8h9Si/QMzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>,
	Sachin Sant <sachinp@linux.ibm.commailto:sachinp@linux.ibm.com>
Subject: [PATCH 5.15 218/532] powerpc/mm/dax: Fix the condition when checking if altmap vmemap can cross-boundary
Date: Fri, 21 Jul 2023 18:02:02 +0200
Message-ID: <20230721160626.216380607@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
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

[ Upstream commit c8eebc4a99f15280654f23e914e746c40a516e50 ]

Without this fix, the last subsection vmemmap can end up in memory even if
the namespace is created with -M mem and has sufficient space in the altmap
area.

Fixes: cf387d9644d8 ("libnvdimm/altmap: Track namespace boundaries in altmap")
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Tested-by: Sachin Sant <sachinp@linux.ibm.com <mailto:sachinp@linux.ibm.com>>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20230616110826.344417-6-aneesh.kumar@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/init_64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/init_64.c b/arch/powerpc/mm/init_64.c
index 386be136026e8..b76cd49d521b9 100644
--- a/arch/powerpc/mm/init_64.c
+++ b/arch/powerpc/mm/init_64.c
@@ -188,7 +188,7 @@ static bool altmap_cross_boundary(struct vmem_altmap *altmap, unsigned long star
 	unsigned long nr_pfn = page_size / sizeof(struct page);
 	unsigned long start_pfn = page_to_pfn((struct page *)start);
 
-	if ((start_pfn + nr_pfn) > altmap->end_pfn)
+	if ((start_pfn + nr_pfn - 1) > altmap->end_pfn)
 		return true;
 
 	if (start_pfn < altmap->base_pfn)
-- 
2.39.2



