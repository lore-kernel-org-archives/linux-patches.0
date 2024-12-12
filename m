Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45C9F21660B;
	Thu, 12 Dec 2024 17:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024472; cv=none; b=BNp/ZUEq+R/89Q82/l2wr6riSuVV8kSGJfmU/CuG4F+Oqas/srGbQUaSXSiteJI+0nsKQweOW/3pKw9Lb1QcfVWaOcN0BSZGaqvyVkZ+TmkFlWriKGVJg4R6grDQD1WWQkaejzd4sX5AqOXXLuLNQRbJQRFmRM4ZFyEI+YjB6tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024472; c=relaxed/simple;
	bh=FP0GY/1ncDyN2pzC6h4pDUuqwCiE8O5rGg7YoLaK8hg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tph8KYbf/CrPtSLt6MWDGY3SFzA6FtWA51CYb9O5HiJAzn/2kyAUscIVuXFHw9QAziJdTzZshgOx9crNIggZFQMvTucfklfCm6eAJodjZxuv5E+KXUAHAx/I5dUR96f/GnSDBmcsSp5ZDfAGfRVZcrVoW/FKDQC7cK7gXFAzw6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oUJj0nXm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oUJj0nXm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD8FCC4CECE;
	Thu, 12 Dec 2024 17:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024472;
	bh=FP0GY/1ncDyN2pzC6h4pDUuqwCiE8O5rGg7YoLaK8hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oUJj0nXmEP7wp9WPybnS3tH0hzg0Cpn/Z1VAJ2UPNM/Mam1MsZsga1VBnYuwSSGi8
	 B1wWtuob8uBn0nZaHseeice9H+/5iq2DpwYrJgzVlSB+G9h8WoSIsbZaamxMnQ8hNu
	 Imkg4a6hEvAmF5Vo3M7IgGYy+yd50IvQMCRHcrjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thiago Rafael Becker <trbecker@gmail.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 307/459] sunrpc: remove unnecessary test in rpc_task_set_client()
Date: Thu, 12 Dec 2024 16:00:45 +0100
Message-ID: <20241212144305.772346876@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

From: Thiago Rafael Becker <trbecker@gmail.com>

[ Upstream commit 023859ce6f88f7cfc223752fb56ec453a147b852 ]

In rpc_task_set_client(), testing for a NULL clnt is not necessary, as
clnt should always be a valid pointer to a rpc_client.

Signed-off-by: Thiago Rafael Becker <trbecker@gmail.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Stable-dep-of: 4db9ad82a6c8 ("sunrpc: clear XPRT_SOCK_UPD_TIMEOUT when reset transport")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/clnt.c | 33 +++++++++++++++------------------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 457042b653bba..7ec5b0bc48ebf 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1077,24 +1077,21 @@ void rpc_task_set_transport(struct rpc_task *task, struct rpc_clnt *clnt)
 static
 void rpc_task_set_client(struct rpc_task *task, struct rpc_clnt *clnt)
 {
-
-	if (clnt != NULL) {
-		rpc_task_set_transport(task, clnt);
-		task->tk_client = clnt;
-		refcount_inc(&clnt->cl_count);
-		if (clnt->cl_softrtry)
-			task->tk_flags |= RPC_TASK_SOFT;
-		if (clnt->cl_softerr)
-			task->tk_flags |= RPC_TASK_TIMEOUT;
-		if (clnt->cl_noretranstimeo)
-			task->tk_flags |= RPC_TASK_NO_RETRANS_TIMEOUT;
-		if (atomic_read(&clnt->cl_swapper))
-			task->tk_flags |= RPC_TASK_SWAPPER;
-		/* Add to the client's list of all tasks */
-		spin_lock(&clnt->cl_lock);
-		list_add_tail(&task->tk_task, &clnt->cl_tasks);
-		spin_unlock(&clnt->cl_lock);
-	}
+	rpc_task_set_transport(task, clnt);
+	task->tk_client = clnt;
+	refcount_inc(&clnt->cl_count);
+	if (clnt->cl_softrtry)
+		task->tk_flags |= RPC_TASK_SOFT;
+	if (clnt->cl_softerr)
+		task->tk_flags |= RPC_TASK_TIMEOUT;
+	if (clnt->cl_noretranstimeo)
+		task->tk_flags |= RPC_TASK_NO_RETRANS_TIMEOUT;
+	if (atomic_read(&clnt->cl_swapper))
+		task->tk_flags |= RPC_TASK_SWAPPER;
+	/* Add to the client's list of all tasks */
+	spin_lock(&clnt->cl_lock);
+	list_add_tail(&task->tk_task, &clnt->cl_tasks);
+	spin_unlock(&clnt->cl_lock);
 }
 
 static void
-- 
2.43.0



