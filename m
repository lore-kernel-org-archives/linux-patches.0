Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470141AB6E9;
	Mon, 14 Oct 2024 15:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919244; cv=none; b=oe0CjKtAFZgjdDn5Bw2bOX8BnEpTTiZlcXF3geAVSKjr4uRuDpZt7ATEuNO62spko2aQ/YvTks5u2WiKN2JGXVvke9xQW6/WTojWn+4VnYgonkf0Nis8s0m1eCsSBgmr71oEQcaAt8S6f/nTyamUKdMggD8b4xWmwojxKOwKyBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919244; c=relaxed/simple;
	bh=DYdEL1dZ3GUa6GYnoJNnKeIZy14UxXDC9Z7Gcw0ePx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pqj3ES90B9Gji3cX57p9YvjZ4eWs+3aRqN3qLKeV6/5zlG7TqoTCRdeGfE+OT9OxcFy1ZjL2yQu/TVh/tSEx05hNBnL/FOFqnVm2mXWy6LTeAesrs+nH7BqdPKelYIKPOlNLe3IZjhxKtxbNEYPyRtIIR3vzWxNCB1jhMA80n9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ohMhSE7l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ohMhSE7l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA4C6C4CEC3;
	Mon, 14 Oct 2024 15:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919244;
	bh=DYdEL1dZ3GUa6GYnoJNnKeIZy14UxXDC9Z7Gcw0ePx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ohMhSE7lppgVeWtflWfOQ7GfXPCWGB6VVJYyTluyfVEBJgm4krspMe2qR5vHmYcvD
	 iheD1dfPjCmtaan508bCvlES/qPgv8DC3kdEVewtKoDB2Ti02AxOHb8LvJCdyxLSLw
	 dAyx/PZtue+2BbSmz5GZ8Pi0hOQEZ7F3OGYBY9b8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luis Henriques (SUSE)" <luis.henriques@linux.dev>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.1 553/798] ext4: fix incorrect tid assumption in jbd2_journal_shrink_checkpoint_list()
Date: Mon, 14 Oct 2024 16:18:27 +0200
Message-ID: <20241014141239.722349242@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luis Henriques (SUSE) <luis.henriques@linux.dev>

commit 7a6443e1dad70281f99f0bd394d7fd342481a632 upstream.

Function jbd2_journal_shrink_checkpoint_list() assumes that '0' is not a
valid value for transaction IDs, which is incorrect.  Don't assume that and
use two extra boolean variables to control the loop iterations and keep
track of the first and last tid.

Signed-off-by: Luis Henriques (SUSE) <luis.henriques@linux.dev>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20240724161119.13448-4-luis.henriques@linux.dev
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jbd2/checkpoint.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -424,6 +424,7 @@ unsigned long jbd2_journal_shrink_checkp
 	tid_t tid = 0;
 	unsigned long nr_freed = 0;
 	unsigned long freed;
+	bool first_set = false;
 
 again:
 	spin_lock(&journal->j_list_lock);
@@ -443,8 +444,10 @@ again:
 	else
 		transaction = journal->j_checkpoint_transactions;
 
-	if (!first_tid)
+	if (!first_set) {
 		first_tid = transaction->t_tid;
+		first_set = true;
+	}
 	last_transaction = journal->j_checkpoint_transactions->t_cpprev;
 	next_transaction = transaction;
 	last_tid = last_transaction->t_tid;
@@ -474,7 +477,7 @@ again:
 	spin_unlock(&journal->j_list_lock);
 	cond_resched();
 
-	if (*nr_to_scan && next_tid)
+	if (*nr_to_scan && journal->j_shrink_transaction)
 		goto again;
 out:
 	trace_jbd2_shrink_checkpoint_list(journal, first_tid, tid, last_tid,


