Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D343019DC;
	Tue, 31 Mar 2026 17:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976779; cv=none; b=rqJVnYg3soj6gH+kO2cQdifHblFTjAHE0UDUAiVo5grTMGF2FJBScRRl/QdIDoqViqOLAJPaBtV4yQYw1Kg1sZcmYP9HjEXaKwmjxvrd5baJuWVS3Bi2zD+pZuoUutiJsFZErh3UMrFcbcI8vLtZylU0hoApZj413dMsgEBu4I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976779; c=relaxed/simple;
	bh=EZUnIiXj7oqmyhPESi7Jm/2F4nQn8MuY2iUOUE3dV9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gkZSTFCUhO2A5sgUGm6P0bsLbR2ti0GmMgXVCIjct28/4S38q9dBEb/+3qn7QIczp0QqJcvZVebbdyWoKrPnBgO2jjHifWdmuYA9oQQBqE6Y/W/CjjeGPJ5TzLf7RPvfMW6SxkG8B4oUg/xc6df+yptHH4ApENQ1CAZ57sJGRJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NOoZbGrM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NOoZbGrM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D427C19423;
	Tue, 31 Mar 2026 17:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976778;
	bh=EZUnIiXj7oqmyhPESi7Jm/2F4nQn8MuY2iUOUE3dV9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NOoZbGrMAfQ3nFH8FT327UcNIpCBkPPS3bXuz72DLRSf5YwE8jkVsdtr1GFC7hGif
	 xsmQ+/oTh+6Avih7X2MwKQBzsEdIyKJDLv7hEdsv6L2gaOpdMtzOacsS7biE3/4k//
	 TwE1oseUR/FkM8xgCBSYawmtBtDv4o3pwjnAmaJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Milos Nikic <nikic.milos@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>,
	Zhang Yi <yi.zhang@huawei.com>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.18 224/309] jbd2: gracefully abort on checkpointing state corruptions
Date: Tue, 31 Mar 2026 18:22:07 +0200
Message-ID: <20260331161801.689563418@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Milos Nikic <nikic.milos@gmail.com>

commit bac3190a8e79beff6ed221975e0c9b1b5f2a21da upstream.

This patch targets two internal state machine invariants in checkpoint.c
residing inside functions that natively return integer error codes.

- In jbd2_cleanup_journal_tail(): A blocknr of 0 indicates a severely
corrupted journal superblock. Replaced the J_ASSERT with a WARN_ON_ONCE
and a graceful journal abort, returning -EFSCORRUPTED.

- In jbd2_log_do_checkpoint(): Replaced the J_ASSERT_BH checking for
an unexpected buffer_jwrite state. If the warning triggers, we
explicitly drop the just-taken get_bh() reference and call __flush_batch()
to safely clean up any previously queued buffers in the j_chkpt_bhs array,
preventing a memory leak before returning -EFSCORRUPTED.

Signed-off-by: Milos Nikic <nikic.milos@gmail.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260311041548.159424-1-nikic.milos@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jbd2/checkpoint.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -267,7 +267,15 @@ restart:
 			 */
 			BUFFER_TRACE(bh, "queue");
 			get_bh(bh);
-			J_ASSERT_BH(bh, !buffer_jwrite(bh));
+			if (WARN_ON_ONCE(buffer_jwrite(bh))) {
+				put_bh(bh); /* drop the ref we just took */
+				spin_unlock(&journal->j_list_lock);
+				/* Clean up any previously batched buffers */
+				if (batch_count)
+					__flush_batch(journal, &batch_count);
+				jbd2_journal_abort(journal, -EFSCORRUPTED);
+				return -EFSCORRUPTED;
+			}
 			journal->j_chkpt_bhs[batch_count++] = bh;
 			transaction->t_chp_stats.cs_written++;
 			transaction->t_checkpoint_list = jh->b_cpnext;
@@ -325,7 +333,10 @@ int jbd2_cleanup_journal_tail(journal_t
 
 	if (!jbd2_journal_get_log_tail(journal, &first_tid, &blocknr))
 		return 1;
-	J_ASSERT(blocknr != 0);
+	if (WARN_ON_ONCE(blocknr == 0)) {
+		jbd2_journal_abort(journal, -EFSCORRUPTED);
+		return -EFSCORRUPTED;
+	}
 
 	/*
 	 * We need to make sure that any blocks that were recently written out


