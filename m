Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BADF012C81F;
	Thu, 13 Jun 2024 11:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279628; cv=none; b=kqQTL1CEJCZjN1JCLl7HZdT/boQ5ZtXbRHhJLgYYzkBBeasTju+zQx3MyaYp7ctYzg/KgfZ/0hbftbkiV6lDl7/QNXrAsqb/c9lXMPvxbiylMKCj+/dghD9VcshTI8TuHXrjQpBUd9rEEQ5GVApHgZDrPFGOION8WVdnHVyYGfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279628; c=relaxed/simple;
	bh=26fz6dM3ozKegmkUpY10+J0HlCf4aEBB4rXnrvXadDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uD8k/sxo0RyzN7gHyYCgjGvCLoc7KIz0zLak8A+YhyJW97bFzCyQoPfYvwSZnDWxloUNtteWan/x1P0i9jK2+cwJ9iSznQ+XsoPpJsGGpeBe2AgKlW0H/P/FIpkvUAAM/UfEuQRMHkllgOY/Hcea5NoN/9sYqrdn4t7GGrXeGhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AtnOUUWD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AtnOUUWD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3FE8C2BBFC;
	Thu, 13 Jun 2024 11:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279628;
	bh=26fz6dM3ozKegmkUpY10+J0HlCf4aEBB4rXnrvXadDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AtnOUUWDz2t6zrqASWzsdJHsTIbWFAP86lz7wdQfW1nAMuKmCBDeemWxB0sCsJSXJ
	 +vUPEVGx9Q8yqonAWAADtMFAE+V3Vpr8qZcouAx2ADfstWICRIQ7AZIcz4q1dYRm/F
	 ZAIINqW941lExPwbXnaihxxXMlNPR2+3cJFyXaPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <kolga@netapp.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Benjamin Coddington <bcodding@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 6.9 141/157] NFS: Fix READ_PLUS when server doesnt support OP_READ_PLUS
Date: Thu, 13 Jun 2024 13:34:26 +0200
Message-ID: <20240613113232.857851984@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anna Schumaker <Anna.Schumaker@Netapp.com>

commit f06d1b10cb016d5aaecdb1804fefca025387bd10 upstream.

Olga showed me a case where the client was sending multiple READ_PLUS
calls to the server in parallel, and the server replied
NFS4ERR_OPNOTSUPP to each. The client would fall back to READ for the
first reply, but fail to retry the other calls.

I fix this by removing the test for NFS_CAP_READ_PLUS in
nfs4_read_plus_not_supported(). This allows us to reschedule any
READ_PLUS call that has a NFS4ERR_OPNOTSUPP return value, even after the
capability has been cleared.

Reported-by: Olga Kornievskaia <kolga@netapp.com>
Fixes: c567552612ec ("NFS: Add READ_PLUS data segment support")
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/nfs4proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -5456,7 +5456,7 @@ static bool nfs4_read_plus_not_supported
 	struct rpc_message *msg = &task->tk_msg;
 
 	if (msg->rpc_proc == &nfs4_procedures[NFSPROC4_CLNT_READ_PLUS] &&
-	    server->caps & NFS_CAP_READ_PLUS && task->tk_status == -ENOTSUPP) {
+	    task->tk_status == -ENOTSUPP) {
 		server->caps &= ~NFS_CAP_READ_PLUS;
 		msg->rpc_proc = &nfs4_procedures[NFSPROC4_CLNT_READ];
 		rpc_restart_call_prepare(task);


