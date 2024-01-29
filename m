Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF83157E61;
	Mon, 29 Jan 2024 17:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548497; cv=none; b=hD5zes/UYQyl/5wAGLazEuaBn4JlykBVGnZ1TMBdxUmB33CKLlQc2shX5/usIUWNKNswJZUI0U7CvorEY0c+umJ5KufYjZVEBvq2WXHq5Xrr+FfzqKKvzk7/lA0YFuixNazSpIU3hTOrSU3zKpUh0DHa9ujbEFLFz8Z+MKj/gD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548497; c=relaxed/simple;
	bh=XwisTrm34uuJSgLy7TQNgnrR9duND0UFg0VxiwYKCXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mAg0UwF+UKVDxy7jrZbLcFrO9RhkF0mBRpBB+lsgiQ4d678+GeSue96wnaIj+N5H5y4tvnDKypG7n7AdQHBPpiBLOoeOO4rU4cJpy6NmhSXmY5wba0gBhywY3NUinid0QZaSYRLmt4H7cbYrBywPKNGYA7BVQLmyKtjeY2UbrSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aW6KzP8f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aW6KzP8f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2C8EC433F1;
	Mon, 29 Jan 2024 17:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548497;
	bh=XwisTrm34uuJSgLy7TQNgnrR9duND0UFg0VxiwYKCXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aW6KzP8fefAMNl8MajvNZ6Z1d1+5Gsd+7YEV6hiFlrPyT5sYqL40fNlb+Driqy+FV
	 NVK3ukEZgT/pYN2DDkmG0KoB5+i5bRzQFFGESBd0D6vhPczq/0D1EhwSEQ5uLRbDgK
	 0z/EEnYw4WS3bmrktinDGS8czepU455z599xVdgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donet Tom <donettom@linux.vnet.ibm.com>,
	Geetika Moolchandani <geetika@linux.ibm.com>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 124/331] selftests: mm: hugepage-vmemmap fails on 64K page size systems
Date: Mon, 29 Jan 2024 09:03:08 -0800
Message-ID: <20240129170018.563707034@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Donet Tom <donettom@linux.vnet.ibm.com>

commit 00bcfcd47a52f50f07a2e88d730d7931384cb073 upstream.

The kernel sefltest mm/hugepage-vmemmap fails on architectures which has
different page size other than 4K.  In hugepage-vmemmap page size used is
4k so the pfn calculation will go wrong on systems which has different
page size .The length of MAP_HUGETLB memory must be hugepage aligned but
in hugepage-vmemmap map length is 2M so this will not get aligned if the
system has differnet hugepage size.

Added  psize() to get the page size and default_huge_page_size() to
get the default hugepage size at run time, hugepage-vmemmap test pass
on powerpc with 64K page size and x86 with 4K page size.

Result on powerpc without patch (page size 64K)
*# ./hugepage-vmemmap
Returned address is 0x7effff000000 whose pfn is 0
Head page flags (100000000) is invalid
check_page_flags: Invalid argument
*#

Result on powerpc with patch (page size 64K)
*# ./hugepage-vmemmap
Returned address is 0x7effff000000 whose pfn is 600
*#

Result on x86 with patch (page size 4K)
*# ./hugepage-vmemmap
Returned address is 0x7fc7c2c00000 whose pfn is 1dac00
*#

Link: https://lkml.kernel.org/r/3b3a3ae37ba21218481c482a872bbf7526031600.1704865754.git.donettom@linux.vnet.ibm.com
Fixes: b147c89cd429 ("selftests: vm: add a hugetlb test case")
Signed-off-by: Donet Tom <donettom@linux.vnet.ibm.com>
Reported-by: Geetika Moolchandani <geetika@linux.ibm.com>
Tested-by: Geetika Moolchandani <geetika@linux.ibm.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/mm/hugepage-vmemmap.c |   29 ++++++++++++++++----------
 1 file changed, 18 insertions(+), 11 deletions(-)

--- a/tools/testing/selftests/mm/hugepage-vmemmap.c
+++ b/tools/testing/selftests/mm/hugepage-vmemmap.c
@@ -10,10 +10,7 @@
 #include <unistd.h>
 #include <sys/mman.h>
 #include <fcntl.h>
-
-#define MAP_LENGTH		(2UL * 1024 * 1024)
-
-#define PAGE_SIZE		4096
+#include "vm_util.h"
 
 #define PAGE_COMPOUND_HEAD	(1UL << 15)
 #define PAGE_COMPOUND_TAIL	(1UL << 16)
@@ -39,6 +36,9 @@
 #define MAP_FLAGS		(MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB)
 #endif
 
+static size_t pagesize;
+static size_t maplength;
+
 static void write_bytes(char *addr, size_t length)
 {
 	unsigned long i;
@@ -56,7 +56,7 @@ static unsigned long virt_to_pfn(void *a
 	if (fd < 0)
 		return -1UL;
 
-	lseek(fd, (unsigned long)addr / PAGE_SIZE * sizeof(pagemap), SEEK_SET);
+	lseek(fd, (unsigned long)addr / pagesize * sizeof(pagemap), SEEK_SET);
 	read(fd, &pagemap, sizeof(pagemap));
 	close(fd);
 
@@ -86,7 +86,7 @@ static int check_page_flags(unsigned lon
 	 * this also verifies kernel has correctly set the fake page_head to tail
 	 * while hugetlb_free_vmemmap is enabled.
 	 */
-	for (i = 1; i < MAP_LENGTH / PAGE_SIZE; i++) {
+	for (i = 1; i < maplength / pagesize; i++) {
 		read(fd, &pageflags, sizeof(pageflags));
 		if ((pageflags & TAIL_PAGE_FLAGS) != TAIL_PAGE_FLAGS ||
 		    (pageflags & HEAD_PAGE_FLAGS) == HEAD_PAGE_FLAGS) {
@@ -106,18 +106,25 @@ int main(int argc, char **argv)
 	void *addr;
 	unsigned long pfn;
 
-	addr = mmap(MAP_ADDR, MAP_LENGTH, PROT_READ | PROT_WRITE, MAP_FLAGS, -1, 0);
+	pagesize  = psize();
+	maplength = default_huge_page_size();
+	if (!maplength) {
+		printf("Unable to determine huge page size\n");
+		exit(1);
+	}
+
+	addr = mmap(MAP_ADDR, maplength, PROT_READ | PROT_WRITE, MAP_FLAGS, -1, 0);
 	if (addr == MAP_FAILED) {
 		perror("mmap");
 		exit(1);
 	}
 
 	/* Trigger allocation of HugeTLB page. */
-	write_bytes(addr, MAP_LENGTH);
+	write_bytes(addr, maplength);
 
 	pfn = virt_to_pfn(addr);
 	if (pfn == -1UL) {
-		munmap(addr, MAP_LENGTH);
+		munmap(addr, maplength);
 		perror("virt_to_pfn");
 		exit(1);
 	}
@@ -125,13 +132,13 @@ int main(int argc, char **argv)
 	printf("Returned address is %p whose pfn is %lx\n", addr, pfn);
 
 	if (check_page_flags(pfn) < 0) {
-		munmap(addr, MAP_LENGTH);
+		munmap(addr, maplength);
 		perror("check_page_flags");
 		exit(1);
 	}
 
 	/* munmap() length of MAP_HUGETLB memory must be hugepage aligned */
-	if (munmap(addr, MAP_LENGTH)) {
+	if (munmap(addr, maplength)) {
 		perror("munmap");
 		exit(1);
 	}


