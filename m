Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A21A6221FAC;
	Tue, 12 Aug 2025 17:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020779; cv=none; b=RuAchCQ6bSK9rgAY6kHMZgMHvuuTOvGVgiwRjdqYLnQK4pPyMdGe1s9YcPrj1JH70i+bGz1EKyxO/MQSqk6HNlwDba0M3CG0tK0c5Pj6ECrzrHSsVIuQ7edLyrPH+BRbfHTPyJB+wsW1eKwLKovwd54RNTXRpqVmncSSse/8Ujk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020779; c=relaxed/simple;
	bh=uUajokU1m+itCPKxCzsbduW+AmjeSkZnhpWjkMfdZtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QuYMhvSf7qr38Xx+ACQ/QjwPyHMBmLWAly5yv4I5uSEOwt5Fg8h8nJRV170IId5bcCQ4e+FQvuBRwhZ+tVNBYe8KEbgJg529tEfZPRdQ1HhU6alVKUPPmmpA8QqpWxN2HCTKYxV9qfPQNNXS8TXQ4nhxB07OhDeYwSwvtkVmI+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U9uAz1Yy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U9uAz1Yy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9B74C4CEF0;
	Tue, 12 Aug 2025 17:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020778;
	bh=uUajokU1m+itCPKxCzsbduW+AmjeSkZnhpWjkMfdZtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U9uAz1YyRUxp4Y5UwA1RQaidfKqfBlFtPZTAs4XBrRnCU8COKYtIMimKExp3vTPUL
	 ViXi8jHbz95ozMaQ8EhyVE80MRTZx9jUkPKwhvySxBRqp3si8gtfTQmZ/wrn/VJZz3
	 NCmxjrqnb7sarBGcQW6v8y5wALSxH+xMwM7W0WFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chunjie Zhu <chunjie.zhu@cloud.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 014/262] gfs2: No more self recovery
Date: Tue, 12 Aug 2025 19:26:42 +0200
Message-ID: <20250812172953.590357925@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit deb016c1669002e48c431d6fd32ea1c20ef41756 ]

When a node withdraws and it turns out that it is the only node that has
the filesystem mounted, gfs2 currently tries to replay the local journal
to bring the filesystem back into a consistent state.  Not only is that
a very bad idea, it has also never worked because gfs2_recover_func()
will refuse to do anything during a withdraw.

However, before even getting to this point, gfs2_recover_func()
dereferences sdp->sd_jdesc->jd_inode.  This was a use-after-free before
commit 04133b607a78 ("gfs2: Prevent double iput for journal on error")
and is a NULL pointer dereference since then.

Simply get rid of self recovery to fix that.

Fixes: 601ef0d52e96 ("gfs2: Force withdraw to replay journals and wait for it to finish")
Reported-by: Chunjie Zhu <chunjie.zhu@cloud.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/util.c | 31 +++++++++++--------------------
 1 file changed, 11 insertions(+), 20 deletions(-)

diff --git a/fs/gfs2/util.c b/fs/gfs2/util.c
index 268ff47b0396..fd921e07e12b 100644
--- a/fs/gfs2/util.c
+++ b/fs/gfs2/util.c
@@ -232,32 +232,23 @@ static void signal_our_withdraw(struct gfs2_sbd *sdp)
 	 */
 	ret = gfs2_glock_nq(&sdp->sd_live_gh);
 
+	gfs2_glock_put(live_gl); /* drop extra reference we acquired */
+	clear_bit(SDF_WITHDRAW_RECOVERY, &sdp->sd_flags);
+
 	/*
 	 * If we actually got the "live" lock in EX mode, there are no other
-	 * nodes available to replay our journal. So we try to replay it
-	 * ourselves. We hold the "live" glock to prevent other mounters
-	 * during recovery, then just dequeue it and reacquire it in our
-	 * normal SH mode. Just in case the problem that caused us to
-	 * withdraw prevents us from recovering our journal (e.g. io errors
-	 * and such) we still check if the journal is clean before proceeding
-	 * but we may wait forever until another mounter does the recovery.
+	 * nodes available to replay our journal.
 	 */
 	if (ret == 0) {
-		fs_warn(sdp, "No other mounters found. Trying to recover our "
-			"own journal jid %d.\n", sdp->sd_lockstruct.ls_jid);
-		if (gfs2_recover_journal(sdp->sd_jdesc, 1))
-			fs_warn(sdp, "Unable to recover our journal jid %d.\n",
-				sdp->sd_lockstruct.ls_jid);
-		gfs2_glock_dq_wait(&sdp->sd_live_gh);
-		gfs2_holder_reinit(LM_ST_SHARED,
-				   LM_FLAG_NOEXP | GL_EXACT | GL_NOPID,
-				   &sdp->sd_live_gh);
-		gfs2_glock_nq(&sdp->sd_live_gh);
+		fs_warn(sdp, "No other mounters found.\n");
+		/*
+		 * We are about to release the lockspace.  By keeping live_gl
+		 * locked here, we ensure that the next mounter coming along
+		 * will be a "first" mounter which will perform recovery.
+		 */
+		goto skip_recovery;
 	}
 
-	gfs2_glock_put(live_gl); /* drop extra reference we acquired */
-	clear_bit(SDF_WITHDRAW_RECOVERY, &sdp->sd_flags);
-
 	/*
 	 * At this point our journal is evicted, so we need to get a new inode
 	 * for it. Once done, we need to call gfs2_find_jhead which
-- 
2.39.5



