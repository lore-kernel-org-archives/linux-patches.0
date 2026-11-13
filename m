Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591081;
	b=jXvd6F8C0P1aBhDCqJyiUWfBrHQGQ6YAj9dH/oUIdfD1BXHkHcvVJozQKO4R7kWlA4oY
	 vz+22prcw/1+IaXD0Sk9zuBLs+0IgzKGJoHVzk2CvQLhL4lm5aXysygqvYBFedP1a9xqz
	 gFvArMwAytR+gyfzY2hG0oSq0/n8NE4A8ciETEGNor0YFA1mCDJ2JRhTWol63o/I366yV
	 PWKudFiCxkYOIvTa8bEBTi0Hhb3j5bV82Cg5lRp4ZyVFrW5P39f3hvM9HoXOaswaBvZBi
	 opPQTN2k56HOgXQ+zoPnHVFLEi/3uiu0MnoqXHVeGBaRbpOpvF94E743iXfDwKEsNLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591081;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PSqJgtXyMPD9raQ6Ztm7T/w5QuNddYxpoQaPDVBIUks=;
	b=ZOnzBFCGjyXJ7itZMS4rzshIDNvTrdBh0+p0YBhRzCSIoEa/gftxm9qTQCiCwRcZmGCB
	 dKM+2+MueO0pMC2E1FBzy0M6WI8fAANb/fCoC3V+tELdoc4/FQHXWFAUJw0HzNb0+vLzo
	 7XAtJTBdP5B6Mr1e7AMg2qHMtLy4bEtJQ0D7ee5mSRqeZh0b9YS4Dtv+mt9cEXslPQb9y
	 D5AR1FRBt54vvmaDSZMy09k2gGbPEIs6ZVxswLUqm6LAdWPnhSbJntvXPSsTQCJFKVo5B
	 THucWeIrpmHgk+P6Gx5qgE/aZJUiO2klRyn12Xm4THFLihfUMKQ+i4kSKFiw/qovRpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QCkw1Ju6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 900F46073225;
	Fri, 13 Nov 2026 17:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QCkw1Ju6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C4C81F000C4;
	Fri, 13 Nov 2026 17:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591081;
	bh=PSqJgtXyMPD9raQ6Ztm7T/w5QuNddYxpoQaPDVBIUks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QCkw1Ju61ErAYzoFu+zwwzL8jzIpU2YCKB2CA82TDfI1f2zY3xmLpkpA++adOfD14
	 NsjifFYlT8uWZqaFRLFNusD/JN4tqxGIjk+XIIjecg20YrJ1F3vDmFxOyO5rIrW4kK
	 ZQStDLG5ZOlZZ/53gAse/TbA1+jT+flH8K95taMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daejun Park <daejun7.park@samsung.com>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 236/670] xfs: dont skip free extents in later batches of a whole-AG FITRIM
Date: Fri, 13 Nov 2026 10:46:40 -0500
Message-ID: <20261113153819.856637903@linuxfoundation.org>
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
index 0b343776da8c3..9ad0d653f266b 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -160,6 +160,8 @@ struct xfs_trim_cur {
 	xfs_agblock_t	end;
 	xfs_extlen_t	minlen;
 	bool		by_bno;
+	/* restart point (with count) for the by-length walk */
+	xfs_agblock_t	restart_bno;
 };
 
 static int
@@ -205,14 +207,15 @@ xfs_trim_gather_extents(
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
@@ -242,9 +245,15 @@ xfs_trim_gather_extents(
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
@@ -347,6 +356,7 @@ xfs_trim_perag_extents(
 		.start		= start,
 		.end		= end,
 		.minlen		= minlen,
+		.restart_bno	= NULLAGBLOCK,
 	};
 	int			error = 0;
 
-- 
2.53.0



