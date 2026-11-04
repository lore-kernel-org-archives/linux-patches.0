Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831675;
	b=4WNRt3pYlQ0aCTLd/8je0vYjXwhvOieyN29BhwlrlzRSixLEzceWwULEP4v0+spkTXYu
	 8hKPO1K8YYKVHraHwDJrQ/i7WpFDOL5K+y6H4YC9q+sMlxueUZ+GzBVme126Qb56h9AHt
	 5gMpJXjUX/2bKcpqe4Y7AzfNo/cth/kA4Au04WOQYBWEn3f74ZfvkdINjf3nTGJfKRZdi
	 6mELWXQFoFRpRZZArr6Cxrt7Ib8yNiRS+FFNqWqQYRxmMRkKLJclxUNqEwjylfzpJxFOY
	 BFxvJc/6o6Ww36jwP231PHz9D2V9jwwK8139xeMh1L4KHECshvhWd2ZU+myvzMQ3o/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831675;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=08F4maF/RngSD/lM+qIwteI1ekk9+x/irJP8QtwwYp4=;
	b=2oK99MxKwBCuSZHbjOEI34JgjgAJTZnMdClo2iO/EqNKgGcy0UTQE5bp+A9ixWbEwH5U
	 DbiS3fbmP2Y6bQVg8Z1cvsp//ioS8mlE2T3FNYhaRLZ+K/lxQ0pD3yutkHZ9XK8h4gWVJ
	 9tjyndEY9hxauRmKmmSheqq8LHezXgtCIWQmIga//b5Mt7+58ql099tXd9uohSvrhnRF9
	 R5cOXiwcE6S6TemkEtY4ndeEMrDMGTySiqq96zsr3TFDi9zEnAf++YyNrZvGTsU3PrztX
	 8p4q690shjAd7j9tzZBspeQa0DfAfbvfZ8vmOu6eChVdRFmoQSJkdZoCD83PHJRFtCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gxRb0yPy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F29606A33C;
	Wed,  4 Nov 2026 22:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gxRb0yPy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C69F81F000C1;
	Wed,  4 Nov 2026 22:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831675;
	bh=08F4maF/RngSD/lM+qIwteI1ekk9+x/irJP8QtwwYp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gxRb0yPyirkEzTO/JIw0yhorIxSMZlRjcpyUeccoj2Oq3QHvFAbsfEwEqr03W0EBH
	 +5Vzm8K0HqlKUbtKiBXcXkoEGHWZyZWHiGlWm8PerGYj++ZUGgZ9UU0pAw4DHkywGm
	 ltxnlUXwQ5w/WLnTzMy7uU0iP8GnzY9QtsfQOfHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0848/1005] xfs: dont overrun incore inode when cleaning attr forks
Date: Wed,  4 Nov 2026 16:09:41 -0500
Message-ID: <20261104211107.060989871@linuxfoundation.org>
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

commit c28b4b48deac17749ed1ebe4289a4ba73541ddc6 upstream.

LOLLM noticed that xrep_dinode_check_afork doesn't check for a
di_forkoff value that is so large that the attr fork would begin after
the end of the inode space.  This causes afork_{ptr,size} to be
nonsense.  What we really ought to do here is zap the attr fork.

Cc: stable@vger.kernel.org # v6.8
Fixes: e744cef2060559 ("xfs: zap broken inode forks")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/inode_repair.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1243,6 +1243,8 @@ xrep_dinode_check_afork(
 	if (XFS_DFORK_BOFF(dip) == 0)
 		return dip->di_aformat != XFS_DINODE_FMT_EXTENTS ||
 		       xfs_dfork_attr_extents(dip) != 0;
+	if (XFS_DFORK_BOFF(dip) >= XFS_LITINO(sc->mp))
+		return true;
 
 	afork_size = XFS_DFORK_SIZE(dip, sc->mp, XFS_ATTR_FORK);
 	afork_ptr = XFS_DFORK_PTR(dip, XFS_ATTR_FORK);


