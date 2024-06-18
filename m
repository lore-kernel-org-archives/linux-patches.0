Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27DC719DF81;
	Tue, 18 Jun 2024 13:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715962; cv=none; b=mPmF+DK6Lg1EpbuXvMGKfupQp/0P4gEqvewknSHfKyx7YUUdw6dvc/k3TABOIRavbrv+/ZIWn2GeriMkeNGmuxy21L5XK7beCjzc39s8q+brV3Zue3SCj1zRsDacOKJm6IDRkM7DF4wqX8+oSfFiR+NSPNVFHQlO8eI0WLjI17M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715962; c=relaxed/simple;
	bh=6zs5PXgxxDtnnn+HjWdK97VKICohyXrHPBrhAEeWCm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ijTBD+MD8FY7bRnMBTA2CEnnm2Rdv35/o9aXf2JyZbfioJHu3KaYdG7SvASci+YP8HNA4YyeUbrtyI5Z8tulZuBuLrBgIWsCb0Z575hTWep5a7UNbFVToA+mteNwyOx1yBGpFjGw/lbOY9XrefrX0/S7SKCIjUDruYeQU/d5IRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VhPe/ls3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VhPe/ls3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4B42C4AF4D;
	Tue, 18 Jun 2024 13:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715962;
	bh=6zs5PXgxxDtnnn+HjWdK97VKICohyXrHPBrhAEeWCm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VhPe/ls37zkxS8BfuyNL95VxPgqStjMk9PhvZ1+zkdAvV1gT/ZrUQdMDgpjX/O1hY
	 UzNu4wgXKpZHBmp5woarfCOCRmVIt1oGXnWKQmoNSUeRbtKX2KHCRz8U4eYXTcitAM
	 qDrXP9/hztRHIZDIg6v+oIhryK/sHkow5NBNnuKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trondmy@hammerspace.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 444/770] NFSD: De-duplicate nfsd4_decode_bitmap4()
Date: Tue, 18 Jun 2024 14:34:57 +0200
Message-ID: <20240618123424.428763428@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit cd2e999c7c394ae916d8be741418b3c6c1dddea8 ]

Clean up. Trond points out that xdr_stream_decode_uint32_array()
does the same thing as nfsd4_decode_bitmap4().

Suggested-by: Trond Myklebust <trondmy@hammerspace.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 638a626af18dc..adf97d72bda80 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -277,21 +277,10 @@ nfsd4_decode_verifier4(struct nfsd4_compoundargs *argp, nfs4_verifier *verf)
 static __be32
 nfsd4_decode_bitmap4(struct nfsd4_compoundargs *argp, u32 *bmval, u32 bmlen)
 {
-	u32 i, count;
-	__be32 *p;
-
-	if (xdr_stream_decode_u32(argp->xdr, &count) < 0)
-		return nfserr_bad_xdr;
-	/* request sanity */
-	if (count > 1000)
-		return nfserr_bad_xdr;
-	p = xdr_inline_decode(argp->xdr, count << 2);
-	if (!p)
-		return nfserr_bad_xdr;
-	for (i = 0; i < bmlen; i++)
-		bmval[i] = (i < count) ? be32_to_cpup(p++) : 0;
+	ssize_t status;
 
-	return nfs_ok;
+	status = xdr_stream_decode_uint32_array(argp->xdr, bmval, bmlen);
+	return status == -EBADMSG ? nfserr_bad_xdr : nfs_ok;
 }
 
 static __be32
-- 
2.43.0



