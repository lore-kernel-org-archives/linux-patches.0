Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D444187331;
	Fri, 27 Sep 2024 12:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440397; cv=none; b=WdvAgM4A5JCpecvIHvCNYLfIc18XHu5+/VvWTfr5UwUsnLxze7N0slkrqmqq4TLJ3RU7N9sGX/9wSrqATzQs0e/ZWAn3AkJG16K/aqDQbKXBma1QfMXSMJm6gnzj136NNgrd8BDrCEYawId7ciVNSImMjqFL3Tz4Wt7V9RtsITI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440397; c=relaxed/simple;
	bh=T9sXm3hgEd+Ijftop4+LX1GKj1HEGneKS9irEqtf6nA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uIa9eeKSZvV1TkqILDy7aSPOkrT6TpNSQScfJXBICsPpuVay8WjUe9hkzl3LVLAeWv2kcAmDOszJhKycqHTSdKMs6DVBDjh86YFTecDG/50j6vqlQJHqaCLggieZF3TvosCDUIJyK++8V2FfKtLewyt1OKwXXc4wwNlXeFTMzPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LkWDBtpT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LkWDBtpT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D341C4CEC4;
	Fri, 27 Sep 2024 12:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440397;
	bh=T9sXm3hgEd+Ijftop4+LX1GKj1HEGneKS9irEqtf6nA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LkWDBtpTHIknnJvk19KV06Kc2PXrAqE23/E23fxBcNg1K5PISFl4HbMK84+aGMJmH
	 vUcPvCNtKQskG5yCQsQ9TOdQAwuhd1Sfsj2g7vafuPvM2iXjPpQdfq2KU4CPl11Mqi
	 5ITiwPUK7ObpNCsrB5grIPBAWkxtLOSSO+q9PdFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+912776840162c13db1a3@syzkaller.appspotmail.com,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 6.1 32/73] xfs: dquot shrinker doesnt check for XFS_DQFLAG_FREEING
Date: Fri, 27 Sep 2024 14:23:43 +0200
Message-ID: <20240927121721.202973508@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.897851549@linuxfoundation.org>
References: <20240927121719.897851549@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 52f31ed228212ba572c44e15e818a3a5c74122c0 ]

Resulting in a UAF if the shrinker races with some other dquot
freeing mechanism that sets XFS_DQFLAG_FREEING before the dquot is
removed from the LRU. This can occur if a dquot purge races with
drop_caches.

Reported-by: syzbot+912776840162c13db1a3@syzkaller.appspotmail.com
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_qm.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -423,6 +423,14 @@ xfs_qm_dquot_isolate(
 		goto out_miss_busy;
 
 	/*
+	 * If something else is freeing this dquot and hasn't yet removed it
+	 * from the LRU, leave it for the freeing task to complete the freeing
+	 * process rather than risk it being free from under us here.
+	 */
+	if (dqp->q_flags & XFS_DQFLAG_FREEING)
+		goto out_miss_unlock;
+
+	/*
 	 * This dquot has acquired a reference in the meantime remove it from
 	 * the freelist and try again.
 	 */
@@ -441,10 +449,8 @@ xfs_qm_dquot_isolate(
 	 * skip it so there is time for the IO to complete before we try to
 	 * reclaim it again on the next LRU pass.
 	 */
-	if (!xfs_dqflock_nowait(dqp)) {
-		xfs_dqunlock(dqp);
-		goto out_miss_busy;
-	}
+	if (!xfs_dqflock_nowait(dqp))
+		goto out_miss_unlock;
 
 	if (XFS_DQ_IS_DIRTY(dqp)) {
 		struct xfs_buf	*bp = NULL;
@@ -478,6 +484,8 @@ xfs_qm_dquot_isolate(
 	XFS_STATS_INC(dqp->q_mount, xs_qm_dqreclaims);
 	return LRU_REMOVED;
 
+out_miss_unlock:
+	xfs_dqunlock(dqp);
 out_miss_busy:
 	trace_xfs_dqreclaim_busy(dqp);
 	XFS_STATS_INC(dqp->q_mount, xs_qm_dqreclaim_misses);


