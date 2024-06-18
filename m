Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85B31419BA;
	Tue, 18 Jun 2024 12:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714787; cv=none; b=Wb5MTNUxLHyA3Ey1oyOJOky+sG8X/Vbspz85CrHlVLxfwvkR6IokjDbtVvfN5xRPN2n8vIk1FPYOTtffDQDDq0YHlRxZ/pB4xV9crH4Pu+1fVYBtQi/4PeK5o34qTpIIIM+TfX0rJrwHq2k3Pc00VMulQGXuJHTulxfnQZGVBrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714787; c=relaxed/simple;
	bh=MOSBfg2PMMgDSGlCpAPslIsiUYP5vDzIpOLCrMxnA1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u6G/kQbbT61fFuRLEu3WPamn679AxvPoii2qMyF+lMoMKWJwkc2o/34JW6xTnt484+iX8yxjDqr6qWJsPR6S+vnngTbc3EZWP9GNYvr1IJ7V0YLW+zJnxOzbPHstdLXrkyPXRzW/YTYMfWTO6u+Jx/pH7Z+783ClomXtljYQ3UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y8hpcInt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y8hpcInt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E9ACC3277B;
	Tue, 18 Jun 2024 12:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714787;
	bh=MOSBfg2PMMgDSGlCpAPslIsiUYP5vDzIpOLCrMxnA1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y8hpcIntk/AGLuo6wmGA1V/Ut+dPd0vg+ZtWdvgiczOqLbYu+WEgmWwwx2Ipfly1J
	 1njv+mzTZY83mQ3OQ4KkH6VQ/Qr6pSiWwpZuNindeVWlO+ok9kTmrpG1HbtXbhLrao
	 EhlU89iiy+w+Sku+P6NSWIoSYZsVn5UPM/dFuTHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 088/770] NFSD: Replace READ* macros in nfsd4_decode_xattr_name()
Date: Tue, 18 Jun 2024 14:29:01 +0200
Message-ID: <20240618123410.673968685@linuxfoundation.org>
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

[ Upstream commit 830c71502ae0ae1677ac6c08ffbcf85a6e7b2937 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index bf2a2ef6a8b97..1fcb668e4110d 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2117,25 +2117,22 @@ nfsd4_vbuf_from_vector(struct nfsd4_compoundargs *argp, struct xdr_buf *xdr,
 static __be32
 nfsd4_decode_xattr_name(struct nfsd4_compoundargs *argp, char **namep)
 {
-	DECODE_HEAD;
 	char *name, *sp, *dp;
 	u32 namelen, cnt;
+	__be32 *p;
 
-	READ_BUF(4);
-	namelen = be32_to_cpup(p++);
-
+	if (xdr_stream_decode_u32(argp->xdr, &namelen) < 0)
+		return nfserr_bad_xdr;
 	if (namelen > (XATTR_NAME_MAX - XATTR_USER_PREFIX_LEN))
 		return nfserr_nametoolong;
-
 	if (namelen == 0)
-		goto xdr_error;
-
-	READ_BUF(namelen);
-
+		return nfserr_bad_xdr;
+	p = xdr_inline_decode(argp->xdr, namelen);
+	if (!p)
+		return nfserr_bad_xdr;
 	name = svcxdr_tmpalloc(argp, namelen + XATTR_USER_PREFIX_LEN + 1);
 	if (!name)
 		return nfserr_jukebox;
-
 	memcpy(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN);
 
 	/*
@@ -2148,14 +2145,14 @@ nfsd4_decode_xattr_name(struct nfsd4_compoundargs *argp, char **namep)
 
 	while (cnt-- > 0) {
 		if (*sp == '\0')
-			goto xdr_error;
+			return nfserr_bad_xdr;
 		*dp++ = *sp++;
 	}
 	*dp = '\0';
 
 	*namep = name;
 
-	DECODE_TAIL;
+	return nfs_ok;
 }
 
 /*
-- 
2.43.0



