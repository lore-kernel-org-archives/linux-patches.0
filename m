Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A4F265630;
	Tue,  8 Apr 2025 11:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110871; cv=none; b=eL/9b5NvNYcO/tp4gL+3wqJplZkuxkUHSU4UTsNKNBi/XX9VXpcILKhTBRj6HGt1UAWckmRykxPL4uwZ2kCo5f5DxM8uMUAvrKwkDkaXTbx5dmyLPGZwVLL0y/MYjcLt2RYznOVeQ6J5fbmD1bNqwtORnFUHpLJWxnPW1MxT1ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110871; c=relaxed/simple;
	bh=ZGy5D5ZpmE5/CpNtZcuTPLO0O3wYWHoHigkjZvoUOPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dvnAlUf4LSDmnFg+MfGq6urhKmm1vI60yo7ZMChk5Pa5N9Fif2eM3+/HxNsdMFtRfl965naTUv2w/qpgk6JafuML/A4KK2rgBzcHV/43qV8lww3e3NlskSD+EXrm2qTTYX1P7BuUDAOLgqN3N2dsYOyGDvxCzk35xQ9Kk6iOg+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jE6bh6Oy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jE6bh6Oy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA0E2C4CEE5;
	Tue,  8 Apr 2025 11:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110871;
	bh=ZGy5D5ZpmE5/CpNtZcuTPLO0O3wYWHoHigkjZvoUOPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jE6bh6OyCVZDwB4Db/ITWeB4KQo3T9mQnJGMZyrZqz5bNY3n0So81X3Pn3V+oCXNF
	 MtM82ySx5dyJUsU1qGGKpaBdxZR/BUkmMzh1paR+rK3QKor1YxSqXwvn0647XFJtKh
	 P9eMJesIWi92g4DcH+zvjcocuJLSpMh5JgXmFi00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 226/731] jbd2: add a missing data flush during file and fs synchronization
Date: Tue,  8 Apr 2025 12:42:03 +0200
Message-ID: <20250408104919.537658364@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit aac45075f6d79a63ac8dff93b3e1d7053a6ba628 ]

When the filesystem performs file or filesystem synchronization (e.g.,
ext4_sync_file()), it queries the journal to determine whether to flush
the file device through jbd2_trans_will_send_data_barrier(). If the
target transaction has not started committing, it assumes that the
journal will submit the flush command, allowing the filesystem to bypass
a redundant flush command. However, this assumption is not always valid.
If the journal is not located on the filesystem device, the journal
commit thread will not submit the flush command unless the variable
->t_need_data_flush is set to 1. Consequently, the flush may be missed,
and data may be lost following a power failure or system crash, even if
the synchronization appears to succeed.

Unfortunately, we cannot determine with certainty whether the target
transaction will flush to the filesystem device before it commits.
However, if it has not started committing, it must be the running
transaction. Therefore, fix it by always set its t_need_data_flush to 1,
ensuring that the committing thread will flush the filesystem device.

Fixes: bbd2be369107 ("jbd2: Add function jbd2_trans_will_send_data_barrier()")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20241206111327.4171337-1-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jbd2/journal.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 49a9e99cbc03d..a10e086a0165b 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -603,7 +603,7 @@ int jbd2_journal_start_commit(journal_t *journal, tid_t *ptid)
 int jbd2_trans_will_send_data_barrier(journal_t *journal, tid_t tid)
 {
 	int ret = 0;
-	transaction_t *commit_trans;
+	transaction_t *commit_trans, *running_trans;
 
 	if (!(journal->j_flags & JBD2_BARRIER))
 		return 0;
@@ -613,6 +613,16 @@ int jbd2_trans_will_send_data_barrier(journal_t *journal, tid_t tid)
 		goto out;
 	commit_trans = journal->j_committing_transaction;
 	if (!commit_trans || commit_trans->t_tid != tid) {
+		running_trans = journal->j_running_transaction;
+		/*
+		 * The query transaction hasn't started committing,
+		 * it must still be running.
+		 */
+		if (WARN_ON_ONCE(!running_trans ||
+				 running_trans->t_tid != tid))
+			goto out;
+
+		running_trans->t_need_data_flush = 1;
 		ret = 1;
 		goto out;
 	}
-- 
2.39.5



