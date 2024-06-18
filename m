Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B5D913B5B8;
	Tue, 18 Jun 2024 12:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715257; cv=none; b=bMENGFZJA/0zatRDKT5DCltk59guSZa0M5DHNhmsYkhQSTDESwKcnIlLI8VX4QVlEDwfe8tw0KWxzif00oBOxODpAty4ZnNFBfJgwePjQuZdZvGez6fLvTjTatDU6pJYOlONGP5WQK2OzxMnz0ZvqDXk8cerkCdCRl13f6PfgWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715257; c=relaxed/simple;
	bh=iLWx9jatmfORFO0rOqxrk+gtaNlFtqnXP0ob+7q65SU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YyG9TBlkxi8qfNq1joSaM5ZUcWoGyyYDt1arrpgOUBQ15qcaOtt9GakaFI8kFnsgywUWKNEOtyyk6QeySTgO7lZBD+LEEgkx9nDYm/7dBsLU0E4r4JMLVGFW5IjdFnF4qZVrRf+YzUuuvUfeeCJLm4VfVZzRBs89j9OucvB1aQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RRG1vdvC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RRG1vdvC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A765C3277B;
	Tue, 18 Jun 2024 12:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715256;
	bh=iLWx9jatmfORFO0rOqxrk+gtaNlFtqnXP0ob+7q65SU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RRG1vdvC/fmjTOL7yguIONhoBSukZOgWvQpiF4X+ZDW2/cFoZGPwP/HA/O0LXF24x
	 qaR0pYhbZe2aBqa5DeyOz8oTBR1pzRyqmPHMDbwCWGjJ62FP15Cld9s3LNTRus+kvS
	 8FdIFBymyHK3zyPAvqedq5fap9lihMqGSYARZIjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 206/770] NFSD: Update the NFSv3 RENAMEv3res encoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:30:59 +0200
Message-ID: <20240618123415.228781248@linuxfoundation.org>
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

[ Upstream commit 89d79e9672dfa6d0cc416699c16f2d312da58ff2 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3xdr.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 052376a65f723..1d52a69562b82 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -1116,12 +1116,12 @@ nfs3svc_encode_createres(struct svc_rqst *rqstp, __be32 *p)
 int
 nfs3svc_encode_renameres(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_res_stream;
 	struct nfsd3_renameres *resp = rqstp->rq_resp;
 
-	*p++ = resp->status;
-	p = encode_wcc_data(rqstp, p, &resp->ffh);
-	p = encode_wcc_data(rqstp, p, &resp->tfh);
-	return xdr_ressize_check(rqstp, p);
+	return svcxdr_encode_nfsstat3(xdr, resp->status) &&
+		svcxdr_encode_wcc_data(rqstp, xdr, &resp->ffh) &&
+		svcxdr_encode_wcc_data(rqstp, xdr, &resp->tfh);
 }
 
 /* LINK */
-- 
2.43.0



