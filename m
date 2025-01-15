Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48054248BDE;
	Wed, 15 Jan 2025 10:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938506; cv=none; b=ZcqzXa9/gdruawrzMrgV+WgX7jkmVXANoVaKC5qpcHSnqwAatIGvvt+PVDk5ziWS1rxRZOv8K47HmE93Ie4Y0+c/s91sG5a1Uu2LUTHExcglTmCd6AS/4uo4XCH1FiEomkXbGJt2m0rftLIeejtEthlajoXBFo8VmBNx3s5c0FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938506; c=relaxed/simple;
	bh=HunJTmBSyNM2ktU7UxrnbKwbtz4hvEzFxyxl8u1CQx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K6atiYjNYiOYcS6kpOK30cUYoBGkTWElVLk7UNkCzcR6OHLb9/FZRp5KjzwE/EUzmvcKy7y4SoTaKQ8wh2dEZm5oWEH+nWobd6vqRMqFvo075AD62gmN+CSW+pu6MYsbgLcjQcGH/J5hTPl1dUCP4/j8JMG131LHTjJ6kMXgIrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QiL+q0g2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QiL+q0g2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C7AC4CEE2;
	Wed, 15 Jan 2025 10:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938506;
	bh=HunJTmBSyNM2ktU7UxrnbKwbtz4hvEzFxyxl8u1CQx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QiL+q0g2VPkykFSY6cXOkh3N+Y8X5swNbOFfOWGWHvUYMceFIvYbXDVS4yHavvQKq
	 NGE6OKZEISeT0k+sJvMyCNpB+5HUsRAVWZVwiK31T2yG7yCvagTMmnjJ7TwcRu5uKS
	 MenqRDd6Szl4pgnWrZFnGymqX23BCDBTn4qYj+5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 004/129] jbd2: flush filesystem device before updating tail sequence
Date: Wed, 15 Jan 2025 11:36:19 +0100
Message-ID: <20250115103554.537031689@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit a0851ea9cd555c333795b85ddd908898b937c4e1 ]

When committing transaction in jbd2_journal_commit_transaction(), the
disk caches for the filesystem device should be flushed before updating
the journal tail sequence. However, this step is missed if the journal
is not located on the filesystem device. As a result, the filesystem may
become inconsistent following a power failure or system crash. Fix it by
ensuring that the filesystem device is flushed appropriately.

Fixes: 3339578f0578 ("jbd2: cleanup journal tail after transaction commit")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Link: https://lore.kernel.org/r/20241203014407.805916-3-yi.zhang@huaweicloud.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jbd2/commit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 0cd7439470fc..84663ff7dc50 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -777,9 +777,9 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	/*
 	 * If the journal is not located on the file system device,
 	 * then we must flush the file system device before we issue
-	 * the commit record
+	 * the commit record and update the journal tail sequence.
 	 */
-	if (commit_transaction->t_need_data_flush &&
+	if ((commit_transaction->t_need_data_flush || update_tail) &&
 	    (journal->j_fs_dev != journal->j_dev) &&
 	    (journal->j_flags & JBD2_BARRIER))
 		blkdev_issue_flush(journal->j_fs_dev);
-- 
2.39.5



