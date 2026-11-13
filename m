Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590270;
	b=QAyXphUqv9iM3owLXoqJMxbpz0LpfkxZ2KZNG2Qs8XGFf4RoKzeb5v+SaGkzI3EwWh/9
	 4bsIeuyufvQpsqkVKi4fQ7F8BNBOA10E43TGqL9liFOsG0t2HoyoJ5dcJywMMa+HWrGD4
	 qG+3ktm0VtT0UqLfBy/vdOFvqw9MTbS39EFGsMs0zJi7zwYWJf1Te+cXbmnxjErNJZmyf
	 NUbPK50Rf6944mW4UExW8H0D4fq14GClcjdLcUjX2phEVS6Vg2w5BupW+fQRVfSwiIUni
	 hWUJlvE0VM/RBmKoUGh7PdOMUOAjJT3Py0xDHYTC2Kk47c89Hkhs5GGkmE8GYk6e4mA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590270;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jw7fSoZX+So6GAlG6bn6QQpPnp5CV0d7a3GVLbmstGo=;
	b=qr0IUTmhBXzZ3bRbKLaQJDIV7GTrcIcKftBiBq9yIpPieen8aepu2WJenRYi1tmN6NJG
	 OBYEIxYDz4oS4YlIzNhPE77jeZ1A0tnRWUDQeklLYSoaCOtCALvIL53UeLoF0H6PWEwfo
	 HKYYUai7nkSCuv3odjbauyInzPRL1BvHBdxVRx/8Qo+euXCOn0xQYTrjVwv77WE5D40ER
	 4dOpTH+prLkPmL5qma4/azrAmHOzLkJvraVT3owV2z2ZSv1voA6ybrAe7RoYKGPczffiV
	 v+koGLVHEaro39aaR1SQYlGaSbS+3K0kw39Dx+sSSLZwj1bPWH/VMHnWdP6hZktR3AA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HfEamcyT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56FDB60776C8;
	Fri, 13 Nov 2026 17:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HfEamcyT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0258E1F000C4;
	Fri, 13 Nov 2026 17:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590270;
	bh=jw7fSoZX+So6GAlG6bn6QQpPnp5CV0d7a3GVLbmstGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HfEamcyTpn+xp+pOIq5bgE2yg8GGeq7kRS2oZR+hVT0mm8HfiX3P6AQGtANoyjfLV
	 7tMVL9gqxq7OODnV3iiISjr5k1cycsspF5Fv4pMxO2GhUXW6+BHasoo1AyDm9gRIPP
	 lGZm36W4pmkPisgVYR73TWCQRQ0gErwmG3YcdPLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daejun Park <daejun7.park@samsung.com>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 261/686] xfs: dont skip free extents in later batches of a whole-AG FITRIM
Date: Fri, 13 Nov 2026 10:46:34 -0500
Message-ID: <20261113153829.871608046@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daejun Park <daejun7.park@samsung.com>

[ Upstream commit 595e67d7261673d03c96950ffbb2e545c00376ed ]

A whole-device FITRIM walks every AG but the last by length, in
batches. xfs_trim_gather_extents() saves the record to restart from in
tcur->start. But tcur->start is also the start of the range to trim.
Later batches therefore never discard the free extents below that
block.

Save the restart record in a new restart_bno field.

Cc: stable@vger.kernel.org # v6.10
Fixes: b0ffe661fab4 ("xfs: fix performance problems when fstrimming a subset of a fragmented AG")
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_discard.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 6917de8321915..b866329c7a28d 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -166,6 +166,8 @@ struct xfs_trim_cur {
 	xfs_agblock_t	end;
 	xfs_extlen_t	minlen;
 	bool		by_bno;
+	/* restart point (with count) for the by-length walk */
+	xfs_agblock_t	restart_bno;
 };
 
 static int
@@ -209,14 +211,15 @@ xfs_trim_gather_extents(
 		error = xfs_alloc_lookup_le(cur, tcur->start, 0, &i);
 		if (!error && !i)
 			error = xfs_alloc_lookup_ge(cur, tcur->start, 0, &i);
-	} else if (tcur->start == 0) {
+	} else if (tcur->restart_bno == NULLAGBLOCK) {
 		/* first time through a by-len starts with max length */
 		cur = xfs_cntbt_init_cursor(mp, tp, agbp, pag);
 		error = xfs_alloc_lookup_ge(cur, 0, tcur->count, &i);
 	} else {
 		/* nth time through a by-len starts where we left off */
 		cur = xfs_cntbt_init_cursor(mp, tp, agbp, pag);
-		error = xfs_alloc_lookup_le(cur, tcur->start, tcur->count, &i);
+		error = xfs_alloc_lookup_le(cur, tcur->restart_bno,
+					    tcur->count, &i);
 	}
 	if (error)
 		goto out_del_cursor;
@@ -246,9 +249,15 @@ xfs_trim_gather_extents(
 		if (--batch <= 0) {
 			/*
 			 * Update the cursor to point at this extent so we
-			 * restart the next batch from this extent.
+			 * restart the next batch from this extent. The
+			 * by-length walk does not visit extents in block
+			 * order, so it must keep the start of the range and
+			 * restart from restart_bno instead.
 			 */
-			tcur->start = fbno;
+			if (tcur->by_bno)
+				tcur->start = fbno;
+			else
+				tcur->restart_bno = fbno;
 			tcur->count = flen;
 			break;
 		}
@@ -351,6 +360,7 @@ xfs_trim_perag_extents(
 		.start		= start,
 		.end		= end,
 		.minlen		= minlen,
+		.restart_bno	= NULLAGBLOCK,
 	};
 	int			error = 0;
 
-- 
2.53.0



