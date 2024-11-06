Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0911922DB;
	Wed,  6 Nov 2024 12:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895365; cv=none; b=N5n9hRSdNm7//m5llYP59tLCdcUygR6MUnZ818PdrDVC4bn4ACUxG7wB0/32nLzxbAVQg21UxOoQDfLUVc9yBjZsNnWbpRgha/h3TktogvvHOq+PIUUkISP3UE1MQqpkBu8Kzt7rze7WZCwzGmzA8J3QdxP1cUmgIo8ki8bjQGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895365; c=relaxed/simple;
	bh=eU0moRQxwSZtItIvJf0eILBZJCEEVh6iCER+hp251kg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hyh+iEbGmzdfdtmhvTuM8fLG6/VTNjK9VGhBoVQsqZ9k16CYZQDpjQVwYKAhsJz4W2BWAXF12y7CoLTmBf13yuxnnvfoGHezElzvkhwYsR+fyIhlE8tNkwNGH0L/lgyDkNgqMOpS99i9QbxgT8wfC5C31C8L36H7fX3OmkNJ4qE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aHUSf+fL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aHUSf+fL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F462C4CECD;
	Wed,  6 Nov 2024 12:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895365;
	bh=eU0moRQxwSZtItIvJf0eILBZJCEEVh6iCER+hp251kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aHUSf+fLCXHl/fIuPjw6fpEW5s+Gzbu3N3aBZraiQbF0AlHesrHikqA6/Cx8EaucZ
	 tFX8O0SQD0YCrTd2CzJcvb0hnlvwqC3lCQHqtcK2hPomE+BXv3Klt3EajhvSbRCqXn
	 8tUtftrhc7dilixqjqYn9Ezv3hpzU3xrsddJPnU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luis Henriques (SUSE)" <luis.henriques@linux.dev>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 4.19 193/350] ext4: fix incorrect tid assumption in ext4_wait_for_tail_page_commit()
Date: Wed,  6 Nov 2024 13:02:01 +0100
Message-ID: <20241106120325.731764532@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luis Henriques (SUSE) <luis.henriques@linux.dev>

commit dd589b0f1445e1ea1085b98edca6e4d5dedb98d0 upstream.

Function ext4_wait_for_tail_page_commit() assumes that '0' is not a valid
value for transaction IDs, which is incorrect.  Don't assume that and invoke
jbd2_log_wait_commit() if the journal had a committing transaction instead.

Signed-off-by: Luis Henriques (SUSE) <luis.henriques@linux.dev>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20240724161119.13448-2-luis.henriques@linux.dev
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5545,8 +5545,9 @@ static void ext4_wait_for_tail_page_comm
 	struct page *page;
 	unsigned offset;
 	journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
-	tid_t commit_tid = 0;
+	tid_t commit_tid;
 	int ret;
+	bool has_transaction;
 
 	offset = inode->i_size & (PAGE_SIZE - 1);
 	/*
@@ -5571,12 +5572,14 @@ static void ext4_wait_for_tail_page_comm
 		put_page(page);
 		if (ret != -EBUSY)
 			return;
-		commit_tid = 0;
+		has_transaction = false;
 		read_lock(&journal->j_state_lock);
-		if (journal->j_committing_transaction)
+		if (journal->j_committing_transaction) {
 			commit_tid = journal->j_committing_transaction->t_tid;
+			has_transaction = true;
+		}
 		read_unlock(&journal->j_state_lock);
-		if (commit_tid)
+		if (has_transaction)
 			jbd2_log_wait_commit(journal, commit_tid);
 	}
 }


