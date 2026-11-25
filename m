Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620149;
	b=1nyyHDCRCRf4vS4TgKkujENKDeSRmw0gMyHPyBZNgtDNLHdCccy1Wg2WxG4X8G3AU7pv
	 kVMyeBTUkpJR3wnNjSE6OCqzVZzrDgfEsZnz5fH/l/jfr7w2Dh9cn7j5+Ngj1qWqlStEM
	 0g15yPQJfvlXDZRXCZkbsiRLBJH8sMO0L91Mv1+LhB8ym7ghX/J0pXPibR9c0kaZcqT3m
	 W/DbqFiItyTYwpQvH9otGNOR6Tz1IrhrqwwvPduVepBiEU43Fjs0qbnx8AUlrCdTljeTP
	 x1k9GfEMf2qoBHW8ctJ0Nu/+nzA1HF5uRNWtx44aMpWaupXdekB/pDnBvK8BB6SUdCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620149;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uAaWH/xxXOpujHZ9F8rd920MYsAZxc2zoVhADSgND+4=;
	b=NJknwxhLUQrJRe5eJo2gGnkNGqwlHHSEykcmDZh6fHxZaETyLagbtSSOR7LdhhGTNahL
	 8FwfPs5/D8WhseuqXYbRyggTHucskSFCRZ9VjYnjGKtcZq8GEIVdgl4rmR5eX3r5TTCg1
	 nx/MEB2oH203Tu4bKI+gY4HNIjVGJlNZopHe+Lx2+DYgUSK8Rd4JqzMjaIUJ97b4TQnMF
	 DW+ACeG/KftNJua4+4m/V9qCVQupAKC59OVr38SruO/xKgD4aVO8KhEJosuPpeNrt+s1R
	 wyBAYws/PSmx/yq7NjCkX8MGgt4/AwSUk3GunveNDQ8/ynVCgPV6SbJD2xgxyOG2RmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=luje5Dzj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435B1606A330;
	Wed, 25 Nov 2026 15:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=luje5Dzj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F9501F000C6;
	Wed, 25 Nov 2026 15:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620148;
	bh=uAaWH/xxXOpujHZ9F8rd920MYsAZxc2zoVhADSgND+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=luje5DzjiS7NTOJnPirQPn26x9h6Xp5J44+N1lC10n6XKDb50Q3lAqn26VDLAnfQJ
	 L3CzP6vwhb0xRYlFoMMCJ01KpHxjI/M90BLlS2CXbaEoFySV6ZkQl4JbZgVeUKcpQk
	 gJA4OLj3BEfrZS+e4dYhJlJQbIeLzDwld0u2bqxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 7.3 0824/1005] ovl: fix leak of lowerdata redirect on ovl_get_inode() failure
Date: Wed, 25 Nov 2026 15:36:02 +0100
Message-ID: <20261125143841.027461116@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Amir Goldstein <amir73il@gmail.com>

commit f1b7e5534854043077bb72afc8d87ad1e0b283e0 upstream.

ovl_lookup_layers() moves d->redirect into oip.lowerdata_redirect and
clears d->redirect before calling ovl_get_inode().  When ovl_get_inode()
fails, it does not free oip.lowerdata_redirect, and ovl_lookup() frees
the already cleared d->redirect, so the lowerdata redirect string is
leaked.

Clear d->redirect only after ovl_get_inode() has succeeded, like
d->upperredirect, so that ovl_lookup() frees it on failure.

Fixes: 2b21da920866 ("ovl: prepare to store lowerdata redirect for lazy lowerdata lookup")
Closes: https://sashiko.dev/#/bug/linux-dabbd363-9c71-4915-af72-e2b5e75fa58e
Cc: stable@vger.kernel.org
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/namei.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -1366,15 +1366,16 @@ static int ovl_lookup_layers(struct ovl_
 		};
 
 		/* Store lowerdata redirect for lazy lookup */
-		if (ctx->ctr > 1 && !d->is_dir && !ctx->stack[ctx->ctr - 1].dentry) {
+		if (ctx->ctr > 1 && !d->is_dir && !ctx->stack[ctx->ctr - 1].dentry)
 			oip.lowerdata_redirect = d->redirect;
-			d->redirect = NULL;
-		}
 
 		inode = ovl_get_inode(dentry->d_sb, &oip);
 		if (IS_ERR(inode))
 			return PTR_ERR(inode);
 
+		if (oip.lowerdata_redirect)
+			d->redirect = NULL;
+
 		ctx->inode = inode;
 		if (ctx->upperdentry && !uppermetacopy)
 			ovl_set_flag(OVL_UPPERDATA, ctx->inode);


