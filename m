Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321E91DEFF7;
	Tue,  8 Oct 2024 13:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393746; cv=none; b=NCgaPw65wkwRCKwPHPZ93WJeYxpe3R/LM0EWzL7FXTMqWmHcCpfwOLuFnOIMcoYR0lcEX4cEvnqWPV4u4bKHmdfua4+xKXpw5Wjj016KjYF4Ka05J4G7CQFrnXi6cbyehTooFPVgwkRvr9FeFQfbGzwx/6/jPXstIegbVKYk/xI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393746; c=relaxed/simple;
	bh=wGhSYBg5Nypk0Q5y9FQxV7xJyVpqwbaxu0fwJXp3yEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dEyRLyX7vbdUJwmrDrvbu6z33MtdU75r/zET8AU027Rus3J85ek+XfFi0wQV/pySH2/4f78VtgtAF7kbT4grG1Cg1GLcBATVA+c4F07uIWw0+PAe0sgz0JKnK8oSQ+Ot7Zy8JUwhxy53wmgezkK1PasuQRRnzp0Bhy9r9k7dKd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L7IQtpNR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L7IQtpNR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B879C4CECC;
	Tue,  8 Oct 2024 13:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393746;
	bh=wGhSYBg5Nypk0Q5y9FQxV7xJyVpqwbaxu0fwJXp3yEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L7IQtpNRGYhl/ASlHleFoTs9FPoVT5Pcrx6GL7Kd3f+jIsIFslZpjmncLVt3J9YxN
	 T4gbA4Fn9ZLTG/wReWdcr0Wm8ideX6OgMoGzhDe/rtP/y6S9u1cVPrh4ybsTLIA3hm
	 tSxaqru9XilcfC1l2cmS1Sb2b8FtY1uiSNsTZeKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luis Henriques (SUSE)" <luis.henriques@linux.dev>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.6 243/386] ext4: fix incorrect tid assumption in ext4_wait_for_tail_page_commit()
Date: Tue,  8 Oct 2024 14:08:08 +0200
Message-ID: <20241008115638.958706405@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5257,8 +5257,9 @@ static void ext4_wait_for_tail_page_comm
 {
 	unsigned offset;
 	journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
-	tid_t commit_tid = 0;
+	tid_t commit_tid;
 	int ret;
+	bool has_transaction;
 
 	offset = inode->i_size & (PAGE_SIZE - 1);
 	/*
@@ -5283,12 +5284,14 @@ static void ext4_wait_for_tail_page_comm
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


