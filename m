Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828927;
	b=rRewXzTwATyP4B2IkOEeQN1lQxzq1L8eFfiPVUmaUqe34/RL2CFRLdTJ5oI8hRwtFKMK
	 89wdD5zmBwuCvQPxYmlThpnJ9jkqP2QLf/ZftGnw1lKQpY/zaxAysGKWr/4BMaIcLLbQZ
	 eLjtjbReIlAhnm/SSjms0N2aQZUs0vfLHYHoyfOhkRNlIIA1jN07keegYzhDRNV9p0Iam
	 QBmLDoR0EkGQzKGluChNaz1tKcr+7Xc/mxGz7LxVdmCEQvdO5syg0cmlsHakax1IFKE00
	 ZLnKteN04D3qdU/Bx9lH/xU/fIJqORyME/lZaFOB/4EK3ISjvdWfudMCJ5qXSv8fpng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828927;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rIs2YyBDEZD03npTU/Gjrn706cKWq7CZRWus/8TJ5EE=;
	b=QWGczTHGLGj1SRM7Sg9YDYWi/8E1DdpUxTIrkDW181xn0viwsLwq7gRio+ZFJdQTkMlk
	 RnRuFh6ceaCgA8EwtnVPW1ZZxvGN/RnHF00N1jR1kNJkqI0TT0kjtpFccLWeo09kVejpN
	 ovSqsYTQKYwxqIoYrwXkLeWVmlqvMqgxBSz86UOghGHoVjXVWTGwdR7JuxA/0f5sELlEX
	 wUMU42uM/5b7LgUi/ZbX1mk/7k40v+cLXysUWWsXa+VTpVrkNW9nHasZ6CTK+oIBG1Xk8
	 3J+iVnJ0Lid7wlc68l1els0krVeakPvB/5p5lrqEvDXBJE6UFfuaMxfVsRttBOGDN8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iXrl1w8x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC511606EEBE;
	Wed,  4 Nov 2026 21:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iXrl1w8x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DC571F000C1;
	Wed,  4 Nov 2026 21:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828926;
	bh=rIs2YyBDEZD03npTU/Gjrn706cKWq7CZRWus/8TJ5EE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iXrl1w8xlrR4G92o115Jg9Zcv+Bj8BczSk5J47JeeSIgG50fL8xyU+xLfvzkxKga2
	 FmfDrw8XZdhyn1o0N29HqJHoOQL4qvxanUF4+sYs06Ct1vTinsXMbu8Gkfrz4UWSp5
	 /pgOQjV3Img+PzcJGbMeq7DjElOBz9taU8Z0ad4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 331/547] xfs: adjust checks for cross-AG reaping issues
Date: Wed,  4 Nov 2026 16:08:35 -0500
Message-ID: <20261104211047.633521390@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 4c6668ecebc61bb0a53d4c6e95509bc960cf6bbc upstream.

While analyzing the reaping code for the previous patch, I studied the
xfs_fsblock_t code to reconstruct how this code works.  AGs have a
superblock at the start of each AG which means that regions in the
xfsb_bitmap (aka xfs_fsblock_t bitmap) cannot cross an AG boundary, so
we don't need a loop here like we do for xfs_rtblock_t bitmaps.

However, the checks here are not quite right -- there can be quite a lot
of reserved space in COW forks, which means that the bitmap extent
actually can exceed XFS_MAX_BMBT_EXTLEN.  We also don't have an explicit
debugging check that we never cross AGs, so add that here.

Cc: stable@vger.kernel.org # v6.8
Fixes: 66da11280f7ecd ("xfs: reintroduce reaping of file metadata blocks to xrep_reap_extents")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/reap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -796,9 +796,9 @@ xreap_fsmeta_extent(
 	xfs_agblock_t		agbno_next = agbno + len;
 	int			error = 0;
 
-	ASSERT(len <= XFS_MAX_BMBT_EXTLEN);
 	ASSERT(sc->ip != NULL);
 	ASSERT(!sc->sa.pag);
+	ASSERT(agno == XFS_FSB_TO_AGNO(sc->mp, fsbno + len - 1));
 
 	/*
 	 * We're reaping blocks after repairing file metadata, which means that


