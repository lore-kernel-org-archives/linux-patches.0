Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC07F3081B8;
	Tue, 11 Nov 2025 01:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825063; cv=none; b=KAIxuWIePVBDUgrbgLQJmp5OFsaWBknXDtSoYmoR9eHIGKtmAguAcez64LroYECKnkqKyIsq7fgAYVe0G55cBz6BWRR2I5KA5xKN0diJesAm9FxvUIcXkRw2w8aP0OIWI6gUsNAsxzpj0eJ83SHHaO9M+HXyiDMC8jSB9jpaGNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825063; c=relaxed/simple;
	bh=9B+GArblTDPZJVxWusVsy7xQl9AjsNMQekllBKujVio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NOfBOaMqlO3w01SqdvtvXj6gjGkrV+hrI9yk8Kzti06odKOxzQrzqdoel746VWcAbCiDQEhOZt2DrplzR8O1Lg+3ckAgfJN33Ahj2S3mO50coynk3aJjkrohsX6r2drO++++lfGiYNGIyjcIy7/v1+NChLOiW7w5HRdI6la2ZJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JdvXZ/dJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JdvXZ/dJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47B05C113D0;
	Tue, 11 Nov 2025 01:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825063;
	bh=9B+GArblTDPZJVxWusVsy7xQl9AjsNMQekllBKujVio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JdvXZ/dJ9FdUrLua4YK51ubul0eeU9guRyWcbrk0SO58rBpyWg7T4AfLzNaZpQi1I
	 6VEV+0HzaG7304LlRTnckvbXjTEvWJgBuKAqoFzKYn29iltAl/XqK1k93mqeLsvbWN
	 3d00JQqXOSMfgmVix5Mtra0GHlVs8n4GWTVGF66I=
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
Subject: [PATCH 6.17 645/849] ext4: increase IO priority of fastcommit
Date: Tue, 11 Nov 2025 09:43:35 +0900
Message-ID: <20251111004552.020370729@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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
index 42bee1d4f9f97..fa66b08de9994 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -663,7 +663,7 @@ void ext4_fc_track_range(handle_t *handle, struct inode *inode, ext4_lblk_t star
 
 static void ext4_fc_submit_bh(struct super_block *sb, bool is_tail)
 {
-	blk_opf_t write_flags = REQ_SYNC;
+	blk_opf_t write_flags = JBD2_JOURNAL_REQ_FLAGS;
 	struct buffer_head *bh = EXT4_SB(sb)->s_fc_bh;
 
 	/* Add REQ_FUA | REQ_PREFLUSH only its tail */
-- 
2.51.0



