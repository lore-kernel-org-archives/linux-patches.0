Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F381607AC;
	Tue, 18 Jun 2024 12:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715091; cv=none; b=c7atK3f4e82vWstUEsSXxTYNVPt8qPd3gspgzNGDPUKSbH1SgnicCjNlbYHmWfuw0s+IR+gh1R3/7+tRtIakEt+Aaqn1jeBz9BLlRTZW4vWAfTmd7smBmBeK3is0ROraxo1fG68Ydg5eQ28D08fSIYuFGNNa0OHy8dnmx0BbgrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715091; c=relaxed/simple;
	bh=Iwgf+4hkQL8MlEm8wgcjlr9bmYqOzKHMq5KK9aUzS2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iL2TUot1nrc8WVA9B9YuICNLOR20Pey9V4yNtxlKy3J6N6cwzFBXdUhzmuuDnsHuGR2H8RhRkwdCO1k3xW0v9GUBjEaIU2no8De95DvLM7Ag+LnuZmxMdBq91Dn8pSCry2LXvwgTfmUiOcIunNoXGZ7imQU0kx/cZDLL7epOCaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S9yA/kKM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S9yA/kKM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B05A2C3277B;
	Tue, 18 Jun 2024 12:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715091;
	bh=Iwgf+4hkQL8MlEm8wgcjlr9bmYqOzKHMq5KK9aUzS2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S9yA/kKMJQmz7pcVzUVYWXqdiBy1aiGj31tcqh8x2uccriVaWMA1IFk0oLvFwOJIG
	 Q7Hvw7MhsprHxie7vzHC9iUJ/E4mIa2FPVG39P0C9D2lp8zRWWmmwuU88Hp3ygdtZS
	 XSKyde0sm3C017UbQtDQA2MIUKbvB3Tg4UDCYcuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 174/770] NFSD: Clean up after updating NFSv3 ACL decoders
Date: Tue, 18 Jun 2024 14:30:27 +0200
Message-ID: <20240618123413.988831924@linuxfoundation.org>
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

[ Upstream commit 9cee763ee654ce8622d673b8e32687d738e24ace ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3xdr.c | 20 --------------------
 fs/nfsd/xdr3.h    |  2 --
 2 files changed, 22 deletions(-)

diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index aa55d0ba2a548..00a96054280a6 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -82,26 +82,6 @@ svcxdr_decode_nfs_fh3(struct xdr_stream *xdr, struct svc_fh *fhp)
 	return true;
 }
 
-static __be32 *
-decode_fh(__be32 *p, struct svc_fh *fhp)
-{
-	unsigned int size;
-	fh_init(fhp, NFS3_FHSIZE);
-	size = ntohl(*p++);
-	if (size > NFS3_FHSIZE)
-		return NULL;
-
-	memcpy(&fhp->fh_handle.fh_base, p, size);
-	fhp->fh_handle.fh_size = size;
-	return p + XDR_QUADLEN(size);
-}
-
-/* Helper function for NFSv3 ACL code */
-__be32 *nfs3svc_decode_fh(__be32 *p, struct svc_fh *fhp)
-{
-	return decode_fh(p, fhp);
-}
-
 static __be32 *
 encode_fh(__be32 *p, struct svc_fh *fhp)
 {
diff --git a/fs/nfsd/xdr3.h b/fs/nfsd/xdr3.h
index 7456aee74f3df..3e1578953f544 100644
--- a/fs/nfsd/xdr3.h
+++ b/fs/nfsd/xdr3.h
@@ -307,8 +307,6 @@ int nfs3svc_encode_entry_plus(void *, const char *name,
 /* Helper functions for NFSv3 ACL code */
 __be32 *nfs3svc_encode_post_op_attr(struct svc_rqst *rqstp, __be32 *p,
 				struct svc_fh *fhp);
-__be32 *nfs3svc_decode_fh(__be32 *p, struct svc_fh *fhp);
 bool svcxdr_decode_nfs_fh3(struct xdr_stream *xdr, struct svc_fh *fhp);
 
-
 #endif /* _LINUX_NFSD_XDR3_H */
-- 
2.43.0



