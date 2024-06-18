Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E8015F408;
	Tue, 18 Jun 2024 12:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715003; cv=none; b=c4IfpFJOaufTPFOIpYoQHH4lm02aOHJXGA+2eBF/5lracRdSZ9/fCYWiSIhwEycbOhp0yNuRotbyU/ZEgSHWGocw9p+ir0MoIwUJA2fsgEQrLz679pU4I/FZ1ZWOTlSWk7PYRhZr8G3UFkonF16/DI4YWc+YdbcAdYe3U6MjuUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715003; c=relaxed/simple;
	bh=5nv0+UrfCrh3/A1lyXkUIA5wfkpjl0fgR6+czQQknrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fVGQUlUJj1MPk/dJvn0V5DfT9keujXsG5uaYlyfcn7o3z7dwECkdbs7K/XAiPmWKecxvIfq+dzDsogtwJavOjuLBFWYj/XwTEXSQgJ0fQbwI+G0NV1MrtGgOB+u2byr/CwWoc/cdPmqlZyi0zvvPJNHyuPhdLyQkDwL7Gteu6yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=txhYgJAg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="txhYgJAg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97312C3277B;
	Tue, 18 Jun 2024 12:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715003;
	bh=5nv0+UrfCrh3/A1lyXkUIA5wfkpjl0fgR6+czQQknrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=txhYgJAg5mP11JZ1TLZ/1R2BGNzn4OPA1VwKhPLGu3moEu28oFSiTYUifY7SXymFi
	 w8k7+AdBsFLxIy8+8uyf5TCs99bt4rjJb4liFHS6isELqFwXYDpyr3fCMOtUcVR4Dt
	 73yWqF1GAHYID/9IpwWpqd2a7aqmz/6E/zYcnsGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 161/770] NFSD: Update the NFSv2 LINK argument decoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:30:14 +0200
Message-ID: <20240618123413.489842023@linuxfoundation.org>
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

[ Upstream commit 77edcdf91f6245a9881b84e4e101738148bd039a ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsxdr.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/nfsd/nfsxdr.c b/fs/nfsd/nfsxdr.c
index d4f4729c7b1c0..3d0fe03a3fb94 100644
--- a/fs/nfsd/nfsxdr.c
+++ b/fs/nfsd/nfsxdr.c
@@ -356,14 +356,12 @@ nfssvc_decode_renameargs(struct svc_rqst *rqstp, __be32 *p)
 int
 nfssvc_decode_linkargs(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_arg_stream;
 	struct nfsd_linkargs *args = rqstp->rq_argp;
 
-	if (!(p = decode_fh(p, &args->ffh))
-	 || !(p = decode_fh(p, &args->tfh))
-	 || !(p = decode_filename(p, &args->tname, &args->tlen)))
-		return 0;
-
-	return xdr_argsize_check(rqstp, p);
+	return svcxdr_decode_fhandle(xdr, &args->ffh) &&
+		svcxdr_decode_diropargs(xdr, &args->tfh,
+					&args->tname, &args->tlen);
 }
 
 int
-- 
2.43.0



