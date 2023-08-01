Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E571200A5
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:37:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0EC5C433C7;
	Tue,  1 Aug 2023 09:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882669;
	bh=SrCFbNO3u2UL/0daFKDVllSug2gXOuRXA0l+xpMPo9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SFDZ8u9XoqGlv/0k/cjO22zkFSypWyFUhLFso84oAcfgnFrXKoR3pDKVTIOZwb8d0
	 ijiaVyMCXjn8KWC+hq7+2Gdm7yywHkVLaMiMEuQLcJx2p6V/yr/wg7S4Y6mHKu4BGq
	 /ZfRuIdx+bA/QmsE8uVlUsZNWi+Qo4dLGxMCDjzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanghui Feng <guanghuifeng@linux.alibaba.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Hanjun Guo <guohanjun@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.1 189/228] ACPI/IORT: Remove erroneous id_count check in iort_node_get_rmr_info()
Date: Tue,  1 Aug 2023 11:20:47 +0200
Message-ID: <20230801091929.682449828@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Guanghui Feng <guanghuifeng@linux.alibaba.com>

commit 003e6b56d780095a9adc23efc9cb4b4b4717169b upstream.

According to the ARM IORT specifications DEN 0049 issue E,
the "Number of IDs" field in the ID mapping format reports
the number of IDs in the mapping range minus one.

In iort_node_get_rmr_info(), we erroneously skip ID mappings
whose "Number of IDs" equal to 0, resulting in valid mapping
nodes with a single ID to map being skipped, which is wrong.

Fix iort_node_get_rmr_info() by removing the bogus id_count
check.

Fixes: 491cf4a6735a ("ACPI/IORT: Add support to retrieve IORT RMR reserved regions")
Signed-off-by: Guanghui Feng <guanghuifeng@linux.alibaba.com>
Cc: <stable@vger.kernel.org> # 6.0.x
Acked-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Tested-by: Hanjun Guo <guohanjun@huawei.com>
Link: https://lore.kernel.org/r/1689593625-45213-1-git-send-email-guanghuifeng@linux.alibaba.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/arm64/iort.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/acpi/arm64/iort.c
+++ b/drivers/acpi/arm64/iort.c
@@ -998,9 +998,6 @@ static void iort_node_get_rmr_info(struc
 	for (i = 0; i < node->mapping_count; i++, map++) {
 		struct acpi_iort_node *parent;
 
-		if (!map->id_count)
-			continue;
-
 		parent = ACPI_ADD_PTR(struct acpi_iort_node, iort_table,
 				      map->output_reference);
 		if (parent != iommu)


