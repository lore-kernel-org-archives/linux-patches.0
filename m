Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9418D340D9A;
	Fri, 21 Nov 2025 13:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732992; cv=none; b=jTS+sHRgPUsQFJKYW0RjxAqbWs1n6IbabUuDK0NvB9ZTdDPPzL2pis1ClsE4/KCpMKUSiTpCZemUcJ/45UqInrl8vZJFke6Y3UL7IYTPy1c8Nnv4PL2B0AbENzfXnjs2MxVhY5mrYlrscLsA7afTvN4fPKzqISbfQl+P1BaGrlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732992; c=relaxed/simple;
	bh=0kICUGI8r4KtpRzTvqOplodThGK5fEpcAhRGSH4g2H8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QUL3aHSoR/zuwl4w17pIU9jbrGTjZ4kqXtUxE5XJXyfnXQ3c2xdsqmmN36HWrjw1yPPPjz0wxZhLbjsBxf3+Oc3SjIBfJNzhyJnJ/Pevfx5ISMaxip4+ZBo1G5x5Hx0rG0lPymaPsecljBGkOnt1DJDyPyifaMQaf/7MtbYQ640=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0QTNB9BA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0QTNB9BA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F69C116D0;
	Fri, 21 Nov 2025 13:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732992;
	bh=0kICUGI8r4KtpRzTvqOplodThGK5fEpcAhRGSH4g2H8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0QTNB9BAn+DlIVZxWoNbR8vsM/fF6v8acGutgmgpMIDnDcyl2IEq6C6PiChSRooFw
	 4iKnCYfo1/bOVDl3IqVm284PQVf7a4AjYb3AwMysxhjoVPgHJL1cdVv78WnGz3LxT9
	 ZNVN52eRRGrLn0+bbnv+pty+nSwu7TkZXsYQlsH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Julian Sun <sunjunchao@bytedance.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 280/529] ext4: increase IO priority of fastcommit
Date: Fri, 21 Nov 2025 14:09:39 +0100
Message-ID: <20251121130240.991717083@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Julian Sun <sunjunchao@bytedance.com>

[ Upstream commit 46e75c56dfeafb6756773b71cabe187a6886859a ]

The following code paths may result in high latency or even task hangs:
   1. fastcommit io is throttled by wbt.
   2. jbd2_fc_wait_bufs() might wait for a long time while
JBD2_FAST_COMMIT_ONGOING is set in journal->flags, and then
jbd2_journal_commit_transaction() waits for the
JBD2_FAST_COMMIT_ONGOING bit for a long time while holding the write
lock of j_state_lock.
   3. start_this_handle() waits for read lock of j_state_lock which
results in high latency or task hang.

Given the fact that ext4_fc_commit() already modifies the current
process' IO priority to match that of the jbd2 thread, it should be
reasonable to match jbd2's IO submission flags as well.

Suggested-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Message-ID: <20250827121812.1477634-1-sunjunchao@bytedance.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/fast_commit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index b527f4ab47e02..62a6960242c5a 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -675,7 +675,7 @@ void ext4_fc_track_range(handle_t *handle, struct inode *inode, ext4_lblk_t star
 
 static void ext4_fc_submit_bh(struct super_block *sb, bool is_tail)
 {
-	blk_opf_t write_flags = REQ_SYNC;
+	blk_opf_t write_flags = JBD2_JOURNAL_REQ_FLAGS;
 	struct buffer_head *bh = EXT4_SB(sb)->s_fc_bh;
 
 	/* Add REQ_FUA | REQ_PREFLUSH only its tail */
-- 
2.51.0



