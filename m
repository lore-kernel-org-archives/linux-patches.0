Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124711DEFC9;
	Tue,  8 Oct 2024 12:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390601; cv=none; b=eHxzVTk7dtpQ18H0x3v/wj3eYaJFIq6SfZz7Ajt+zoNzqvU0rkPhMzZAkJnnYujqFdUtnctXQr9YNcrSRoj+moMsjbap7SwYbET+Wu6q0JonrJQho19crtRa2WgsowML7IiFDNEfd3AMHM2QD07tRGvq1EDLUWk8C8KoGhvuhNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390601; c=relaxed/simple;
	bh=2m0HS+mrZjJmqb6XLkxHJtaHEYh5i2geRu9CEIBJcEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u6YZG9V7q/3v5LK1tMsKO8nLP5SNHZuz8ZuRUdKw7xX0XTppW1mHw7bH46nLYGdlW6FZDCjxNmi4dTDCKQZ5uzYyPtQNNcPCeNwVfT3pd14GJgdIhoaDFug6gtYmI40chB50l0oNRzQWbuC+GVZDU4QhAQ8QVxx9+a3wAdEWz94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PjT8nUm+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PjT8nUm+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CEA1C4CEC7;
	Tue,  8 Oct 2024 12:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390600;
	bh=2m0HS+mrZjJmqb6XLkxHJtaHEYh5i2geRu9CEIBJcEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PjT8nUm+1re7B+2PDJIpkWF3gZ6OE22x1YRLtimGfAjmu9DGTKx96Dm/XH5hC7FlF
	 iMwMkbA4Ow3/cOxEDw6vZ9n1Mm/XFYHOpKyMQ7gylVjANIN2kqHng2Mi8GY+Us03+h
	 sLYMpPgyYOwOI3o8Us4I0TDmby9FxiGldLg1diQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luis Henriques (SUSE)" <luis.henriques@linux.dev>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.10 336/482] ext4: fix incorrect tid assumption in jbd2_journal_shrink_checkpoint_list()
Date: Tue,  8 Oct 2024 14:06:39 +0200
Message-ID: <20241008115701.648223343@linuxfoundation.org>
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
@@ -410,6 +410,7 @@ unsigned long jbd2_journal_shrink_checkp
 	tid_t tid = 0;
 	unsigned long nr_freed = 0;
 	unsigned long freed;
+	bool first_set = false;
 
 again:
 	spin_lock(&journal->j_list_lock);
@@ -429,8 +430,10 @@ again:
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
@@ -460,7 +463,7 @@ again:
 	spin_unlock(&journal->j_list_lock);
 	cond_resched();
 
-	if (*nr_to_scan && next_tid)
+	if (*nr_to_scan && journal->j_shrink_transaction)
 		goto again;
 out:
 	trace_jbd2_shrink_checkpoint_list(journal, first_tid, tid, last_tid,


