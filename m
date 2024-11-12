Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 878852123F7;
	Tue, 12 Nov 2024 10:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407161; cv=none; b=s5IhkDRWtLc5Bq79gG+maA7xALGb8h87R+zGTusAPJloe5iFFLKf3h92qgUcffRxZW44kV0ek9p34NynBeqpxVlNsneV9SdXWhLBAB7qxKBY9QB6ybzWVlDAUdJAn+Vkf3gMa5+4DH/IrsilP/ShBgJLQiHltXW8VR/DWsJjwt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407161; c=relaxed/simple;
	bh=gLW/QaNabNTT9br4e6bxdAkY6Rqx7OP/hbmtddJw4fk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KHEE2ajLMCPS+cGLd/KO46kV6auxlHItU6ckQk7e7hgY5pSzg6xu2nS3yiE4r1ShQlxIBpGUMX1N2Ge0IKUQoQh/WhPosHOPXozsq5gcpV3Q+eNfue9kAsWEXlwu70BhyW39uCCvN7U/GfhRyTLvjcYM7TdCCRC466eXwNU44pE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kUSIgWih; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kUSIgWih"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEAB3C4CECD;
	Tue, 12 Nov 2024 10:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407161;
	bh=gLW/QaNabNTT9br4e6bxdAkY6Rqx7OP/hbmtddJw4fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kUSIgWih65nQVW0OLhbxiY3V1oe/id9v+UdUPZPqrJedNxsZJUE52aLDtuDIl6Nih
	 t5ckt6XC4eF8OxR9YgqWArLMMfSV+Plrv8thGPw8wusXF2K875vQt2PfMPNkEfEBUO
	 xzwAVvxcVKI8vNFn6YXTMiBxuJmmHEqWOiGLxGs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Kanner <andrew.kanner@gmail.com>,
	syzbot+386ce9e60fa1b18aac5b@syzkaller.appspotmail.com,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 69/76] ocfs2: remove entry once instead of null-ptr-dereference in ocfs2_xa_remove()
Date: Tue, 12 Nov 2024 11:21:34 +0100
Message-ID: <20241112101842.408212564@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101839.777512218@linuxfoundation.org>
References: <20241112101839.777512218@linuxfoundation.org>
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

From: Andrew Kanner <andrew.kanner@gmail.com>

commit 0b63c0e01fba40e3992bc627272ec7b618ccaef7 upstream.

Syzkaller is able to provoke null-ptr-dereference in ocfs2_xa_remove():

[   57.319872] (a.out,1161,7):ocfs2_xa_remove:2028 ERROR: status = -12
[   57.320420] (a.out,1161,7):ocfs2_xa_cleanup_value_truncate:1999 ERROR: Partial truncate while removing xattr overlay.upper.  Leaking 1 clusters and removing the entry
[   57.321727] BUG: kernel NULL pointer dereference, address: 0000000000000004
[...]
[   57.325727] RIP: 0010:ocfs2_xa_block_wipe_namevalue+0x2a/0xc0
[...]
[   57.331328] Call Trace:
[   57.331477]  <TASK>
[...]
[   57.333511]  ? do_user_addr_fault+0x3e5/0x740
[   57.333778]  ? exc_page_fault+0x70/0x170
[   57.334016]  ? asm_exc_page_fault+0x2b/0x30
[   57.334263]  ? __pfx_ocfs2_xa_block_wipe_namevalue+0x10/0x10
[   57.334596]  ? ocfs2_xa_block_wipe_namevalue+0x2a/0xc0
[   57.334913]  ocfs2_xa_remove_entry+0x23/0xc0
[   57.335164]  ocfs2_xa_set+0x704/0xcf0
[   57.335381]  ? _raw_spin_unlock+0x1a/0x40
[   57.335620]  ? ocfs2_inode_cache_unlock+0x16/0x20
[   57.335915]  ? trace_preempt_on+0x1e/0x70
[   57.336153]  ? start_this_handle+0x16c/0x500
[   57.336410]  ? preempt_count_sub+0x50/0x80
[   57.336656]  ? _raw_read_unlock+0x20/0x40
[   57.336906]  ? start_this_handle+0x16c/0x500
[   57.337162]  ocfs2_xattr_block_set+0xa6/0x1e0
[   57.337424]  __ocfs2_xattr_set_handle+0x1fd/0x5d0
[   57.337706]  ? ocfs2_start_trans+0x13d/0x290
[   57.337971]  ocfs2_xattr_set+0xb13/0xfb0
[   57.338207]  ? dput+0x46/0x1c0
[   57.338393]  ocfs2_xattr_trusted_set+0x28/0x30
[   57.338665]  ? ocfs2_xattr_trusted_set+0x28/0x30
[   57.338948]  __vfs_removexattr+0x92/0xc0
[   57.339182]  __vfs_removexattr_locked+0xd5/0x190
[   57.339456]  ? preempt_count_sub+0x50/0x80
[   57.339705]  vfs_removexattr+0x5f/0x100
[...]

Reproducer uses faultinject facility to fail ocfs2_xa_remove() ->
ocfs2_xa_value_truncate() with -ENOMEM.

In this case the comment mentions that we can return 0 if
ocfs2_xa_cleanup_value_truncate() is going to wipe the entry
anyway. But the following 'rc' check is wrong and execution flow do
'ocfs2_xa_remove_entry(loc);' twice:
* 1st: in ocfs2_xa_cleanup_value_truncate();
* 2nd: returning back to ocfs2_xa_remove() instead of going to 'out'.

Fix this by skipping the 2nd removal of the same entry and making
syzkaller repro happy.

Link: https://lkml.kernel.org/r/20241103193845.2940988-1-andrew.kanner@gmail.com
Fixes: 399ff3a748cf ("ocfs2: Handle errors while setting external xattr values.")
Signed-off-by: Andrew Kanner <andrew.kanner@gmail.com>
Reported-by: syzbot+386ce9e60fa1b18aac5b@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/671e13ab.050a0220.2b8c0f.01d0.GAE@google.com/T/
Tested-by: syzbot+386ce9e60fa1b18aac5b@syzkaller.appspotmail.com
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/xattr.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -2040,8 +2040,7 @@ static int ocfs2_xa_remove(struct ocfs2_
 				rc = 0;
 			ocfs2_xa_cleanup_value_truncate(loc, "removing",
 							orig_clusters);
-			if (rc)
-				goto out;
+			goto out;
 		}
 	}
 


