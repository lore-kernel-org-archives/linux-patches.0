Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1B713E022;
	Tue, 18 Jun 2024 12:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714672; cv=none; b=NiEjiySrA1Kp+UxE7B+Um7i3QXDrcdqTDBmYteGdFB7eiYPoe2J7etUFXGMz4Lbsx16B839P78xpgwy4Ft+EWA6nt9IYANLNnZd65LJtxYdNWrQmS3Nq6dergHbt+ib3n2Pfum/wNRdSOiDpRhdVQ95CvUYgtV2dBl2EEbV0yMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714672; c=relaxed/simple;
	bh=ukRtv34gUYYGSlO49k0VQr4ttkAcIFTbyePuwwhapXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JCz4V4Ut3dl38PEiGjS81lCqQoPyDK/tcSZyWMqyqFl9Cr2KaQIWDEq/fwvORFeWKkxy0WUHpxs6vS/CenCPaOob9KbR+8udNCFwKfy1MwLDJLcuIFAOFPd762bXbC4n4eoOtSUCOTY89cjhVVb0qwOZ9sbwKNuD9IID7ddTjko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=164CI6j7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="164CI6j7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BC9DC32786;
	Tue, 18 Jun 2024 12:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714672;
	bh=ukRtv34gUYYGSlO49k0VQr4ttkAcIFTbyePuwwhapXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=164CI6j7XoZNm/viLybvc/I/yXorO2afaDwSqavDyvs552cM4frYz7wdzh4F8KWhJ
	 hR8ci8vYXsSUDrzfenCMmX1arJ03t2ZQmMZ0uxsuul1DRplrPi1mykhSxMmBf8kQ2y
	 4SMcP7OR88Grn9TBmS0pYN0TZMCWLkU4ldN4+4ws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 050/770] NFSD: Replace READ* macros in nfsd4_decode_readdir()
Date: Tue, 18 Jun 2024 14:28:23 +0200
Message-ID: <20240618123409.221970831@linuxfoundation.org>
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

[ Upstream commit 0dfaf2a371436860ace6af889e6cd8410ee63164 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index c9652040d748b..6036f8d595efa 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1234,17 +1234,22 @@ nfsd4_decode_read(struct nfsd4_compoundargs *argp, struct nfsd4_read *read)
 static __be32
 nfsd4_decode_readdir(struct nfsd4_compoundargs *argp, struct nfsd4_readdir *readdir)
 {
-	DECODE_HEAD;
+	__be32 status;
 
-	READ_BUF(24);
-	p = xdr_decode_hyper(p, &readdir->rd_cookie);
-	COPYMEM(readdir->rd_verf.data, sizeof(readdir->rd_verf.data));
-	readdir->rd_dircount = be32_to_cpup(p++);
-	readdir->rd_maxcount = be32_to_cpup(p++);
-	if ((status = nfsd4_decode_bitmap(argp, readdir->rd_bmval)))
-		goto out;
+	if (xdr_stream_decode_u64(argp->xdr, &readdir->rd_cookie) < 0)
+		return nfserr_bad_xdr;
+	status = nfsd4_decode_verifier4(argp, &readdir->rd_verf);
+	if (status)
+		return status;
+	if (xdr_stream_decode_u32(argp->xdr, &readdir->rd_dircount) < 0)
+		return nfserr_bad_xdr;
+	if (xdr_stream_decode_u32(argp->xdr, &readdir->rd_maxcount) < 0)
+		return nfserr_bad_xdr;
+	if (xdr_stream_decode_uint32_array(argp->xdr, readdir->rd_bmval,
+					   ARRAY_SIZE(readdir->rd_bmval)) < 0)
+		return nfserr_bad_xdr;
 
-	DECODE_TAIL;
+	return nfs_ok;
 }
 
 static __be32
-- 
2.43.0



