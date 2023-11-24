Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B5C339BE;
	Fri, 24 Nov 2023 19:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yh3xZQHS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F9E9C433C8;
	Fri, 24 Nov 2023 19:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853184;
	bh=M3byNKa0lFcdGwlZStTkPZHBheACugsgMNiK4NPmYrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yh3xZQHSiHtr9tgLBJR2iBrbFFF5gegpHdx7YLeGyiDjG5YFRORyatVpldGKbAm9/
	 0S+zLJFuCv7dy/eMesi6oBKBSmoMYXUrA991mphGiYNLnfu/ENZx0veMKVgIuZs3Yv
	 SqDgLztxaJUbvEx7cy8b1VwEfyvHh30HGnYcjkig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 088/297] SUNRPC: ECONNRESET might require a rebind
Date: Fri, 24 Nov 2023 17:52:10 +0000
Message-ID: <20231124172003.331090205@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 4b09ca1508a60be30b2e3940264e93d7aeb5c97e ]

If connect() is returning ECONNRESET, it usually means that nothing is
listening on that port. If so, a rebind might be required in order to
obtain the new port on which the RPC service is listening.

Fixes: fd01b2597941 ("SUNRPC: ECONNREFUSED should cause a rebind.")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/clnt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 7756c62e0c3ed..fc37f314a09dd 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -2088,6 +2088,7 @@ call_connect_status(struct rpc_task *task)
 	task->tk_status = 0;
 	switch (status) {
 	case -ECONNREFUSED:
+	case -ECONNRESET:
 		/* A positive refusal suggests a rebind is needed. */
 		if (RPC_IS_SOFTCONN(task))
 			break;
@@ -2096,7 +2097,6 @@ call_connect_status(struct rpc_task *task)
 			goto out_retry;
 		}
 		fallthrough;
-	case -ECONNRESET:
 	case -ECONNABORTED:
 	case -ENETDOWN:
 	case -ENETUNREACH:
-- 
2.42.0



