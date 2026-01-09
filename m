Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC2135A932;
	Fri,  9 Jan 2026 12:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960595; cv=none; b=rEd3hDZ4zXIGqTVn82PvAzeC7gVxazA1IKgGYg3Uim5M242VZH7/CYFW1PvOvvPo+0ViFpArRvyeiVz1mGXOEj0s3Mqc29+mOanyW4C1rVJtG+Ofv8USljeFX71tZ/p4WqYahFq6+L6mL/FTJp2MUP8pnYUjYvaVsPXWTnu7h0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960595; c=relaxed/simple;
	bh=kumB04/Sg2Z5Q+Gb05wGl6ttn/TGCCB0ICqp+x2mGPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IKFJSJ0zMq3ZUc4dK7X0sQe7oo852clAeOJzfellahRe52yUhDo+e4ticsTYjLK9m+s3oGJ1rrYqH6rMAp80bt74Nc7Xps6uEm0U6Zx1VvYTC2pi5jDXqYGu9W5euu+vAAZdX5p6cKzhnmEqIQUWxXE2PGayeqBfOlRs7xCGM9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BWrqcP1U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BWrqcP1U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BB09C4CEF1;
	Fri,  9 Jan 2026 12:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960595;
	bh=kumB04/Sg2Z5Q+Gb05wGl6ttn/TGCCB0ICqp+x2mGPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BWrqcP1ULkI36gZghcpwvAAN4jSz5dONTeSN3+ZaIuw1Y2sG/T4pJVyWKqwSd4W56
	 Zcdsr4Ro//eIlmIxog8WBEPiVum8rWPgMnsMDixNlnIFsbSqSdl5WrWGf/SFetx7B/
	 rgfxUS6iWEXr53h3XrcfYehl9VYpEfKHPBwIjojc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Byungchul Park <byungchul@sk.com>,
	Jan Kara <jack@suse.cz>,
	stable@kernel.org,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.6 427/737] jbd2: use a weaker annotation in journal handling
Date: Fri,  9 Jan 2026 12:39:26 +0100
Message-ID: <20260109112150.059310341@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Byungchul Park <byungchul@sk.com>

commit 40a71b53d5a6d4ea17e4d54b99b2ac03a7f5e783 upstream.

jbd2 journal handling code doesn't want jbd2_might_wait_for_commit()
to be placed between start_this_handle() and stop_this_handle().  So it
marks the region with rwsem_acquire_read() and rwsem_release().

However, the annotation is too strong for that purpose.  We don't have
to use more than try lock annotation for that.

rwsem_acquire_read() implies:

   1. might be a waiter on contention of the lock.
   2. enter to the critical section of the lock.

All we need in here is to act 2, not 1.  So trylock version of
annotation is sufficient for that purpose.  Now that dept partially
relies on lockdep annotaions, dept interpets rwsem_acquire_read() as a
potential wait and might report a deadlock by the wait.

Replace it with trylock version of annotation.

Signed-off-by: Byungchul Park <byungchul@sk.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: stable@kernel.org
Message-ID: <20251024073940.1063-1-byungchul@sk.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jbd2/transaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -445,7 +445,7 @@ repeat:
 	read_unlock(&journal->j_state_lock);
 	current->journal_info = handle;
 
-	rwsem_acquire_read(&journal->j_trans_commit_map, 0, 0, _THIS_IP_);
+	rwsem_acquire_read(&journal->j_trans_commit_map, 0, 1, _THIS_IP_);
 	jbd2_journal_free_transaction(new_transaction);
 	/*
 	 * Ensure that no allocations done while the transaction is open are


