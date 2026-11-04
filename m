Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831605;
	b=Ia9nrxaTXd6CHEJ5Z/DPAw3Uj5JdFHAFuKwGq3ovfYkoORpIN9scbdRb1u0QjV0q+fC/
	 TB7jaaWSDsJBw3YnKEVLyX3WMhaIO+reW2qzsLO150ZOmIb2Omrvv6QH1w/N8CvebH86h
	 YoZsWCw/2IZxYuX9i/Yt9nk4cOHxd0Kfpu/6Ny3N0vGFGGWAYvppa+IRBBe+1sKSxp0o1
	 TXc+bZUwDfdUazR6cqjy1+nZ9b923b+N4xY2Cg+1+AuJE6UMMbzu/7r4BueXNMoC/fF+j
	 yavnWkORW6ZUrVzTyL2QjD+hgHGrW0tQZKi/9zO1X9dw6vcXT/jjIBPVRLde5uVnfdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831605;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fHTG7Din9fwdyf8ALQrk8CnWnTtbUb7PI598J7VvUEA=;
	b=kYWV2i9fDRNyljDC7tU8mYI6MkJt36KRnq47kMES2GCe9m+Lx7NJl4f3xya2gJHrh788
	 GgLS7mpcC107u1mbU4LB1c1qU4Ry+7CG5lmjdYOpZ7UzEUcM7Vbefvth5yfe7YK/RTL4T
	 ub/YN0Vh7nJ9MrDAsMNfO63th31CwOOSUJFmihjHuG+hSouzzXsK60iuqv4fEUWacfd99
	 nuD1XC2WVH48zlPziQTbLPR9TOMHs9DJ7wdtOmgf8NKHTKVYH9ABgIp3OEno/Wj2UcBou
	 OtcCuyg2+XK3VgZBC2+hkJYBkddDbFXAqzcOHi9FbcXZE57OLVNciL8ZMTs6zSVwHEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TdjimljH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 923B2606A31B;
	Wed,  4 Nov 2026 22:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TdjimljH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA9E1F000C1;
	Wed,  4 Nov 2026 22:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831605;
	bh=fHTG7Din9fwdyf8ALQrk8CnWnTtbUb7PI598J7VvUEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TdjimljH1D46qS6D9wutgVQJ0Vk3Gfoj47ddKAMwbrUQH6woMzk9WbHOLsO1C/A61
	 bITGsswg5iroZ9ySwUcmTbKiXZusAjjUNQisfE2rM2lTAfr+l/nSq1MNjX7UGJKKdK
	 6qhaKd06ZPbcBrTV+OAhQpl2G9Zo//lkAaWS34Ig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0806/1005] xfs: adjust checks for cross-AG reaping issues
Date: Wed,  4 Nov 2026 16:08:59 -0500
Message-ID: <20261104211105.931470814@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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


