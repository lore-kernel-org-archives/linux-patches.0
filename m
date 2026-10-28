Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209284;
	b=2Tw6idMf/aJtxWSZgN8Fm/ex6/FO8goVfwXsb5jz8mvujEwN6YjIjAYbcXV4NSG66oxS
	 VTxFXdLE6ZHymxTTPb3s3e7eRtouu975n2FcWlxtEgftx6qJdCP4Z2FSb0bwvXIp353os
	 lvSVdZXbxnYr6jI5d+pERxsJieJAQyJLfuqR3Ztyi7Xqk9CSPa8CCEO5payeW4Bp9h12/
	 9B+A8I/7/FawDutyDykE7/ame3ZfzF/SHa1FM7F+mnOHQLpKUEcBwC9MR0MypYlgI1MeY
	 xHgD5OEUx9QO50FZ0/y5I3JAw+RfjFqJ4AIlUH4qTci+n96dUBbS/k3t0ILYln1n7pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209284;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Px4TcFbhBGoFjjq37vSqpjFS52qypP0eHo4hoRFCXu8=;
	b=XK6camahVUiXv717oyYUy9DbG1u0lfkggoSxB5brAFFvS9qF9Y/uMWNXhGJ3KyOds3Rv
	 P6p6Tvc/Fcop3S7g5F7zSFeUf3Q8oB9YSNtJxLNJXXJQEmWbUB/XdVXjd4uqASxYujfbs
	 8VjN0Wg6zVRve6QUkXlMVnkmXdZYi5hozasWS/HozmaWdxJbyJtfT+2uzzYqwzWc58P+o
	 sLapmcy8SnX1AAI9fVyW9OzScmJoItXY4iaWyLUMoy1Be3s7i5a1cEZNQ66Mo1R9UPw0s
	 qu0J4yW03UnUU6nZ9ra8bi4dYVWMB4v8qEu+pjqoU32tDyfixcmlroiK1c7yjBHIV9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qYwSIcA8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68BE4606A31D;
	Wed, 28 Oct 2026 17:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qYwSIcA8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF8711F01825;
	Wed, 28 Oct 2026 17:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209284;
	bh=Px4TcFbhBGoFjjq37vSqpjFS52qypP0eHo4hoRFCXu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qYwSIcA8g7MwMZocxpySWq5qvsMm7KVH+tF4n1gFl5f86eL5t3b3CzsgXJHSP/YFw
	 ZdJqinxvfQ779GW4+kxF85744NZYzdzBL3dtX5ZekWrd0zY6HD2khFQaykzBASbftC
	 BH4arjxskGeRBPZw2eyGAln5w+YzjBQ2LkoGzEPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Siddh Raman Pant <siddh.raman.pant@oracle.com>
Subject: [PATCH 5.10 415/516] xfs: fix intermittent hang during quotacheck
Date: Wed, 28 Oct 2026 17:59:27 +0100
Message-ID: <20261028170013.318114163@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit f0c2d7d2abca24d19831c99edea458704fac8087 ]

Every now and then, I see the following hang during mount time
quotacheck when running fstests.  Turning on KASAN seems to make it
happen somewhat more frequently.  I've edited the backtrace for brevity.

