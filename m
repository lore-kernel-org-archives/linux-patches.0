Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4BF1D90A4;
	Tue, 15 Oct 2024 13:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998188; cv=none; b=Mf+fj5TSnxqBqLalmrw/LELzF9SknolaLTFYfadF9WT/mTyKqGKBNmLFchGgLsr4SSYXEaqiLthReZtYNn3wMU7ML8X08DdEMif6eOdFUpVasUfx/cDoxblEdCt7FCZ183D3O7FMhJ/GNoHBNV/IdIUrEb4qTbHKFSeuBhoIWns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998188; c=relaxed/simple;
	bh=mG8n070ZwCr5MsQK2C3UD9fVa6fv4bh4c3y8UJ3XqaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K49R4c9uKi1eaA8AAFPax3IExsTFAeZ8OhBomeBhTUZmMJCU5EbH0QuRgM5/hFjnRl/8cBSDYqVkD4BwB2tgj7BlbnSb/d/1R1ebC00aNTIaBqrkSQNDubrhjK8DhaNK2R8I6OK05iWaLiI581WAHN0svr7vOyWLX11Mwef+La4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZGBEqOIe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZGBEqOIe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7A74C4CEC6;
	Tue, 15 Oct 2024 13:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998188;
	bh=mG8n070ZwCr5MsQK2C3UD9fVa6fv4bh4c3y8UJ3XqaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZGBEqOIe35zOQPbBLZwh1TqEKumssurAFK9JJ3Se1x6XtDNWrhqCxWlz3f1u/SZQB
	 GkCHPi8rV7wqklFwFSACniefSuKUeuP+8FdzAhBkVNPwbyeb1GKtGLOqmK/QfqQG1f
	 LQJZUsFVJQ808cJqkeYa/VMMotinr+NtMbTM4ayw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luis Henriques (SUSE)" <luis.henriques@linux.dev>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 5.10 373/518] ext4: fix incorrect tid assumption in __jbd2_log_wait_for_space()
Date: Tue, 15 Oct 2024 14:44:37 +0200
Message-ID: <20241015123931.368346943@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


