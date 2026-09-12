Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1F347D47A;
	Sat, 12 Sep 2026 17:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232578; cv=none; b=tsTRa65v6RtuZI+gtxrKvNSvXRAjTCI3JzyFQ1ExUZJBV7195Pam81ajlf5RbTDDiIW04cIh57DkBizyxl0EvlgLZT0jtR3hdrA8QqQY+y3PkWLolF1zCQ6ChygK1HrUHRWTt703vDDMpvm+4nLjwl1MpNLfqb7wzfRtNW1Ejds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232578; c=relaxed/simple;
	bh=Okvry7e3qyZp9UkjJ64JMUIBTs9i1YRijBwefyLo6z0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LZVJfXprKuV7JoPuokpa+Ve2OnViAG4rkyi+VJaa1LfeInYpSj/6SYlxgLiz8I99NCpKSZphkRnzwue3EnAY+J1D7HL1UZGoIK7ggItVTf8BIuymiWeB6YhtyKJ3X+AAxjy6q3KW5YjqZwi03f0rGZHClp9x4WrTGs7zg2X25zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PeVMzLg2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PeVMzLg2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE0B11F000FF;
	Sat, 12 Sep 2026 17:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232574;
	bh=fwulpXhCdPRMcmL3lx8i1xtUcC1uSYTMvNaKu89anHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PeVMzLg2VgUw6+8MmIyNEHUybHGrvnhsgBA9e7EjTAecXwJFiSlsfcatpP2YtwXW3
	 AOY+eLl6NdjH7s8TZS19exnKy9si/ZwZaX5deMhbroIziDy3PSax9TOhMfApfcx2hM
	 E+H/v34iZX95V7LXfSUDJKhk85kdBO1j17fiCUJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 039/935] nfsd: validate symlink target length in NFSv4 CREATE
Date: Sat, 12 Sep 2026 08:51:09 +0200
Message-ID: <20260912065527.735681727@linuxfoundation.org>
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

commit 041f57056e5fb9c80adc088269322d2c61074406 upstream.

nfsd4_decode_create() accepts an unbounded cr_datalen from the wire for
NF4LNK symlink targets, allowing a client to force a kmalloc of up to
the maximum RPC payload size (several MiB) per COMPOUND op that persists
until compound teardown.  The VFS rejects oversized targets with
ENAMETOOLONG, but the allocation has already occurred.

Reject cr_datalen == 0 early with nfserr_inval and cr_datalen greater
than NFS4_MAXPATHLEN (PATH_MAX) with nfserr_nametoolong to bound the
allocation.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Assisted-by: kres:claude-opus-4-7
Reported-by: Chris Mason <clm@meta.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260530-nfsd-fixes-v2-9-f27e8eb4d974@kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4xdr.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -801,6 +801,10 @@ nfsd4_decode_create(struct nfsd4_compoun
 	case NF4LNK:
 		if (xdr_stream_decode_u32(argp->xdr, &create->cr_datalen) < 0)
 			return nfserr_bad_xdr;
+		if (create->cr_datalen == 0)
+			return nfserr_inval;
+		if (create->cr_datalen > NFS4_MAXPATHLEN)
+			return nfserr_nametoolong;
 		p = xdr_inline_decode(argp->xdr, create->cr_datalen);
 		if (!p)
 			return nfserr_bad_xdr;


