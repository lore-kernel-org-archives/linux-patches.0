Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6DBF4137B2;
	Fri,  4 Sep 2026 05:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500379; cv=none; b=Fxym9+nzyRSfRzIOjiuSvyy8I4La6GuAscqHHIFa4JVQaxA7qSVXA8b0v1XCrn0iMmvvFIqUnsb8oSKeFUIMU4nlDTg11wfNCq6nS8hwIQ/fzFUeI4oLlsaqHNFU1krTmK1O6/zuk1iGb/2h0//5co+bX2Z+V8Uo/75OXH9gEzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500379; c=relaxed/simple;
	bh=TPxmPDYlUGllETb7mk7fpKxZ3trXPebEIJRjEa946jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LWfPbg6hhh98sUJDC4dyJcyAuicpo5EPUKTYTweaLm0MXqWBTX14Wx78ZDF3SYpmX1dhi6HwW+HGKwaB80oKfKvZJOmMiXcY5nIKYYr+qZZ9pA2EhEmDZeeWbh6XK5YdkmJn72vgvq86kiIcDi1t410Tx3BR4AXi0+W6cpKqoHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lsjfv6gA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lsjfv6gA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA261F00A3E;
	Fri,  4 Sep 2026 05:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500377;
	bh=1W4EDswxN/FK0ViM6mw+iO4ZTm2dHLl3lFcumItb7bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lsjfv6gAf91BgwBJcHMkzyxspgb2AavxUOuwdWiGaI9Yf8+BXWYx9dq6fDdjwcMUM
	 SuTZLVkybzWxL7G/iit6JMlIVaVPFNMb29d0z+57rrdJJ2DnmqqRtSZXQdh82pyMCv
	 WgDXcAnKAxzbaL0uOiqZuKIhm7/7rz34TymaFhv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Graf <graf@amazon.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH 6.18 036/552] mm/mm_init: deferred_grow_zone(): fix out-of-range first_deferred_pfn
Date: Fri,  4 Sep 2026 06:53:13 +0200
Message-ID: <20260904045748.648551372@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Graf <graf@amazon.com>

commit 97090500d776c3f6d08e857e3a0a7cf092999094 upstream.

With CONFIG_DEFERRED_STRUCT_PAGE_INIT enabled, deferred_grow_zone()
initializes struct pages early in boot to satisfy an allocation.

With a large CMA reservation in place, the ranges deferred_init_memmap()
finds may not add up to the allocation it was asked for, and the function
ends up initializing the memory map of the entire zone and still falls
short.

That is fine in itself: the function accounts for it and leaves the
caller to decide whether it now has enough memory.

However, the update of pgdat->first_deferred_pfn that tracks where
uninitialized memory map starts could overflow.

If the node's RAM end is not aligned on PAGES_PER_SECTION boundaries and
some deferred struct pages were initialized, pgdat->first_deferred_pfn
would point past the end of the node's memory.

deferred_init_memmap() later picks up from pgdat->first_deferred_pfn and
hits a BUG_ON(), because it expects a pfn within its node.

For example, when running a kernel with CONFIG_DEFERRED_STRUCT_PAGE_INIT=y
and CONFIG_CMA=y using the following qemu command line

  qemu-system-x86_64 -enable-kvm -m 8032M -kernel bzImage \
      -append "nokaslr cma=4768M@0x100000000"

the kernel panics:

  kernel BUG at mm/mm_init.c:2131!
  CPU: 3 UID: 0 PID: 36 Comm: pgdatinit0 Not tainted 7.2.0-rc6 #1
  RIP: 0010:deferred_init_memmap+0x1b8/0x1c0
  RAX: 0000000000236000 R13: 0000000000238000
  Call Trace:
   kthread+0xdf/0x120
   ret_from_fork+0x187/0x250

Make sure that the update of pgdta->first_deferred_pfn does not overflow
when the entire zone's (and therefore node's) memory map is initialized.

Fixes: 3acb913c9d5b ("mm/mm_init: use deferred_init_memmap_chunk() in deferred_grow_zone()")
Cc: stable@vger.kernel.org
Assisted-by: Kiro:claude-opus-5
Signed-off-by: Alexander Graf <graf@amazon.com>
Link: https://patch.msgid.link/20260807031243.87904-1-graf@amazon.com
[rppt: massaged the changelog]
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mm_init.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2238,10 +2238,13 @@ bool __init deferred_grow_zone(struct zo
 	}
 
 	/*
-	 * There were no pages to initialize and free which means the zone's
-	 * memory map is completely initialized.
+	 * The loop only tests spfn before entering an iteration, so on exit it
+	 * may point up to a section past the end of the zone.  When it does,
+	 * the rest of the zone has already been handed to
+	 * deferred_init_memmap_chunk() and nothing is left to initialize.
 	 */
-	pgdat->first_deferred_pfn = nr_pages ? spfn : ULONG_MAX;
+	pgdat->first_deferred_pfn =
+		spfn < zone_end_pfn(zone) ? spfn : ULONG_MAX;
 
 	pgdat_resize_unlock(pgdat, &flags);
 


