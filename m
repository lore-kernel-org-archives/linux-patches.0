Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A92533FE09;
	Fri,  4 Sep 2026 05:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498711; cv=none; b=Dhwx+GWwpvNkNxy2k4WVXb2toq7ctXH03b7knP1QMuZdumFziXTx8dW1Uc0Er19eRzv+lHKPgrkB57Nv09yx20PE3PWtUTWqGgYGBDu9YzUPVbsRsTlz098XaaPGSKa+cm7ZEPk06YOx0tG0TpqN2tQjuy1YO1iy2RUCBViUhOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498711; c=relaxed/simple;
	bh=Pi+RmRptqvmHUTTbQD5oXFrvE6GL+rexKEwQMp3p4lE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MYJxL3MkdGTVRWzTxElEAFuum1dFHrzzZ7FIv2gPZedFS7lPv9TxJd6tE9XL/68Hfao/JBGJ1a3IG2ielFBcJUclGzjH5kdoARzB7ksX3yHgQva9Jh5lK0Ak3wrgVO+/h/7Sk3E8/HpI6i8sRxeEruxW5JE0S7a2tHNywl3Xrg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hsRayw1t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hsRayw1t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 024391F00A3D;
	Fri,  4 Sep 2026 05:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498708;
	bh=il7cvjeecm6kTtwzrC1uBkByOZpvUbaMBaJ6oe1Ndng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hsRayw1tXHQOnST28pqyDgUthXjZofDWppc4uzB1pS5BCUNHfGKnUxri+q27n+yqv
	 Buq4Wu/tjT/j1IPEyxmUa1Or8UKnsuCX9TSet2FhEO/B6Mblk11zgCjnDDZ5Aug6Dj
	 6v8Ks79cVkm/IIH2I2aWqt6sEjRSU7Bcqzt21gfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 7.2 158/713] nfsd: validate symlink target length in NFSv4 CREATE
Date: Fri,  4 Sep 2026 06:52:06 +0200
Message-ID: <20260904045807.367594458@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -959,6 +959,10 @@ nfsd4_decode_create(struct nfsd4_compoun
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


