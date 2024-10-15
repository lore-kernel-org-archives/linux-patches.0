Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40ED91D4154;
	Tue, 15 Oct 2024 12:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993784; cv=none; b=rhY5QJQF2+dCVWBDEZL8RJneJ1H+EnLB6T2hU7+DLSaUwRhD9AvAVEDAlfZVLlYdiaYTg7ZZRNIlkNJmtfnoZ8EV30QIXg010tcfXjTr2o0R0c6x0d5R5bDnislRvAudozxKg/223ClOwXNPxjcKWxh6FudhcK8BHK/0wkSGorM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993784; c=relaxed/simple;
	bh=2/K5Kt+CHrVE0JM0NHliw5U8yMi3FcdyzQfFbVOgBGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sFrzHzMMYtfIVwpXRWhktlyS2gTzEby3XcOkbRtmFIriGgfCJLG7ZdGEn2G7EGyx4jDuAeK57/zas0sV3F0aZcElyPg0db2PvN7mQRzq5YO8jCM2yay1DCqLH/gSowfhu3uhM3/O89vhu3SQH3YcW/A9SLHMfFYcDHFgIXtnKZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IXT9a10b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IXT9a10b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FFDBC4CEC6;
	Tue, 15 Oct 2024 12:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993783;
	bh=2/K5Kt+CHrVE0JM0NHliw5U8yMi3FcdyzQfFbVOgBGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IXT9a10bYXmIQCQ+2r1H3xS/1+hCtlWdKNP8DPO/xdJYcwyzvgVK8zMsx4H0wrNGD
	 FIwJBWRoRq2gezfuX/28ocryW1RhRFr+Xmupo+LRNx26A5YKldjVb66bpTVdRbMSGm
	 57faNgxvT+g1NxTZPDwrPv9maa+0bClOFhlk61DQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luis Henriques (SUSE)" <luis.henriques@linux.dev>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 5.15 513/691] ext4: fix incorrect tid assumption in jbd2_journal_shrink_checkpoint_list()
Date: Tue, 15 Oct 2024 13:27:41 +0200
Message-ID: <20241015112500.706249372@linuxfoundation.org>
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
@@ -427,6 +427,7 @@ unsigned long jbd2_journal_shrink_checkp
 	tid_t tid = 0;
 	unsigned long nr_freed = 0;
 	unsigned long freed;
+	bool first_set = false;
 
 again:
 	spin_lock(&journal->j_list_lock);
@@ -446,8 +447,10 @@ again:
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
@@ -477,7 +480,7 @@ again:
 	spin_unlock(&journal->j_list_lock);
 	cond_resched();
 
-	if (*nr_to_scan && next_tid)
+	if (*nr_to_scan && journal->j_shrink_transaction)
 		goto again;
 out:
 	trace_jbd2_shrink_checkpoint_list(journal, first_tid, tid, last_tid,


