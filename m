Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6A8B676;
	Mon, 23 Jun 2025 22:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716987; cv=none; b=VkUKR/zNfwJSUMBqPLQZsAYbeh+D1RbpqQqJ/LnEeHmaJ4JZazCHsOLoe0BofbuYQj5pVqLd1cq/YNbgCOjaaM09AD8ycRXi5/0UH343+czagresrOhyLcl+fg2yWDtwWfXrAgfOpeWztTbDIRsdtoijIPdngLr4NNo7l/gX9ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716987; c=relaxed/simple;
	bh=S/i6QmrPlLmupkKbsWs1iEGiKnDmjBVTL3byZiEKttQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EeuOEev/7/PFndWJfN+lUxCsMaxHAIQApw9OXyofRkSE8iEi37p5z2EgCm3LE2N1cVmGErA9ux6sfs9PMIBls93M7QOSYz/8QYXKsrfUlTBiuAyzNHDzlu3sJ9EbrEr74fNx7ylDTLj9PuMsEeJZNMgpTumBbOV/boxb/QuJ34c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ERsKoJqo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ERsKoJqo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98E66C4CEEA;
	Mon, 23 Jun 2025 22:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716986;
	bh=S/i6QmrPlLmupkKbsWs1iEGiKnDmjBVTL3byZiEKttQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ERsKoJqo7ErexBmWT7LAH1RcGdiGV3K5fLm//2fB0oJaTocxLEl9JGVi1tlH3l4Tx
	 e4aU7lIB83Y8jR2JssJm220QUmTLE9pd4a5/C9ZFUd6CeWzlWqTY+S1YEeLEUi7vXt
	 8mfMuaXf8gTGkxUlXn5vnPL5rMh/sAknBxmxm7B8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Sadovnikov <a.sadovnikov@ispras.ru>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>
Subject: [PATCH 6.12 304/414] jffs2: check that raw node were preallocated before writing summary
Date: Mon, 23 Jun 2025 15:07:21 +0200
Message-ID: <20250623130649.604893370@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

From: Artem Sadovnikov <a.sadovnikov@ispras.ru>

commit ec9e6f22bce433b260ea226de127ec68042849b0 upstream.

Syzkaller detected a kernel bug in jffs2_link_node_ref, caused by fault
injection in jffs2_prealloc_raw_node_refs. jffs2_sum_write_sumnode doesn't
check return value of jffs2_prealloc_raw_node_refs and simply lets any
error propagate into jffs2_sum_write_data, which eventually calls
jffs2_link_node_ref in order to link the summary to an expectedly allocated
node.

kernel BUG at fs/jffs2/nodelist.c:592!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 1 PID: 31277 Comm: syz-executor.7 Not tainted 6.1.128-syzkaller-00139-ge10f83ca10a1 #0
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
RIP: 0010:jffs2_link_node_ref+0x570/0x690 fs/jffs2/nodelist.c:592
Call Trace:
 <TASK>
 jffs2_sum_write_data fs/jffs2/summary.c:841 [inline]
 jffs2_sum_write_sumnode+0xd1a/0x1da0 fs/jffs2/summary.c:874
 jffs2_do_reserve_space+0xa18/0xd60 fs/jffs2/nodemgmt.c:388
 jffs2_reserve_space+0x55f/0xaa0 fs/jffs2/nodemgmt.c:197
 jffs2_write_inode_range+0x246/0xb50 fs/jffs2/write.c:362
 jffs2_write_end+0x726/0x15d0 fs/jffs2/file.c:301
 generic_perform_write+0x314/0x5d0 mm/filemap.c:3856
 __generic_file_write_iter+0x2ae/0x4d0 mm/filemap.c:3973
 generic_file_write_iter+0xe3/0x350 mm/filemap.c:4005
 call_write_iter include/linux/fs.h:2265 [inline]
 do_iter_readv_writev+0x20f/0x3c0 fs/read_write.c:735
 do_iter_write+0x186/0x710 fs/read_write.c:861
 vfs_iter_write+0x70/0xa0 fs/read_write.c:902
 iter_file_splice_write+0x73b/0xc90 fs/splice.c:685
 do_splice_from fs/splice.c:763 [inline]
 direct_splice_actor+0x10c/0x170 fs/splice.c:950
 splice_direct_to_actor+0x337/0xa10 fs/splice.c:896
 do_splice_direct+0x1a9/0x280 fs/splice.c:1002
 do_sendfile+0xb13/0x12c0 fs/read_write.c:1255
 __do_sys_sendfile64 fs/read_write.c:1323 [inline]
 __se_sys_sendfile64 fs/read_write.c:1309 [inline]
 __x64_sys_sendfile64+0x1cf/0x210 fs/read_write.c:1309
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x35/0x80 arch/x86/entry/common.c:81
 entry_SYSCALL_64_after_hwframe+0x6e/0xd8

Fix this issue by checking return value of jffs2_prealloc_raw_node_refs
before calling jffs2_sum_write_data.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Cc: stable@vger.kernel.org
Fixes: 2f785402f39b ("[JFFS2] Reduce visibility of raw_node_ref to upper layers of JFFS2 code.")
Signed-off-by: Artem Sadovnikov <a.sadovnikov@ispras.ru>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jffs2/summary.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/jffs2/summary.c
+++ b/fs/jffs2/summary.c
@@ -858,7 +858,10 @@ int jffs2_sum_write_sumnode(struct jffs2
 	spin_unlock(&c->erase_completion_lock);
 
 	jeb = c->nextblock;
-	jffs2_prealloc_raw_node_refs(c, jeb, 1);
+	ret = jffs2_prealloc_raw_node_refs(c, jeb, 1);
+
+	if (ret)
+		goto out;
 
 	if (!c->summary->sum_num || !c->summary->sum_list_head) {
 		JFFS2_WARNING("Empty summary info!!!\n");
@@ -872,6 +875,8 @@ int jffs2_sum_write_sumnode(struct jffs2
 	datasize += padsize;
 
 	ret = jffs2_sum_write_data(c, jeb, infosize, datasize, padsize);
+
+out:
 	spin_lock(&c->erase_completion_lock);
 	return ret;
 }


