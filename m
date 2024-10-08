Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769AB1DEFE3;
	Tue,  8 Oct 2024 13:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393749; cv=none; b=cF2MnwGdsjztgdd9R7T9ENgQ8xCWDHAAWzkGpOhg4JOevHDoTQ9eUbxzY/zdqlUt6Ugb7d2JujvOrnSMsR47n5RwU25e4B4lNEhbQpGzMrxYEokItLIHXTY2eM3IGaD1fmzmetVP1Q5p6m+txQfoxK3xcZA6VT68SRl++oA0JWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393749; c=relaxed/simple;
	bh=VcNJuzPyVckSbfHCIDS6ujXGPQ0bek6l5VoIB0vrUlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cfgPVkX6f8TwWNXCKVMiXDglk2vuvN/42E40sLusMvlivqvtqh2fcnkXMigPLpC3RnR/PmnpFet2tCRcmjKMadWQFE3tO5XAx+xGQj3lJIa5GD8mUCBOKybfpqR3415arjS52GLIWRZ4wJYrJHMYFUHeOCAsSE4jjGgAoVzF0+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QRqJDicT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QRqJDicT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F46C4CEC7;
	Tue,  8 Oct 2024 13:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393749;
	bh=VcNJuzPyVckSbfHCIDS6ujXGPQ0bek6l5VoIB0vrUlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QRqJDicTUXkYkkKUVG0t+RU/ZmKsPFF9YDHL/HHGA3zHx/asXuP0yXz/RqKPgfjoL
	 WsDBMPz2IEC41KhKMWiiWNsjxuxVy+RQfwQn3VmRJrmg3fWekrHph+NgxrQpRxAisf
	 aG3Czg4z6DBZUCv0utIdtqoVyEYmU8lPablITleE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luis Henriques (SUSE)" <luis.henriques@linux.dev>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.6 244/386] ext4: fix incorrect tid assumption in jbd2_journal_shrink_checkpoint_list()
Date: Tue,  8 Oct 2024 14:08:09 +0200
Message-ID: <20241008115638.998334869@linuxfoundation.org>
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
@@ -412,6 +412,7 @@ unsigned long jbd2_journal_shrink_checkp
 	tid_t tid = 0;
 	unsigned long nr_freed = 0;
 	unsigned long freed;
+	bool first_set = false;
 
 again:
 	spin_lock(&journal->j_list_lock);
@@ -431,8 +432,10 @@ again:
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
@@ -462,7 +465,7 @@ again:
 	spin_unlock(&journal->j_list_lock);
 	cond_resched();
 
-	if (*nr_to_scan && next_tid)
+	if (*nr_to_scan && journal->j_shrink_transaction)
 		goto again;
 out:
 	trace_jbd2_shrink_checkpoint_list(journal, first_tid, tid, last_tid,


