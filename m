Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A8939FF7;
	Fri, 24 Nov 2023 18:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qXeeNfQ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B78D6C433C8;
	Fri, 24 Nov 2023 18:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849943;
	bh=rTNvR+Sys52exE+Fvb7Ob2gYDty7133CT2fI9PFrhSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qXeeNfQ/YhYi4+jWlmGN9Ew2dJ68W0al1fF3s25VrKzf+nTWQXYZA4KuMcrwpWGpA
	 DEIhzKEqgVJYYqKIHdr7Wfln7pWhTXQWt6D+ExjIp3+M25ya7IZPUCYfWM6PnbnDs1
	 7pL2jsF/BIcwrT90CVO5Ilvhh4nq0KU/fcBAh69U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.6 375/530] s390/mm: add missing arch_set_page_dat() call to vmem_crst_alloc()
Date: Fri, 24 Nov 2023 17:49:01 +0000
Message-ID: <20231124172039.425328585@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

commit 09cda0a400519b1541591c506e54c9c48e3101bf upstream.

If the cmma no-dat feature is available all pages that are not used for
dynamic address translation are marked as "no-dat" with the ESSA
instruction. This information is visible to the hypervisor, so that the
hypervisor can optimize purging of guest TLB entries. This also means that
pages which are used for dynamic address translation must not be marked as
"no-dat", since the hypervisor may then incorrectly not purge guest TLB
entries.

Region and segment tables allocated via vmem_crst_alloc() are incorrectly
marked as "no-dat", as soon as slab_is_available() returns true.

Such tables are allocated e.g. when kernel page tables are split, memory is
hotplugged, or a DCSS segment is loaded.

Fix this by adding the missing arch_set_page_dat() call.

Cc: <stable@vger.kernel.org>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/mm/vmem.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/arch/s390/mm/vmem.c
+++ b/arch/s390/mm/vmem.c
@@ -12,6 +12,7 @@
 #include <linux/hugetlb.h>
 #include <linux/slab.h>
 #include <linux/sort.h>
+#include <asm/page-states.h>
 #include <asm/cacheflush.h>
 #include <asm/nospec-branch.h>
 #include <asm/pgalloc.h>
@@ -45,8 +46,11 @@ void *vmem_crst_alloc(unsigned long val)
 	unsigned long *table;
 
 	table = vmem_alloc_pages(CRST_ALLOC_ORDER);
-	if (table)
-		crst_table_init(table, val);
+	if (!table)
+		return NULL;
+	crst_table_init(table, val);
+	if (slab_is_available())
+		arch_set_page_dat(virt_to_page(table), CRST_ALLOC_ORDER);
 	return table;
 }
 


