Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831678;
	b=YMvDbbbE7JFS5xA4tLdSbFTy7n1S8ruT+O+f7Q5fWAUE1gXL64F60HesjVmd/zVHRUKf
	 f3vzDbYzeuOQgjbx5r8/q3GMXCqUDZX9QalyXPhGyqomlbhRioYSffgkh5XZ3DHB83Vw/
	 ICnJ/ERmjMTFB99iQYs7Y2Q8sOAbasJSTGiRPYRBfQRr2r8FSjyAhqk+rn2GdZYNRJx5/
	 XH+q1Ke7F9ahDgLzFZ4FJa1U8l4qAgZh0wyxHfIJGA2LmorJrjqogmJ7eW8bmpYrOUkDu
	 nGGM2tCR52f9iF1prTWrFAGJSD0prJqDP3aolqlvzs9K70QbwwUQChP4ZhkZ5Ur71XQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831678;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WaiBWWR3o4eqHbaFE3CURxBVByQahfnTNXU+a8zLEXY=;
	b=XUFVmUAiMkv1Uao62WrNyu7yjlLeGIs8HhRltjx8/qPykKiKK3aHusCjpJRl9b3qWtG9
	 fSMPxKpjUx8gFcXJx1AB1ofN6PjD9IDEu3rtFMpPq66GHv4/9W2aa+AzxQRikt0Eos2iO
	 /cTqMTW6PnC+KMRlkMsfG5CMR/i1Ecd1Mb34Ytw+KMj1mJVvaAJtGpoZljvvg1eQm3KnI
	 goB68ozdKZbNV3N9F4P+rpwwOgYPYcCluji5E2GPtN60ZU+bnkeDJl1L9NFLP+A2Rrxte
	 eCM3JFbMo310DSsexMqONU8POCEUknHbB7K7nmi92Ki516gTewbOT1XK+edp9hPLLPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mKM91sC8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46140606A33A;
	Wed,  4 Nov 2026 22:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mKM91sC8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D79C01F00919;
	Wed,  4 Nov 2026 22:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831678;
	bh=WaiBWWR3o4eqHbaFE3CURxBVByQahfnTNXU+a8zLEXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mKM91sC8KyzrXKu617bDAd0BGS2ZWgijRsJQhUKuvruvgFbHP9od6o0Q8ze4fYalo
	 L5/FIpdmWlp8KAj+47sviCb2ZU8b9T+JZQHOagQ8DGG1k+IgmLDq3cQcaZB6gLkQwg
	 VOa/B2PcxV4vbRlZEepnpGGLncTNFP5pE8iDbQC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0850/1005] xfs: dont rescan ifree and icount when frozen
Date: Wed,  4 Nov 2026 16:09:43 -0500
Message-ID: <20261104211107.110390160@linuxfoundation.org>
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

commit 18028768415e3c05ab7edb22d740e2f4dc52836a upstream.

LOLLM points out that it's pointless to rescan the AGs if we've already
frozen the filesystem because there won't be any more perturbations.
Fix this to mark the scan incomplete and exit.

Cc: stable@vger.kernel.org # v5.2
Fixes: 75efa57d0bf5fc ("xfs: add online scrub for superblock counters")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/fscounters.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -384,6 +384,11 @@ retry:
 	 * to maintain ifree <= icount before giving up.
 	 */
 	if (fsc->ifree > fsc->icount) {
+		if (fsc->frozen) {
+			xchk_set_incomplete(sc);
+			return -EFSCORRUPTED;
+		}
+
 		if (tries--)
 			goto retry;
 		return -EDEADLOCK;


