Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5BD22F1D;
	Fri, 24 Nov 2023 18:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G3A6v4Wh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90EF8C433C8;
	Fri, 24 Nov 2023 18:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851850;
	bh=Qn8UPmX6RoqPcIH71tzNBz8Ucu4X91ZU08vtZ3F8m0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G3A6v4WhBNrRvbIJnq1bd4rklgKgVZzj85QvojXXGYbpmHo0gnNG8PL/1LOk5+74A
	 YW1UCuSJu3QvDL2TkKhMN9oNwsG+8W5ac5VvdvZf5OD6Gz9zz+iyYUCwuafgd4aky0
	 pAUUeWKSIPGegWKlpMPcryrTC+3dZwWb9qXHY/7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 121/372] SUNRPC: Add an IS_ERR() check back to where it was
Date: Fri, 24 Nov 2023 17:48:28 +0000
Message-ID: <20231124172014.511200242@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5a8e6d46809ae..82afb56695f8d 100644
--- a/net/sunrpc/rpcb_clnt.c
+++ b/net/sunrpc/rpcb_clnt.c
@@ -746,6 +746,10 @@ void rpcb_getport_async(struct rpc_task *task)
 
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



