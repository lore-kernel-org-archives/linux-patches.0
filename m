Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF9D1ED4F
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:39:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CD8BC433C8;
	Tue, 25 Jul 2023 11:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690285155;
	bh=2/eA/CV27OVrwQ3JCtceH2Yt/9DmqWEMtCZn9Q1pfD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kf9OyYQyB8Ry+1NO1MQskSMJQ3b7y7gah27dH/WJINbhykH3VT310ZPeu51PDNUMs
	 sx2cjNOWDU2e4yUxkcs+Y2LGUf3MRkKpXPp7kX8nsmF0T6Gfon8tG1Mz4mVPxXZVHf
	 RbTlUF5EvCHOs5G9igf/91Mif3YfbEnLmQ1aLpNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>,
	Sachin Sant <sachinp@linux.ibm.commailto:sachinp@linux.ibm.com>
Subject: [PATCH 5.4 104/313] powerpc/mm/dax: Fix the condition when checking if altmap vmemap can cross-boundary
Date: Tue, 25 Jul 2023 12:44:17 +0200
Message-ID: <20230725104525.476613311@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
References: <20230725104521.167250627@linuxfoundation.org>
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
index 210f1c28b8e41..e4fb5ab41e2d3 100644
--- a/arch/powerpc/mm/init_64.c
+++ b/arch/powerpc/mm/init_64.c
@@ -178,7 +178,7 @@ static bool altmap_cross_boundary(struct vmem_altmap *altmap, unsigned long star
 	unsigned long nr_pfn = page_size / sizeof(struct page);
 	unsigned long start_pfn = page_to_pfn((struct page *)start);
 
-	if ((start_pfn + nr_pfn) > altmap->end_pfn)
+	if ((start_pfn + nr_pfn - 1) > altmap->end_pfn)
 		return true;
 
 	if (start_pfn < altmap->base_pfn)
-- 
2.39.2



