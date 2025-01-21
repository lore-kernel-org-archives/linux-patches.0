Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F6A1F5439;
	Tue, 21 Jan 2025 18:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482886; cv=none; b=R/z/W89T2wYC1B61Cg7D14cXK7aOHirq5EjQ1M7vmcD/6ifN7cA1MYPab1zkBT+niShMU5e0/i9gBeLuPqMt5paJ2waJgY2uLxXmvEhJ+tWh8+HbZi2zY5uGuMCt53RHoZnB85b8Rld9p0Ea45nIsAEp9kmZYlPqM6DS8viQJKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482886; c=relaxed/simple;
	bh=DKqXbHGF5otVx/DuzPzct8c47vD9ng+El6+aYG8FbC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Slty9o9tmlOLxEM/2x340VrpKe5qESkMF31Wfgw2iII4HrNaINpCNrCI0PkNqnmdXpsFXILqZln8/MCyM+CCJJRCdlxeF1UchA+I5gGCy0tUF1PQAN4iHWQnjpnP3xX5q5IWLZwVziHl8P4zmGpBOOYEABg29MsGayk6J1AEMpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AgCcEOPP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AgCcEOPP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 461EBC4CEDF;
	Tue, 21 Jan 2025 18:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482886;
	bh=DKqXbHGF5otVx/DuzPzct8c47vD9ng+El6+aYG8FbC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AgCcEOPP9mdxslYqiXbw6/Co5ogz7UdiD5AAqIi1R86bqtVNngWLGopOTiFkS80Rz
	 8voRBYHp1zu1f7dZxx/G1NPlyTqpduvZL7u1vy/zlgjLQ36UC7P9z97YTE8+5X2/45
	 JoaRrrUk3F96iwb9zoyVrQt2U9eEvlcXD0IdXoW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 002/127] jbd2: flush filesystem device before updating tail sequence
Date: Tue, 21 Jan 2025 18:51:14 +0100
Message-ID: <20250121174529.772736556@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 540a3ccb3287..9b2225ab5fe5 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -810,9 +810,9 @@ void jbd2_journal_commit_transaction(journal_t *journal)
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



