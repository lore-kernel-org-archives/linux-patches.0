Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 546CA1DE8A9;
	Tue,  8 Oct 2024 12:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390598; cv=none; b=B2YFocAS8vlm+uhmNOncJL6dV8gsjg3ioWhDvfl/COfs8+Gcvjj0R5GtgQoFgLQtotG/EqnpjNttwO0uRqJW2zYxl0dzRhKhUQQamj6H+yJDVLDjk2Z/Fnq9JC3Jm71PSBGxagaTk8pwx9aulvWPwvbdI5cqt3IILXKmjaXsU7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390598; c=relaxed/simple;
	bh=BnS385pPSDC9xlovUfzP4o3jdoqruqftc6CYf7B3FWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XZZ5JrVt8HgUF8xInfTqejyf9h35C8b9WMwlQHAlhzsfoeVmRv0eFZlJRRlp4gBSVSq8ZuH+s4ddfZu7nQAEUlLgzNhL7766BISHLFztaD/QASDzrruwjw4YJWkKfZ+Omis7fIb7sKwltwVGTr5p6gNc/HrkGTTI3m3mpYJSJEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PaDBPyDN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PaDBPyDN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B2A7C4CEC7;
	Tue,  8 Oct 2024 12:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390597;
	bh=BnS385pPSDC9xlovUfzP4o3jdoqruqftc6CYf7B3FWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PaDBPyDN63HNfZRFezU2extuIQ2uVE1efOx514BTqlfTuqsLJDTRF+b1rTghfYzed
	 v+RPizHx0sZmt5NDdYxaPs1l86r/JG2pg4c1Hr8n1mEkyKpg1znoIpEhkkUz79cVDm
	 OAR7rMbgqGzeyCjX0GuqAXv3wSGxkrzkgRPsnLfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luis Henriques (SUSE)" <luis.henriques@linux.dev>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.10 335/482] ext4: fix incorrect tid assumption in ext4_wait_for_tail_page_commit()
Date: Tue,  8 Oct 2024 14:06:38 +0200
Message-ID: <20241008115701.608857318@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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
@@ -5233,8 +5233,9 @@ static void ext4_wait_for_tail_page_comm
 {
 	unsigned offset;
 	journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
-	tid_t commit_tid = 0;
+	tid_t commit_tid;
 	int ret;
+	bool has_transaction;
 
 	offset = inode->i_size & (PAGE_SIZE - 1);
 	/*
@@ -5259,12 +5260,14 @@ static void ext4_wait_for_tail_page_comm
 		folio_put(folio);
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


