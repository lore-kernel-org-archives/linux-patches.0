Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1429C1CFEDB;
	Wed,  2 Oct 2024 13:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876483; cv=none; b=tmtQZNlPHeuGdaofphHN5cjj7J3wYQj4ecHmcXPTmLBXL2sfhe6NK0pb8gY4z0CWniYnM9bNlx7wgpAsP2iIcM9VvC3+MOCTmGUPJPeD8ZCZH0xOQZE1hnMenU00ieIDFW0uoDVhO7r+8NhljSsPNK4uQ/W4ljj2E2/2yDP/cFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876483; c=relaxed/simple;
	bh=SUj25+4v3WBU7nhEmR3QCKbanQNYQMlkKF6EA7+oH3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HdNG25098Q0yWCdPhPFZhHRo9Pyymf5EZibo1TZQmdI/VvCvNRl7v8ljE8eh90e+XnwEuwwPipCjfQqpqHCGa8y6L29Svih/yhNRwZT7lNbI1HU+8p4Lp9d16tpevfQJjBBrQRfuXR3WwVuj/BtCj5FKcsRmtFH2Gs4ddtQQJHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VCB3r4Qw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VCB3r4Qw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 495DCC4CEC5;
	Wed,  2 Oct 2024 13:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876482;
	bh=SUj25+4v3WBU7nhEmR3QCKbanQNYQMlkKF6EA7+oH3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VCB3r4Qw3xPdXXBFIeW4GM1fSIxu4VUIrsUDJSBv+syEBfbNBO75luzCLfWnifYBy
	 17kerq395R6Ipl0v6a4JtKTTJ1jDUHXf8vcocnkcY1XFsMYR/US2ia0WFIy0jYgtaN
	 xh2PE4ZMr+1u6cKXmYF8HrS2vpZLiNKNmxIyL57g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guoqing Jiang <guoqing.jiang@linux.dev>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 6.11 428/695] nfsd: call cache_put if xdr_reserve_space returns NULL
Date: Wed,  2 Oct 2024 14:57:06 +0200
Message-ID: <20241002125839.547162943@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guoqing Jiang <guoqing.jiang@linux.dev>

[ Upstream commit d078cbf5c38de83bc31f83c47dcd2184c04a50c7 ]

If not enough buffer space available, but idmap_lookup has triggered
lookup_fn which calls cache_get and returns successfully. Then we
missed to call cache_put here which pairs with cache_get.

Fixes: ddd1ea563672 ("nfsd4: use xdr_reserve_space in attribute encoding")
Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
Reviwed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4idmap.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/nfs4idmap.c b/fs/nfsd/nfs4idmap.c
index 7a806ac13e317..8cca1329f3485 100644
--- a/fs/nfsd/nfs4idmap.c
+++ b/fs/nfsd/nfs4idmap.c
@@ -581,6 +581,7 @@ static __be32 idmap_id_to_name(struct xdr_stream *xdr,
 		.id = id,
 		.type = type,
 	};
+	__be32 status = nfs_ok;
 	__be32 *p;
 	int ret;
 	struct nfsd_net *nn = net_generic(SVC_NET(rqstp), nfsd_net_id);
@@ -593,12 +594,16 @@ static __be32 idmap_id_to_name(struct xdr_stream *xdr,
 		return nfserrno(ret);
 	ret = strlen(item->name);
 	WARN_ON_ONCE(ret > IDMAP_NAMESZ);
+
 	p = xdr_reserve_space(xdr, ret + 4);
-	if (!p)
-		return nfserr_resource;
-	p = xdr_encode_opaque(p, item->name, ret);
+	if (unlikely(!p)) {
+		status = nfserr_resource;
+		goto out_put;
+	}
+	xdr_encode_opaque(p, item->name, ret);
+out_put:
 	cache_put(&item->h, nn->idtoname_cache);
-	return 0;
+	return status;
 }
 
 static bool
-- 
2.43.0



