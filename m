Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059999;
	b=T0izHcfRw50G6e6SDnvE7EfmcD2UAx529Rmhrmdc6kynhfx4Q/Hpsw75ZUSGPwwmPRUq
	 7BAYojczm/20VqOHf82rakddp8sf8WuBos0tVfj8f19RgD8CEdzw7gVlFkmIYsH2WA1B+
	 tBThrgmBCY9IYbBe6r8UeZ52w0jNaUKfvLhYq6FqK5kuyUCK69R2sFWrCpPRl8yDQdR40
	 0WZ5Jd6Ob0Kaip9F50/rd30DJ/iN/nCkbo4l5TnSzrBUg15s/o1PeDLHmX9ZFwNvexGgK
	 9eBsaltBwh2KkREkh4FwXtY3aooa78kkwYMYIej8yfeOIDrn1l63bPGdSWm4zasD7uA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059999;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Am/EXtT7sPW0Co6+zzuuRlAQ9bC4GTBKBoWNFcBFehY=;
	b=T+I6a6EACGHIR1j6Mo+bWFNjpttAuNz4i8O2quy2YBoW6KWWifSJOnys+0Wv9dFTv5u7
	 XmuJ5hCxzqxw7QL1NO6AsN/q1YIdrlgZEyYE+fan/a0jCUf5NjBMAWQedooL4oHPcIxTw
	 hYMj1IQGi97BgxRe3tTNlT8+CNpf2bzmsN/Ph6WyuZcPhv0mcSocTMoPIUXho6g1ltGzG
	 R3+ZJAf1Ow1SUQ+lQ5vxqXx6T28GWjO3R5zXFZoBayofIEUfdqWXCjHWuQ3l1dRzR2Yyk
	 SqJeVAgp16Lkdcy37mjWVrx+g21vfl/R/KFtyjt+U4Kp4tJPcCahaeZJZv4iNoOiQmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vKeKWkXq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A943D606A325;
	Thu, 19 Nov 2026 03:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vKeKWkXq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05CAB1F000C4;
	Thu, 19 Nov 2026 03:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059999;
	bh=Am/EXtT7sPW0Co6+zzuuRlAQ9bC4GTBKBoWNFcBFehY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vKeKWkXq/cEGLmIcM6Y7J1FGpMEmveLuGho6imaOeBYSP8rX0xqK4QHPXxbbzhJuj
	 /xF6WwjLUleijbYsaCOlrbE+sysiLZjBtXO3N2MuxfdLDipmbFeNNWZkcKfjvZ7J7B
	 50+mvOjF3u+pewfVXBkIaZuQ6Jik98L04I/s5hbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Chinner <dgc@kernel.org>,
	Daejun Park <daejun7.park@samsung.com>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1042/1848] xfs: dont skip free extents of the longest length in a whole-AG FITRIM
Date: Wed, 18 Nov 2026 15:51:20 +0100
Message-ID: <20261118150000.956709175@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
[ sashal: adapted the change to xfs_trim_extents(), using agf_longest directly instead of batched trim cursor state ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_discard.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index f979d0d7e6cd6..fbb88fb3061a0 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -53,9 +53,10 @@ xfs_trim_extents(
 	cur = xfs_allocbt_init_cursor(mp, NULL, agbp, agno, XFS_BTNUM_CNT);
 
 	/*
-	 * Look up the longest btree in the AGF and start with it.
+	 * Start at the last record of the longest length.
 	 */
-	error = xfs_alloc_lookup_ge(cur, 0, be32_to_cpu(agf->agf_longest), &i);
+	error = xfs_alloc_lookup_le(cur, NULLAGBLOCK,
+				    be32_to_cpu(agf->agf_longest), &i);
 	if (error)
 		goto out_del_cursor;
 
-- 
2.53.0



