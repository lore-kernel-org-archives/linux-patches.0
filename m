Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5EBC1AB6EF;
	Wed, 20 Nov 2024 12:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107517; cv=none; b=IUcyPzRD1DNH8WRfLwn1YxK+/agDZ5vxH5r/obyMLEtjiVEBkWih1QBZpPLiRBy1pnArHDc/LKmxmYKefX5S5qHo6/HzuZDr8QgEFCgoxVvITVDKaMtnm+gg16BHtlVMbAUYl4WCgO7SubYWYLvn2Tve753CxyD+ixpYVQacqZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107517; c=relaxed/simple;
	bh=4tVTpL1mZd7+8SG+9SA52ST+5AaJybesJh/dQrw4g8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dqFyV51V9MI2yDPFYL07rvWypbSFwXb6S+6EAq+VOF+gJkQ5XgYXfsz0P90vP8Mfu1ozpGQC3kPVCGHxSDJOCicXce4KTbqFj42AjYvgD4MSknoJXGvbpKTIGanA0SjgHXbUXqfJPfMzGQyjECtom6xZOR8c21gkZuyHekyLBqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BDNdra8x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BDNdra8x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE05C4CECD;
	Wed, 20 Nov 2024 12:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107517;
	bh=4tVTpL1mZd7+8SG+9SA52ST+5AaJybesJh/dQrw4g8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BDNdra8xFg65mTooiWWUsQcWlr8L446zV9ffCus52EsYzfdvPTWnp/6mmLwyaXVqh
	 FMZZIaL81z+xvFDWYTOdKBFegaKVRmwezUqCojlJlbvwmmW6RPATa8uFljD3wGIGxC
	 wEbBDzEhFd5Jyn1BleEA3YeC1+hKbcW4mpn0sHpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	"Liam R. Howlett" <Liam.Howlett@Oracle.com>,
	"Joel Fernandes (Google)" <joel@joelfernandes.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.11 047/107] mm/mremap: fix address wraparound in move_page_tables()
Date: Wed, 20 Nov 2024 13:56:22 +0100
Message-ID: <20241120125630.737996804@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

commit a4a282daf1a190f03790bf163458ea3c8d28d217 upstream.

On 32-bit platforms, it is possible for the expression `len + old_addr <
old_end` to be false-positive if `len + old_addr` wraps around.
`old_addr` is the cursor in the old range up to which page table entries
have been moved; so if the operation succeeded, `old_addr` is the *end* of
the old region, and adding `len` to it can wrap.

The overflow causes mremap() to mistakenly believe that PTEs have been
copied; the consequence is that mremap() bails out, but doesn't move the
PTEs back before the new VMA is unmapped, causing anonymous pages in the
region to be lost.  So basically if userspace tries to mremap() a
private-anon region and hits this bug, mremap() will return an error and
the private-anon region's contents appear to have been zeroed.

The idea of this check is that `old_end - len` is the original start
address, and writing the check that way also makes it easier to read; so
fix the check by rearranging the comparison accordingly.

(An alternate fix would be to refactor this function by introducing an
"orig_old_start" variable or such.)


Tested in a VM with a 32-bit X86 kernel; without the patch:

```
user@horn:~/big_mremap$ cat test.c
#define _GNU_SOURCE
#include <stdlib.h>
#include <stdio.h>
#include <err.h>
#include <sys/mman.h>

#define ADDR1 ((void*)0x60000000)
#define ADDR2 ((void*)0x10000000)
#define SIZE          0x50000000uL

int main(void) {
  unsigned char *p1 = mmap(ADDR1, SIZE, PROT_READ|PROT_WRITE,
      MAP_ANONYMOUS|MAP_PRIVATE|MAP_FIXED_NOREPLACE, -1, 0);
  if (p1 == MAP_FAILED)
    err(1, "mmap 1");
  unsigned char *p2 = mmap(ADDR2, SIZE, PROT_NONE,
      MAP_ANONYMOUS|MAP_PRIVATE|MAP_FIXED_NOREPLACE, -1, 0);
  if (p2 == MAP_FAILED)
    err(1, "mmap 2");
  *p1 = 0x41;
  printf("first char is 0x%02hhx\n", *p1);
  unsigned char *p3 = mremap(p1, SIZE, SIZE,
      MREMAP_MAYMOVE|MREMAP_FIXED, p2);
  if (p3 == MAP_FAILED) {
    printf("mremap() failed; first char is 0x%02hhx\n", *p1);
  } else {
    printf("mremap() succeeded; first char is 0x%02hhx\n", *p3);
  }
}
user@horn:~/big_mremap$ gcc -static -o test test.c
user@horn:~/big_mremap$ setarch -R ./test
first char is 0x41
mremap() failed; first char is 0x00
```

With the patch:

```
user@horn:~/big_mremap$ setarch -R ./test
first char is 0x41
mremap() succeeded; first char is 0x41
```

Link: https://lkml.kernel.org/r/20241111-fix-mremap-32bit-wrap-v1-1-61d6be73b722@google.com
Fixes: af8ca1c14906 ("mm/mremap: optimize the start addresses in move_page_tables()")
Signed-off-by: Jann Horn <jannh@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mremap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -648,7 +648,7 @@ again:
 	 * Prevent negative return values when {old,new}_addr was realigned
 	 * but we broke out of the above loop for the first PMD itself.
 	 */
-	if (len + old_addr < old_end)
+	if (old_addr < old_end - len)
 		return 0;
 
 	return len + old_addr - old_end;	/* how much done */


