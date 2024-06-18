Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB5C50297;
	Tue, 18 Jun 2024 12:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714764; cv=none; b=On7mYCzh0+/+kOVxyGVY00pFg30Iv4JSZUQ1KP5pD09fLRK+l8g+EMD055oV2Ma96CN19cAASDfHXHSwUrXT+XO6EOm8Ds4CXD7RZtbC4g/AYy7Zpose5V3IJCFa0bnKFwGSTLCuGCQgqRlqhXTmcvMjcnZ4YXLvIYInf0kaUbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714764; c=relaxed/simple;
	bh=feV/t1F0jcJNEp06rh5yFg1FhrGBk1xGVf1LSVt4b1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u/xAkiiUT4eSPtfRza6flYKR8PEzixSiwrJDg0vcpDdC//XH20pVGz1qIVweLiV96ILY3kxwsgo7wLKUce6QfRrLGR5xB437ve1hQ+OzAmzAcqHy20vtBa+ny6kqrRs2FH3hfgl6od0YMHhcB0wUwXY2HIUWndzaiSxXFAN+cT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2qfQeR4E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2qfQeR4E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCBC3C3277B;
	Tue, 18 Jun 2024 12:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714764;
	bh=feV/t1F0jcJNEp06rh5yFg1FhrGBk1xGVf1LSVt4b1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2qfQeR4E6sXLXkHBQ/+HIHDUTxRHudwA5sC72D45eJNisOEPNsVN0zM73jP0kPj/W
	 DIYCobv26jBETUy0ZBAr3Y9ZEUevOeWDwjzGjHqu2CIYPefbacdaCwwz7TS5ErLNgf
	 noOPu90VJ96O7sMyPlcXGusS8r/bnSM/Q/SjbpyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 081/770] NFSD: Replace READ* macros in nfsd4_decode_fallocate()
Date: Tue, 18 Jun 2024 14:28:54 +0200
Message-ID: <20240618123410.408305443@linuxfoundation.org>
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

[ Upstream commit 6aef27aaeae7611f98af08205acc79f5a8f3aa59 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 2c684f7e74650..c8506bb6d8725 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1906,17 +1906,17 @@ static __be32
 nfsd4_decode_fallocate(struct nfsd4_compoundargs *argp,
 		       struct nfsd4_fallocate *fallocate)
 {
-	DECODE_HEAD;
+	__be32 status;
 
-	status = nfsd4_decode_stateid(argp, &fallocate->falloc_stateid);
+	status = nfsd4_decode_stateid4(argp, &fallocate->falloc_stateid);
 	if (status)
 		return status;
+	if (xdr_stream_decode_u64(argp->xdr, &fallocate->falloc_offset) < 0)
+		return nfserr_bad_xdr;
+	if (xdr_stream_decode_u64(argp->xdr, &fallocate->falloc_length) < 0)
+		return nfserr_bad_xdr;
 
-	READ_BUF(16);
-	p = xdr_decode_hyper(p, &fallocate->falloc_offset);
-	xdr_decode_hyper(p, &fallocate->falloc_length);
-
-	DECODE_TAIL;
+	return nfs_ok;
 }
 
 static __be32
-- 
2.43.0



