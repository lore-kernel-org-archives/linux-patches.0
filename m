Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828955;
	b=hw/L3ILTDc0oqY3OEH/dCXcuoC6oLpb2L5cQhlXfKv/jtPj22mpAXZq5SXsh1SV12kP+
	 i4453u4pFMgRY5n+GuFJReDancENroQkn1lZI2G3a99q7EUUhty9qUMiOY+0H9nSdoeLf
	 6Ex46jTCiwAKY72GedxhAkX2DFqraoXjG7CQaaKipuaCAfNLiuu1T4BWZKx/BE3sdPphy
	 0JTV0jKd0XR7wE+tMqIT2pBsFwgukCXOlb2t8dZlhoLF+nWVY0zcpEQ4N+g+DAD8HsANm
	 nVolQE9S4hrkJqwgTPsNMJz3D6KQmxdK0LhLttYg8hQjnPx99uJBWrLJH572ETct+mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828955;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oAnNg+bLflxO9vDC05JbilJVGvf5uUUIjiToOOEYbus=;
	b=EIFKeLfcdAGre4og83cF+yhWYkDfE3eHCWigc/0qruxSz/rHSOSKYdo696PYnjP0wtGG
	 Bh5Y8thxp8ShsTGKMpukME5Rf0/86K6pB5J3v60c1ebedIipl2B2LZb0Iw0/iViDjtSv9
	 TBiEquX/mULYdaCCUTmL7Gq3MwgaBKdXYt8jv16oNcMmKHX7/I1S310fnFqFgYDuE59VI
	 Q3tTw6NElZ75fNBgikaLNVrCreqblYjXzVdMfmsQ0YNhaCjhxpXKBb06EdSPBSbT+y9hi
	 L3idGYh387rYQNLCxTSKUdDQLCqnbGUMNyHZrCuZRvRkYguYQTmC47FHCEHcTdcxwEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P8LhDFfu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0A7607043F;
	Wed,  4 Nov 2026 21:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P8LhDFfu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD00D1F00A15;
	Wed,  4 Nov 2026 21:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828955;
	bh=oAnNg+bLflxO9vDC05JbilJVGvf5uUUIjiToOOEYbus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P8LhDFfu7Sf0Fig42FrWVPeAHzaIMy7huArDJoxewPznOWbRIuJK8tKCc6RQPDt5d
	 +VRqOxUOsBdDXEdotQ47r0D+or1LnLaU51r2unvG0dnV/DAkNrmUGuUwEqfkbebqJu
	 HA2AtOqpuPpx1IpqGHZzi9ThsCUwvP307Q9sfp4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 311/547] xfs: fix inode btree repair when a cluster is larger than a chunk
Date: Wed,  4 Nov 2026 16:08:15 -0500
Message-ID: <20261104211047.050183642@linuxfoundation.org>
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

commit 65b89ac3e8c2f041384f715a71b9d113edfa32e5 upstream.

LOLLM noticed that on filesystems where an inode cluster buffer is
larger than an inode chunk, we can run through the loop body in
xrep_ibt_process_cluster more than once, and the number of inodes that
we pass to xrep_ibt_cluster_record is incorrectly large.  In this case
we can run right off the end of the buffer.  Fix this by moving the
nr_inodes computation inside the loop.

Note that this is only likely to happen on filesystems with (say) 512b
inodes and 64k fsblocks.

Cc: stable@vger.kernel.org # v6.8
Fixes: dbfbf3bdf639a2 ("xfs: repair inode btrees")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/ialloc_repair.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/xfs/scrub/ialloc_repair.c
+++ b/fs/xfs/scrub/ialloc_repair.c
@@ -293,12 +293,8 @@ xrep_ibt_process_cluster(
 	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
 	xfs_agino_t		cluster_ag_base;
 	xfs_agino_t		irec_index;
-	unsigned int		nr_inodes;
 	int			error;
 
-	nr_inodes = min_t(unsigned int, igeo->inodes_per_cluster,
-			XFS_INODES_PER_CHUNK);
-
 	/*
 	 * Grab the inode cluster buffer.  This is safe to do with a broken
 	 * inobt because imap_to_bp directly maps the buffer without touching
@@ -317,6 +313,10 @@ xrep_ibt_process_cluster(
 	for (irec_index = 0;
 	     irec_index < igeo->inodes_per_cluster;
 	     irec_index += XFS_INODES_PER_CHUNK) {
+		unsigned int	nr_inodes =
+			min_t(unsigned int, XFS_INODES_PER_CHUNK,
+					igeo->inodes_per_cluster - irec_index);
+
 		error = xrep_ibt_cluster_record(ri,
 				cluster_ag_base + irec_index, cluster_bp,
 				nr_inodes);


