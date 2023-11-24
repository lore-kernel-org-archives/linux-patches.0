Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448772E84A;
	Fri, 24 Nov 2023 19:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AYnyQdDG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CCD0C433C7;
	Fri, 24 Nov 2023 19:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852700;
	bh=kVL+/nlXlz2/qsUqRJk9+f6NzTE+DbDZhhTk0DZ3gTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AYnyQdDGB8cUJiA0QUeM+n6Qb5+8jpCNFAovKdKvgU+Io6a9D3UEdf2fGfXYalGl4
	 gsQLwdJ1Zg3aN5xE2ZmsTWYcuow+RfhKNHhoSi6ilXk8bmP7D+25BNBnWXOhrZyO0E
	 gvWmrD4xUiRszSaptos+YaxqSDrpcRK/lKMDIAi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 064/193] SUNRPC: Add an IS_ERR() check back to where it was
Date: Fri, 24 Nov 2023 17:53:11 +0000
Message-ID: <20231124171949.803014666@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171947.127438872@linuxfoundation.org>
References: <20231124171947.127438872@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 4f3ed837186fc0d2722ba8d2457a594322e9c2ef ]

This IS_ERR() check was deleted during in a cleanup because, at the time,
the rpcb_call_async() function could not return an error pointer.  That
changed in commit 25cf32ad5dba ("SUNRPC: Handle allocation failure in
rpc_new_task()") and now it can return an error pointer.  Put the check
back.

A related revert was done in commit 13bd90141804 ("Revert "SUNRPC:
Remove unreachable error condition"").

Fixes: 037e910b52b0 ("SUNRPC: Remove unreachable error condition in rpcb_getport_async()")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/rpcb_clnt.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/sunrpc/rpcb_clnt.c b/net/sunrpc/rpcb_clnt.c
index 38fe2ce8a5aa1..8fad45320e1b9 100644
--- a/net/sunrpc/rpcb_clnt.c
+++ b/net/sunrpc/rpcb_clnt.c
@@ -743,6 +743,10 @@ void rpcb_getport_async(struct rpc_task *task)
 
 	child = rpcb_call_async(rpcb_clnt, map, proc);
 	rpc_release_client(rpcb_clnt);
+	if (IS_ERR(child)) {
+		/* rpcb_map_release() has freed the arguments */
+		return;
+	}
 
 	xprt->stat.bind_count++;
 	rpc_put_task(child);
-- 
2.42.0



