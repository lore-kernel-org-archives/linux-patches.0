Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0EFF189910;
	Tue,  8 Oct 2024 12:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392329; cv=none; b=OFszpfVX2YI5g6d4wvDS3FcHRNLMBS/Hp0Z8BaVC2d6BsmDdPaMNfmvPy913M34LQKeSJZL+MOYNBs4Tpa+htO2e470cLNuF0jqY73QneDexXTj3n0gny0ibnt6DoU/wzBSPaYP/o/e5UkmkNYK0tXN9/FEBRxYgX0EMdFWVM54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392329; c=relaxed/simple;
	bh=S7b9I3LENrNrC404yRtJfIB5UwWaIJ1Ecuzn8dikVzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a3scd1iE6Vi2jjAdxR25lXNIsbp72kxVLt/UC4u8naTernUZP8LtJLeG2vnmOZSqDAO/1TX8fUzS2JjVR1SHtsEggUvXhV0D1Az5n1RVj/3pWf0NK5aD9GhJUmxpDycdjcvnUQakEsLE7Mjx/DiNLEx46+Zi54cq7nZgtv9anME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=avFCRv8N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="avFCRv8N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F704C4CEC7;
	Tue,  8 Oct 2024 12:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392329;
	bh=S7b9I3LENrNrC404yRtJfIB5UwWaIJ1Ecuzn8dikVzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=avFCRv8NB3WpOIIscbYevdLdVi4dkL3XPynKl+5g76Nf1s4Svz4Zre/hm0xaSszhL
	 mYfSSRc9X06ClEq7U3sQPeAuDJc0vSk6S/2Dpl1Oefo/gbpOt1DvYpEJdH3xMwmvji
	 j6ma74ytt7Jo3A98uZChW5DIPbX0DjvDBKSezGpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luis Henriques (SUSE)" <luis.henriques@linux.dev>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.11 384/558] ext4: fix incorrect tid assumption in ext4_fc_mark_ineligible()
Date: Tue,  8 Oct 2024 14:06:54 +0200
Message-ID: <20241008115717.399241062@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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


