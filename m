Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 232B37FBC8;
	Mon,  8 Apr 2024 14:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584868; cv=none; b=WlObbBHT2PzTfTToOvrFWswD+wYuO6G2HvhKJVKoinr21S/e8NjHLzCYrulphmI1JNGZRUE+8cY1wPz/2/4Q5eJ179fxSb+ilnKyKWqleobaNJBoBFWyV+S3fA5o5wyoJYJ4O2E4/uG3JqmsOTludJR4gTQJ9+37bmWsEQqoLRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584868; c=relaxed/simple;
	bh=0yRo/eMJRV+dTuuqs6ir0VM/Qo0W/oM+SgYlb4+QkNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OjOXJXQmMO8DP24JFBdtHtdXaifVUMEUw4Vz9jBT0ZmR+WKKBtafDc5PUESZvI0pf/ZpYvDT38V6t1o46z4ZAVyAWtXICBcp3lZ4dOKWUERYmN5dgl2RdhqM2/dszW/Dvmi4kwSlZtamu9PFAi/oMc37n9p4TwNO1zsLCySVhvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a2tk2BzK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a2tk2BzK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FCBBC433C7;
	Mon,  8 Apr 2024 14:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584868;
	bh=0yRo/eMJRV+dTuuqs6ir0VM/Qo0W/oM+SgYlb4+QkNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a2tk2BzKyIZ67SC8EXhYXlewgdyv6B+Jd/zEXvENFcaBAioFvP7ccS7v2eINRCG8v
	 310Nmkri+mcVQ5aOvSeaP5hYHzlje7FtarP/tp4CZYSQLbGkdVB0yANF9659n6lG5q
	 9e+z5+sLx9NDZZ9abxIpPanTyaCwNitLp0MeL+ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 554/690] nfsd: dont take fi_lock in nfsd_break_deleg_cb()
Date: Mon,  8 Apr 2024 14:57:00 +0200
Message-ID: <20240408125419.683589300@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

From: NeilBrown <neilb@suse.de>

[ Upstream commit 5ea9a7c5fe4149f165f0e3b624fe08df02b6c301 ]

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
---
 fs/nfsd/nfs4state.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 64a8567ea4c40..0f1ece95bd642 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4950,10 +4950,8 @@ nfsd_break_deleg_cb(struct file_lock *fl)
 	 */
 	fl->fl_break_time = 0;
 
-	spin_lock(&fp->fi_lock);
 	fp->fi_had_conflict = true;
 	nfsd_break_one_deleg(dp);
-	spin_unlock(&fp->fi_lock);
 	return false;
 }
 
@@ -5541,12 +5539,13 @@ nfs4_set_delegation(struct nfsd4_open *open, struct nfs4_ol_stateid *stp,
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
 
-- 
2.43.0



