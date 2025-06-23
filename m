Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2573E24DCFD;
	Mon, 23 Jun 2025 13:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685227; cv=none; b=EytpLrl93yNpxSAEX7tR/FJpdZVzdic6APyeOB0ma5RP2AVIvuNysc+vuPdfrXLNqQlBglCQwHwQBgZgTtWAKpB6ncosrb0UJrygOYTbwqOQLHd+jlgXnvypeQXe+18Ebd9FPPbYdqLIyOFG9QTyaRW7jhQI2/n7MZSZ8v0IUno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685227; c=relaxed/simple;
	bh=5z02bEFeqXLqwNdARNBm0Wxdgvh6UVfouiZT8IHvQNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tEE/8oZiGig85gfEbygDrH7p5GSDdFsSX7uWmncCNC//H2HVUO5DDOPl13cFXgzNKXVEHwHFEaU2dT+QRjeL8+bmM9sdLvNDk7jfhCkOAxxeKykhRqfatxdc+si8OU9yptL2UtGm2kmeO/PNK6sPkB8FMV+jT9DXNFCPaiFXJzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jZSzznrj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jZSzznrj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 522A3C4CEEA;
	Mon, 23 Jun 2025 13:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685226;
	bh=5z02bEFeqXLqwNdARNBm0Wxdgvh6UVfouiZT8IHvQNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jZSzznrjG7jP1JT2NK4X/i16opYluEzzdWlaQW+ZcMpjS0kQ9krXI2gpEXlkXFZZc
	 lgHUQFu7vlh++CiKr21xaMd2XayXeqrdNepCGaOWgB0Em8exhikBg5aQeOA63zXUxC
	 1hWHBVD23ZE1P1RhNjL23kS3rWmL5Le7vvZ9v2vg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Larry Bassel <larry.bassel@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 076/222] NFSD: Fix NFSv3 SETATTR/CREATEs handling of large file sizes
Date: Mon, 23 Jun 2025 15:06:51 +0200
Message-ID: <20250623130614.388460275@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit a648fdeb7c0e17177a2280344d015dba3fbe3314 ]

iattr::ia_size is a loff_t, so these NFSv3 procedures must be
careful to deal with incoming client size values that are larger
than s64_max without corrupting the value.

Silently capping the value results in storing a different value
than the client passed in which is unexpected behavior, so remove
the min_t() check in decode_sattr3().

Note that RFC 1813 permits only the WRITE procedure to return
NFS3ERR_FBIG. We believe that NFSv3 reference implementations
also return NFS3ERR_FBIG when ia_size is too large.

Cc: stable@vger.kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
(cherry picked from commit a648fdeb7c0e17177a2280344d015dba3fbe3314)
[Larry: backport to 5.4.y. Minor conflict resolved due to missing commit 9cde9360d18d
NFSD: Update the SETATTR3args decoder to use struct xdr_stream]
Signed-off-by: Larry Bassel <larry.bassel@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3xdr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 03e8c45a52f3c..25b6b4db0af24 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -122,7 +122,7 @@ decode_sattr3(__be32 *p, struct iattr *iap, struct user_namespace *userns)
 
 		iap->ia_valid |= ATTR_SIZE;
 		p = xdr_decode_hyper(p, &newsize);
-		iap->ia_size = min_t(u64, newsize, NFS_OFFSET_MAX);
+		iap->ia_size = newsize;
 	}
 	if ((tmp = ntohl(*p++)) == 1) {	/* set to server time */
 		iap->ia_valid |= ATTR_ATIME;
-- 
2.39.5



