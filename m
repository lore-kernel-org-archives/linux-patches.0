Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B62118C025;
	Tue, 10 Sep 2024 09:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961979; cv=none; b=miKQB0UVqpkB4Bn8lKvseCqQ70iis17bV+Xa0Nu2vcXb4Bufbdr0ozd3jkajb7vmKeuSmcPspSPT0ANYQTCJOEKDfiAr834OxzudXEPCkBSY9z4HicsYUfVuNTyRVndwxnZRvyMms0NNY2sqKB7r78/isceHzSW4YnZoPF8Zu8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961979; c=relaxed/simple;
	bh=FMzmzt0iDrH9vIZWX5BbGNQxAJPCBFtV1nkvvKiRa5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E8UR7qhpJcieswPhSltpyUWRSO9zw8FLez+yxavabclpwTHZqVzNa3w/T3uCKTP0yOB0BifClZOGFzNnACt9gbvrxsGULlk3pa+bqhXnk/Yx0Xj1/lBfZVmhkUBm8zdAMqZD3GMN6DM0nFd/gmJ6xeAqN4REZ5ahYSbyofvLBa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YGWVPetU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YGWVPetU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 863EFC4CECD;
	Tue, 10 Sep 2024 09:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961978;
	bh=FMzmzt0iDrH9vIZWX5BbGNQxAJPCBFtV1nkvvKiRa5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YGWVPetU6BJ6oMldqOAIV/mPmW1Qa6kPW1loCeFeV++ikZhb0Pf4OpKupNZw2YK1g
	 gJIDBUiSRyTpeGsbCtGhJjWqkLVEGzxX8+nqkiKNMf38lTFTzFaXJ3+bC7D6t5XMcO
	 HXTHLKDJmLIbUcrN3ubscraeXBkwKFkPkYrclrxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 227/375] jbd2: avoid mount failed when commit block is partial submitted
Date: Tue, 10 Sep 2024 11:30:24 +0200
Message-ID: <20240910092630.173393186@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ye Bin <yebin10@huawei.com>

[ Upstream commit 0bab8db4152c4a2185a1367db09cc402bdc62d5e ]

We encountered a problem that the file system could not be mounted in
the power-off scenario. The analysis of the file system mirror shows that
only part of the data is written to the last commit block.
The valid data of the commit block is concentrated in the first sector.
However, the data of the entire block is involved in the checksum calculation.
For different hardware, the minimum atomic unit may be different.
If the checksum of a committed block is incorrect, clear the data except the
'commit_header' and then calculate the checksum. If the checkusm is correct,
it is considered that the block is partially committed, Then continue to replay
journal.

Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20240620072405.3533701-1-yebin@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jbd2/recovery.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/fs/jbd2/recovery.c b/fs/jbd2/recovery.c
index 1f7664984d6e..0d14b5f39be6 100644
--- a/fs/jbd2/recovery.c
+++ b/fs/jbd2/recovery.c
@@ -443,6 +443,27 @@ static int jbd2_commit_block_csum_verify(journal_t *j, void *buf)
 	return provided == cpu_to_be32(calculated);
 }
 
+static bool jbd2_commit_block_csum_verify_partial(journal_t *j, void *buf)
+{
+	struct commit_header *h;
+	__be32 provided;
+	__u32 calculated;
+	void *tmpbuf;
+
+	tmpbuf = kzalloc(j->j_blocksize, GFP_KERNEL);
+	if (!tmpbuf)
+		return false;
+
+	memcpy(tmpbuf, buf, sizeof(struct commit_header));
+	h = tmpbuf;
+	provided = h->h_chksum[0];
+	h->h_chksum[0] = 0;
+	calculated = jbd2_chksum(j, j->j_csum_seed, tmpbuf, j->j_blocksize);
+	kfree(tmpbuf);
+
+	return provided == cpu_to_be32(calculated);
+}
+
 static int jbd2_block_tag_csum_verify(journal_t *j, journal_block_tag_t *tag,
 				      journal_block_tag3_t *tag3,
 				      void *buf, __u32 sequence)
@@ -810,6 +831,13 @@ static int do_one_pass(journal_t *journal,
 			if (pass == PASS_SCAN &&
 			    !jbd2_commit_block_csum_verify(journal,
 							   bh->b_data)) {
+				if (jbd2_commit_block_csum_verify_partial(
+								  journal,
+								  bh->b_data)) {
+					pr_notice("JBD2: Find incomplete commit block in transaction %u block %lu\n",
+						  next_commit_ID, next_log_block);
+					goto chksum_ok;
+				}
 			chksum_error:
 				if (commit_time < last_trans_commit_time)
 					goto ignore_crc_mismatch;
@@ -824,6 +852,7 @@ static int do_one_pass(journal_t *journal,
 				}
 			}
 			if (pass == PASS_SCAN) {
+			chksum_ok:
 				last_trans_commit_time = commit_time;
 				head_block = next_log_block;
 			}
@@ -843,6 +872,7 @@ static int do_one_pass(journal_t *journal,
 					  next_log_block);
 				need_check_commit_time = true;
 			}
+
 			/* If we aren't in the REVOKE pass, then we can
 			 * just skip over this block. */
 			if (pass != PASS_REVOKE) {
-- 
2.43.0



