Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758983EC57C;
	Thu, 15 Jan 2026 17:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499442; cv=none; b=HNPtV6ycrB4L5+/mWb35o3hG0tPW/pp4c2NiWkIeDl5P6EC5AFMV0eEHh44brqKbW4hHjpYLwO4ZxZiX7U/Zj2tiy5WEU7bYMuZYOcs52CE7YDeuIb0UzueOFThjFwUwBQtv/WFlWaXQOWZVgq24EUDACZ9gLxeAE3TNC3TsxUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499442; c=relaxed/simple;
	bh=IoqcjD55rzyvIxlkDeenj1DBs8RpNBS23/YGqbhf0Q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QvwA+5jwv/JXX8N+nnSFOLAGJvV1PiM47zNlaeA4AzxPd4A3IZ1d9w+CIL7khbIHbN4ScaNT0cjOwnczsdOTWtXJB3PZe1+39E7/rp4QwBusNK7Ni5FkB4oCBW7N2/QTIiM2HizTgrbMCsoH8ypcEOSvHvJC/rdPVEjLJyG1hG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W0pkNOz9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W0pkNOz9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2393C16AAE;
	Thu, 15 Jan 2026 17:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499442;
	bh=IoqcjD55rzyvIxlkDeenj1DBs8RpNBS23/YGqbhf0Q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W0pkNOz9aq3jiYAfB/p/zphlw7u05RiTVL31p+key1MZ3fnEe1d08KUX6H+l5AeaT
	 EdKwRKH0Nn+g2k8i7joS8s/7g1kPppY6xNnri7stJVIFTVfvPQAwY2q8PM5WI/dU/8
	 ItVyoT5eHqQfZ9q1+tY71NJmctvOeDXX4nISBgSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Byungchul Park <byungchul@sk.com>,
	Jan Kara <jack@suse.cz>,
	stable@kernel.org,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.10 227/451] jbd2: use a weaker annotation in journal handling
Date: Thu, 15 Jan 2026 17:47:08 +0100
Message-ID: <20260115164239.107946738@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -448,7 +448,7 @@ repeat:
 	read_unlock(&journal->j_state_lock);
 	current->journal_info = handle;
 
-	rwsem_acquire_read(&journal->j_trans_commit_map, 0, 0, _THIS_IP_);
+	rwsem_acquire_read(&journal->j_trans_commit_map, 0, 1, _THIS_IP_);
 	jbd2_journal_free_transaction(new_transaction);
 	/*
 	 * Ensure that no allocations done while the transaction is open are


