Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50312223DF6;
	Tue, 26 Aug 2025 13:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213578; cv=none; b=ps5YQL3DsnLmVFqkJt1y+7dqkJwlgS7uZuqD44TkDs1gl5EXtXSV8NZhpzXEssqorbXwiy5gKf2TnzX161qj/GRrATdwcDTiNzu6tG+pvKe1HORoNYw4wyLS9FukFrI2HoAfIrlqefQcjHgh4uzWh0Ho0DJnsX3MiCuTR3Wjx3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213578; c=relaxed/simple;
	bh=Tbx8ElKOqxmXHEsrywL2mQdqi2793QgU7mJYmgiZpB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c/ExdzA1mNsF0L3/phkQ6ADNLb2j0uKoNeYTYMFlKq0hXpdfWJQ+GSBzvQtwjvbUqNHC/KO6zEZva2/nQMyKZu69ly1Nds3aYZwH1yIboc5rbBSYcKjxzHosavsHiX5zZQRdO1oPjbT4aYIFepaoRt7OmxAS8mHsfROVerYFmSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nL/HppD1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nL/HppD1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D22B3C113CF;
	Tue, 26 Aug 2025 13:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213578;
	bh=Tbx8ElKOqxmXHEsrywL2mQdqi2793QgU7mJYmgiZpB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nL/HppD1aGsZtx9NcCUbaPAnSohLbKt454It2n/bBectrF3sUPDxwCQFULISfrCgE
	 aA0UbcIqj8kK07Wy3bih6BWwuDdCpJYwZbO55X81Pq+gIK/m+rQfZr97nCSJGvPIn2
	 pR5G9CBU+in0gS8/H+Vz5MvmSfAM8qzXO6s0CWDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John David Anglin <dave.anglin@bell.net>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 400/587] parisc: Update comments in make_insert_tlb
Date: Tue, 26 Aug 2025 13:09:09 +0200
Message-ID: <20250826111003.099957776@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -499,6 +499,12 @@
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
@@ -511,17 +517,18 @@
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


