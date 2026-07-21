Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A965415F1A;
	Tue, 21 Jul 2026 19:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662619; cv=none; b=rM47x1sYL8WBN/yyhCNMAsr0b/1Si/UkPg4L28PChYN5EZsTyizOkmfXFC0QMeQSZTW9o9sooMzHrzonrKy0k5QSsc1xbczuA9C/5nRFx3OA3OR/xlyLfJUuZAKL3iD9VhWmkDmh3q+mcZ2ho+Oihf5HbQYEiWb4PTxyzC/zeE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662619; c=relaxed/simple;
	bh=hztvCeTCGu/LHmZmCicHlTluZAXrXke2zFLTnJzplqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B62l3/zKO2r9ieVy92w4MDZ1WBhztIlLhgMu1LOg8gJmM0aEWADW6EPxDfVh0v/ekadthXqej4edLFCtNbzH63VEIN2G1usOjwMO22rWo6RZiuWoJ94KMumMFzucE0G6TEScvOlWdrb/6WJ6h5sQbgeDvb5HqP6sIen1EznQKXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UZ+st+Q0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UZ+st+Q0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F2551F000E9;
	Tue, 21 Jul 2026 19:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662618;
	bh=Na8bFb11pbrLko1cBnECepZhXwmMJB2WM1jvbxTYiFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UZ+st+Q0Adv54jXd6tqUtDOiJ4g4B2OzBFd3HcX7XVHWKjzn393DkfwUUjKb4LtMM
	 UPmk9afH+4ymfrQpjKil73EPS5gi8YhkybWMeMueCQ9f2B9Vt7axNbMjxaizq0qWV1
	 YKYzbuamkSZ2KrMSVNKaRKR2fLIBXOQ3jiN20Pyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0506/1276] xprtrdma: Initialize re_id before removal registration
Date: Tue, 21 Jul 2026 17:15:49 +0200
Message-ID: <20260721152457.430657031@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Chris Mason <clm@meta.com>

[ Upstream commit bb7caa63e1db22fd03e8dc591b12169e99169dff ]

rpcrdma_create_id() registers ep->re_rn with the rpcrdma ib_client
before returning the new rdma_cm_id to rpcrdma_ep_create(). However
rpcrdma_ep_create() currently stores that pointer in ep->re_id only
after rpcrdma_create_id() returns.

A local administrator can race an NFS/RDMA mount against RDMA device
removal. If rpcrdma_remove_one() observes the just-registered
notification before rpcrdma_ep_create() assigns ep->re_id,
rpcrdma_ep_removal_done() calls trace_xprtrdma_device_removal(NULL).
The tracepoint dereferences id->device->name and copies
id->route.addr.dst_addr, so the callback can crash the kernel with a
NULL pointer dereference.

Store the rdma_cm_id in ep->re_id immediately before publishing
ep->re_rn. The existing error path still destroys the id directly if
registration fails; ep is then freed by the caller without using
ep->re_id. Remove the later duplicate assignment in rpcrdma_ep_create().

Fixes: 3f4eb9ff9234 ("xprtrdma: Handle device removal outside of the CM event handler")
Assisted-by: kres:openai-gpt-5
Signed-off-by: Chris Mason <clm@meta.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index ab7c6178a2b9ba..dc8629bf294dc4 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -334,6 +334,7 @@ static struct rdma_cm_id *rpcrdma_create_id(struct rpcrdma_xprt *r_xprt,
 	if (rc)
 		goto out;
 
+	ep->re_id = id;
 	rc = rpcrdma_rn_register(id->device, &ep->re_rn, rpcrdma_ep_removal_done);
 	if (rc)
 		goto out;
@@ -406,7 +407,6 @@ static int rpcrdma_ep_create(struct rpcrdma_xprt *r_xprt)
 	}
 	__module_get(THIS_MODULE);
 	device = id->device;
-	ep->re_id = id;
 	reinit_completion(&ep->re_done);
 
 	ep->re_max_requests = r_xprt->rx_xprt.max_reqs;
-- 
2.53.0



