Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D740A17D89F;
	Tue, 18 Jun 2024 12:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715544; cv=none; b=YdBrYRzOVkvhgry4MaPs9ae2NA7JVwAc9ZCAqjM/GO6ClLgNJLvu1DgGALudJgDpVyVQpu2M18NB/DNpn26vzy3RPSbNE4OkzsReT18tRrXkBMGB+uo0qRk/OgkS1quLoU4xSL+EMwvy048+CswXH9/Tsx+n7HoGHoG4rEUgL+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715544; c=relaxed/simple;
	bh=SksUb0GE61VmsYNCmhOyYjSuoTu+zgNFjT9A980ZtZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oLp2RzzzcqwRol+Jn+L7mnwGDi9ItQ3DG7FKiHB2vE9dEWiBVSPIMrOlO5xtNhPskadD7LNBnQdd5xVPsTy8VEdSqsGqjpPSscqqcbqRE4828vMg3Ii8xtayfarcI7GKIo2X5I3brKrqsBHKpPlolQ1xvJKDS4YCwpviAXFGqEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FzmU+lYC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FzmU+lYC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53BE6C4AF48;
	Tue, 18 Jun 2024 12:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715544;
	bh=SksUb0GE61VmsYNCmhOyYjSuoTu+zgNFjT9A980ZtZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FzmU+lYC3ZHufNvZS5xHNMoXZGrRWNTmjqjkJDNDVElx8abzelWXyEQkyRl/jQpOz
	 J4tIbGgveyxB7CLtjFaTM+GnmyJTxtg8CyUgPXuq411kj0l/c8vpht7G2Jal2NJF4u
	 ctIL2jTfxdlAWw/5JDBGpP0mC9Fx769ZaSmo8DRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 313/770] lockd: Update the NLMv1 nlm_res results encoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:32:46 +0200
Message-ID: <20240618123419.339961616@linuxfoundation.org>
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

[ Upstream commit e96735a6980574ecbdb24c760b8d294095e47074 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/xdr.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/lockd/xdr.c b/fs/lockd/xdr.c
index daf3524040d66..4fb6090bc9158 100644
--- a/fs/lockd/xdr.c
+++ b/fs/lockd/xdr.c
@@ -349,24 +349,23 @@ nlmsvc_encode_testres(struct svc_rqst *rqstp, __be32 *p)
 }
 
 int
-nlmsvc_encode_shareres(struct svc_rqst *rqstp, __be32 *p)
+nlmsvc_encode_res(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_res_stream;
 	struct nlm_res *resp = rqstp->rq_resp;
 
-	if (!(p = nlm_encode_cookie(p, &resp->cookie)))
-		return 0;
-	*p++ = resp->status;
-	*p++ = xdr_zero;		/* sequence argument */
-	return xdr_ressize_check(rqstp, p);
+	return svcxdr_encode_cookie(xdr, &resp->cookie) &&
+		svcxdr_encode_stats(xdr, resp->status);
 }
 
 int
-nlmsvc_encode_res(struct svc_rqst *rqstp, __be32 *p)
+nlmsvc_encode_shareres(struct svc_rqst *rqstp, __be32 *p)
 {
 	struct nlm_res *resp = rqstp->rq_resp;
 
 	if (!(p = nlm_encode_cookie(p, &resp->cookie)))
 		return 0;
 	*p++ = resp->status;
+	*p++ = xdr_zero;		/* sequence argument */
 	return xdr_ressize_check(rqstp, p);
 }
-- 
2.43.0



