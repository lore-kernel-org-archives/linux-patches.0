Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00EA382292;
	Sat, 12 Sep 2026 19:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240937; cv=none; b=ksyl+x4BHUrEc/c93owHvmezhQBUp0XgEi3b0n21zuxpu4eQJdG7Jf9O52bWWEEVtIeNNOh2vePmyqXvH0Dd9kKsaRkVW82suLVvgNnktbSiwQSVcZVFroQ/bbittZAVz1adDUxf1e4JTRfYZ0GV2qsVjU/EZyQIOLZP97tWxXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240937; c=relaxed/simple;
	bh=Uw89IOwyPPg11QGRLozblAQUG3C9FXJyTj2VYm8VdHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I8+yLeqNgz0/gfYZ8SbzxuPcHGc/ymXSsN171X8inR5V9AzEhL/EH4nqMzSBxPpc83nsYiLQJBbiDi2YR5h0jnhmOffHXA4JLM7Go71cxYC2DrBPTIyEhCHajTfM5+DlZ+735F9vdy2UU5DA7g5JDFZQe+c2BmOAn42veLcGaIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p2pQJ3zx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p2pQJ3zx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D69191F000FF;
	Sat, 12 Sep 2026 19:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240934;
	bh=d5/oR7XKmHlSTGxvZvK9cXnnVilQ0ONQsQz+i/Cszso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p2pQJ3zx/ff+Kbk4zhkwjCuUXEhU1quKDmy2H10VGYDrG+ihsXiqFwu8c4akv1b6v
	 /RETlt/aTQTkKgrDYkneTwX3F/fR6PqSmEW5ABEoWJ/olJrLxSWl7Jw2ZfWxQyE5rC
	 UDyi4K8stBOat14cwkV6OZCmlQf6qPKVfb1nXg0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 5.10 033/798] nfsd: return NFS4ERR_NOTSUPP for unsupported netloc4 types
Date: Sat, 12 Sep 2026 08:54:21 +0200
Message-ID: <20260912065517.720383772@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1918,6 +1918,7 @@ static __be32 nfsd4_decode_nl4_server(st
 {
 	struct nfs42_netaddr *naddr;
 	__be32 *p;
+	u32 str_len;
 
 	if (xdr_stream_decode_u32(argp->xdr, &ns->nl4_type) < 0)
 		return nfserr_bad_xdr;
@@ -1947,6 +1948,18 @@ static __be32 nfsd4_decode_nl4_server(st
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


