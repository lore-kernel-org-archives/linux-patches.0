Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590880;
	b=ZxfauPmsK7tO5jrNDeKfgfexaO+BaJmgHw9mhY85EcdoCESP2W6UFiES7qMy0F983IFc
	 yPDwfGFObiVDmFMPxo7wfufLMn7VwqRR2ldkbh8ll7kAlIkQPlgoA4Uh+bwL9tM2C6/Cm
	 9XUU0+u+ljzh9fDL+noAQz689lCq3o4qWioaC97GUVDaqTdbybt84sqMQJthcowVRriiu
	 TwRIoFZEl3nktpKx9zx4xdEjLnT26xtvkIRmekslBPbLsY6rLLhxWJQ2+w7lJqdtBdQS6
	 RxeDd1BzbZte8vBh0RLkCT6glUcDyFFf8erI32snmRSVI2I5PVEDiFgEyqCLT8eW9BA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590880;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EV0t2kR+bgy19pc7XeutJDN0Ge1F/UjWKPG6CVXdSx4=;
	b=Kjg5mK3wwhcUPQXoaE1tptpboFoGZkd0XhplUdwX9FfLTwZV8cu4CTnBNi1x+GObkpXP
	 Dss3caB1R469RHd1eP6llvBomXk/2Fx7XBWyG2ZSX/LxQrqaDmcuadGWjPqz84/aef3uI
	 9m2sSP+hHH2awCKzdpcOk+v1CYGYFpzEAdPXZNkVfvQ7PMIRix/CFw/MbQyWY0TP6D9NN
	 e3Ro2gPwwerxivnGwwYH58S845n/g5kil3Ev29m1wiZzOYBJjD3Fd09W6dz6xGhRI5ICC
	 4bDRf81Zodwa1sZOAeJlv0+7/A4gcsIDlqLS1xbmjhacW1GyQeEnsyyOOJOkkRzNM4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O6WqjGf0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A2C606D4BA;
	Fri, 13 Nov 2026 17:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O6WqjGf0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA85A1F000C4;
	Fri, 13 Nov 2026 17:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590880;
	bh=EV0t2kR+bgy19pc7XeutJDN0Ge1F/UjWKPG6CVXdSx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O6WqjGf0XshimEATPnCk8dqVStJJNA/KMJ7gfJNKzPqLrCtDg5V78TDEgBm1woNHm
	 yCCUm8MahRRQm7gMKWTdZcb7X2se0Kjk5wMA6sh2pHsUWbESVpjYuufrkgdIU1dZlR
	 Or5GI1lUlyy8HXa5r0t5aux3ylRc6oUxSfZzXJus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 075/670] xfs: forcibly reset quota timers when upgrading to bigtime during repair
Date: Fri, 13 Nov 2026 10:43:59 -0500
Message-ID: <20261113153814.103440156@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit 780212c8d8105eadb5f56b4c7aafb94937755582 ]

If we decide to upgrade a dquot to BIGTIME as part of repairing it, we
should zero out the timer fields so that they are re-evaluated and reset
in bigtime format instead of letting through whatever was in there
before.

Cc: stable@vger.kernel.org # v6.8
Fixes: a5b91555403e3a ("xfs: repair quotas")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/quota_repair.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/quota_repair.c b/fs/xfs/scrub/quota_repair.c
index 368be503334fa..0def7a1b366a8 100644
--- a/fs/xfs/scrub/quota_repair.c
+++ b/fs/xfs/scrub/quota_repair.c
@@ -348,6 +348,8 @@ xrep_quota_block(
 	bp->b_ops = &xfs_dquot_buf_ops;
 	for (i = 0; i < qi->qi_dqperchunk; i++, dqblk++) {
 		struct xfs_disk_dquot	*ddq = &dqblk->dd_diskdq;
+		bool			was_bigtime =
+				!!(ddq->d_type & XFS_DQTYPE_BIGTIME);
 
 		trace_xrep_disk_dquot(sc->mp, dqtype, id + i);
 
@@ -356,8 +358,21 @@ xrep_quota_block(
 		ddq->d_type = dqtype;
 		ddq->d_id = cpu_to_be32(id + i);
 
-		if (xfs_has_bigtime(sc->mp) && ddq->d_id)
+		if (xfs_has_bigtime(sc->mp) && ddq->d_id) {
+			/*
+			 * If something was broken with this dquot and it was a
+			 * non-bigtime dquot, we'll grant everyone a fresh
+			 * grace period by zeroing the timer field rather than
+			 * try to interpret what might be garbage.
+			 */
+			if (!was_bigtime) {
+				ddq->d_btimer = 0;
+				ddq->d_itimer = 0;
+				ddq->d_rtbtimer = 0;
+			}
+
 			ddq->d_type |= XFS_DQTYPE_BIGTIME;
+		}
 
 		xrep_quota_fix_timer(sc->mp, ddq, ddq->d_blk_softlimit,
 				ddq->d_bcount, &ddq->d_btimer,
-- 
2.53.0



