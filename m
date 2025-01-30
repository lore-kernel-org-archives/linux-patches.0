Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6DA61E522;
	Thu, 30 Jan 2025 14:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246917; cv=none; b=h+KUFx+LCBlnPCNmmdfucA+CTElG9yC0oLQX9ZI/vCEynEHiPtYT0PpPeHuaQryD9lU3q/mjV95F9cVIczU3mNTXaTZQA9WAfrjbVdE9K+SqvptJfQ9DFquuLox9RCR2JkXUSzWrBnpm/AqN3w79GI2I+XgsstPGPNyBGteVZvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246917; c=relaxed/simple;
	bh=VzT4YMB94IkQ1trKLjIdZ75tnnpOlZd9UMZjfniYSFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NVYwMgitfN1znBk4EnPIdxzKFRzpyv54hAWpbrwt1rz4I5JDvSCwk7is+5iMpyKEoyNnDzWDLRa1lT22ZgQWfGywFH4F+X9RmH5I+Ylcv3+jcuruKt7wYC8pJStXHcg1Cw3tMlJ+ct9qgrA5F/mKie9ARV0SAHUg54zzIQLjWAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eV2XXeuf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eV2XXeuf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70482C4CED2;
	Thu, 30 Jan 2025 14:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246916;
	bh=VzT4YMB94IkQ1trKLjIdZ75tnnpOlZd9UMZjfniYSFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eV2XXeufQ70skXpuxQ1+gharuv3wsnQTvWCxJHtB4b+R653LTca7xDpzLGZQl9lc1
	 L4m9nqM8mafRgiAcU61WcEEJbA6cDJrejMSRktACqmpdNNcq1Zs+tO2L851z/ivv5V
	 /fRMPJq/IBc4CQt20aUAyHIBzQKQyNkHjZfwYRkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 002/133] jbd2: flush filesystem device before updating tail sequence
Date: Thu, 30 Jan 2025 14:59:51 +0100
Message-ID: <20250130140142.593458939@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7d548821854e..84e4cc9ef08b 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -823,9 +823,9 @@ void jbd2_journal_commit_transaction(journal_t *journal)
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
 		blkdev_issue_flush(journal->j_fs_dev, GFP_NOFS);
-- 
2.39.5



