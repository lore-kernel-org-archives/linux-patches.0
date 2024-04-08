Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76FCB7BB1A;
	Mon,  8 Apr 2024 13:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584753; cv=none; b=BaIR0VfJ3gOi7uDa0BXbWxW0ksP4jMeQVoz+Bm0UQeDBxnWcEtvBl3UUqRMDTU+LuRX8NI9Ye7wvDnQ6n9EnOoReTf+qb23q1uO54fA/6wbDyPItGPcHBcer66KHtTgkaOq8ER7b3nj5Ys2CT4d9XaneMioA8omkjPvCvke4a38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584753; c=relaxed/simple;
	bh=I0LXOwe597XfoCLFFBc2DGy62Ws68OctWS0hfxYMH6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mOFttWFIdpyNdhsPRlScCuQY5+Uvm6Er/XW2PPEnX8b2ag1a4d14P4crfXjX7cI4ZgNmcV6eEr8Id74ih+DPDA4j+6WQFrO36aVCWbsHKkyN/haSC0b1cK74nCHU+mX1b0Jnmlid7JaU+59Tmrl06tjKOSHKdpBT0KychafruCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kj49y8+2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kj49y8+2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3DC4C43390;
	Mon,  8 Apr 2024 13:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584753;
	bh=I0LXOwe597XfoCLFFBc2DGy62Ws68OctWS0hfxYMH6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kj49y8+2mUSIdQdl1CcoL6nkoxjKTgunIW2SY2HNm3KVZWzHKMmcQYk6vboadtyzB
	 7XzJelj2TU3k4WES0ZIuyweUK28RcLdyTGxharuu+fDrjCdpJFl3+L/r/JCQiUsRcG
	 aK7Z6ZVXd+l9/H0B9orDdnhSUkJy+Fj6CPvT4bk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tavian Barnes <tavianator@tavianator.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 544/690] nfsd: Fix creation time serialization order
Date: Mon,  8 Apr 2024 14:56:50 +0200
Message-ID: <20240408125419.358165628@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tavian Barnes <tavianator@tavianator.com>

[ Upstream commit d7dbed457c2ef83709a2a2723a2d58de43623449 ]

In nfsd4_encode_fattr(), TIME_CREATE was being written out after all
other times.  However, they should be written out in an order that
matches the bit flags in bmval1, which in this case are

    #define FATTR4_WORD1_TIME_ACCESS        (1UL << 15)
    #define FATTR4_WORD1_TIME_CREATE        (1UL << 18)
    #define FATTR4_WORD1_TIME_DELTA         (1UL << 19)
    #define FATTR4_WORD1_TIME_METADATA      (1UL << 20)
    #define FATTR4_WORD1_TIME_MODIFY        (1UL << 21)

so TIME_CREATE should come second.

I noticed this on a FreeBSD NFSv4.2 client, which supports creation
times.  On this client, file times were weirdly permuted.  With this
patch applied on the server, times looked normal on the client.

Fixes: e377a3e698fb ("nfsd: Add support for the birth time attribute")
Link: https://unix.stackexchange.com/q/749605/56202
Signed-off-by: Tavian Barnes <tavianator@tavianator.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4xdr.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index c40876daf60c0..5b95499a1f344 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3365,6 +3365,11 @@ nfsd4_encode_fattr(struct xdr_stream *xdr, struct svc_fh *fhp,
 		if (status)
 			goto out;
 	}
+	if (bmval1 & FATTR4_WORD1_TIME_CREATE) {
+		status = nfsd4_encode_nfstime4(xdr, &stat.btime);
+		if (status)
+			goto out;
+	}
 	if (bmval1 & FATTR4_WORD1_TIME_DELTA) {
 		p = xdr_reserve_space(xdr, 12);
 		if (!p)
@@ -3381,11 +3386,6 @@ nfsd4_encode_fattr(struct xdr_stream *xdr, struct svc_fh *fhp,
 		if (status)
 			goto out;
 	}
-	if (bmval1 & FATTR4_WORD1_TIME_CREATE) {
-		status = nfsd4_encode_nfstime4(xdr, &stat.btime);
-		if (status)
-			goto out;
-	}
 	if (bmval1 & FATTR4_WORD1_MOUNTED_ON_FILEID) {
 		u64 ino = stat.ino;
 
-- 
2.43.0



