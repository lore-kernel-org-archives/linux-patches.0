Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CDFC36B07C;
	Fri,  4 Sep 2026 06:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502072; cv=none; b=mIrzI+t+OUAijIImo9m3pXxj3BbLbkyDN606rm3OZDrSIis7zg/Sxk0o1aJb9tHeaYwdZ3dl5MQfAmN4SHVZIBEKYZFoTPzDMPfKLqqr3bwEKyRhgCyJbJ36K5o7hKRAlmfJiODzYAf4IfQdSjGQShidEb3qSMwowzks/m1Hqzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502072; c=relaxed/simple;
	bh=0I3YmrLe/baajDO9egWBaxpU5uMhd/jn2+xdkvyGsxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A5P066EYvwKrYTAc9PkzMDpT/w1t9ay4zpfIe5zSsaVATN0Y48bikvY9bCpTgAmyCO6pSRawtqWF7ZkuFsxDe1UBzlZWtlF9CmEKvzsgupFcoptN3lbOunhiotu4VHr2w2UPG1kwQEiDhjep2uTgD+IXX/optuBm/7HcTm36uRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TTkQ6/p6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TTkQ6/p6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 950901F00A3D;
	Fri,  4 Sep 2026 06:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502071;
	bh=Mn5OHXwckZ0FHaCe3D5x5A8PG5NB94ZIWmO8klfLr/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TTkQ6/p6hjKGi8nw3mw6h4hetThPe5+5q78waZTNERHkNkNGx55VJJ0BGqMp3edmL
	 Ra0fysGGuRpIPJoOUmPQbay0KHNAH2yBgACR1pOMAjpCLk1tLEjd+J0aX/Apktw28D
	 I43Vjf1LOGvA7pArwDuGOqmQ5hu/5oDm3yDJkZbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.12 078/403] nfsd: return NFS4ERR_NOTSUPP for unsupported netloc4 types
Date: Fri,  4 Sep 2026 06:58:01 +0200
Message-ID: <20260904045736.605944599@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

commit 45b06a75086f331f52cbb81223a59421d43f8809 upstream.

nfsd4_decode_nl4_server() handled only NL4_NETADDR and returned
nfserr_bad_xdr for NL4_NAME and NL4_URL. Those forms are well-formed XDR,
so BADXDR is misleading -- the request is unsupported, not malformed.

Decode and discard the utf8str_cis for NL4_NAME and NL4_URL to keep the
stream consistent, and return nfserr_notsupp. nfsd4_proc_compound() honors
a decode-time op->status, so the op fails without executing.

Fixes: 84e1b21d5ec4 ("NFSD add ca_source_server<> to COPY")
Cc: stable@vger.kernel.org
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260710-nfsd-testing-v3-7-a0ff7db6aa3e@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4xdr.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1946,6 +1946,7 @@ static __be32 nfsd4_decode_nl4_server(st
 {
 	struct nfs42_netaddr *naddr;
 	__be32 *p;
+	u32 str_len;
 
 	if (xdr_stream_decode_u32(argp->xdr, &ns->nl4_type) < 0)
 		return nfserr_bad_xdr;
@@ -1975,6 +1976,18 @@ static __be32 nfsd4_decode_nl4_server(st
 			return nfserr_bad_xdr;
 		memcpy(naddr->addr, p, naddr->addr_len);
 		break;
+	case NL4_NAME:
+	case NL4_URL:
+		/*
+		 * Well-formed XDR, but only NL4_NETADDR is supported. Consume
+		 * the utf8str_cis to keep the stream aligned, then return
+		 * NFS4ERR_NOTSUPP rather than the misleading NFS4ERR_BADXDR.
+		 */
+		if (xdr_stream_decode_u32(argp->xdr, &str_len) < 0)
+			return nfserr_bad_xdr;
+		if (!xdr_inline_decode(argp->xdr, str_len))
+			return nfserr_bad_xdr;
+		return nfserr_notsupp;
 	default:
 		return nfserr_bad_xdr;
 	}


