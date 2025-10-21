Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6BA25A355;
	Tue, 21 Oct 2025 20:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077386; cv=none; b=CgWVcFbvnTWmYPPPnwxrMlKotRsZRzVYXNAnuxoIrAvmWv8V1EoJn8Wb/+xcCwfp1Ppx6d5G1cCJ+q1Ug+GmlnN3FRHtxeg983VE5VKh50mhv11DDNIB1wgVFK2AbjtS4m8DT55939MMXKmLWOJbjffz3m77wFkY74a/Zct6DxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077386; c=relaxed/simple;
	bh=hes/aS3mn6ATSm7JB02LGy4QyNpyyi/Km5FvAHK8FiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tp98qr+vf9gh+wklnJaLFGH7UNCGi7NcNC9v2F7jFYHSmFtnsUWopZHKd8G93JgWk4CKUn/aDhdYJVp2r20rmvEqPvi6qswNWvBbzUw7ZYxxUVsTIfhKcXmwQjyOv5PVRkzSMAG2M1YDnuH3/tEWv5BX1Sb1H8uOIjv9u3yw7+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0+U1D2Ez; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0+U1D2Ez"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A7F4C4CEF1;
	Tue, 21 Oct 2025 20:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077386;
	bh=hes/aS3mn6ATSm7JB02LGy4QyNpyyi/Km5FvAHK8FiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0+U1D2EzZRGfAg9sdUs8fABS+U8HUu+YkI9ZM29DBcmVvG6+buKppO9kHVbuIkVj8
	 44C4H6QX8WsyVwTZjaH6B7uy0E3nNBmcSJGQy0EaiNGQX8NgkxkkTdmWwhSqn6tE+A
	 XktE/zrNK0kOSnJ5FwUzLBcw29otmI7BrlWf4UW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.17 046/159] perf/core: Fix MMAP2 event device with backing files
Date: Tue, 21 Oct 2025 21:50:23 +0200
Message-ID: <20251021195044.313446535@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -9390,7 +9390,7 @@ static void perf_event_mmap_event(struct
 		flags |= MAP_HUGETLB;
 
 	if (file) {
-		struct inode *inode;
+		const struct inode *inode;
 		dev_t dev;
 
 		buf = kmalloc(PATH_MAX, GFP_KERNEL);
@@ -9408,7 +9408,7 @@ static void perf_event_mmap_event(struct
 			name = "//toolong";
 			goto cpy_name;
 		}
-		inode = file_inode(vma->vm_file);
+		inode = file_user_inode(vma->vm_file);
 		dev = inode->i_sb->s_dev;
 		ino = inode->i_ino;
 		gen = inode->i_generation;


