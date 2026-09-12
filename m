Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9DE2D8364;
	Sat, 12 Sep 2026 15:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226781; cv=none; b=UH8aszajAD1H80//F3P0LJMcHoLJpnGJ2rXPcmYquTdVLhY8v/MUJ8vcBPtUBYzipwg2/zVzvOcaNFzafM2aY8NcUsXYtuxz4y5vYdqi1CiIoW43YMqH+ArHe7+2uHFL1JA1XdsNTR1U1SiQ6wfXemVMchc/7z4Avqu6sUzOQr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226781; c=relaxed/simple;
	bh=qeyKJmSlrcUnAQmEqxRuiRuVXG5jDEO9IVChNgPEEl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NlAPgi32O/mXpaTBANx+thjHUck/PXezh3xHhMzv/L+tVGjGoaWfoFxbjXS2I19AiWI9Kebm489dcsJtpk0lzwg3Y4NGIf0PCez2dEpki6m8EW50UswG9YrQMOncl6OVUcvDMIQHbfGPSCNID2usT3FsHJ5GKItZoU+EQmzuqK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=chNWGQ7v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="chNWGQ7v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D8751F000FF;
	Sat, 12 Sep 2026 15:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226779;
	bh=109nm7p/hXOYmebL0B/GnGJ6MF2zQ8ux8XtI/O6GNb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=chNWGQ7v6thUPLosDOGfXq2XYIMjRhz+mD4utdOGqx0MNc+uLQAKbvuhxeIREh5FA
	 N0vRCTTuFvw+v0qcQmhUaB08k5PpHzoy6god+eRKHMu6CUeYdyshUo8LXRDM1JUwyX
	 vAaIf2BrDoRcSURAiSwKuTL5k5DWTSEp1QqRZTuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 0046/1191] nfsd: validate symlink target length in NFSv4 CREATE
Date: Sat, 12 Sep 2026 08:46:14 +0200
Message-ID: <20260912065549.174015932@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


