Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271F93290A5;
	Fri, 24 Apr 2026 13:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037986; cv=none; b=AO4O53ZsZJl3BW57dZNvBQeS5u/lfH59KAD+WEbsxQvyt5aKWoxX8GoIqndUzkrUqsCW1Dtu51GN/FPDmJl/Zg8iywjMZBhHOuAJIVz3AiJEWW9+RRkelTKaFQvH9LdphG8MU0f0XsM/K7DrLMJySYkcqNg/HEFUIFJpEp6p4RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037986; c=relaxed/simple;
	bh=alehJjcUMwfPDhEen7LCqXcZoFlkOfsz6EbvTf/6r5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VpCLow+M6gJ2ulsKDv3pTpHAmz9h5oAwQnTVFh0Ey05Npl2e380VQKFYTk2egCjydUS8H7dU+PCr25NFQBZzTOZnSUmUC0GxexIiD9l3TR72N0zRNKBgB/XPc0QdLVtd3WWlYouvRxQkJqfO9AM9+2KsriD0XLvwvokP33rHBnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1tJ0AOEM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1tJ0AOEM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B040FC19425;
	Fri, 24 Apr 2026 13:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037986;
	bh=alehJjcUMwfPDhEen7LCqXcZoFlkOfsz6EbvTf/6r5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1tJ0AOEMgfiIRqqpTR/qbz1kEUMQwVMGG0XgWCGFr/Ir0PVlxSeJpjvDc3iOliOxN
	 N9HyPk6CIloJ9pa7CqClF7R5MjTg0kg2t56KlOmj1KI8Nl8IT7z4ks3P7zUYvg+yo9
	 xEluumr2e0SRn3oIXKwts1SCEZ732pHt+BTLZ+14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	syzbot+cf7946ab25b21abc4b66@syzkaller.appspotmail.com,
	Eric Biggers <ebiggers@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.6 146/166] f2fs: fix to avoid memory leak in f2fs_rename()
Date: Fri, 24 Apr 2026 15:31:00 +0200
Message-ID: <20260424132603.637329005@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

commit 3cf11e6f36c170050c12171dd6fd3142711478fc upstream.

syzbot reported a f2fs bug as below:

BUG: memory leak
unreferenced object 0xffff888127f70830 (size 16):
  comm "syz.0.23", pid 6144, jiffies 4294943712
  hex dump (first 16 bytes):
    3c af 57 72 5b e6 8f ad 6e 8e fd 33 42 39 03 ff  <.Wr[...n..3B9..
  backtrace (crc 925f8a80):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4520 [inline]
    slab_alloc_node mm/slub.c:4844 [inline]
    __do_kmalloc_node mm/slub.c:5237 [inline]
    __kmalloc_noprof+0x3bd/0x560 mm/slub.c:5250
    kmalloc_noprof include/linux/slab.h:954 [inline]
    fscrypt_setup_filename+0x15e/0x3b0 fs/crypto/fname.c:364
    f2fs_setup_filename+0x52/0xb0 fs/f2fs/dir.c:143
    f2fs_rename+0x159/0xca0 fs/f2fs/namei.c:961
    f2fs_rename2+0xd5/0xf20 fs/f2fs/namei.c:1308
    vfs_rename+0x7ff/0x1250 fs/namei.c:6026
    filename_renameat2+0x4f4/0x660 fs/namei.c:6144
    __do_sys_renameat2 fs/namei.c:6173 [inline]
    __se_sys_renameat2 fs/namei.c:6168 [inline]
    __x64_sys_renameat2+0x59/0x80 fs/namei.c:6168
    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
    do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

The root cause is in commit 40b2d55e0452 ("f2fs: fix to create selinux
label during whiteout initialization"), we added a call to
f2fs_setup_filename() without a matching call to f2fs_free_filename(),
fix it.

Fixes: 40b2d55e0452 ("f2fs: fix to create selinux label during whiteout initialization")
Cc: stable@kernel.org
Reported-by: syzbot+cf7946ab25b21abc4b66@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-f2fs-devel/69a75fe1.a70a0220.b118c.0014.GAE@google.com
Suggested-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/namei.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -940,6 +940,7 @@ static int f2fs_rename(struct mnt_idmap
 			return err;
 
 		err = f2fs_create_whiteout(idmap, old_dir, &whiteout, &fname);
+		f2fs_free_filename(&fname);
 		if (err)
 			return err;
 	}


