Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A0147ACF6;
	Sat, 12 Sep 2026 17:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232782; cv=none; b=Z6ReuuxhlSwcUnXgtru/BCsTuUWF0vyeVm2t4tVArYWODNRD3i/aTSRcOLjMrJWHLVGZlT8RPdAg2EKbolhIwEWfNhWi+ETtoiVuX/PjXjNkZZmR98aK0oqTvzv+0dzNTN8jAUIabF5yRZa8EIYKxVD6jp+bukSCqjn0xsthnWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232782; c=relaxed/simple;
	bh=hYLDX18V+gVEBIKwSa4XylsQPYUtVXSd2UCRO+by3u0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r7KHMQkHLJbfg6MD24+4TWL0vkqM3+Z3JGAL+rk9m9sP5GC9Hn5K9yVhfkXkO/U6lPimMbg92XI5p0AJG3cB/a4WvWm519zAeHA3k32i+7LDxgxj7MS3hvJaPuAGVmX9Uy9JWh0KAZhSRBQ1qxUt9c2X+i8jc0eq/ch+NkhTAr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ybGcpiUx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ybGcpiUx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D5F31F000FF;
	Sat, 12 Sep 2026 17:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232780;
	bh=5d4CNrRKo9G21TgIBAzOMrGLfJFG8axn3O1sDKvxUJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ybGcpiUxH4bigBn6StxBgqXaHWJff4gfSQFU5S3RcDC+yA2/F1AD3xQOwYMN3pp/Y
	 423QAs6VQY/G+u6eFUd/M+FRtVetFqWYe/bPyJmPw4W0U9bt21TjDnoHyZIUCA5r5x
	 hzgpxPmPIFI3GZ5s4rlDkYNK9X6E24AbSKfIlJ0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 5.15 037/935] nfsd: return NFS4ERR_NOTSUPP for unsupported netloc4 types
Date: Sat, 12 Sep 2026 08:51:07 +0200
Message-ID: <20260912065527.690876565@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


