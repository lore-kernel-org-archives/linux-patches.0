Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D7215B159;
	Tue, 18 Jun 2024 12:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714699; cv=none; b=HMGYXzKz7EHiMs7LbaUzcXIPZuffopuAbyXC2uQWuFHeQErTPPUFdTDiqANH9MsK1nXpTs9LQmrf6MNmKZB+NeOhSNTKLKu7Hk1ZwGPjaE44HE3+e2O38DBjkCjryJlLAFNsfvjhB9HZk0wqeKfJwLVwFjacyMKiDytBnXTnuxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714699; c=relaxed/simple;
	bh=TDFnmOYDPf8HtHQA+cN1wHFux5HmKn+QoSgFM2b47SE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AEUm6Hy/m1s5wt36LSt5xfxrIJRJmV/4ZErsrSLa4yZ2XMRID59i+9rfu79ZmRANLO6zR4tGWnpZav8btXutv7O8vBF0o+JAUTfcRJXJz8do51KUdyecmKPMxSMYKvsa5XDt6acSTz9YDV/6QrxbEydC0/5f0krUAXwPr/0mtEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SMmD3tO7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SMmD3tO7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1685C3277B;
	Tue, 18 Jun 2024 12:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714699;
	bh=TDFnmOYDPf8HtHQA+cN1wHFux5HmKn+QoSgFM2b47SE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SMmD3tO7aUuVNZ+vIDx3hmOu19qMeBx/Hl6TEWBzc7kO40Iu7aEL5CUd3SMbSRfxv
	 z/jtukmZEFbBEI8Up3X6d9kQvlAYZYBCeMIE83GqfDygnzLGFX3xY6Kx4QrE2mJpFC
	 9yMV6nETkGv5EFB8kvT610GcK85c991bouiRIfSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 058/770] NFSD: Replace READ* macros in nfsd4_decode_verify()
Date: Tue, 18 Jun 2024 14:28:31 +0200
Message-ID: <20240618123409.527339458@linuxfoundation.org>
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

[ Upstream commit 67cd453eeda86be90f83a0f4798f33832cf2d98c ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 057cc1579f9b8..231a2628e3e6f 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1370,20 +1370,27 @@ nfsd4_decode_setclientid_confirm(struct nfsd4_compoundargs *argp, struct nfsd4_s
 static __be32
 nfsd4_decode_verify(struct nfsd4_compoundargs *argp, struct nfsd4_verify *verify)
 {
-	DECODE_HEAD;
+	__be32 *p, status;
 
-	if ((status = nfsd4_decode_bitmap(argp, verify->ve_bmval)))
-		goto out;
+	status = nfsd4_decode_bitmap4(argp, verify->ve_bmval,
+				      ARRAY_SIZE(verify->ve_bmval));
+	if (status)
+		return status;
 
 	/* For convenience's sake, we compare raw xdr'd attributes in
 	 * nfsd4_proc_verify */
 
-	READ_BUF(4);
-	verify->ve_attrlen = be32_to_cpup(p++);
-	READ_BUF(verify->ve_attrlen);
-	SAVEMEM(verify->ve_attrval, verify->ve_attrlen);
+	if (xdr_stream_decode_u32(argp->xdr, &verify->ve_attrlen) < 0)
+		return nfserr_bad_xdr;
+	p = xdr_inline_decode(argp->xdr, verify->ve_attrlen);
+	if (!p)
+		return nfserr_bad_xdr;
+	verify->ve_attrval = svcxdr_tmpalloc(argp, verify->ve_attrlen);
+	if (!verify->ve_attrval)
+		return nfserr_jukebox;
+	memcpy(verify->ve_attrval, p, verify->ve_attrlen);
 
-	DECODE_TAIL;
+	return nfs_ok;
 }
 
 static __be32
-- 
2.43.0



