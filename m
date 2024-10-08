Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66CCC1DFE14;
	Tue,  8 Oct 2024 13:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393715; cv=none; b=VmYtEC2gWlDpEBEXbpSuaBA7YGQ/SRogJhuJjwtcjmCAM29gnTi69buslRUT3dGvWRNr0U6/eE6fpm/QXJIXnClMsLBLbVVlXLX4+OHlSSmBuXxxT+PdL8JKQACaH/rXJQnfEqUMsP9Cip+omePTZ2RkYXkuJPCW2nJa+QDnEnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393715; c=relaxed/simple;
	bh=JNf9szA5fD6fgg6aKNWG+RlUKI9Ob5dyuP+aenthJ/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KR0mLv3YcKx4RIJYhw6UqhTjdzpZ+S8TxcoG6B49uwF1kRIjHpvD+77NnJ1myTqEnqw1PRCkft8/PpS1x4orGk/ZNbmAl+AGn2O6BIlUVuvWgugvqRjd4jm/0HTmvDrLGXHvwRLq3EtwcHaKXO8VObh7607h8/C38Q+lRKuEpi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mgPiB+e+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mgPiB+e+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6503CC4CECC;
	Tue,  8 Oct 2024 13:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393715;
	bh=JNf9szA5fD6fgg6aKNWG+RlUKI9Ob5dyuP+aenthJ/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mgPiB+e+gv+UliEecTvVsYDeW7n2dgct8y3jvtvCWjL6ReioJdwFR0QzUBOtbkLIO
	 WQ72uPr0ZVWypOMv5c8Nenqh8CpWCPxP8Pr+lVsmRTT+v2tkabMQ06xkCj7XLcLz7q
	 yW7D396emOp0jkEh4TSCkNl0Jg9iNm93kInhbTXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luis Henriques (SUSE)" <luis.henriques@linux.dev>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.6 235/386] ext4: fix incorrect tid assumption in ext4_fc_mark_ineligible()
Date: Tue,  8 Oct 2024 14:08:00 +0200
Message-ID: <20241008115638.648966556@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luis Henriques (SUSE) <luis.henriques@linux.dev>

commit ebc4b2c1ac92fc0f8bf3f5a9c285a871d5084a6b upstream.

Function jbd2_journal_shrink_checkpoint_list() assumes that '0' is not a
valid value for transaction IDs, which is incorrect.

Furthermore, the sbi->s_fc_ineligible_tid handling also makes the same
assumption by being initialised to '0'.  Fortunately, the sb flag
EXT4_MF_FC_INELIGIBLE can be used to check whether sbi->s_fc_ineligible_tid
has been previously set instead of comparing it with '0'.

Signed-off-by: Luis Henriques (SUSE) <luis.henriques@linux.dev>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20240724161119.13448-5-luis.henriques@linux.dev
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/fast_commit.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -339,22 +339,29 @@ void ext4_fc_mark_ineligible(struct supe
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	tid_t tid;
+	bool has_transaction = true;
+	bool is_ineligible;
 
 	if (ext4_fc_disabled(sb))
 		return;
 
-	ext4_set_mount_flag(sb, EXT4_MF_FC_INELIGIBLE);
 	if (handle && !IS_ERR(handle))
 		tid = handle->h_transaction->t_tid;
 	else {
 		read_lock(&sbi->s_journal->j_state_lock);
-		tid = sbi->s_journal->j_running_transaction ?
-				sbi->s_journal->j_running_transaction->t_tid : 0;
+		if (sbi->s_journal->j_running_transaction)
+			tid = sbi->s_journal->j_running_transaction->t_tid;
+		else
+			has_transaction = false;
 		read_unlock(&sbi->s_journal->j_state_lock);
 	}
 	spin_lock(&sbi->s_fc_lock);
-	if (tid_gt(tid, sbi->s_fc_ineligible_tid))
+	is_ineligible = ext4_test_mount_flag(sb, EXT4_MF_FC_INELIGIBLE);
+	if (has_transaction &&
+	    (!is_ineligible ||
+	     (is_ineligible && tid_gt(tid, sbi->s_fc_ineligible_tid))))
 		sbi->s_fc_ineligible_tid = tid;
+	ext4_set_mount_flag(sb, EXT4_MF_FC_INELIGIBLE);
 	spin_unlock(&sbi->s_fc_lock);
 	WARN_ON(reason >= EXT4_FC_REASON_MAX);
 	sbi->s_fc_stats.fc_ineligible_reason_count[reason]++;


