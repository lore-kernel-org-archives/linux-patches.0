Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360FD1CC89D;
	Wed,  6 Nov 2024 13:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898468; cv=none; b=gDTFBmLn+xmcjazhQQencQVQyVAGPULv9tZyXuFgDTnpUroa3BCOEZ6inSsc8AJrXxPODnEFiVGmwLEQbtVkrfHl9KepAm0ASLzIRD2H5PS6ZkLaVe735/DFPey883Mr2w7rKpQK/np2gkvYyAvSNh1bR5zv334g7p2HevuARQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898468; c=relaxed/simple;
	bh=HdSDVC851OseMLiOqNTxhN3vDlXaAXHdAV9Fo9zPwOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sdnq1jeXOl5ZPQm8a6K1SHE6WVVcScUkAw8LbVBFEYYN3H5GCISYx/K5YYh757zlR+Vf3eO6tN5LFjBa8IfPRjBJ2EkXl1ivq+GV/FxCcQorLKwN7uibZGllNzm0rOPU8F92YjI6a2VOoTLMZMjYe7MYRFxBOUvGStiJXG4uqF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X39xFZVt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X39xFZVt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD580C4CECD;
	Wed,  6 Nov 2024 13:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898468;
	bh=HdSDVC851OseMLiOqNTxhN3vDlXaAXHdAV9Fo9zPwOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X39xFZVt8Hy/mzE5S8PI3X7qDl4QwJ0PAwdhhE9zN6eiLc8QSnuXg+xp7ZG5/H+Ve
	 esNCgtoVReTahCpsMnYffv5h/WLhdbOJB7b/1i1u7iG6cPRrTIQuDs8Ui6fFZigyuy
	 3z7clOF2S1bhTzq8Cx0PtGJ2uLpWlM308P/vGs+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luis Henriques (SUSE)" <luis.henriques@linux.dev>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 5.4 248/462] ext4: fix incorrect tid assumption in __jbd2_log_wait_for_space()
Date: Wed,  6 Nov 2024 13:02:21 +0100
Message-ID: <20241106120337.650320874@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luis Henriques (SUSE) <luis.henriques@linux.dev>

commit 972090651ee15e51abfb2160e986fa050cfc7a40 upstream.

Function __jbd2_log_wait_for_space() assumes that '0' is not a valid value
for transaction IDs, which is incorrect.  Don't assume that and invoke
jbd2_log_wait_commit() if the journal had a committing transaction instead.

Signed-off-by: Luis Henriques (SUSE) <luis.henriques@linux.dev>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20240724161119.13448-3-luis.henriques@linux.dev
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jbd2/checkpoint.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -115,9 +115,12 @@ __releases(&journal->j_state_lock)
 		if (space_left < nblocks) {
 			int chkpt = journal->j_checkpoint_transactions != NULL;
 			tid_t tid = 0;
+			bool has_transaction = false;
 
-			if (journal->j_committing_transaction)
+			if (journal->j_committing_transaction) {
 				tid = journal->j_committing_transaction->t_tid;
+				has_transaction = true;
+			}
 			spin_unlock(&journal->j_list_lock);
 			write_unlock(&journal->j_state_lock);
 			if (chkpt) {
@@ -125,7 +128,7 @@ __releases(&journal->j_state_lock)
 			} else if (jbd2_cleanup_journal_tail(journal) == 0) {
 				/* We were able to recover space; yay! */
 				;
-			} else if (tid) {
+			} else if (has_transaction) {
 				/*
 				 * jbd2_journal_commit_transaction() may want
 				 * to take the checkpoint_mutex if JBD2_FLUSHED


