Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591082;
	b=SMd4OFAGcE0llwlkcOBZPLlZFj/RgqGHl/4+8Vhdq7BFZ1r04071qZz3TUGDThGmxKaS
	 4lEG+R57GOHusR/AdddePWBaAdY8OZ0dvbVVl9kqg9k9uvuRX5m4BFgvE8hDGG6lYczLs
	 CwCyxIV3cqaTCzmbOhGLrBKE7rD3WtG6SCORbNSHGDzuPE6X9srKef5AcYVQ/HRB8gSC1
	 SiR/5Jg9jw3hAaO6DLelC9lqiDt5nuUMf8xbFsBnYi0gTgVLIKBLei/KhdJVVHyTVmBxE
	 eQMGeJnoLyt+AIKPleUgAdwnlQMOiCqZH+p9FanGxDpcbYdvkrZ9mZliiIwMsdmPyMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591082;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QWLnPqgKsqC2UdH0WDFwfZL8Dd3r0pc2DP3gbLlZ5xc=;
	b=vf9fWhGjOjilMDqL1j7T1OF1EmgO3VVJdjQzDZdXvdPlANF0PLlAFh116q33yf4xioWT
	 HtoHSBWEVzL8gfl0Tz6fG3EWfYXoILn41r/QCkDLKvG3eo8JeNYuRA00CmV896A5Ljrij
	 KuA2dBoJAb9i3MIkG8rbrmpdst9oSJHb1wGzf/FZlDc6yk9eLD0C+gUqn2F2g51VvuYlK
	 qvq5wtbukxlvkTEtRLtL/iKCkv0M5H0MQcwsQXFcvrnoqWZy7WGZcw1E2BiV9bVyVHWXF
	 LwrJqKBR4rWtMg9r7C/k0Ls+YSjMqPDlBU2igZjZawcUNBViOi08M3ERerJd/iXaCTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="P/AF2XfU";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93E06073234;
	Fri, 13 Nov 2026 17:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P/AF2XfU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7527F1F000C6;
	Fri, 13 Nov 2026 17:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591082;
	bh=QWLnPqgKsqC2UdH0WDFwfZL8Dd3r0pc2DP3gbLlZ5xc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P/AF2XfU7qgY92OfPsHpaCTg0jd218L2hDlVotHgeIpTKAF5vSWdc8Wfc5QF+OEuq
	 g59XA5PSOmuLzIUQJ87/HE6hvC7JpTmIgJIXKv0FmbuCNb1Mq0S8upGEMu9qjJQjFm
	 BI8ikIrBOtCH+phJrNOGaMUebd/NGQ3c4tSu0JOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Chinner <dgc@kernel.org>,
	Daejun Park <daejun7.park@samsung.com>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 237/670] xfs: dont skip free extents of the longest length in a whole-AG FITRIM
Date: Fri, 13 Nov 2026 10:46:41 -0500
Message-ID: <20261113153819.887250463@linuxfoundation.org>
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

From: Daejun Park <daejun7.park@samsung.com>

[ Upstream commit 5745f4f10a1a16aa5bb020acc38afa33f2d5ff99 ]

Since commit a66d636385d6 ("xfs: fix fstrim offset calculations"), the
by-length walk of an AG in FITRIM starts with
xfs_alloc_lookup_ge(cur, 0, pagf_longest) and walks down. The lookup
lands on the longest free extent with the lowest block number. The
other free extents of that length sort after it and are never
discarded.

Start every by-length batch with xfs_alloc_lookup_le() at restart_bno.

Suggested-by: Dave Chinner <dgc@kernel.org>
Link: https://lore.kernel.org/r/ZgiJWxVcVwag0fIP@dread.disaster.area
Cc: stable@vger.kernel.org
Fixes: a66d636385d6 ("xfs: fix fstrim offset calculations")
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_discard.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 9ad0d653f266b..66c2f2fcec7bf 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -207,12 +207,12 @@ xfs_trim_gather_extents(
 		error = xfs_alloc_lookup_le(cur, tcur->start, 0, &i);
 		if (!error && !i)
 			error = xfs_alloc_lookup_ge(cur, tcur->start, 0, &i);
-	} else if (tcur->restart_bno == NULLAGBLOCK) {
-		/* first time through a by-len starts with max length */
-		cur = xfs_cntbt_init_cursor(mp, tp, agbp, pag);
-		error = xfs_alloc_lookup_ge(cur, 0, tcur->count, &i);
 	} else {
-		/* nth time through a by-len starts where we left off */
+		/*
+		 * A by-len walk starts at the last record of the longest
+		 * length (restart_bno is NULLAGBLOCK until the first batch
+		 * ends) and then where the previous batch stopped.
+		 */
 		cur = xfs_cntbt_init_cursor(mp, tp, agbp, pag);
 		error = xfs_alloc_lookup_le(cur, tcur->restart_bno,
 					    tcur->count, &i);
-- 
2.53.0



