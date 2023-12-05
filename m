Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48B026110;
	Tue,  5 Dec 2023 03:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PKCl1kzF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB747C433C8;
	Tue,  5 Dec 2023 03:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746738;
	bh=9CkyPILyCMsPA1YsXVii3q/gY+ZbABXMBDKIQCSkGU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PKCl1kzF4NrgCfanXTR0gQS/twX0DBPSH/0qYXPOPu6uG9QDIe0k24beJwYPLfXT4
	 SCfeGOHSqGMzjRYYydUDQfH2UJg2BUqoutN88zzNwL1Enr9odJzwPFuMxmIVJhu6VT
	 AJd8uUIv/bqxMlYyIKJTHefwvN44W/Pw7fGRWpkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 113/134] s390/cmma: fix handling of swapper_pg_dir and invalid_pg_dir
Date: Tue,  5 Dec 2023 12:16:25 +0900
Message-ID: <20231205031542.634391701@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 84bb41d5df48868055d159d9247b80927f1f70f9 ]

If the cmma no-dat feature is available the kernel page tables are walked
to identify and mark all pages which are used for address translation (all
region, segment, and page tables). In a subsequent loop all other pages are
marked as "no-dat" pages with the ESSA instruction.

This information is visible to the hypervisor, so that the hypervisor can
optimize purging of guest TLB entries. All pages used for swapper_pg_dir
and invalid_pg_dir are incorrectly marked as no-dat, which in turn can
result in incorrect guest TLB flushes.

Fix this by marking those pages correctly as being used for DAT.

Cc: <stable@vger.kernel.org>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/mm/page-states.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/s390/mm/page-states.c b/arch/s390/mm/page-states.c
index 00e7b0876dc50..79a037f49f707 100644
--- a/arch/s390/mm/page-states.c
+++ b/arch/s390/mm/page-states.c
@@ -181,6 +181,12 @@ void __init cmma_init_nodat(void)
 		return;
 	/* Mark pages used in kernel page tables */
 	mark_kernel_pgd();
+	page = virt_to_page(&swapper_pg_dir);
+	for (i = 0; i < 4; i++)
+		set_bit(PG_arch_1, &page[i].flags);
+	page = virt_to_page(&invalid_pg_dir);
+	for (i = 0; i < 4; i++)
+		set_bit(PG_arch_1, &page[i].flags);
 
 	/* Set all kernel pages not used for page tables to stable/no-dat */
 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start, &end, NULL) {
-- 
2.42.0



