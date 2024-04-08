Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE717D414;
	Mon,  8 Apr 2024 13:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583475; cv=none; b=msBVNB8ulpyHLnXqU+0vUvQAP6l4GPAm12JKmxDDzRC4ZndBLpdZ3yV1vNVYD2aWClTDRgL6vmZDCM7dVOGqHaM+Hpg1Ukl+HjCIuWMdtyaL3LOqca/0VoY0u+t2VTDl59hP7Inqke0gJ1roqaMhnNr41YqVzPgRrdvotwaZMss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583475; c=relaxed/simple;
	bh=ppGydzDhScoYE8wu5DfZqQhOR8r2hDlnEXluG0eOzh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YTrm/4JP4BkMDP5LBPMegf9v0hOcB+N/2+Me4EmvB+rdJDcC+rQ0dsD4N0u9u5zGpjVPZonvdBqlpaV3QPyQjiKXk4Q/m14d8qAzVzrY99J16ag4T01ftCHjvD35JSfmLsVYYXNPwLLjdlF9aPU4eXRUazrsmbo95C4rm7pdbwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iCiJDyq+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iCiJDyq+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D24C43390;
	Mon,  8 Apr 2024 13:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583475;
	bh=ppGydzDhScoYE8wu5DfZqQhOR8r2hDlnEXluG0eOzh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iCiJDyq+TfTzProAmqClZ2w7ZDjOxGg7BtQ4GUp9WRlaP0is8C5l+p4ftcwhBqp+O
	 MKKiOv+Px5SLobsB/Hh5zn2n3FQJ262/oyrYeukYfZNAben4rAmCRyWWp5faaA1KmV
	 wZJVz5LVkzR5dJ8uN7CImZ/kZpL75Xf0UjP7919I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trondmy@hammerspace.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 251/690] NFSD: De-duplicate nfsd4_decode_bitmap4()
Date: Mon,  8 Apr 2024 14:51:57 +0200
Message-ID: <20240408125408.695729755@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit cd2e999c7c394ae916d8be741418b3c6c1dddea8 ]

Clean up. Trond points out that xdr_stream_decode_uint32_array()
does the same thing as nfsd4_decode_bitmap4().

Suggested-by: Trond Myklebust <trondmy@hammerspace.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4xdr.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 506ecfca2338b..4459722259fb2 100644
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



