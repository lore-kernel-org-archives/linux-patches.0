Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 376A72BE643;
	Tue, 26 Aug 2025 11:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208403; cv=none; b=iTx5p5IijJSPQm1IscYcM74AZxkY5C983gLixbM9ZsJk+VQRiugLsWUTayw1CiBEgWoVioy1+RqCYpZDnZrt8h13EVp3DnyVeLGUzabMye/DI0uDG+J/zzGmX1QYORYXYb/LO8h3qLmlJmngaJHuwdmu8vmf+hKCK1AUod+0RxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208403; c=relaxed/simple;
	bh=XFcLju0UdtT6JAullpycXv6+2bwGLIFq9NnaC7A+qwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hV3/QwID7YW7BeVXti+Is3pA8SC6RsK/g5tpVcQLeTX9mEUONpJm3cspun9O2EvrR8U0DBwBItHDj5VI9bQXXS3RlFLwsMF7MNKwL3BfLOKcpPOj3zZh2E+aGcHRY6wYqkejDUcdjbFcKBrLyoinP1op5Ds4MglqjILfWFZh7h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U3ENPJuG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U3ENPJuG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65BB5C4CEF1;
	Tue, 26 Aug 2025 11:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208402;
	bh=XFcLju0UdtT6JAullpycXv6+2bwGLIFq9NnaC7A+qwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U3ENPJuGQCGJ5jqiGzd+XNvN2d++CwlzTQqhWlBBrrXD4wRd6Gh24qJyUBt2lQU+Z
	 nA36TAcNX7ODQ0c7ni40sJXdP5QYDipn0TPVPdufU9l5lrsENT3QV62OXvJ891WXgj
	 8tdPPZktDs2tCReoJVgYGo797RP8u+pYzrxJ6NpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John David Anglin <dave.anglin@bell.net>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.12 097/322] parisc: Update comments in make_insert_tlb
Date: Tue, 26 Aug 2025 13:08:32 +0200
Message-ID: <20250826110918.083972972@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


