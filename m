Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B457226D04;
	Mon, 23 Jun 2025 22:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716659; cv=none; b=BvzQe6czU3ScfOdybf3TQy9Lpmr/M39/r3TiTY5lHlQuADrIAFAx4FM1zILZv94Z9aX9ZZmyeXo84Usbx8wxuVgHiOO/d4Fzn9u/G7rBeAZ1/EJiOP3iNWNMwwQ+nUc/jYXWo/Db/ppINo9WEahrEMfccFeVnDWHfF2Wawck5VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716659; c=relaxed/simple;
	bh=Plmg6t/y47uz2+GCa9WbG9DolsKtK+dLddLiPLmQXiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=at3ipUdA83ihYLc1fGJ3mxtLcWOY74SH/m/+r7JwhGkYu8sOuBy2Du6JIt2HF9PF6VnZz8NLwva/MTem6UtoZPB8tnD7bXpnOhyDRSuc+wDCv17tND9WV7SH2QvBR2sGtWpyDmSXsR0GvnJayjVQgVZya2ZzdxyDkUGC6W59DTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NV7FKQg1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NV7FKQg1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11484C4CEEA;
	Mon, 23 Jun 2025 22:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716659;
	bh=Plmg6t/y47uz2+GCa9WbG9DolsKtK+dLddLiPLmQXiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NV7FKQg1Ekj9ZbUNWvY6bSIF/XbiUeztqFqQvxiYX3NoyCFqmrXt3a9SjJ4FhseI9
	 xuTjXripnZgdVN7FQGOC0kiHcMeWpfgyMkXdBSkIxkprGEbK2a04ZcS28co5rwiNYh
	 AhiKPx70pUXm+yryljHUFcJbcQqP4b9e7tGg2+uU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.15 348/411] jffs2: check jffs2_prealloc_raw_node_refs() result in few other places
Date: Mon, 23 Jun 2025 15:08:12 +0200
Message-ID: <20250623130642.406659797@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

commit 2b6d96503255a3ed676cd70f8368870c6d6a25c6 upstream.

Fuzzing hit another invalid pointer dereference due to the lack of
checking whether jffs2_prealloc_raw_node_refs() completed successfully.
Subsequent logic implies that the node refs have been allocated.

Handle that. The code is ready for propagating the error upwards.

KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 1 PID: 5835 Comm: syz-executor145 Not tainted 5.10.234-syzkaller #0
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
RIP: 0010:jffs2_link_node_ref+0xac/0x690 fs/jffs2/nodelist.c:600
Call Trace:
 jffs2_mark_erased_block fs/jffs2/erase.c:460 [inline]
 jffs2_erase_pending_blocks+0x688/0x1860 fs/jffs2/erase.c:118
 jffs2_garbage_collect_pass+0x638/0x1a00 fs/jffs2/gc.c:253
 jffs2_reserve_space+0x3f4/0xad0 fs/jffs2/nodemgmt.c:167
 jffs2_write_inode_range+0x246/0xb50 fs/jffs2/write.c:362
 jffs2_write_end+0x712/0x1110 fs/jffs2/file.c:302
 generic_perform_write+0x2c2/0x500 mm/filemap.c:3347
 __generic_file_write_iter+0x252/0x610 mm/filemap.c:3465
 generic_file_write_iter+0xdb/0x230 mm/filemap.c:3497
 call_write_iter include/linux/fs.h:2039 [inline]
 do_iter_readv_writev+0x46d/0x750 fs/read_write.c:740
 do_iter_write+0x18c/0x710 fs/read_write.c:866
 vfs_writev+0x1db/0x6a0 fs/read_write.c:939
 do_pwritev fs/read_write.c:1036 [inline]
 __do_sys_pwritev fs/read_write.c:1083 [inline]
 __se_sys_pwritev fs/read_write.c:1078 [inline]
 __x64_sys_pwritev+0x235/0x310 fs/read_write.c:1078
 do_syscall_64+0x30/0x40 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x67/0xd1

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 2f785402f39b ("[JFFS2] Reduce visibility of raw_node_ref to upper layers of JFFS2 code.")
Fixes: f560928baa60 ("[JFFS2] Allocate node_ref for wasted space when skipping to page boundary")
Cc: stable@vger.kernel.org
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jffs2/erase.c |    4 +++-
 fs/jffs2/scan.c  |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/fs/jffs2/erase.c
+++ b/fs/jffs2/erase.c
@@ -427,7 +427,9 @@ static void jffs2_mark_erased_block(stru
 			.totlen =	cpu_to_je32(c->cleanmarker_size)
 		};
 
-		jffs2_prealloc_raw_node_refs(c, jeb, 1);
+		ret = jffs2_prealloc_raw_node_refs(c, jeb, 1);
+		if (ret)
+			goto filebad;
 
 		marker.hdr_crc = cpu_to_je32(crc32(0, &marker, sizeof(struct jffs2_unknown_node)-4));
 
--- a/fs/jffs2/scan.c
+++ b/fs/jffs2/scan.c
@@ -256,7 +256,9 @@ int jffs2_scan_medium(struct jffs2_sb_in
 
 		jffs2_dbg(1, "%s(): Skipping %d bytes in nextblock to ensure page alignment\n",
 			  __func__, skip);
-		jffs2_prealloc_raw_node_refs(c, c->nextblock, 1);
+		ret = jffs2_prealloc_raw_node_refs(c, c->nextblock, 1);
+		if (ret)
+			goto out;
 		jffs2_scan_dirty_space(c, c->nextblock, skip);
 	}
 #endif


