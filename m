Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828976;
	b=yBF5m7tmINNuitDU+T1F5PEa1nmsHK02VkZgwEKdAXqloof3Q6Kykv6uwIv2hVOXCyOd
	 BFAwINvMQCiQDJx/qt2laq6fYbdVw93FjGYdN+sXW+ujr9Ls42+L8xXu38Y+ned+KrGyp
	 I16VzArZOT6XidaA9nfELr3zd1mycGzo6K++U+wDMs9DlKyQwewpgrnvYXk534RePqeET
	 Lt/xTbYgRIfRlUiiu3AKxirU/w/VRk/5xQ8KnavRNi6jLyDogKZUFaGgBmmRHPcMzJip4
	 kpJSxbSW2/7ldQQfs+JVK44H9yce1Zdls2HExEvp3VA3Foq6ARxyTMTbYvxQOE1lCxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828976;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oQI4erhWL6U5aF1TzEBtJ632LgoI2up2y9VBTKdXFAg=;
	b=yIy0c5kogpdW741oV+fQL+cW1pcAkSff7N9lJlSaHnq8x+1FSfFRp5Ooj0tl8aUSgcfD
	 aMCNDjJGQ/yqbyn9QpbN0+DSw5Kin0+VorgH1IcO27oBIzwqM460rpqj27VjjhOQLgld0
	 kfgo40yjuFi6NG8zwEC2r9p+nOfpu0zaFQlkxjKnyjBmiISWiCtPKYTiQzuXRp3dvyUm/
	 qFvDcp84sYDTMgxNDWCV55Jaa5L8c2IfkG43/N0ytqYjFPkkOIxYm/cDp9MY0gEE7MDbI
	 cxbkg8s19nTeBaX+j26tQg1X6ekKC+1DyvcHGu+3vcRaNVyDQQaunGMbeRUwz3k08Tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Cc1/jh+G";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A686072665;
	Wed,  4 Nov 2026 21:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cc1/jh+G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E97851F00919;
	Wed,  4 Nov 2026 21:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828976;
	bh=oQI4erhWL6U5aF1TzEBtJ632LgoI2up2y9VBTKdXFAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cc1/jh+GEGMWEhvo8pfVWpY1Mx01jiVKY35t750Far3PhSQrpyguyvmbLXGT7t/Ym
	 bTQeEHBzgZGDfpEC1EQ+s+6Qe9DYk2XEX2cZRDVpaFizqbp17orqKzMhNsyXu9vsFf
	 JP6z6DvkyZvl5lnMMGsE7C31h7ALu3jZyGkgqCb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 347/547] xfs: always zero the whole shortform header when zeroing attr fork
Date: Wed,  4 Nov 2026 16:08:51 -0500
Message-ID: <20261104211048.126111445@linuxfoundation.org>
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

commit 52aa50cea408e27454d206cccecbe4f694a6c1e1 upstream.

LOLLM noticed that xrep_xattr_fork_remove can decide to reset the attr
fork contents to an empty shortform header, but then fails to zero the
padding byte in the header.  Fix that.

Cc: stable@vger.kernel.org # v6.10
Fixes: e47dcf113ae348 ("xfs: repair extended attributes")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/attr_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -970,7 +970,7 @@ xrep_xattr_fork_remove(
 		ifp->if_format = XFS_DINODE_FMT_LOCAL;
 		hdr = xfs_idata_realloc(ip, (int)sizeof(*hdr) - ifp->if_bytes,
 				XFS_ATTR_FORK);
-		hdr->count = 0;
+		memset(hdr, 0, sizeof(*hdr));
 		hdr->totsize = cpu_to_be16(sizeof(*hdr));
 		xfs_trans_log_inode(sc->tp, ip,
 				XFS_ILOG_CORE | XFS_ILOG_ADATA);


