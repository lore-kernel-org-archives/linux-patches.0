Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9EC01922D0;
	Tue, 10 Sep 2024 10:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963784; cv=none; b=NsQ1Q+4p2wa7xJfEfZX/B88PlQEt+20F+SFeDJtIruCUqHSRxE2X28Ru3J3bGSwpYP6Xxk73LkqwBdQlzJSyJv0jfPoIgUg7DQ2hrXGm8i51guAtoa+4KA3CzLigB5n73iymJYpto/oTRHz9Pj32jC9cT7NfNdhKoXbHdF2GK74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963784; c=relaxed/simple;
	bh=L5G1G4swjlcGrlBxZKZDrU6jDVKhSBgnVjFLdWHiNt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l4DfAr2tbD9HLZbnReVzt46mCgF9DykZytmzv9ThFSRC3VAVMuXIPznugzNxm730W+9H0rkmEgbfqSiBfnb366BEcQ2eEw8ghoN+AdKQpwTUi4CBLmm7o/0XMt9KW+VU7HkosgLvWeUpThcsQyTI4oRnyGBVw2+KMMkitmamtMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vFDNUmlP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vFDNUmlP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50706C4CEC3;
	Tue, 10 Sep 2024 10:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963784;
	bh=L5G1G4swjlcGrlBxZKZDrU6jDVKhSBgnVjFLdWHiNt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vFDNUmlPzGyxlChRgDDnFpAYfDrw1GBWUh26vj3iTFtVAqNlRmvHXqKELsd1L4Pki
	 kKqSl8js7xqkxnFqNIfkQIYuaZg6K5ll4jR+MZpUQc4NQrRr/IqNaZpMY2icNAMU46
	 eIAmIPxawk4GnYw06A7mXGJx7u23h+rb9yLInLdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luis Henriques (SUSE)" <luis.henriques@linux.dev>,
	Jan Kara <jack@suse.cz>,
	Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 148/214] ext4: fix possible tid_t sequence overflows
Date: Tue, 10 Sep 2024 11:32:50 +0200
Message-ID: <20240910092604.789144459@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

From: Luis Henriques (SUSE) <luis.henriques@linux.dev>

[ Upstream commit 63469662cc45d41705f14b4648481d5d29cf5999 ]

In the fast commit code there are a few places where tid_t variables are
being compared without taking into account the fact that these sequence
numbers may wrap.  Fix this issue by using the helper functions tid_gt()
and tid_geq().

Signed-off-by: Luis Henriques (SUSE) <luis.henriques@linux.dev>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Link: https://patch.msgid.link/20240529092030.9557-3-luis.henriques@linux.dev
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/fast_commit.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index e81b886d9c67..62255b3eb1b4 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -325,7 +325,7 @@ void ext4_fc_mark_ineligible(struct super_block *sb, int reason, handle_t *handl
 		read_unlock(&sbi->s_journal->j_state_lock);
 	}
 	spin_lock(&sbi->s_fc_lock);
-	if (sbi->s_fc_ineligible_tid < tid)
+	if (tid_gt(tid, sbi->s_fc_ineligible_tid))
 		sbi->s_fc_ineligible_tid = tid;
 	spin_unlock(&sbi->s_fc_lock);
 	WARN_ON(reason >= EXT4_FC_REASON_MAX);
@@ -1206,7 +1206,7 @@ int ext4_fc_commit(journal_t *journal, tid_t commit_tid)
 	if (ret == -EALREADY) {
 		/* There was an ongoing commit, check if we need to restart */
 		if (atomic_read(&sbi->s_fc_subtid) <= subtid &&
-			commit_tid > journal->j_commit_sequence)
+		    tid_gt(commit_tid, journal->j_commit_sequence))
 			goto restart_fc;
 		ext4_fc_update_stats(sb, EXT4_FC_STATUS_SKIPPED, 0, 0);
 		return 0;
@@ -1278,7 +1278,7 @@ static void ext4_fc_cleanup(journal_t *journal, int full, tid_t tid)
 		list_del_init(&iter->i_fc_list);
 		ext4_clear_inode_state(&iter->vfs_inode,
 				       EXT4_STATE_FC_COMMITTING);
-		if (iter->i_sync_tid <= tid)
+		if (tid_geq(tid, iter->i_sync_tid))
 			ext4_fc_reset_inode(&iter->vfs_inode);
 		/* Make sure EXT4_STATE_FC_COMMITTING bit is clear */
 		smp_mb();
@@ -1308,7 +1308,7 @@ static void ext4_fc_cleanup(journal_t *journal, int full, tid_t tid)
 	list_splice_init(&sbi->s_fc_q[FC_Q_STAGING],
 				&sbi->s_fc_q[FC_Q_MAIN]);
 
-	if (tid >= sbi->s_fc_ineligible_tid) {
+	if (tid_geq(tid, sbi->s_fc_ineligible_tid)) {
 		sbi->s_fc_ineligible_tid = 0;
 		ext4_clear_mount_flag(sb, EXT4_MF_FC_INELIGIBLE);
 	}
-- 
2.43.0



