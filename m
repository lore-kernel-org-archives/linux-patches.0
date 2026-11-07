Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061653;
	b=kdiDyE/LIR8phkI6nPmOaSh29pcDewetsApm/yZfcjBHme/A8F52LytyuIq86KsAhaDn
	 YeDKvzg0UHgIS1iQXiZIRY1TatS4VsjA6AloO9yqxWRIdLs+T5atNxiPi2UNWDfDzbMkF
	 5Jvn5yyvCruS3lWCFMPpkn19pmJZihrAv9Z3qzUILvhipmFVSG6+OtJgivwWRLTS3OoSB
	 glqXkyoiE8RrhIcv91Uk6POqRET8fD7ht487rV0viHhhpokSFb65+XZOr4VxC/iAhYcr9
	 7wa1BFMWG07jNeidv+qukKe/7kOa+z2KWI3NL3s0vL5imegqrRuV1sOOJo/dTq9J1eA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061653;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rOKM+FqkzPp10JT8kjF40qASPSTHDi1qPOl+2v4lVmE=;
	b=DL29KEU/Pi+pthoW55Ra83WLUP5yf1oF+Yff1Gv9ZYiI11htC2iBD+y4CjqXPKtEfu8c
	 vB0RquTn0FBDkeprgVQO0YBeXTVpgrRAcrBzvJ4lzGHKYgviz2C7b1zBpMb2C32g8bImj
	 8G3Gv0DWTsFnVoyOkuYkOX/++fXpNv71zxAPLcCAoSjqK30zAh9rGokIESecylmhTFvlJ
	 DS+Tl+rqrUO0alK8DpPkJaUMvqqR1XCloeWoRJtm44LFapthLZZHnNYwgcVWnlVfjNrUq
	 zdmTLmc4eKGQT0Cf0HadY+m/ckwrMO3BaXEG/83nKDfn7tOL/aDVyquOXizM8wp1xJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fToi+Ick;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96EB9606A32D;
	Sat,  7 Nov 2026 14:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fToi+Ick
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5ADA1F0089F;
	Sat,  7 Nov 2026 14:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061653;
	bh=rOKM+FqkzPp10JT8kjF40qASPSTHDi1qPOl+2v4lVmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fToi+IckeYjgfsjTth+H+nxdvMuStRzUF4q1NI2CT/F6Tgzi03crKikUrd4miwUJn
	 vUp7SOoQ9T1gp7ZGSI7S/g6r/g+ZwJZ6oedLE1FCofxUZm6tz3cRsDTaCVE5bG7q2X
	 f+Wp+oupszcve1A4SzVjUfe4tZHVLIRcF47NdGNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0713/1536] xfs: adjust checks for cross-AG reaping issues
Date: Sat,  7 Nov 2026 08:45:29 -0500
Message-ID: <20261107135017.526656459@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
@@ -583,9 +583,9 @@ xreap_fsmeta_extent(
 	xfs_agblock_t		agbno_next = agbno + len;
 	int			error = 0;
 
-	ASSERT(len <= XFS_MAX_BMBT_EXTLEN);
 	ASSERT(sc->ip != NULL);
 	ASSERT(!sc->sa.pag);
+	ASSERT(agno == XFS_FSB_TO_AGNO(sc->mp, fsbno + len - 1));
 
 	/*
 	 * We're reaping blocks after repairing file metadata, which means that


