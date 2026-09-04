Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05413515D2;
	Fri,  4 Sep 2026 05:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498432; cv=none; b=mhdFxTd+G7guxtXhWm++8e+Gav4Oz+7tldFVYw7f6j9FhNN9bPc4YFzQQ48NqqmqiFWVMdtw7gj1JiYRcjVH9+9JaguIwq7UNU8byXrAPd8PskI0T1mp0x43plQN8D+2g6UlHePbaMhTMR1MXROMHjq1u1eE/AfEeOnVK7qFDNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498432; c=relaxed/simple;
	bh=qBLsNW1imEFubvh6hGempdheh7LvSjkLcl/OfprKM6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aGufFFek2B7Z1B8d2zVbTJRl0msC7c8eMex8gEfsKwbxsnX6UjMXB6ddEKpEGqq55bdoesrK2AaszgJp5mwhEMYe3WMPuZkm3UT/aNmyJBDYfr7g5HfioF6pYW6wiEeIPHoBt7K4SQaP5yginOK0QGSK02ZpfwSL4BcSRA1S3AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZNaCSArw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZNaCSArw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A861F00A3D;
	Fri,  4 Sep 2026 05:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498430;
	bh=T6AkxGO0PtJ5BQuHjb+4ls2JMwn1e5V9QcFjUZUwNB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZNaCSArwpS9/EXdBoQPHNMlpCiU05cD2q0nVayHa9a5OvE+uI2t+bgnjsP/punMYi
	 nZENa70ivNKfHOWmdzTueoKEmWJQU9SfUPRJoiORzhQrnX1A5XF8qi5LAKUPx2g3CO
	 4HS5FlJK7FhrZmE2KFbYCLseGyFBN4qAzFfnSG7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Graf <graf@amazon.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH 7.2 060/713] mm/mm_init: deferred_grow_zone(): fix out-of-range first_deferred_pfn
Date: Fri,  4 Sep 2026 06:50:28 +0200
Message-ID: <20260904045805.182860677@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2214,10 +2214,13 @@ bool __init deferred_grow_zone(struct zo
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
 


