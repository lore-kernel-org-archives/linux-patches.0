Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7DF248BCA;
	Wed, 15 Jan 2025 10:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937589; cv=none; b=UjTk1F7XVIA2Nixdj59S92wDUPR27OgViKm9J1mPMTOvRaI8LikIeu/4KrLB+zwUqNEm2nM775I7OdhxzeChc9eclpb3dHk+16iqkrgQvBxhbByLTWMvyvvbHPZcQb9cHFcOrO1B8uSjLeXuzkT8aX1AjnDD+uybqFB0NWK891k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937589; c=relaxed/simple;
	bh=XhrM5PgFMNHKd7kh7TUM1zfO465f1Jke3RIXoXoKxJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DD+YxqnCVIOkqQfbEHwhq14WsvFnGZHpt2BCID3Hsj4MnsRbAda96htNYC7vkMYZFrFZ0k/iaXjprpf9O2lGQPckK5bD19FMeCh+9jRsLQZ46eIgo6bHGHCXm6dSJJtFFXciosgOHsnaAkHIo5JONCrLq8CWtfSwelf8tlNRN08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ctk97Poo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ctk97Poo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C10C4CEDF;
	Wed, 15 Jan 2025 10:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937588;
	bh=XhrM5PgFMNHKd7kh7TUM1zfO465f1Jke3RIXoXoKxJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ctk97PoorKTy+HbcQTeC3mxELQmiiahV1MbrRBFlKuGcWgwYFE3doFjG4OKFn0CFu
	 k5lfS1t7OrinQE+kHJK1eVO/TJyQYhWQkaLEoIqjdBNSBbg/NalU87nUyYQbufs6oM
	 UPgLzhhsRvEnv8cFGB8Gl0NYrn2shMNJRjE3p5aw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 05/92] jbd2: flush filesystem device before updating tail sequence
Date: Wed, 15 Jan 2025 11:36:23 +0100
Message-ID: <20250115103547.745159293@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7b34deec8b87..6d02dcad8ffd 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -811,9 +811,9 @@ void jbd2_journal_commit_transaction(journal_t *journal)
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



