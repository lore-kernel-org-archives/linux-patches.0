Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1AC63D5;
	Sat, 30 Dec 2023 12:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SEvwx37+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD26C433C7;
	Sat, 30 Dec 2023 12:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937679;
	bh=tbQoJK8CN6dE1QnN/jnhpzy/91HO5P4u0k7XTGbDP74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SEvwx37+WFXth5sRdE0d7zHCX+vp0ZIwdF8gA+cZP/4GIa/OSHNddGKvL/6NkxkvR
	 oAk4TeYNNzaypD2R6oRryJH/3VfQt+ndLlQrzZEFh+gjjaX16ICkia++Q+JEVWKFrd
	 wZtJN1J/gu+UyZtkNpTZViAbVOuTJsjLBomjciSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Morin <guillaume@morinfr.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 020/156] SUNRPC: Revert 5f7fc5d69f6e92ec0b38774c387f5cf7812c5806
Date: Sat, 30 Dec 2023 11:57:54 +0000
Message-ID: <20231230115813.032018292@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit bd018b98ba84ca0c80abac1ef23ce726a809e58c ]

Guillaume says:
> I believe commit 5f7fc5d69f6e ("SUNRPC: Resupply rq_pages from
> node-local memory") in Linux 6.5+ is incorrect. It passes
> unconditionally rq_pool->sp_id as the NUMA node.
>
> While the comment in the svc_pool declaration in sunrpc/svc.h says
> that sp_id is also the NUMA node id, it might not be the case if
> the svc is created using svc_create_pooled(). svc_created_pooled()
> can use the per-cpu pool mode therefore in this case sp_id would
> be the cpu id.

Fix this by reverting now. At a later point this minor optimization,
and the deceptive labeling of the sp_id field, can be revisited.

Reported-by: Guillaume Morin <guillaume@morinfr.org>
Closes: https://lore.kernel.org/linux-nfs/ZYC9rsno8qYggVt9@bender.morinfr.org/T/#u
Fixes: 5f7fc5d69f6e ("SUNRPC: Resupply rq_pages from node-local memory")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/svc_xprt.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index 4cfe9640df481..5cfe5c7408b74 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -666,9 +666,8 @@ static bool svc_alloc_arg(struct svc_rqst *rqstp)
 	}
 
 	for (filled = 0; filled < pages; filled = ret) {
-		ret = alloc_pages_bulk_array_node(GFP_KERNEL,
-						  rqstp->rq_pool->sp_id,
-						  pages, rqstp->rq_pages);
+		ret = alloc_pages_bulk_array(GFP_KERNEL, pages,
+					     rqstp->rq_pages);
 		if (ret > filled)
 			/* Made progress, don't sleep yet */
 			continue;
-- 
2.43.0



