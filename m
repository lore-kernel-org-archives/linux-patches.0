Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8C1155A56;
	Tue, 18 Jun 2024 12:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715502; cv=none; b=pvK7vmNbCz/EDNxPGbRPXmRIM9jEyokERMtRHyQy43NoIZY1ms8zGW2ZPsuWLYmYvG073olVlVHABlTPIhlEIQSdVZzPzLeIAda36WtPSEy/PZ0BOl7XS554zMwfjfAHYMtHKrmUEmxh2bR76gMdGjhfAtj9Qd/JQmNwUtSgU3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715502; c=relaxed/simple;
	bh=TedJFpeddxZhpGwOcBG1uOIKduhQv8Bc7L7NiXbcgiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hqQCQByxPcHorc/2yxgWQXT5ZsFL6toRp8ZcYwVx+CM9HLMaZO3fZC27in2vAd4HOfOXAYG/CagHP2L2fy83orPO10dxpZCkPYtcqhSUAPYAXOu7VCWJwZmV6e9sIzavsUCKZOGDJwokYq/eo5elSak1KHuW6bgU6XEXVVg0Y0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J3FIZELs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J3FIZELs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24554C3277B;
	Tue, 18 Jun 2024 12:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715502;
	bh=TedJFpeddxZhpGwOcBG1uOIKduhQv8Bc7L7NiXbcgiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J3FIZELsuAu9+xF3vUusUwEiajrWRMzAHDxAP4WEkVgzY1/2zNGMZKVj16Q3Z511p
	 X6N6hbZMkECWebvdRac5xC4RE+MZj8wUibR8UiPRTU5pPE3fsEC1QqApFpeiLSX9vF
	 k44VtWcPr1X7hMjXDkd6hUrcAeChYgMZeNMJLaQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	JianHong Yin <jiyin@redhat.com>,
	Chuck Lever III <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 330/770] nfsd: fix NULL dereference in nfs3svc_encode_getaclres
Date: Tue, 18 Jun 2024 14:33:03 +0200
Message-ID: <20240618123420.007672609@linuxfoundation.org>
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

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit ab1016d39cc052064e32f25ad18ef8767a0ee3b8 ]

In error cases the dentry may be NULL.

Before 20798dfe249a, the encoder also checked dentry and
d_really_is_positive(dentry), but that looks like overkill to me--zero
status should be enough to guarantee a positive dentry.

This isn't the first time we've seen an error-case NULL dereference
hidden in the initialization of a local variable in an xdr encoder.  But
I went back through the other recent rewrites and didn't spot any
similar bugs.

Reported-by: JianHong Yin <jiyin@redhat.com>
Reviewed-by: Chuck Lever III <chuck.lever@oracle.com>
Fixes: 20798dfe249a ("NFSD: Update the NFSv3 GETACL result encoder...")
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3acl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs3acl.c b/fs/nfsd/nfs3acl.c
index cfb686f23e571..5e13e5f7f92b8 100644
--- a/fs/nfsd/nfs3acl.c
+++ b/fs/nfsd/nfs3acl.c
@@ -170,7 +170,7 @@ static int nfs3svc_encode_getaclres(struct svc_rqst *rqstp, __be32 *p)
 	struct nfsd3_getaclres *resp = rqstp->rq_resp;
 	struct dentry *dentry = resp->fh.fh_dentry;
 	struct kvec *head = rqstp->rq_res.head;
-	struct inode *inode = d_inode(dentry);
+	struct inode *inode;
 	unsigned int base;
 	int n;
 	int w;
@@ -179,6 +179,7 @@ static int nfs3svc_encode_getaclres(struct svc_rqst *rqstp, __be32 *p)
 		return 0;
 	switch (resp->status) {
 	case nfs_ok:
+		inode = d_inode(dentry);
 		if (!svcxdr_encode_post_op_attr(rqstp, xdr, &resp->fh))
 			return 0;
 		if (xdr_stream_encode_u32(xdr, resp->mask) < 0)
-- 
2.43.0



