Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3CF189910;
	Tue,  8 Oct 2024 12:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392337; cv=none; b=tA+SrnIP7RdXqz5GachS8WZsRoXAoTXRPa+cR5+hpYNdYkQ0A4Q2X4BE0sYxrxXMQiLsqe01odrqg1u9pIa8ILsUJpZ9VabsJwn9jGFrmyyG5itkSVaBNJFz9PWizDYMiiaCtTOpuFLD25qDM49s/e2k+DBKmdxX9XGo95A65bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392337; c=relaxed/simple;
	bh=gIl+IyspxKo5yWkgpzSGjbSH378HhCaGGtFfgBd4dHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N8TN1Q7s3s/KChK2Zu7ilsdZKJ+PXnhGLWoS3O51LTzQdyYsDfg+SyMRa61TW9NEW5aPz/QnlMxkPudPBNK3M+TQHDL7EiSkHfEVGWIm6D5BRLYSKBuVwj8TpWzG8bti5tVd78wPAj2/cyy1T/x/wWApfOw9gdq9bBl7zmt4SYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ephv8Mvd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ephv8Mvd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E4D5C4CEC7;
	Tue,  8 Oct 2024 12:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392336;
	bh=gIl+IyspxKo5yWkgpzSGjbSH378HhCaGGtFfgBd4dHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ephv8MvdrbL5RzGh1NV2ItzR3Br7gbZMjqAk9899MLJ+QqZcwUs2ZVcXHIMXSiOTL
	 Z/KfyLUN/LjdNYqb99PIWKiXMmRzb3YyRHfJbXSagPolRmtJH+KNllLaTLlwLWnUOi
	 IyovdOWY90AA3U0yvQBFcKhz3cmLnciEusS833PI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luis Henriques (SUSE)" <luis.henriques@linux.dev>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.11 386/558] ext4: fix incorrect tid assumption in __jbd2_log_wait_for_space()
Date: Tue,  8 Oct 2024 14:06:56 +0200
Message-ID: <20241008115717.477269836@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -79,9 +79,12 @@ __releases(&journal->j_state_lock)
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
@@ -89,7 +92,7 @@ __releases(&journal->j_state_lock)
 			} else if (jbd2_cleanup_journal_tail(journal) == 0) {
 				/* We were able to recover space; yay! */
 				;
-			} else if (tid) {
+			} else if (has_transaction) {
 				/*
 				 * jbd2_journal_commit_transaction() may want
 				 * to take the checkpoint_mutex if JBD2_FLUSHED


