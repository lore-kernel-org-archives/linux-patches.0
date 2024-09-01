Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF3171C68C;
	Sun,  1 Sep 2024 16:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208465; cv=none; b=Zb+Jh2lAiLqSeKHYFYxYFlmeSrJpkRFR6n1CcJeKvZG5Cn3TT8EMowOzAZVix6mJ6UtWt5z2lw/h+fqQVcPSxzixTr+JaY1pzwMxNYCQjqDz9Oga3gakoiUtVTxf3XFtJK1S/L8rJ2pNCXy8xNi5vBcQWfdI0KLsNObHzhq0D9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208465; c=relaxed/simple;
	bh=7RJtrmFnEF5jJgaa7OTn/Mpbmdw8EHKZ17GuLnrC3yA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tw3lVcYILx/ZEsaePDgK2yxSVFmmR+5zSjg4rsytM5JAQx9XDVF5a6uLYXyejSoVFgeeCCAJ0nYt9g797qllZkwweXlI1kGbW1s8dwvZsYLu2UL69herFEmQ9uJ0+LE4xTCQdqNOdvlcTAny96ei0yiWYqxoers+cRja/NiUH7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FvhIXkz7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FvhIXkz7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE5DC4CEC4;
	Sun,  1 Sep 2024 16:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208465;
	bh=7RJtrmFnEF5jJgaa7OTn/Mpbmdw8EHKZ17GuLnrC3yA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FvhIXkz7+0N/8XF+2+9f1XF/tJA2GmRuY56kvlTK6YvKC/j2Uxy3/oc/GW0Tev06C
	 Zafi3QkSB/nN6ygpGesL7xuYByusblHNSz7xyOYUstEa2PBiWbXxDQWJbXr45tEQ0w
	 UJU2ysKTWnpFxZh0d5iSYzpGShoENbmO1MXpbR2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 059/149] nfsd: ensure that nfsd4_fattr_args.context is zeroed out
Date: Sun,  1 Sep 2024 18:16:10 +0200
Message-ID: <20240901160819.687995275@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit f58bab6fd4063913bd8321e99874b8239e9ba726 ]

If nfsd4_encode_fattr4 ends up doing a "goto out" before we get to
checking for the security label, then args.context will be set to
uninitialized junk on the stack, which we'll then try to free.
Initialize it early.

Fixes: f59388a579c6 ("NFSD: Add nfsd4_encode_fattr4_sec_label()")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index c7bfd2180e3f2..8a7bc2b58e721 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3545,6 +3545,9 @@ nfsd4_encode_fattr4(struct svc_rqst *rqstp, struct xdr_stream *xdr,
 	args.dentry = dentry;
 	args.ignore_crossmnt = (ignore_crossmnt != 0);
 	args.acl = NULL;
+#ifdef CONFIG_NFSD_V4_SECURITY_LABEL
+	args.context = NULL;
+#endif
 
 	/*
 	 * Make a local copy of the attribute bitmap that can be modified.
@@ -3617,7 +3620,6 @@ nfsd4_encode_fattr4(struct svc_rqst *rqstp, struct xdr_stream *xdr,
 	args.contextsupport = false;
 
 #ifdef CONFIG_NFSD_V4_SECURITY_LABEL
-	args.context = NULL;
 	if ((attrmask[2] & FATTR4_WORD2_SECURITY_LABEL) ||
 	     attrmask[0] & FATTR4_WORD0_SUPPORTED_ATTRS) {
 		if (exp->ex_flags & NFSEXP_SECURITY_LABEL)
-- 
2.43.0



