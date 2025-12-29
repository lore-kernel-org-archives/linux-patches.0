Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F873191BD;
	Mon, 29 Dec 2025 16:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025591; cv=none; b=WwDHm4+uqr2nYLstXmgGpJ/q9IZSsJjfS5yKDixPBfCmD+NuduUeIPXGz88aSID/p9cmMJAcb2fcxDIjASJzw9HoqZdasoy0dxFIfe1DcAQGHD4l5LsXlhPniKdmylNa+m2KnAYEDIZt5nmdWhvX7h3rSEDATWaiTqYS6zhiOPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025591; c=relaxed/simple;
	bh=XvRvFoeVHJFsA5maglyMgNvqKQQ45KZ/Ek3V84AB09k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pPKwWYVc2pk4Au9z3PZZK48YmimltLWJ+4MS8Q+69px7FKV7tV7fE7UVawQwLTdC3xJW5SLjn/Cvmz5glPKc+23I3nU0/nu34+1Vkffbvc6FebgN6F8yeUhppdfk5+6giKjp4Sa32BK0/D8D+9TdZ4YmcP0nXjmmag8pCkZuE4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Arm/DpH7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Arm/DpH7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDE8FC4CEF7;
	Mon, 29 Dec 2025 16:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025591;
	bh=XvRvFoeVHJFsA5maglyMgNvqKQQ45KZ/Ek3V84AB09k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Arm/DpH7ImUtIDZGeHWjtIdPeNQykaEVgEmPpoNqSzCPpTD3y58DBLZMsqI93350m
	 bp6cOwKLp/chB12U1fEHFqt5oWsjtDvoyPiLmdKp9iF2CmPWJWtNaXUQL4dPEucik7
	 qsviK0z2zsYNewgoAXMPR115HiM5aME2Z9ny+v9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Byungchul Park <byungchul@sk.com>,
	Jan Kara <jack@suse.cz>,
	stable@kernel.org,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.18 266/430] jbd2: use a weaker annotation in journal handling
Date: Mon, 29 Dec 2025 17:11:08 +0100
Message-ID: <20251229160734.141551981@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -441,7 +441,7 @@ repeat:
 	read_unlock(&journal->j_state_lock);
 	current->journal_info = handle;
 
-	rwsem_acquire_read(&journal->j_trans_commit_map, 0, 0, _THIS_IP_);
+	rwsem_acquire_read(&journal->j_trans_commit_map, 0, 1, _THIS_IP_);
 	jbd2_journal_free_transaction(new_transaction);
 	/*
 	 * Ensure that no allocations done while the transaction is open are


