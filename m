Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7553652F8B;
	Mon,  8 Jan 2024 15:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VXyjTg8t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F058DC433C8;
	Mon,  8 Jan 2024 15:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728529;
	bh=9gdN4uOo4NRNeW+VvTiM/+MN0ESLIHKr3Y9NNSauEUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VXyjTg8tpQmEyOW5VLgj6amvCIQ9tJBFbcL85oAipMlZ+/5GDPLZLKUNg4NXN3iW+
	 K6vYZUOEGKKp0GsyYSYdFyArJBmvJxz3CZuqImag1QelN9esg1L67pFhkD1EbtAlyZ
	 Ue6y7kWOAthpIZm6iliI27hEGVHc7wJ4lgjz9gVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 088/150] s390/mm: add missing arch_set_page_dat() call to vmem_crst_alloc()
Date: Mon,  8 Jan 2024 16:35:39 +0100
Message-ID: <20240108153515.289158857@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 09cda0a400519b1541591c506e54c9c48e3101bf ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/mm/vmem.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/s390/mm/vmem.c b/arch/s390/mm/vmem.c
index 9a0ce5315f36d..3cbb461820666 100644
--- a/arch/s390/mm/vmem.c
+++ b/arch/s390/mm/vmem.c
@@ -11,6 +11,7 @@
 #include <linux/list.h>
 #include <linux/hugetlb.h>
 #include <linux/slab.h>
+#include <asm/page-states.h>
 #include <asm/cacheflush.h>
 #include <asm/nospec-branch.h>
 #include <asm/pgalloc.h>
@@ -44,8 +45,11 @@ void *vmem_crst_alloc(unsigned long val)
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
 
-- 
2.43.0



