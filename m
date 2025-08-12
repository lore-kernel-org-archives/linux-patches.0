Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC691C8621;
	Tue, 12 Aug 2025 18:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021966; cv=none; b=d9ULKBgZTiwfloiH8/izuCFATQk/VXwPcoh6jOHp2++fsVGzH5CHUznX2r/fXb5VRs2MSyhU1CG6U9i0GZXahmPlOZ9gWLHZclraIP3JDnx1TDTUdJBNJ/kLV2Khja1PsM7emIxH4Hw1QktOxM1kARPIvTQC0OvGp7JNQr+keow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021966; c=relaxed/simple;
	bh=M6J4Wh061FG8cxDmksfkNaiEHI7jKNAOqaomwVgPd+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rB1Q33ivT4FGkd9lhKwamrWGeY5Wzz6+GgywVk1nemVh1KcqMOIbzBAi9RhyGttQpWGFS7c8gz31RlMJzT+r8YUQmQCPXsuwvSY0RgmF5+SsPybUL14zok28OxTFIHU1P5L7npKS0miKZgZU8GfO8f5OxqAufj5DQJfjzSUTQFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eEo/jvKP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eEo/jvKP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F069FC4CEF0;
	Tue, 12 Aug 2025 18:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021966;
	bh=M6J4Wh061FG8cxDmksfkNaiEHI7jKNAOqaomwVgPd+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eEo/jvKPXg50my82wzfU2fua+qXpUEibU5XDSASmZadwTfGJhD1HtqazfbNAslHxY
	 O9q33PuBjoOWtMYF9/UqxHor2gXPl5runy/IJqFYbGSDgwlq96zCnFUWosZKDknVXt
	 EyVsfrH/9xPMQvZZtBjt1tgQAqd3Sqq8dwxezFPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chunjie Zhu <chunjie.zhu@cloud.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 016/369] gfs2: No more self recovery
Date: Tue, 12 Aug 2025 19:25:13 +0200
Message-ID: <20250812173015.350966370@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 13be8d1d228b..ee198a261d4f 100644
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



