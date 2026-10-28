Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209264;
	b=s/2/QAsEvjtOc3qVK/e96b6PLpqNN72G3MpfKWVaMnD14dUFPk4/Nh8P8SoSaKRqNBIJ
	 UBtMSWBZC0Ro5vl/h3b0gWarTmKSiOU6eV4I4LFqgURG1vBnHigSQ6p5TTu9WlUeLUVIt
	 XV0IMz51pqj3JFcgCnCTkEMJyzayB39Q3FuKdCZD4hreSPFMhQXwi8za9II4ndxazHy9b
	 R62fPRcr/kIds9q5dqSkpXUOBjNRX4h/jhUPOBywBVdv2i2kMurolvMCLJ+6JPWokFeeD
	 gE0d8jIL4V82aEbKCArvkdXRE3grrxyjexL4ZZZWdR0tD4+jZiNmZXcbpGDNyMpSZcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209264;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C/aa+FF1jGs2HOhcHrqlXpLUUSzGxX4M+l6BNYeBlyY=;
	b=bapESdOVfNM92vovdP9oapga+5pRjrnZpaiIcCp/zL6YUg0JdzWv7SMQzmD8Ya3M/4vq
	 mO2rU48Er8WITi5gUQTy8DknVGVSxQEjRvK1VGLE5P4kZMhbW5VjhUUblVE6l4rW4RLxK
	 1NrFE1MqRzg/AB7ydHkHX1v0+rlZU5IuAspxG/1bAYpo3iBvtVTb9Ti4fD8W7zuAGl+Vv
	 1W7tWs+BMeAT7juus2ZWI+tlBaDj5RR3K8qh0COuhUGZc3kKas2qPAWmESP0mRCnAx22H
	 T3j0oCsMfLP8+vBvefPvVcfs6P9h+xFgM3Iw1w58wFJar88LQ7D0toi4ZOD348ExBig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NpPxpCfj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4548A606A325;
	Wed, 28 Oct 2026 17:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NpPxpCfj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 950471F01825;
	Wed, 28 Oct 2026 17:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209264;
	bh=C/aa+FF1jGs2HOhcHrqlXpLUUSzGxX4M+l6BNYeBlyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NpPxpCfjjr6h19TC+sD+xz+Gv3oFIFKJnzrWBYo6AM1cELbgjwpVspisgQV7wnSR4
	 ZBiiVla1xKu5Jp0zrjjcniI1GPVSdFIoXBC1uNcCPSA9DAN64n+tqi2AXJyMO+T/Ze
	 uqRlPRqaWX8SUGlX9diO++TDfItfxoFUtZm/4Frw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Chinner <dchinner@redhat.com>,
	Brian Foster <bfoster@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Siddh Raman Pant <siddh.raman.pant@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 409/516] xfs: dont nest icloglock inside ic_callback_lock
Date: Wed, 28 Oct 2026 17:59:21 +0100
Message-ID: <20261028170013.173948804@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 6be001021f0b307c8c1544e8b3ac87de20d711de ]

It's completely unnecessary because callbacks are added to iclogs
without holding the icloglock, hence no amount of ordering between
the icloglock and ic_callback_lock will order the removal of
callbacks from the iclog.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Stable-dep-of: 7b5f775be14a ("xfs: fix unmount hang with unflushable inodes stuck in the AIL")

5.10:

Fixed conflict due to the following missing commit:
	956f6daa84bf ("xfs: add iclog state trace events")

Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_log.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 22d7d74231d42..2b83b2b7786bc 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2721,10 +2721,7 @@ static void
 xlog_state_do_iclog_callbacks(
 	struct xlog		*log,
 	struct xlog_in_core	*iclog)
-		__releases(&log->l_icloglock)
-		__acquires(&log->l_icloglock)
 {
-	spin_unlock(&log->l_icloglock);
 	spin_lock(&iclog->ic_callback_lock);
 	while (!list_empty(&iclog->ic_callbacks)) {
 		LIST_HEAD(tmp);
@@ -2736,12 +2733,6 @@ xlog_state_do_iclog_callbacks(
 		spin_lock(&iclog->ic_callback_lock);
 	}
 
-	/*
-	 * Pick up the icloglock while still holding the callback lock so we
-	 * serialise against anyone trying to add more callbacks to this iclog
-	 * now we've finished processing.
-	 */
-	spin_lock(&log->l_icloglock);
 	spin_unlock(&iclog->ic_callback_lock);
 }
 
@@ -2782,13 +2773,12 @@ xlog_state_do_callback(
 				iclog = iclog->ic_next;
 				continue;
 			}
+			spin_unlock(&log->l_icloglock);
 
-			/*
-			 * Running callbacks will drop the icloglock which means
-			 * we'll have to run at least one more complete loop.
-			 */
-			cycled_icloglock = true;
 			xlog_state_do_iclog_callbacks(log, iclog);
+			cycled_icloglock = true;
+
+			spin_lock(&log->l_icloglock);
 			if (XLOG_FORCED_SHUTDOWN(log))
 				wake_up_all(&iclog->ic_force_wait);
 			else
-- 
2.53.0



