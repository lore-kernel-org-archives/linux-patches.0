Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC251D4154;
	Tue, 15 Oct 2024 12:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993761; cv=none; b=MulQ7pLeYas/6Fgu1POQogQbtzJBco4RbEN2bzDcWleltV3kXd9pFDhgiqPBLCGncUl0Aho36kXvFTUqVZrPoU8dO1XWeJzjrsW27SDUrwAC/34LQ5xGSVtqtY+tUTvQG2AQs44bqlFeVmvz1ENlzWSYEjpPo6LxXDfW5jrowuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993761; c=relaxed/simple;
	bh=A/hdOrQTTOFdLruPF5405SZUAlze5zNBk17a/0nGZI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EsHDibnjh0ZqWxee2SD5fnatbtpRdW7kXMWLbwkk2Pj+3J7nsx1GbBlyH2UIuEu/12vErXNJbnYdPxziOZnLdnxlgavKmwkh53D5ssjTRsNsRgkOiP3mHkk0ckneJxac9uJGFM28TR/sTW5Iiw5e2BkZq07yTRFHEO+3ibUxvBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xNvOn1NB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xNvOn1NB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06C08C4CEC6;
	Tue, 15 Oct 2024 12:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993760;
	bh=A/hdOrQTTOFdLruPF5405SZUAlze5zNBk17a/0nGZI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xNvOn1NBoHQz+LF5g817h4YnxUHOEiICh/arH5eylr2nDKVlnLPRVoCKXMyzejTcO
	 Jx5LV99HKtSErAJLCs/SVAuyTwxC2D6Ij5vdXGJM7vp9MAbY5YNFoGVvhY6gB3oudA
	 N1bBcEAtmHrhB+ofs/bE03DM0YH8P3h4/HICddWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luis Henriques (SUSE)" <luis.henriques@linux.dev>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 5.15 507/691] ext4: fix incorrect tid assumption in __jbd2_log_wait_for_space()
Date: Tue, 15 Oct 2024 13:27:35 +0200
Message-ID: <20241015112500.466057827@linuxfoundation.org>
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
@@ -91,9 +91,12 @@ __releases(&journal->j_state_lock)
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
@@ -104,7 +107,7 @@ __releases(&journal->j_state_lock)
 				 * journal was aborted due to an error.
 				 */
 				;
-			} else if (tid) {
+			} else if (has_transaction) {
 				/*
 				 * jbd2_journal_commit_transaction() may want
 				 * to take the checkpoint_mutex if JBD2_FLUSHED


