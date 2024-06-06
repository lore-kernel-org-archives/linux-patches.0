Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0300C1B375C;
	Thu,  6 Jun 2024 14:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683428; cv=none; b=PlvA29G4nxlztZLcKAO2IUrrUcJQPcI6dGT/qTURT/ZIWILfJyLqBbxCW5zMY7RMUgRyVY3elQGBd/qr8X3b61KFPFUL7fNuQe8gzLc1Jvm4Gki97etodWCu1UnBeo7xp/7R/sUPY7XxhYMS5wb8l5fpqfD2OQW/HIKZNSVQojI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683428; c=relaxed/simple;
	bh=aUmafDC9Y41UliYDz+EfTJZXIJlT49AoHC51PxKgrQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bPxy598mK5BbyMsE+S1JIyrV9cNYYEuVygThyzOYyDPBiSRGfRyjANBIefEwa8jTSvkpf6NvqlfsnuY/w+MNH4bDhxnHn31ztNVZRH3PohO6EQM8dIIwbz4VyILo/wgbV9oL6kVln/TByWlUsq0Q/t/aIaHU/XFXCJqefq8r0HU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SJUuJP7t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SJUuJP7t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8357C32781;
	Thu,  6 Jun 2024 14:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683427;
	bh=aUmafDC9Y41UliYDz+EfTJZXIJlT49AoHC51PxKgrQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SJUuJP7tyk5vu5xVUJAsXeyo3z8NyYy+LggWSbogdisgsZr0C1CkQJPVt6Mv3GImj
	 JLGdm/Ub8KyVW3nCsBAeBQFozKe5+Kje4JbU08z7sVIQx4lG1cP6WT3XZiT59dA3mS
	 1tNCqQN9itkMsKppuBQZEdh1GBjyCtBZ1NHa5fxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Aprelkov <aaprelkov@usergate.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 364/744] sunrpc: removed redundant procp check
Date: Thu,  6 Jun 2024 16:00:36 +0200
Message-ID: <20240606131744.153954064@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Aprelkov <aaprelkov@usergate.com>

[ Upstream commit a576f36971ab4097b6aa76433532aa1fb5ee2d3b ]

since vs_proc pointer is dereferenced before getting it's address there's
no need to check for NULL.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 8e5b67731d08 ("SUNRPC: Add a callback to initialise server requests")
Signed-off-by: Aleksandr Aprelkov <aaprelkov@usergate.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/svc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index 812fda9d45dd6..691499d1d2315 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -1265,8 +1265,6 @@ svc_generic_init_request(struct svc_rqst *rqstp,
 	if (rqstp->rq_proc >= versp->vs_nproc)
 		goto err_bad_proc;
 	rqstp->rq_procinfo = procp = &versp->vs_proc[rqstp->rq_proc];
-	if (!procp)
-		goto err_bad_proc;
 
 	/* Initialize storage for argp and resp */
 	memset(rqstp->rq_argp, 0, procp->pc_argzero);
-- 
2.43.0