XFS (sdd): Quotacheck needed: Please wait.
XFS: Assertion failed: bp->b_flags & _XBF_DELWRI_Q, file: fs/xfs/xfs_buf.c, line: 2411
------------[ cut here ]------------
WARNING: CPU: 0 PID: 1831409 at fs/xfs/xfs_message.c:104 assfail+0x46/0x4a [xfs]
CPU: 0 PID: 1831409 Comm: mount Tainted: G        W         5.19.0-rc6-xfsx #rc6 09911566947b9f737b036b4af85e399e4b9aef64
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1 04/01/2014
RIP: 0010:assfail+0x46/0x4a [xfs]
Code: a0 8f 41 a0 e8 45 fe ff ff 8a 1d 2c 36 10 00 80 fb 01 76 0f 0f b6 f3 48 c7 c7 c0 f0 4f a0 e8 10 f0 02 e1 80 e3 01 74 02 0f 0b <0f> 0b 5b c3 48 8d 45 10 48 89 e2 4c 89 e6 48 89 1c 24 48 89 44 24
RSP: 0018:ffffc900078c7b30 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff8880099ac000 RCX: 000000007fffffff
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffffa0418fa0
RBP: ffff8880197bc1c0 R08: 0000000000000000 R09: 000000000000000a
R10: 000000000000000a R11: f000000000000000 R12: ffffc900078c7d20
R13: 00000000fffffff5 R14: ffffc900078c7d20 R15: 0000000000000000
FS:  00007f0449903800(0000) GS:ffff88803ec00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005610ada631f0 CR3: 0000000014dd8002 CR4: 00000000001706f0
Call Trace:
 <TASK>
 xfs_buf_delwri_pushbuf+0x150/0x160 [xfs 4561f5b32c9bfb874ec98d58d0719464e1f87368]
 xfs_qm_flush_one+0xd6/0x130 [xfs 4561f5b32c9bfb874ec98d58d0719464e1f87368]
 xfs_qm_dquot_walk.isra.0+0x109/0x1e0 [xfs 4561f5b32c9bfb874ec98d58d0719464e1f87368]
 xfs_qm_quotacheck+0x319/0x490 [xfs 4561f5b32c9bfb874ec98d58d0719464e1f87368]
 xfs_qm_mount_quotas+0x65/0x2c0 [xfs 4561f5b32c9bfb874ec98d58d0719464e1f87368]
 xfs_mountfs+0x6b5/0xab0 [xfs 4561f5b32c9bfb874ec98d58d0719464e1f87368]
 xfs_fs_fill_super+0x781/0x990 [xfs 4561f5b32c9bfb874ec98d58d0719464e1f87368]
 get_tree_bdev+0x175/0x280
 vfs_get_tree+0x1a/0x80
 path_mount+0x6f5/0xaa0
 __x64_sys_mount+0x103/0x140
 do_syscall_64+0x2b/0x80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

I /think/ this can happen if xfs_qm_flush_one is racing with
xfs_qm_dquot_isolate (i.e. dquot reclaim) when the second function has
taken the dquot flush lock but xfs_qm_dqflush hasn't yet locked the
dquot buffer, let alone queued it to the delwri list.  In this case,
flush_one will fail to get the dquot flush lock, but it can lock the
incore buffer, but xfs_buf_delwri_pushbuf will then trip over this
ASSERT, which checks that the buffer isn't on a delwri list.  The hang
results because the _delwri_submit_buffers ignores non DELWRI_Q buffers,
which means that xfs_buf_iowait waits forever for an IO that has not yet
been scheduled.

AFAICT, a reasonable solution here is to detect a dquot buffer that is
not on a DELWRI list, drop it, and return -EAGAIN to try the flush
again.  It's not /that/ big of a deal if quotacheck writes the dquot
buffer repeatedly before we even set QUOTA_CHKD.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
(cherry picked from commit 8d0baec78e8a7abe03b449820507c9777dae7f7b)
Stable-dep-of: d62016b1a2df ("xfs: avoid dquot buffer pin deadlock")
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_qm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 3c17e0c0f8169..907819e7873eb 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1245,6 +1245,13 @@ xfs_qm_flush_one(
 			error = -EINVAL;
 			goto out_unlock;
 		}
+
+		if (!(bp->b_flags & _XBF_DELWRI_Q)) {
+			error = -EAGAIN;
+			xfs_buf_relse(bp);
+			goto out_unlock;
+		}
+
 		xfs_buf_unlock(bp);
 
 		xfs_buf_delwri_pushbuf(bp, buffer_list);
-- 
2.53.0



