Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1FFC35BDCC;
	Fri,  9 Jan 2026 12:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962341; cv=none; b=LgBI8qBpPhH/SQgD/dVS9aijtiMjDQBJgZvEewkIdH3iSD/iifCxrdD5I2OL3r+ZwQbdM0gq41mXy6PmKuM39nC0EzQW3Hcv31MwcCDljpfTD7tTusIDYY8OgyKuASJxtCKFEOaQk0dgoGw7sFym3ToKjYmssJ4mhie8FAvtwN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962341; c=relaxed/simple;
	bh=Z2LQ9abonvVOaVcQ2/JOhCMABcpyRy9iof58SvfPbn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eXW314r+dZX1DUHKycQIL0Dkpc3Zrvnqdl/bQEbekBhB9r2nR4zSsneEtmbo7MUV+3ugO1zRYhH3yTTPJMKYe3ByQXVWytSeLrXdLade4seAjDy3IAoOf1FCK7o35fk45lhD8L29lNUlSs3dVzVXYFHByOXYo+J1vKTL0X1eZgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T9vybeMV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T9vybeMV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AFE0C16AAE;
	Fri,  9 Jan 2026 12:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962341;
	bh=Z2LQ9abonvVOaVcQ2/JOhCMABcpyRy9iof58SvfPbn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T9vybeMVIz0anVJOQPtm8HBR6qu8JCZTRscCnTT6EFBYB2/ya6oTI+Dkx8PP2rWSm
	 12TLjyRmnghJ7Ark27ZyQbmEeHBQ7esVdoLJ3uIStdEgqe78aWC5jv3NkG1xfJl5d8
	 bFH1l+2l38l2liFSzbIUfmk0j4wHDmaXv0TvAIzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Byungchul Park <byungchul@sk.com>,
	Jan Kara <jack@suse.cz>,
	stable@kernel.org,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.1 331/634] jbd2: use a weaker annotation in journal handling
Date: Fri,  9 Jan 2026 12:40:09 +0100
Message-ID: <20260109112129.981487557@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -460,7 +460,7 @@ repeat:
 	read_unlock(&journal->j_state_lock);
 	current->journal_info = handle;
 
-	rwsem_acquire_read(&journal->j_trans_commit_map, 0, 0, _THIS_IP_);
+	rwsem_acquire_read(&journal->j_trans_commit_map, 0, 1, _THIS_IP_);
 	jbd2_journal_free_transaction(new_transaction);
 	/*
 	 * Ensure that no allocations done while the transaction is open are


