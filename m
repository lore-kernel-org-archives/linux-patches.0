Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052344;
	b=n5YgxG/6XHgLx1rnrNX4QIBdLEk6how8s0iLmhUK4aiqw3g1YNNCwYx1JM11Av+bNqBa
	 2jowWKUGcFcu52ktDGeN2r4riwYMYXgvY+5O81tINnT1N4xL85q9OACogKn4VgjxGpBzZ
	 ijFTfDnm0aneC+k3y6UcsXCbfAo2XBK5jRHaEL/rjYeqM6FcpW3iQsvoaCuD8MGjMZ4nG
	 foHH49VDmubt1sSvaxAwGxhQt2DYu7HjTdvoNrn8bOpcdwG+XxE/2tWwIL+AWzkr2bpm2
	 DWFD0Q+4/LL3Gntj3B205um2wfoZPGhDmYrIjTtZBLi3bRW6zmkvQ+ONuCbjatGoXCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052344;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vMXA025fUm2N0E3JyRXqxDD32oHSAs+dkcl6VcO/j34=;
	b=uHGjvjUv7bNVfNrYETVnQlHvrW6uvPvgZsxrfLhMV/7sPYYLY7JNzxBzQy9+D2Z+Hy0g
	 wd8qdPVrn7Up9/Na5vtBS21bYBxxz1Io9fh+mAOWf3Q3G6AkQsbos5lbdRDPNRPb97PgZ
	 JeqKvtLw1hFrtTUsCt7jO+jHcoMX81X4aI/kwv/C7XiV/zM3Ge3R9We8tRV3dp636e3gL
	 7YDIuInpuhYYzw4m0pw3XngFimCFAYxmzv1rTBqm6sDRSCPfeVqmLcHsRXR+ZsMdstCHc
	 ko9DxutWyoyoqRjiyYUMS5yfuT8mbh5cwW55p5NJKjc7o3PunRf2rWGoaLjiYcvzq4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qd8dfg1o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF6960A2602;
	Thu, 19 Nov 2026 01:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qd8dfg1o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D666D1F000C4;
	Thu, 19 Nov 2026 01:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052344;
	bh=vMXA025fUm2N0E3JyRXqxDD32oHSAs+dkcl6VcO/j34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qd8dfg1oLGCoOMhi2EKkHJsjyHPaTLLA+LPEaOBUc55+JLUjrOazPTivdXQ6QHZrS
	 KGDj9oxq5XJhvh+s/xW5HGWmWI1NN2UNT6C1Sx9B5Hiy14RG66/9a6AKpG+0rAu1eu
	 TwufvZow8MLZdWcuuOqOwaCQC5Bbh87mRMWXZpVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6646318bbcf419411bc5@syzkaller.appspotmail.com,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0531/2214] nilfs2: fix deadlock between nilfs_evict_inode() and find_inode()
Date: Wed, 18 Nov 2026 15:36:47 +0100
Message-ID: <20261118150032.301944116@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

[ Upstream commit ff1227f70eead8704ecfec69259fb4c041f92cda ]

Syzbot reported a deadlock between nilfs_evict_inode(), executed via
an asynchronous workqueue (kworker) as:

  process_one_work()
    process_scheduled_works()
      nilfs_iput_work_func()
        nilfs_dispose_list()
          iput()
            iput_final()
              evict()
                s_op->evict_inode()
                  nilfs_evict_inode()

and find_inode(), called via

  nilfs_mkdir()
    nilfs_new_inode()
      nilfs_insert_inode_locked()
        insert_inode_locked4()
          inode_insert5()
            find_inode()

When an inode is deleted (i_nlink == 0), nilfs_evict_inode() clears its
ifile bitmap entry and then synchronously triggers the log writer via
nilfs_transaction_commit() if IS_SYNC(inode) is true.

If a concurrent directory creation via nilfs_new_inode() attempts to
allocate the same newly freed inode number, however, find_inode() called
just before inserting it into the inode hash, blocks waiting for the old
inode's evict() to complete.

Meanwhile, the synchronous log writer invoked from nilfs_evict_inode()
tries to acquire a write lock on 'ns_segctor_sem' which is read locked
by the caller of nilfs_new_inode() (in this case, nilfs_mkdir()),
resulting in a deadlock.

The synchronous log writer invocation from nilfs_evict_inode() is a
legacy artifact; it is no longer necessary because the call itself
(triggered by iput()) is now handled asynchronously with a kworker
if i_nlink == 0.  It merely increases the risk of deadlock.

Fix this deadlock by removing the synchronous log writer trigger from
nilfs_evict_inode().

Reported-by: syzbot+6646318bbcf419411bc5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6646318bbcf419411bc5
Fixes: 7ef3ff2fea8b ("nilfs2: fix deadlock of segment constructor over I_SYNC flag")
Tested-by: syzbot+6646318bbcf419411bc5@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/inode.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 7b9d138c8bf8f..ee082c2c6e896 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -975,13 +975,7 @@ void nilfs_evict_inode(struct inode *inode)
 
 	nilfs_clear_inode(inode);
 
-	if (IS_SYNC(inode))
-		nilfs_set_transaction_flag(NILFS_TI_SYNC);
 	nilfs_transaction_commit(sb);
-	/*
-	 * May construct a logical segment and may fail in sync mode.
-	 * But delete_inode has no return value.
-	 */
 }
 
 int nilfs_setattr(struct user_namespace *mnt_userns, struct dentry *dentry,
-- 
2.53.0



