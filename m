Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA1F47DFBF;
	Sat, 12 Sep 2026 13:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219843; cv=none; b=L1dMeVtIpMdPRbQZ9w3ygyyY2o9gkx4ImG4xWSioqv1l/9IQGyd8YW95H2TzXRHy1HU8Gf4W1I/O2TzrUcWuRVoAaYBFDGKwah25pw64AfJCRwTZITSPq2BBOS6N9IuV7E4DfGp5x4XZD6WrUe5xjCZiqNJU5ZfzuOlJg85QelA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219843; c=relaxed/simple;
	bh=rvu2/8+QF1p9Jl+Z72AhHEeb/STVu5nA6IBIazI8xuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JHcbU6boNukbzEkzUas8Z7DRh1tljV5R4h9yZuzJ92IX4EHyM8OeViGtXBU+Hm7xrfI5gCM1vTodZAFwv0VOxZ6XTA/wYvMRRoNVMoykeisSu2CRq//ycpGaHWJ7ZLPzYZO0PuobA7fG8MWnUM4eTDzGrAl6cAvLim9krZ5tJTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mnV4xeJG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mnV4xeJG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EDD61F000FF;
	Sat, 12 Sep 2026 13:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219842;
	bh=6USDRgFSVG63X8gPRZvXlzkDbrw33TJLBhIB6XCozZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mnV4xeJGSnNy3AAg63TWBAs6jl3huxZFtqa83JDB0Xfoij90rCGtWSCpaf3kZ4zdE
	 SJBN1ikDCKAHt07V9cO6uy+8AQLKb2wv2kAWD9RjAILT4A6P0rcf08tzFgaPYn/vKi
	 Nen7gJVIMDg6L3vceG4X0RKOUMsaWELXmNgOxBNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.6 0055/1424] nfsd: validate symlink target length in NFSv4 CREATE
Date: Sat, 12 Sep 2026 08:41:27 +0200
Message-ID: <20260912065608.534246298@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


