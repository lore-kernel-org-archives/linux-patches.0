Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A40715B541;
	Tue, 18 Jun 2024 12:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714702; cv=none; b=jj2I+HPrh9pKs0KN1Htke2oFoBTmG15ApUyZqLwqjVxNvZBgbV98PQt5yQ4yGFeXyRge/uvynwcK9lvNUPBPhYKlJhK7dNUQ7SlrVXc49YTmBnuZ53c3CkkdibBeJLsvbZvlepEQw/YQYLDmvBgBP82ejeMqhEMgPTjxAZlr64M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714702; c=relaxed/simple;
	bh=5UukM0VgHob3iYHMoAkjWIi8RkmS5N2X5bvZickLwNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BFryZrF3jTxwr3VX5XAXnDzFb2rgnKby4ymiQgobdDx9ChQHoaOtPF2SWesagw52uGVPZdctwyX5jFg7jRGjfyC2YxHJ2aKQKfLIrOyoKBZ/R+K4grvmbaP7J6CIXeWj/gGYzdwPbiAWbcdN/ItEaoIRQZ+OMMtg+7sOjmQYaKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q0O8cfiS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q0O8cfiS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE774C3277B;
	Tue, 18 Jun 2024 12:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714702;
	bh=5UukM0VgHob3iYHMoAkjWIi8RkmS5N2X5bvZickLwNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q0O8cfiSKDAntgco7AGjMJk5cyVSHjLB9YEBSS8cBLyha+7gpQ3P6anLiTnbPYDrM
	 fD0KA9AWATc1MFy+fbYi9taQfcJPWsUD6fO53q2YVlBe2+kTEvwolu/LFsxvMV6aK0
	 AU9g/7Im89AXbFl6eO28dudcdlOmxDS2l/RHbamA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 059/770] NFSD: Replace READ* macros in nfsd4_decode_write()
Date: Tue, 18 Jun 2024 14:28:32 +0200
Message-ID: <20240618123409.564597778@linuxfoundation.org>
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

[ Upstream commit 244e2befcba80f42c65293b6c56282bb78f9f417 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 231a2628e3e6f..26744b7f0e35c 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1396,22 +1396,23 @@ nfsd4_decode_verify(struct nfsd4_compoundargs *argp, struct nfsd4_verify *verify
 static __be32
 nfsd4_decode_write(struct nfsd4_compoundargs *argp, struct nfsd4_write *write)
 {
-	DECODE_HEAD;
+	__be32 status;
 
-	status = nfsd4_decode_stateid(argp, &write->wr_stateid);
+	status = nfsd4_decode_stateid4(argp, &write->wr_stateid);
 	if (status)
 		return status;
-	READ_BUF(16);
-	p = xdr_decode_hyper(p, &write->wr_offset);
-	write->wr_stable_how = be32_to_cpup(p++);
+	if (xdr_stream_decode_u64(argp->xdr, &write->wr_offset) < 0)
+		return nfserr_bad_xdr;
+	if (xdr_stream_decode_u32(argp->xdr, &write->wr_stable_how) < 0)
+		return nfserr_bad_xdr;
 	if (write->wr_stable_how > NFS_FILE_SYNC)
-		goto xdr_error;
-	write->wr_buflen = be32_to_cpup(p++);
-
+		return nfserr_bad_xdr;
+	if (xdr_stream_decode_u32(argp->xdr, &write->wr_buflen) < 0)
+		return nfserr_bad_xdr;
 	if (!xdr_stream_subsegment(argp->xdr, &write->wr_payload, write->wr_buflen))
-		goto xdr_error;
+		return nfserr_bad_xdr;
 
-	DECODE_TAIL;
+	return nfs_ok;
 }
 
 static __be32
-- 
2.43.0



