Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB47931E823;
	Sat, 12 Sep 2026 19:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240945; cv=none; b=buj6sYPKDSkJao4sx3xMUosgKznWGRfYc86g4BXyLkXKIvA8Ai7Z0NaV0pnDeGqfv3gZknsAyk/tQpPEFqfqsR8BupGMvWJuqO12tOi81IPs8Mvpw/hPjboqqQd89Zf4NoiMHIm1W6AckhiycLmLWdSIU09ovYaMlk25abvl6Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240945; c=relaxed/simple;
	bh=DQdsZHX05c0H1D1BA6xM0fme/gfq7b4fbkl7plzEllQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OD3CpM3aWR5f6x/r9UG4LXPLlQl+lZJA/WPbx9ZkR7kCuOFRbqNzJSMAdjQbECaJ3GOnCOg1Jep3J287W5VJIJgFfeTzADs4057h9QzjBTPDU/KVjW6LPdRV5APXSli+SgUqeDo0xmyAJA4SIGklMaID42UU3DmoZcqgb3U1yQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bsjXdGWN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bsjXdGWN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B27381F000FF;
	Sat, 12 Sep 2026 19:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240944;
	bh=QOugPWVJ6hNWpz1M4Lo0jpz1HUYgvjNrLYJUiWW17Z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bsjXdGWN+4fzo+d2eZgiLBG5V/2jXPVYEmVAAw3K6JnoYkerqQm3Z/NQa0dat5DYR
	 Lr3MySeAIBTzDwgAHhoXtZVAsI/gEi6AIzkvm+l/YqYH/X8sO7x83JIyBywNecNDdb
	 PxkoY5iqjX6fSln+eGAU402pufaZDuFx62WX6FkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.10 035/798] nfsd: validate symlink target length in NFSv4 CREATE
Date: Sat, 12 Sep 2026 08:54:23 +0200
Message-ID: <20260912065517.766601925@linuxfoundation.org>
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


