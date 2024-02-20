Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 909F8151CED;
	Tue, 20 Feb 2024 21:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465330; cv=none; b=QJOxWCe1yselBxFujjmPkJt5na6OGCwLWuvD4EluHQaVGmrs/U85kmVZrL+6C89Nnbss8UjIf8lSBlrHAXw31bwbO14pouRfdmVL8nrJ6xNjjjdAL8NnbSCIi4csx6Ae/3eBcCfSxzuz3vtLXFYrZWNzYqWDLoX+e2Yes7lGf9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465330; c=relaxed/simple;
	bh=IyrkN4z7daQYV095EC64rBWUYcRRhXsrxLusFKGrtFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SrpIjwqtu2cNzu9lEzmbCRVZwgs3N29Kh3cYxrOqepl/hqVS6Q+56HuDYTDotHSefvi6cNtJYhZZ5EmovP+4iBLdYOeBDEe7wj96p03Ni3bw53wemqNRE+cvt+GJ6kLc4N9nkzHv1RtaQAbZkwV+cMg9zXR4w4owXIaRyzz1k9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MBN4u1op; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MBN4u1op"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 034B1C433F1;
	Tue, 20 Feb 2024 21:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465330;
	bh=IyrkN4z7daQYV095EC64rBWUYcRRhXsrxLusFKGrtFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MBN4u1opyaA59I++kYJfIvq+MyzElVRfC2ayMu1gkp2g95nsShrfN6pMSaY/ntm76
	 9O1q/GA5baKLyJzM68F2fjhXT3hN3EN39N8sWhn3ZL+5iZolGc2Ndr7nEyMPfnAJCZ
	 H8hx27mNDG2Tf2wAZ7ahV4PQN9b2vR+6Mjh3rSps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.7 309/309] nfsd: dont take fi_lock in nfsd_break_deleg_cb()
Date: Tue, 20 Feb 2024 21:57:48 +0100
Message-ID: <20240220205642.773771304@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 5ea9a7c5fe4149f165f0e3b624fe08df02b6c301 upstream.

A recent change to check_for_locks() changed it to take ->flc_lock while
holding ->fi_lock.  This creates a lock inversion (reported by lockdep)
because there is a case where ->fi_lock is taken while holding
->flc_lock.

->flc_lock is held across ->fl_lmops callbacks, and
nfsd_break_deleg_cb() is one of those and does take ->fi_lock.  However
it doesn't need to.

Prior to v4.17-rc1~110^2~22 ("nfsd: create a separate lease for each
delegation") nfsd_break_deleg_cb() would walk the ->fi_delegations list
and so needed the lock.  Since then it doesn't walk the list and doesn't
need the lock.

Two actions are performed under the lock.  One is to call
nfsd_break_one_deleg which calls nfsd4_run_cb().  These doesn't act on
the nfs4_file at all, so don't need the lock.

The other is to set ->fi_had_conflict which is in the nfs4_file.
This field is only ever set here (except when initialised to false)
so there is no possible problem will multiple threads racing when
setting it.

The field is tested twice in nfs4_set_delegation().  The first test does
not hold a lock and is documented as an opportunistic optimisation, so
it doesn't impose any need to hold ->fi_lock while setting
->fi_had_conflict.

The second test in nfs4_set_delegation() *is* make under ->fi_lock, so
removing the locking when ->fi_had_conflict is set could make a change.
The change could only be interesting if ->fi_had_conflict tested as
false even though nfsd_break_one_deleg() ran before ->fi_lock was
unlocked.  i.e. while hash_delegation_locked() was running.
As hash_delegation_lock() doesn't interact in any way with nfs4_run_cb()
there can be no importance to this interaction.

So this patch removes the locking from nfsd_break_one_deleg() and moves
the final test on ->fi_had_conflict out of the locked region to make it
clear that locking isn't important to the test.  It is still tested
*after* vfs_setlease() has succeeded.  This might be significant and as
vfs_setlease() takes ->flc_lock, and nfsd_break_one_deleg() is called
under ->flc_lock this "after" is a true ordering provided by a spinlock.

Fixes: edcf9725150e ("nfsd: fix RELEASE_LOCKOWNER")
Signed-off-by: NeilBrown <neilb@suse.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4945,10 +4945,8 @@ nfsd_break_deleg_cb(struct file_lock *fl
 	 */
 	fl->fl_break_time = 0;
 
-	spin_lock(&fp->fi_lock);
 	fp->fi_had_conflict = true;
 	nfsd_break_one_deleg(dp);
-	spin_unlock(&fp->fi_lock);
 	return false;
 }
 
@@ -5557,12 +5555,13 @@ nfs4_set_delegation(struct nfsd4_open *o
 	if (status)
 		goto out_unlock;
 
+	status = -EAGAIN;
+	if (fp->fi_had_conflict)
+		goto out_unlock;
+
 	spin_lock(&state_lock);
 	spin_lock(&fp->fi_lock);
-	if (fp->fi_had_conflict)
-		status = -EAGAIN;
-	else
-		status = hash_delegation_locked(dp, fp);
+	status = hash_delegation_locked(dp, fp);
 	spin_unlock(&fp->fi_lock);
 	spin_unlock(&state_lock);
 


