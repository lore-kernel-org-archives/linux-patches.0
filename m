Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90E915A84B;
	Tue, 18 Jun 2024 12:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714581; cv=none; b=aBSRbLXgFZMZf6xtxjEWlwzbSI+9WmrcLDahBSWchwhuSTU/5TvPffTMgVDGkgV3Yyzm6Zuv4YKa9kFyY5IaVejAXOF1Q5vrKMWNuUrqTlL0ujkVusK+jcNrAJ3YuHzvjWuhI4Kypii+aMqMJfX42hz+gj3QZK9Ezjbz88sZS2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714581; c=relaxed/simple;
	bh=qI/Vq+7HZNOaPy4Gt6Quce3qkpaJLWRQ8wSrvzUBBeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ipr3gb55cSTSwR00xs4D64LGk+YJHqe95dXJFg41cgYQYewUg1EVo/bKlcXU7f1i0PbrlU0Tgt6rvdkz1f9HWCZJ1pah19aXVniPoIXaKsxk12AJROz5R/mmKuwWrGpHPvNAr4h+DTN6GNVsfDN97VXq0SLUX43EzVY1JX9ExW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ihD/qmLB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ihD/qmLB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2544AC3277B;
	Tue, 18 Jun 2024 12:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714580;
	bh=qI/Vq+7HZNOaPy4Gt6Quce3qkpaJLWRQ8wSrvzUBBeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ihD/qmLByZbiGT2Bde93chr8reMqr38ikxyaZcYGG5xVCpjai2pkwIRaxn6emM7ZJ
	 kDlXlynaFj+fIAebNWGd0IGFJ082UheHfYE8Ed12Ln61JrQcZ5xE/eA11QJlxwXKn7
	 e/0xisZlpIB1aU51SfFUWHGQXf0TrXDkm6bjcXsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 019/770] NFSD: Replace READ* macros that decode the fattr4 size attribute
Date: Tue, 18 Jun 2024 14:27:52 +0200
Message-ID: <20240618123408.040142260@linuxfoundation.org>
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

[ Upstream commit 2ac1b9b2afbbacf597dbec722b23b6be62e4e41e ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index de5ac334cb8ab..5ec0c2dac3348 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -273,8 +273,11 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
 	starting_pos = xdr_stream_pos(argp->xdr);
 
 	if (bmval[0] & FATTR4_WORD0_SIZE) {
-		READ_BUF(8);
-		p = xdr_decode_hyper(p, &iattr->ia_size);
+		u64 size;
+
+		if (xdr_stream_decode_u64(argp->xdr, &size) < 0)
+			return nfserr_bad_xdr;
+		iattr->ia_size = size;
 		iattr->ia_valid |= ATTR_SIZE;
 	}
 	if (bmval[0] & FATTR4_WORD0_ACL) {
-- 
2.43.0



