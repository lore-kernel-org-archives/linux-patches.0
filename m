Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6EB78285;
	Mon,  8 Apr 2024 13:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583145; cv=none; b=SYzTYothQ4nLgz5GM9Pvby7GG4XlUXeeyVlDDU1GOkK+Dp0jybobsniCEUS8/3puxofOfrAckANNElqHq1cDPyL/6NNXH8QoqjsXIyCnofosQKPu5QlAS01ZPDyo8bUlxUE0AfikMbm6G0iEY/GVLMvLbUCRUltStUeshJCkCxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583145; c=relaxed/simple;
	bh=wazc6BUyByF5cso3vspqbD8dRoKIuK5j+TLtKHCkkbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OBoz8GsFNuC4iThKt3VOirI3GbvcausiAlMCPXi1dDGhYFUo1OzllKysTxRUOIRVLs2GhjsFm4rl8+Mtdn0zn7/DpHKuFcLUY20KwR2cAog21ea9wh8YZeOHNI2SE7G5uKOu0jhVD0zd+f24PgnPrRHybq4q07AZ7Ygx0umlYkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mjVGwWW4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mjVGwWW4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95980C433C7;
	Mon,  8 Apr 2024 13:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583145;
	bh=wazc6BUyByF5cso3vspqbD8dRoKIuK5j+TLtKHCkkbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mjVGwWW4/nRp+EfFdX8wcmc5kTycEZokd9LWBfdKhKW9dN6844KwV6/4onrb07CY4
	 cHsNNAYwDZbX2PtzmCavOiQsImwRIA6cG4WPEtluypG1ZxA4ni30jVybI49KBjNXUX
	 I9RdEpz3kvnmq/0PvP5TGdFsAp5GxDjTzU9amL+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 144/273] 9p: Fix read/write debug statements to report server reply
Date: Mon,  8 Apr 2024 14:56:59 +0200
Message-ID: <20240408125313.760940165@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dominique Martinet <asmadeus@codewreck.org>

[ Upstream commit be3193e58ec210b2a72fb1134c2a0695088a911d ]

Previous conversion to iov missed these debug statements which would now
always print the requested size instead of the actual server reply.

Write also added a loop in a much older commit but we didn't report
these, while reads do report each iteration -- it's more coherent to
keep reporting all requests to server so move that at the same time.

Fixes: 7f02464739da ("9p: convert to advancing variant of iov_iter_get_pages_alloc()")
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Message-ID: <20240109-9p-rw-trace-v1-1-327178114257@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/client.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/9p/client.c b/net/9p/client.c
index e265a0ca6bddd..f7e90b4769bba 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -1583,7 +1583,7 @@ p9_client_read_once(struct p9_fid *fid, u64 offset, struct iov_iter *to,
 		received = rsize;
 	}
 
-	p9_debug(P9_DEBUG_9P, "<<< RREAD count %d\n", count);
+	p9_debug(P9_DEBUG_9P, "<<< RREAD count %d\n", received);
 
 	if (non_zc) {
 		int n = copy_to_iter(dataptr, received, to);
@@ -1609,9 +1609,6 @@ p9_client_write(struct p9_fid *fid, u64 offset, struct iov_iter *from, int *err)
 	int total = 0;
 	*err = 0;
 
-	p9_debug(P9_DEBUG_9P, ">>> TWRITE fid %d offset %llu count %zd\n",
-		 fid->fid, offset, iov_iter_count(from));
-
 	while (iov_iter_count(from)) {
 		int count = iov_iter_count(from);
 		int rsize = fid->iounit;
@@ -1623,6 +1620,9 @@ p9_client_write(struct p9_fid *fid, u64 offset, struct iov_iter *from, int *err)
 		if (count < rsize)
 			rsize = count;
 
+		p9_debug(P9_DEBUG_9P, ">>> TWRITE fid %d offset %llu count %d (/%d)\n",
+			 fid->fid, offset, rsize, count);
+
 		/* Don't bother zerocopy for small IO (< 1024) */
 		if (clnt->trans_mod->zc_request && rsize > 1024) {
 			req = p9_client_zc_rpc(clnt, P9_TWRITE, NULL, from, 0,
@@ -1650,7 +1650,7 @@ p9_client_write(struct p9_fid *fid, u64 offset, struct iov_iter *from, int *err)
 			written = rsize;
 		}
 
-		p9_debug(P9_DEBUG_9P, "<<< RWRITE count %d\n", count);
+		p9_debug(P9_DEBUG_9P, "<<< RWRITE count %d\n", written);
 
 		p9_req_put(clnt, req);
 		iov_iter_revert(from, count - written - iov_iter_count(from));
-- 
2.43.0



