Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 547A2280008;
	Tue, 27 May 2025 17:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366735; cv=none; b=YYtuI45qf75lo77FKoDtMf2Z+qjrtp8Lleq2fDujifHe2piRw1uOhxEKgXgNga0J0ZK0zFrgvCCntorqBepMFw+A4/2BNlZx09T4DbPPUQmtlThMZt5qDGnXmX3zuytcHKEYk8njfufBnn9CzShDgJznz64mKXpEI8qYOMwPgRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366735; c=relaxed/simple;
	bh=caIJNPn6xTwiNvwH7FK4L0p5wl+oYPWZZ0fLO8A38GE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LtdGN6CqXLuIPGhVcjQRMzT9Z/1JFwQvY47UmQewPzORGSxPVRCH5yBmUAdGI9K8FC2pNy1CWnrTGHY2rTDDdERf6t8Fp/U5tWBwYK6CKSQZy14up7RHjKMiXlllJl8u8ffff7qHhpuooUcVvEsQ66uKNHTpoTvXiUyTMSdxopk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I5I3XVyR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I5I3XVyR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6912C4CEEB;
	Tue, 27 May 2025 17:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366735;
	bh=caIJNPn6xTwiNvwH7FK4L0p5wl+oYPWZZ0fLO8A38GE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I5I3XVyRDsnllkaT8RIJeXhPUKojr8Y77RIJgmkVEw6NUZGqOxQ7pcW+sB4oztof0
	 qjPoEW53HARmlqgiBdckPU3bZJq1e5wRRw8+mLit4EHXrjOnT40EjP406RWsy/uMMr
	 6Ds4KbElJINmdcTVoFNtL1Ti3PxdZk3lkDCavI3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 165/783] jbd2: do not try to recover wiped journal
Date: Tue, 27 May 2025 18:19:22 +0200
Message-ID: <20250527162519.887089995@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit a662f3c03b754e1f97a2781fa242e95bdb139798 ]

If a journal is wiped, we will set journal->j_tail to 0. However if
'write' argument is not set (as it happens for read-only device or for
ocfs2), the on-disk superblock is not updated accordingly and thus
jbd2_journal_recover() cat try to recover the wiped journal. Fix the
check in jbd2_journal_recover() to use journal->j_tail for checking
empty journal instead.

Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Link: https://patch.msgid.link/20250206094657.20865-4-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jbd2/recovery.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/jbd2/recovery.c b/fs/jbd2/recovery.c
index 9192be7c19d83..23502f1a67c1e 100644
--- a/fs/jbd2/recovery.c
+++ b/fs/jbd2/recovery.c
@@ -287,19 +287,20 @@ static int fc_do_one_pass(journal_t *journal,
 int jbd2_journal_recover(journal_t *journal)
 {
 	int			err, err2;
-	journal_superblock_t *	sb;
-
 	struct recovery_info	info;
 
 	memset(&info, 0, sizeof(info));
-	sb = journal->j_superblock;
 
 	/*
 	 * The journal superblock's s_start field (the current log head)
 	 * is always zero if, and only if, the journal was cleanly
-	 * unmounted.
+	 * unmounted. We use its in-memory version j_tail here because
+	 * jbd2_journal_wipe() could have updated it without updating journal
+	 * superblock.
 	 */
-	if (!sb->s_start) {
+	if (!journal->j_tail) {
+		journal_superblock_t *sb = journal->j_superblock;
+
 		jbd2_debug(1, "No recovery required, last transaction %d, head block %u\n",
 			  be32_to_cpu(sb->s_sequence), be32_to_cpu(sb->s_head));
 		journal->j_transaction_sequence = be32_to_cpu(sb->s_sequence) + 1;
-- 
2.39.5



