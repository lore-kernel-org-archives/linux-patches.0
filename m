Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590876;
	b=LzHtnt+MdP/4hTqRZVefGzlpgvvLkQ6e9R127gOA+pW0B11X2ROtQP/XsMp3Q7Qxy1AR
	 oDaT90WMjHbB/DHcFXod7nyDivV1+TmkxjAlpgPNhMQgh8iMeq0ZZfpOEzMDAA+ePG8ki
	 RjqdWaQ2dQ65uSblmkoL6kBxF8gc4rmJmp9AfrtmAbU+WvZMsHETIyV/AlTW+Sajd8Mff
	 wL3p+NeOOiHWFkoddL7cRH4q/LaOuIFWhS7A2pl4vo8lO6EJl2X7DgtXDL//zZn5+kwHr
	 330VW9lEfAwEDxDdBrIDS+OPWHL8v2jP5XYrS4GiPCfj4dBceQqxw2oy2Z7LJYJwnEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590876;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0MMNGhsW2uWmiASYmNpT+k5Va9YY4nU/jbRGLnLcnZY=;
	b=ED4ElFqXB/lnctg7Fzk71+oZ/Vckmpp6n1F1auGQw6dqu+8i08bHLtDHy+DDW9xi3W6S
	 dU8vxPXF3Pr5fX5h3UAjFkHnpImBgbZ2ZEdAc95fu2wYkIc5jdbNG8g7RAkPWHMkiQuvw
	 Y0ndOvbUiJRBPrF7CMFAxzTybuhBTXAp4JruZvRtnjyh8i/pQBz+bR+nSJTuvHAm8dPGg
	 c80qRYjYP50P3YQnY7BClCzAPJQ5CfwZTgVrkyDgNZnHlEe9GBQ0wMpe82B0y9Cj74EGI
	 Nnd5bKmXYJ5eMwrXnAx1lOOXLjiKbvHbmp9YI5oXhlpurLI/Nb+7v8ILFlXYS0ja7tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PmQ5Ob0W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 900FE606D4A9;
	Fri, 13 Nov 2026 17:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PmQ5Ob0W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CD341F000C4;
	Fri, 13 Nov 2026 17:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590876;
	bh=0MMNGhsW2uWmiASYmNpT+k5Va9YY4nU/jbRGLnLcnZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PmQ5Ob0WhsBfpYY8xHsuJ10xwVBU7geyypU8EN65N5JtlmTLx0TDPOowyLOXzly0e
	 X7Yk363eDivelnNEULBd5kQqMUQSRWZhZgrjm06gVlQmm7wDv7+3v2uD2+bmtkeJBP
	 RMPK62KOPKmuVThaIz7XIt2t/LFqsh8o6VGpj36E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 072/670] xfs: dont queue rmap update twice when reaping a fork
Date: Fri, 13 Nov 2026 10:43:56 -0500
Message-ID: <20261113153813.984132486@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit 219ff8a734d8438e24eb346a847c9b1ad9b7ab5d ]

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
[ sashal: Adapted rs->ip and rs->whichfork references to direct ip and whichfork arguments. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/reap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index 4ce345ae4565e..0c827798ade67 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -905,12 +905,12 @@ xrep_reap_bmapi_iter(
 		/*
 		 * Schedule removal of the mapping from the fork.  We use
 		 * deferred log intents in this function to control the exact
-		 * sequence of metadata updates.
+		 * sequence of metadata updates.  The BUI queues a RUI to
+		 * remove the reverse mapping.
 		 */
 		xfs_bmap_unmap_extent(sc->tp, ip, whichfork, imap);
 		xfs_trans_mod_dquot_byino(sc->tp, ip, XFS_TRANS_DQ_BCOUNT,
 				-(int64_t)imap->br_blockcount);
-		xfs_rmap_unmap_extent(sc->tp, ip, whichfork, imap);
 		return 0;
 	}
 
-- 
2.53.0



