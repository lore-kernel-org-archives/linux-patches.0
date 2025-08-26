Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DB714B950;
	Tue, 26 Aug 2025 13:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214961; cv=none; b=A1wyiieh/InVeMI57Dz5Q92zkylblrmtLrUh+7hBSu8BsSUVWS39x/mWhdAZKhiuknoq6GL/Gx0k9qhXbHI8x9uqVS10ce/ltSGROdTIEy/bBiXeS+MU/tRoqHex+3ECjr4jOtdyKIjhV0scXhDXniqSCopy72HTm/h/CkFWPVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214961; c=relaxed/simple;
	bh=QFCQB+1bNHRU/olRviaUXGzutbpIgu6PTdb2TbFLRJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L/q9oQui6olVcSdxXpYkNc3kOrNIoMFanTxsnZBZNx0gRGq732x3JYKaoyXQ/GfRF+69f4nPm0MeJXbh0urmS+jvLOzoz8ay6y9aK8/ehkMwWSIBty+AdngDaIL9a22tsq5UIge33nnBWn8CyiywtRT9mq4pHmCP2bkIO9wLcpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DdtVzOSf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DdtVzOSf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A6A9C4CEF1;
	Tue, 26 Aug 2025 13:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214961;
	bh=QFCQB+1bNHRU/olRviaUXGzutbpIgu6PTdb2TbFLRJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DdtVzOSfNhkQxskLpxFBuVaGC0mrYrpVvxYy/DSiVnZHoxmvAfF7ti5LrP7LTJNWW
	 BlmfaGPv5mTSMOr3Be/FYaXK+vMorb9MZsr3+pp8IsgP4feayCfghVTLBJP+wbZ710
	 4skmXJKCR73dB6CJPQ52DTbLNIBxWLzwHyqAq1IU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John David Anglin <dave.anglin@bell.net>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 318/482] parisc: Update comments in make_insert_tlb
Date: Tue, 26 Aug 2025 13:09:31 +0200
Message-ID: <20250826110938.663322101@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: John David Anglin <dave.anglin@bell.net>

commit cb22f247f371bd206a88cf0e0c05d80b8b62fb26 upstream.

The following testcase exposed a problem with our read access checks
in get_user() and raw_copy_from_user():

#include <stdint.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <sys/mman.h>
#include <sys/types.h>

int main(int argc, char **argv)
{
  unsigned long page_size = sysconf(_SC_PAGESIZE);
  char *p = malloc(3 * page_size);
  char *p_aligned;

  /* initialize memory region. If not initialized, write syscall below will correctly return EFAULT. */
  if (1)
	memset(p, 'X', 3 * page_size);

  p_aligned = (char *) ((((uintptr_t) p) + (2*page_size - 1)) & ~(page_size - 1));
  /* Drop PROT_READ protection. Kernel and userspace should fault when accessing that memory region */
  mprotect(p_aligned, page_size, PROT_NONE);

  /* the following write() should return EFAULT, since PROT_READ was dropped by previous mprotect() */
  int ret = write(2, p_aligned, 1);
  if (!ret || errno != EFAULT)
	printf("\n FAILURE: write() did not returned expected EFAULT value\n");

  return 0;
}

Because of the way _PAGE_READ is handled, kernel code never generates
a read access fault when it access a page as the kernel privilege level
is always less than PL1 in the PTE.

This patch reworks the comments in the make_insert_tlb macro to try
to make this clearer.

Signed-off-by: John David Anglin <dave.anglin@bell.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org # v5.12+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/entry.S |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/arch/parisc/kernel/entry.S
+++ b/arch/parisc/kernel/entry.S
@@ -486,6 +486,12 @@
 	 * this happens is quite subtle, read below */
 	.macro		make_insert_tlb	spc,pte,prot,tmp
 	space_to_prot   \spc \prot        /* create prot id from space */
+
+#if _PAGE_SPECIAL_BIT == _PAGE_DMB_BIT
+	/* need to drop DMB bit, as it's used as SPECIAL flag */
+	depi		0,_PAGE_SPECIAL_BIT,1,\pte
+#endif
+
 	/* The following is the real subtlety.  This is depositing
 	 * T <-> _PAGE_REFTRAP
 	 * D <-> _PAGE_DIRTY
@@ -498,17 +504,18 @@
 	 * Finally, _PAGE_READ goes in the top bit of PL1 (so we
 	 * trigger an access rights trap in user space if the user
 	 * tries to read an unreadable page */
-#if _PAGE_SPECIAL_BIT == _PAGE_DMB_BIT
-	/* need to drop DMB bit, as it's used as SPECIAL flag */
-	depi		0,_PAGE_SPECIAL_BIT,1,\pte
-#endif
 	depd            \pte,8,7,\prot
 
 	/* PAGE_USER indicates the page can be read with user privileges,
 	 * so deposit X1|11 to PL1|PL2 (remember the upper bit of PL1
-	 * contains _PAGE_READ) */
+	 * contains _PAGE_READ). While the kernel can't directly write
+	 * user pages which have _PAGE_WRITE zero, it can read pages
+	 * which have _PAGE_READ zero (PL <= PL1). Thus, the kernel
+	 * exception fault handler doesn't trigger when reading pages
+	 * that aren't user read accessible */
 	extrd,u,*=      \pte,_PAGE_USER_BIT+32,1,%r0
 	depdi		7,11,3,\prot
+
 	/* If we're a gateway page, drop PL2 back to zero for promotion
 	 * to kernel privilege (so we can execute the page as kernel).
 	 * Any privilege promotion page always denys read and write */


