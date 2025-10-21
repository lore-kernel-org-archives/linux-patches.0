Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE205350A2A;
	Tue, 21 Oct 2025 19:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076748; cv=none; b=po0M6daIOx923QN96iO7Z3L3NWDt8tGq4AslHUJ5+6V4obnMCK1K+BiM7mxjPKCNl6lCGKL1ippyTkznnOA/C4Wvc/Dh1SkSevkANYE0g6GfdN7JOiptFZKt39mhcgzaQLoDox4o6pB1pDgf4d/qJEk5gVyl5LrDSol34oU51+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076748; c=relaxed/simple;
	bh=toVv56p8Ueg7D1zf4osCvITCaZicFvgmxVYRcG7uzI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oWtj/G6Oks9pAg/xJyl+nOjuR8ApUB3R0M23KHlysMmewrWzy2e+oKN74bzg8vIhr4IHrKmzusN4aqzrtb8UNCBHT59w0P5cG6z9ForuAdIJ0kFLmDVV/W+UC4tAKKp1Fjb4ig6GTDNe+KVtZb3UmuXPNkxE5JNcLoRUmijah5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V2ehkBtd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V2ehkBtd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4789EC4CEF1;
	Tue, 21 Oct 2025 19:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076747;
	bh=toVv56p8Ueg7D1zf4osCvITCaZicFvgmxVYRcG7uzI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V2ehkBtd1S5zo/6RI0qgmgS4UcKxsz+kEJy8qtobLSbfvDO0MrkYrtfYFmIrSqeP3
	 1byZGQbwiAv8P7zGATpch90IVKsTBpuZiUl14Ag1jBfopLsZKDh701WbIQBqewx2nk
	 y0ytaLwME2cB5RZ53CtEmLSyFnEOoFB9nbDHnS8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.12 025/136] perf/core: Fix MMAP2 event device with backing files
Date: Tue, 21 Oct 2025 21:50:13 +0200
Message-ID: <20251021195036.581007903@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

commit fa4f4bae893fbce8a3edfff1ab7ece0c01dc1328 upstream.

Some file systems like FUSE-based ones or overlayfs may record the backing
file in struct vm_area_struct vm_file, instead of the user file that the
user mmapped.

That causes perf to misreport the device major/minor numbers of the file
system of the file, and the generation of the file, and potentially other
inode details.  There is an existing helper file_user_inode() for that
situation.

Use file_user_inode() instead of file_inode() to get the inode for MMAP2
events.

Example:

  Setup:

    # cd /root
    # mkdir test ; cd test ; mkdir lower upper work merged
    # cp `which cat` lower
    # mount -t overlay overlay -olowerdir=lower,upperdir=upper,workdir=work merged
    # perf record -e cycles:u -- /root/test/merged/cat /proc/self/maps
    ...
    55b2c91d0000-55b2c926b000 r-xp 00018000 00:1a 3419                       /root/test/merged/cat
    ...
    [ perf record: Woken up 1 times to write data ]
    [ perf record: Captured and wrote 0.004 MB perf.data (5 samples) ]
    #
    # stat /root/test/merged/cat
      File: /root/test/merged/cat
      Size: 1127792         Blocks: 2208       IO Block: 4096   regular file
    Device: 0,26    Inode: 3419        Links: 1
    Access: (0755/-rwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
    Access: 2025-09-08 12:23:59.453309624 +0000
    Modify: 2025-09-08 12:23:59.454309624 +0000
    Change: 2025-09-08 12:23:59.454309624 +0000
     Birth: 2025-09-08 12:23:59.453309624 +0000

  Before:

    Device reported 00:02 differs from stat output and /proc/self/maps

    # perf script --show-mmap-events | grep /root/test/merged/cat
             cat     377 [-01]   243.078558: PERF_RECORD_MMAP2 377/377: [0x55b2c91d0000(0x9b000) @ 0x18000 00:02 3419 2068525940]: r-xp /root/test/merged/cat

  After:

    Device reported 00:1a is the same as stat output and /proc/self/maps

    # perf script --show-mmap-events | grep /root/test/merged/cat
             cat     362 [-01]   127.755167: PERF_RECORD_MMAP2 362/362: [0x55ba6e781000(0x9b000) @ 0x18000 00:1a 3419 0]: r-xp /root/test/merged/cat

With respect to stable kernels, overlayfs mmap function ovl_mmap() was
added in v4.19 but file_user_inode() was not added until v6.8 and never
back-ported to stable kernels.  FMODE_BACKING that it depends on was added
in v6.5.  This issue has gone largely unnoticed, so back-porting before
v6.8 is probably not worth it, so put 6.8 as the stable kernel prerequisite
version, although in practice the next long term kernel is 6.12.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Amir Goldstein <amir73il@gmail.com>
Cc: stable@vger.kernel.org # 6.8
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -8997,7 +8997,7 @@ static void perf_event_mmap_event(struct
 		flags |= MAP_HUGETLB;
 
 	if (file) {
-		struct inode *inode;
+		const struct inode *inode;
 		dev_t dev;
 
 		buf = kmalloc(PATH_MAX, GFP_KERNEL);
@@ -9015,7 +9015,7 @@ static void perf_event_mmap_event(struct
 			name = "//toolong";
 			goto cpy_name;
 		}
-		inode = file_inode(vma->vm_file);
+		inode = file_user_inode(vma->vm_file);
 		dev = inode->i_sb->s_dev;
 		ino = inode->i_ino;
 		gen = inode->i_generation;


