Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828966;
	b=Zxf8PuhJePHz8kI5TISdtD2oMcZ7KYbiFVU+/KMrFwQ6sZZwjB8lEsGy6PjS+dTOWgvv
	 +0rt9hFF2TDpZ42TczmGYj/RzfSrpqdYEn5nbitn1uQhFm8++U7cV2n2zUlRfFT9me+PV
	 rSa2+/TYXfIrg5mv4x0AH6leaP7FQGAQku0lLSLUZ14/dNw5oFOfEiG6OiSfj+zXwQvaz
	 VwCjyrp42CtDZhUfjfZ+fbp6g9EtkOpd9sjgMl2cA9w307XOZ7krzibqykqLaL8qmk6Xg
	 tW+p28a1AgCrBJ3ljyCupG1O+cRNV7W31iH02fk1xjSCTfWJ1FAZ2I2bgnciUoP6KPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828966;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gTNPYf1wCaQpS2ngBrQxCD10LGDI1CH7+Ii58vb36d8=;
	b=WixRhw/STpEQzo62nW8wOLqjmIETaal48+8c7Mqd6UCNzXtbOyuQEKa0mj9zHTXriPnZ
	 IpBRZI4UhG1x/kFgRB5cTPhFG/sOWTt/2Ff1cyqx3UhhJGHZ899bOoHza2OsyEy6txtiI
	 v+bosC2Pu/QPaa1cDIYSKNFTrBSTt22dceAgRIb3N6ofsam6JvMlftxyIL4ILjR8CsqHq
	 h5dvHoFqt6jDiTzMnE42p8E8EgQjsLw0cpYSbt0EkTvYphcb1SjN8FMa+VkC6rwGXDJIy
	 5G8NSw1KZ4e41wfOh2v+u55LYTe6m2oBCc/1sqJYn+lqEvPtw5inkcP9Ho+WuZ6gAaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ArQurKmR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A05607E487;
	Wed,  4 Nov 2026 21:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ArQurKmR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 816521F000C1;
	Wed,  4 Nov 2026 21:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828965;
	bh=gTNPYf1wCaQpS2ngBrQxCD10LGDI1CH7+Ii58vb36d8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ArQurKmRVNCDeC4oH4SwJV2Z2zwsdULR4NDqlHiDgXiKuCKzOcNM/3AzTrOnVNcyT
	 r/alcxPscjOmmBk/of9Ir9KbDbQNALAzbCy62sZTqaj0Y58q4C76Dhl5BZDSSJi92g
	 zCIl14uEo9Ot9RfGu02PkufiojAMUraNSh7i0JXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 358/547] xfs: dont queue rmap update twice when reaping a fork
Date: Wed,  4 Nov 2026 16:09:02 -0500
Message-ID: <20261104211048.457789262@linuxfoundation.org>
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

commit 219ff8a734d8438e24eb346a847c9b1ad9b7ab5d upstream.

LOLLM noticed that xrep_reap_bmapi_iter calls xfs_bmap_unmap_extent and
xfs_rmap_unmap_extent to remove a mapping from a file fork and its
reverse mapping.  However, xfs_bmap_del_extent_real also queues a
deferred rmap removal log item, which means that we incorrectly queue
two rmap removal operations.  Fix that by removing the extra call and
updating the comment to mention this subtlety that I forgot, having
written the code. :P

Cc: stable@vger.kernel.org # v6.10
Fixes: 5befb047b9f4de ("xfs: add the ability to reap entire inode forks")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/reap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -1480,12 +1480,12 @@ xrep_reap_bmapi_iter(
 		/*
 		 * t0: Schedule removal of the mapping from the fork.  We use
 		 * deferred log intents in this function to control the exact
-		 * sequence of metadata updates.
+		 * sequence of metadata updates.  The BUI queues a RUI to
+		 * remove the reverse mapping.
 		 */
 		xfs_bmap_unmap_extent(sc->tp, rs->ip, rs->whichfork, imap);
 		xfs_trans_mod_dquot_byino(sc->tp, rs->ip, XFS_TRANS_DQ_BCOUNT,
 				-(int64_t)imap->br_blockcount);
-		xfs_rmap_unmap_extent(sc->tp, rs->ip, rs->whichfork, imap);
 		return 0;
 	}
 


