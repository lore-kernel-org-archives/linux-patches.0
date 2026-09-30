Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9662251812B;
	Wed, 30 Sep 2026 17:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787999; cv=none; b=jI89UxlQZTvy87ENYr0O8dIfL3pexGOBsiw8AKk/ly4JK0zt9bFaOo7RWRPuWuQGhG9qKH7sxpz80JHulvPXIL+WnmxdAIRX8aAPKpHZE4SrRWdMNmewTY3Iz16/UZ8W2v24sSvdspl0mF77et3wSIpXWKYjDHLt4RY76NFmP4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787999; c=relaxed/simple;
	bh=GddsWltmR3+VRq3kFt5rqXrT9h9cGLspLY73ST1SylU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BQyjSf66LKj5f2OYMCZnkhEokAfSNedDS9JLPnC54zIxop3PnrM3FQXJaZZrvw9GKMRp7PIS6OTY9i2ksQaI49+a94/1cBX6UbvVt34GWRU/E6AMk86ASU5rBc534JAlb4lEF8yK9Adk0Z5RxTNHE8DUPt9z1Bivcq+JyFqDFtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KRoNYSqn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KRoNYSqn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE591F000FF;
	Wed, 30 Sep 2026 17:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787998;
	bh=UDfDyulyQe8HF9NuTJqxvkTR+xAk80KbE1CPcSX5GeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KRoNYSqnQoF51YGCP5S3mt7qsAN5U7QjI/sdKQYzmW7HuJoHh9JE6dcxUBiJxusMx
	 saPxEI8M8h89Ibrj+ZNpLFp3g1vawi7PFC7tlO3eB8MYDspKIo7mu3k/rzG3+GkdJy
	 uAlcmm0RYiL0a5QAlLaMpyGQ+e+0CWTwjm71yhuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 427/457] xfs: call xfs_dquot_set_prealloc_limits if we installed default rtb limits
Date: Wed, 30 Sep 2026 17:28:52 +0200
Message-ID: <20260930152355.204911304@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 065f3ce5936e68da75f3dc18201d290073d78f3c upstream.

Now that we have quotas for the realtime volume, we also have
precomputed watermark limits for the realtime block counts.  These
precomputations should be done any time we change the rtb limits, which
means that xfs_qm_adjust_dqlimits needs to ensure that if we installed
a default rtb limit.

Cc: stable@vger.kernel.org # v6.13
Fixes: 5dd70852b03901 ("xfs: create quota preallocation watermarks for realtime quota")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_dquot.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -139,10 +139,14 @@ xfs_qm_adjust_dqlimits(
 		dq->q_ino.softlimit = defq->ino.soft;
 	if (!dq->q_ino.hardlimit)
 		dq->q_ino.hardlimit = defq->ino.hard;
-	if (!dq->q_rtb.softlimit)
+	if (!dq->q_rtb.softlimit) {
 		dq->q_rtb.softlimit = defq->rtb.soft;
-	if (!dq->q_rtb.hardlimit)
+		prealloc = 1;
+	}
+	if (!dq->q_rtb.hardlimit) {
 		dq->q_rtb.hardlimit = defq->rtb.hard;
+		prealloc = 1;
+	}
 
 	if (prealloc)
 		xfs_dquot_set_prealloc_limits(dq);


