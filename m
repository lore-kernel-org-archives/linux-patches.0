Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B73DD49D58C;
	Thu, 17 Sep 2026 18:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671575; cv=none; b=pZr1U9UU1rxLvG+zvO+EY6Si7TloALtYko5WQ2mYDlubWe/B3TyN1e5HfWjH72CB3tR0nLGrBBu5YszEAS5BOOaEyei9BzjyqcmG7qI2ONdHwQxh1MxuvjJu8JCQlzVzcJop13EByiqFOOehabLNZ5jP5ltqamEqdmkgWXFuZXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671575; c=relaxed/simple;
	bh=lzOa5VDgoxv6xDyp7i/LQ950Afg02O05p1oxO6kpCbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oyZ+E33gd/KhuE9UZrVXbcC3OWRyTsrts/fMUqAyAy6sxK5xH3fKoW4MhQql2SAEHye6C2wGOUqLcZ8/kOv9er2WIRvYSjP+E4pdrdyS/Q0BpgzzFJEmrHXARvsOiODTzc18BVjWZOa0uqqmLeG/rSbw4MWMV5nEk7g0SEusvxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sSXu7oQE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sSXu7oQE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB93B1F000FF;
	Thu, 17 Sep 2026 18:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671573;
	bh=n3kd7HjrvbHmT2pJANhi0KSN+HK06qESTrFi5dZ8VyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sSXu7oQEF1QYAfqZ7RsMZ81iuE7EtqS4WXwou9xd0hTRO2JqW+DLMpAhYzCiavm2M
	 S4plMq4O68XiJa8xCV4+z/PLc4mB7kIcX3x9cL7XJ3xYAryqM4v0cKeqy96heYeu0Z
	 TSrbfMmrWRwqDAh9Pk+1ijaHBkMM9VfgkXZmEL+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1022/1102] NFSD: Make nfsd_genl_rqstp::rq_ops array best-effort
Date: Thu, 17 Sep 2026 16:16:05 +0100
Message-ID: <20260917151606.416497840@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit a2d61427fb4b630b94ed9bd457dd8bc239b83e4b ]

To enable NFSD to handle NFSv4 COMPOUNDs of unrestricted size,
resize the array in struct nfsd_genl_rqstp so it saves only up to
16 operations per COMPOUND.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: a99d720ed2a5 ("nfsd: widen nfsd_genl_rqstp address fields to sockaddr_storage")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsctl.c |    3 ++-
 fs/nfsd/nfsd.h   |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1627,7 +1627,8 @@ int nfsd_nl_rpc_status_get_dumpit(struct
 				int j;
 
 				args = rqstp->rq_argp;
-				genl_rqstp.rq_opcnt = args->opcnt;
+				genl_rqstp.rq_opcnt = min_t(u32, args->opcnt,
+							    ARRAY_SIZE(genl_rqstp.rq_opnum));
 				for (j = 0; j < genl_rqstp.rq_opcnt; j++)
 					genl_rqstp.rq_opnum[j] =
 						args->ops[j].opnum;
--- a/fs/nfsd/nfsd.h
+++ b/fs/nfsd/nfsd.h
@@ -82,7 +82,7 @@ struct nfsd_genl_rqstp {
 
 	/* NFSv4 compound */
 	u32			rq_opcnt;
-	u32			rq_opnum[NFSD_MAX_OPS_PER_COMPOUND];
+	u32			rq_opnum[16];
 };
 
 extern struct svc_program	nfsd_programs[];


