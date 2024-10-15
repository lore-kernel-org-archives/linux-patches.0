Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5EF91CFEA9;
	Tue, 15 Oct 2024 12:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993780; cv=none; b=j76EKABu4DFKuP/QbS8HY2BIECktrgvJonFqMczzICXKCnQUipbB+/T9eGaQJ5oAhFKFFyg9CvphhSZcbpCSAkZei0K0jpKQloCi/As7QFqKU3T3n5m+HjB9VKdJjkyxX2ov2GzmeIVbZdq+h8yNHsIWb1z2eWOjkKcTjpBoe/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993780; c=relaxed/simple;
	bh=8Gml2jdVqVNppTCy13P3oJ4qGKS0vj7FLCDcyBwSOOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RNvco66An9qu8mBIBf+kdqnOonEMimxtigruPyynI2fXzg7WwLfcOCzRyzDsE8VAyTcfOFYP0INOz3vwhGbUxX1TkXR2HIYavvPB+jcXZOHk9Br7utVuD2XIaltTne0rCD0mgKDhLta8u1ORiQjmjiYRjxL0QZ6KKcn+J0fG4Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A8zbqzva; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A8zbqzva"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 289BAC4CEC6;
	Tue, 15 Oct 2024 12:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993780;
	bh=8Gml2jdVqVNppTCy13P3oJ4qGKS0vj7FLCDcyBwSOOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A8zbqzva55ZfK6N91dvDPCldyx0E/i//HQmbgKBu4t7Nrym8hj4ZaEJ/fjYhjE/f5
	 APLyuUC0pkuj5oqoxvpdspey4jhoII+e3M9CtHqbpv48jQqiVvexPMLFaNcdwtTKRm
	 ReNn0oIkOtWZB2aFWMYgBBwpyffxzE8wPiwCpUjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luis Henriques (SUSE)" <luis.henriques@linux.dev>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 5.15 512/691] ext4: fix incorrect tid assumption in ext4_wait_for_tail_page_commit()
Date: Tue, 15 Oct 2024 13:27:40 +0200
Message-ID: <20241015112500.667049588@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5301,8 +5301,9 @@ static void ext4_wait_for_tail_page_comm
 	struct page *page;
 	unsigned offset;
 	journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
-	tid_t commit_tid = 0;
+	tid_t commit_tid;
 	int ret;
+	bool has_transaction;
 
 	offset = inode->i_size & (PAGE_SIZE - 1);
 	/*
@@ -5327,12 +5328,14 @@ static void ext4_wait_for_tail_page_comm
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


