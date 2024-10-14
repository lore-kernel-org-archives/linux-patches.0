Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0724419E802;
	Mon, 14 Oct 2024 14:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916538; cv=none; b=qllVtrLxE4uXaq4aM+Vgotyvq0Ik1Z6YX3+9IcY+EK6eU8AmpvpfLM3j44W4DhKR3MhuB/0FnJViEGai4vMxnvXYcgdqaxThFiePoJvQahaawnIa23aOcVvnL1+yuX8Crau9SQg6oSj9p1WP6dGtwXdvGC6MAWIQBSCkE5P9L5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916538; c=relaxed/simple;
	bh=bOnwC81/UpNdBnEqIe6JhimC24tkIPhf6y2L1l1l4L4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fm2xboPjrwqIixWcgCYEWhBU7eazGt6H7Kk+DnieVdvxL7OdG9oXlPiMiweHhwF2zXFwkyK+azLkYy/0bZfB1FFopxUivcDoSCn/AVLi+HTtSx1af5jOAeX6EkQD99jjo1OveUu+wux1gbtyH6oBWdLyOPP42+BRY8IIFcpcsnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FlV2aQSa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FlV2aQSa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83BE4C4CEC3;
	Mon, 14 Oct 2024 14:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916537;
	bh=bOnwC81/UpNdBnEqIe6JhimC24tkIPhf6y2L1l1l4L4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FlV2aQSaosG144yUVOQS9FQYX5Vd6ofzwLizdKR/EMArQwwy4d/KlYDGujtVs+ZzD
	 claFOWdjkLUC56clqbOoMg9nmdlQqP3mSFjA/ucwf3si/taMOO7a6xgsvzB+ojmX37
	 +/f9fUpk6WmWBGmcxsBC2jmSHsiZCG24XxEJZ3bM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrick Roy <roypat@amazon.co.uk>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	David Hildenbrand <david@redhat.com>,
	James Gowans <jgowans@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.11 212/214] secretmem: disable memfd_secret() if arch cannot set direct map
Date: Mon, 14 Oct 2024 16:21:15 +0200
Message-ID: <20241014141053.250150809@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

From: Patrick Roy <roypat@amazon.co.uk>

commit 532b53cebe58f34ce1c0f34d866f5c0e335c53c6 upstream.

Return -ENOSYS from memfd_secret() syscall if !can_set_direct_map().  This
is the case for example on some arm64 configurations, where marking 4k
PTEs in the direct map not present can only be done if the direct map is
set up at 4k granularity in the first place (as ARM's break-before-make
semantics do not easily allow breaking apart large/gigantic pages).

More precisely, on arm64 systems with !can_set_direct_map(),
set_direct_map_invalid_noflush() is a no-op, however it returns success
(0) instead of an error.  This means that memfd_secret will seemingly
"work" (e.g.  syscall succeeds, you can mmap the fd and fault in pages),
but it does not actually achieve its goal of removing its memory from the
direct map.

Note that with this patch, memfd_secret() will start erroring on systems
where can_set_direct_map() returns false (arm64 with
CONFIG_RODATA_FULL_DEFAULT_ENABLED=n, CONFIG_DEBUG_PAGEALLOC=n and
CONFIG_KFENCE=n), but that still seems better than the current silent
failure.  Since CONFIG_RODATA_FULL_DEFAULT_ENABLED defaults to 'y', most
arm64 systems actually have a working memfd_secret() and aren't be
affected.

>From going through the iterations of the original memfd_secret patch
series, it seems that disabling the syscall in these scenarios was the
intended behavior [1] (preferred over having
set_direct_map_invalid_noflush return an error as that would result in
SIGBUSes at page-fault time), however the check for it got dropped between
v16 [2] and v17 [3], when secretmem moved away from CMA allocations.

[1]: https://lore.kernel.org/lkml/20201124164930.GK8537@kernel.org/
[2]: https://lore.kernel.org/lkml/20210121122723.3446-11-rppt@kernel.org/#t
[3]: https://lore.kernel.org/lkml/20201125092208.12544-10-rppt@kernel.org/

Link: https://lkml.kernel.org/r/20241001080056.784735-1-roypat@amazon.co.uk
Fixes: 1507f51255c9 ("mm: introduce memfd_secret system call to create "secret" memory areas")
Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: James Gowans <jgowans@amazon.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/secretmem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/secretmem.c
+++ b/mm/secretmem.c
@@ -238,7 +238,7 @@ SYSCALL_DEFINE1(memfd_secret, unsigned i
 	/* make sure local flags do not confict with global fcntl.h */
 	BUILD_BUG_ON(SECRETMEM_FLAGS_MASK & O_CLOEXEC);
 
-	if (!secretmem_enable)
+	if (!secretmem_enable || !can_set_direct_map())
 		return -ENOSYS;
 
 	if (flags & ~(SECRETMEM_FLAGS_MASK | O_CLOEXEC))
@@ -280,7 +280,7 @@ static struct file_system_type secretmem
 
 static int __init secretmem_init(void)
 {
-	if (!secretmem_enable)
+	if (!secretmem_enable || !can_set_direct_map())
 		return 0;
 
 	secretmem_mnt = kern_mount(&secretmem_fs);


