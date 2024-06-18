Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8767415AAD8;
	Tue, 18 Jun 2024 12:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714601; cv=none; b=Wff/gKSxZtuxEOOME8qaYlmrrP4EoZB0AfQa//lNgGl1QOoOUSRKW0iAJhKFllcqZr1xQ9wx4KRemQO2igMS3Zmak1iKmAmWADpXysoQyfcBH+c2jmJRcgJxv/Lcgh1PZ+NHNL5B7nDMoPDHl5T+22Gfs9MvPzqdoaMkFInQApA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714601; c=relaxed/simple;
	bh=jXbWI+WUZbHbXGgHgpp3MJrEvP0HCu+KF7Y4fYCMOR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jyYiJs2kfCTSh/BlHcV/w0qrNzP0Q3VZovBCrEMUE1iVW01t4FP7xECRAHYRkOAISZjwTG6mrqoq22RIO9XMk/UBkpye49cGlJrt47f7w3jE6ofKvaWkuT1kNMWg4I0jcfzLzrTjV9ZmZDzTGc7yNNT4P9rIWgyLqvIjJYRgplQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SmWDe2hk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SmWDe2hk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F416C3277B;
	Tue, 18 Jun 2024 12:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714601;
	bh=jXbWI+WUZbHbXGgHgpp3MJrEvP0HCu+KF7Y4fYCMOR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SmWDe2hkBSNx6qP4jWMcY1KjNmjA9eZaLG78/TUyvsu5nkSt3gAxo/vFuxt2WemD1
	 FHqbEZaF5GbX82QEM2erg4ixmN1lBN1rLsCEtlceQu1NcsIbMihUJ5S535zsm1Kxz8
	 /OKezPHXo78a+NJhy9BF9V5D89isfbfgPoZlRSGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 025/770] NFSD: Replace READ* macros that decode the fattr4 security label attribute
Date: Tue, 18 Jun 2024 14:27:58 +0200
Message-ID: <20240618123408.267906746@linuxfoundation.org>
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

[ Upstream commit dabe91828f92cd493e9e75efbc10f9878d2a73fe ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 46 ++++++++++++++++++++++++++++++----------------
 1 file changed, 30 insertions(+), 16 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 09975786e71b2..453a902c7490a 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -324,6 +324,33 @@ nfsd4_decode_acl(struct nfsd4_compoundargs *argp, struct nfs4_acl **acl)
 	return nfs_ok;
 }
 
+static noinline __be32
+nfsd4_decode_security_label(struct nfsd4_compoundargs *argp,
+			    struct xdr_netobj *label)
+{
+	u32 lfs, pi, length;
+	__be32 *p;
+
+	if (xdr_stream_decode_u32(argp->xdr, &lfs) < 0)
+		return nfserr_bad_xdr;
+	if (xdr_stream_decode_u32(argp->xdr, &pi) < 0)
+		return nfserr_bad_xdr;
+
+	if (xdr_stream_decode_u32(argp->xdr, &length) < 0)
+		return nfserr_bad_xdr;
+	if (length > NFS4_MAXLABELLEN)
+		return nfserr_badlabel;
+	p = xdr_inline_decode(argp->xdr, length);
+	if (!p)
+		return nfserr_bad_xdr;
+	label->len = length;
+	label->data = svcxdr_dupstr(argp, p, length);
+	if (!label->data)
+		return nfserr_jukebox;
+
+	return nfs_ok;
+}
+
 static __be32
 nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
 		   struct iattr *iattr, struct nfs4_acl **acl,
@@ -332,7 +359,6 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
 	unsigned int starting_pos;
 	u32 attrlist4_count;
 	u32 dummy32;
-	char *buf;
 
 	DECODE_HEAD;
 	iattr->ia_valid = 0;
@@ -440,24 +466,12 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
 			return nfserr_bad_xdr;
 		}
 	}
-
 	label->len = 0;
 	if (IS_ENABLED(CONFIG_NFSD_V4_SECURITY_LABEL) &&
 	    bmval[2] & FATTR4_WORD2_SECURITY_LABEL) {
-		READ_BUF(4);
-		dummy32 = be32_to_cpup(p++); /* lfs: we don't use it */
-		READ_BUF(4);
-		dummy32 = be32_to_cpup(p++); /* pi: we don't use it either */
-		READ_BUF(4);
-		dummy32 = be32_to_cpup(p++);
-		READ_BUF(dummy32);
-		if (dummy32 > NFS4_MAXLABELLEN)
-			return nfserr_badlabel;
-		READMEM(buf, dummy32);
-		label->len = dummy32;
-		label->data = svcxdr_dupstr(argp, buf, dummy32);
-		if (!label->data)
-			return nfserr_jukebox;
+		status = nfsd4_decode_security_label(argp, label);
+		if (status)
+			return status;
 	}
 	if (bmval[2] & FATTR4_WORD2_MODE_UMASK) {
 		if (!umask)
-- 
2.43.0



