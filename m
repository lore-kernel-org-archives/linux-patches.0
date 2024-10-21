Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A311E907B;
	Mon, 21 Oct 2024 10:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507577; cv=none; b=KGcGUrtbsJT/rLiSnLZdhCpTf2+WPzAYOjf0BwTKhJ1rpnjHH0kmo39aTCcMPNeUtDq777JXoBI309CAayBTXgzhZvxHjidYXet69N8owiIE5LorMcy5qx4hDFdoU/UhKL7i8JykpcZSYhdWFbT4uvrTP93SYkCU1zR4lBvyNsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507577; c=relaxed/simple;
	bh=CGX4IgAjQX3B7A/isf1fznStHJvgoPDa3Ho0Z8eYhyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PGNpxBXsYLxTgA2yAVuCMyanGaOx+X76iacP1KmDpMZjdMIgAckRacRBq8yUywA6UUmklI3QcfU02OZBpLogC7PcRMdgIfHmLKLj06EVBHlVzhVRanQ3Zn11zUhUwAHct4RF+S9rpJmuhfg5nR++YNNxC9cEeomk6DLEVpthIHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=avoOd4Sw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="avoOd4Sw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F658C4CEE6;
	Mon, 21 Oct 2024 10:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507576;
	bh=CGX4IgAjQX3B7A/isf1fznStHJvgoPDa3Ho0Z8eYhyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=avoOd4SwEhk7tfM3jZfBfMjZNJgCHeFako2DB9RRFBe71toIni3dzUUTgWF9rNo9Y
	 il5vEuZ01dVTEyDi8eg/64XS0+Y2yxGxO75AdPfqMkguD2T4JEODvSJkUV6mwnr18Y
	 9sN0Oek0Gh+d1tYWtJcb4nIKJdmFkocELG3FkYsw=
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
Subject: [PATCH 5.15 31/82] secretmem: disable memfd_secret() if arch cannot set direct map
Date: Mon, 21 Oct 2024 12:25:12 +0200
Message-ID: <20241021102248.477237445@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102247.209765070@linuxfoundation.org>
References: <20241021102247.209765070@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/secretmem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/secretmem.c
+++ b/mm/secretmem.c
@@ -234,7 +234,7 @@ SYSCALL_DEFINE1(memfd_secret, unsigned i
 	/* make sure local flags do not confict with global fcntl.h */
 	BUILD_BUG_ON(SECRETMEM_FLAGS_MASK & O_CLOEXEC);
 
-	if (!secretmem_enable)
+	if (!secretmem_enable || !can_set_direct_map())
 		return -ENOSYS;
 
 	if (flags & ~(SECRETMEM_FLAGS_MASK | O_CLOEXEC))
@@ -278,7 +278,7 @@ static int secretmem_init(void)
 {
 	int ret = 0;
 
-	if (!secretmem_enable)
+	if (!secretmem_enable || !can_set_direct_map())
 		return ret;
 
 	secretmem_mnt = kern_mount(&secretmem_fs);


