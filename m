Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B5015532B;
	Tue, 18 Jun 2024 12:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715408; cv=none; b=a4IkvI+hqbFrwam9rCmfpbo+p+uYzgVZBBkGgJlVuTZJX3GMAU9Ry1qnfmnmu7HjyUDo4P9dCRCpV1pSLMZ/68vf//AKxONHfhzwiLcquUqb37LMHUFIlESlZ4ul0uPggUJ5MFAm2bppNjlyR9v2Qps0LJnAG4vmS1TaS+2IBf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715408; c=relaxed/simple;
	bh=xuQviIjn0Nmpovp9Z8ntWq1+J9seMFe6KXlXVNbjTzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jQd3zlDil+9uborF/bpJmjXktN6CPBsTuqxvkfFfu6WwPOXKfRqAxblJk2mik2O4XM8PqxMdxMNtyqIoi1xV3XePIFZ45P78PWv+YKuCj/5eHoUtbudEX3mhM3G+vkQFKBuIwC4nCgu/lSVVQaYR4dl4rsT+TrxjJwE7zW6Uwnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JtBDxuhR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JtBDxuhR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6F2DC3277B;
	Tue, 18 Jun 2024 12:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715408;
	bh=xuQviIjn0Nmpovp9Z8ntWq1+J9seMFe6KXlXVNbjTzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JtBDxuhRad+LlBCf+v1+QhZijtXVT7CsJyPs3HeDQGhZyQDtvE2NpVkV9fBjRFwhq
	 rUvpAz4olgXmLNUqKW5zAimHp/nomNoy+rWql/Dg9b7so5zYecOLKrnIb4PRugQku8
	 hK8CkrqyEkzp7wWeknHVAzNA1x8h6v6Cb48U0gjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"J. Bruce Fields" <bfields@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 298/770] nfsd: rpc_peeraddr2str needs rcu lock
Date: Tue, 18 Jun 2024 14:32:31 +0200
Message-ID: <20240618123418.765255481@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit 05570a2b01117209b500e1989ce8f1b0524c489f ]

I'm not even sure cl_xprt can change here, but we're getting "suspicious
RCU usage" warnings, and other rpc_peeraddr2str callers are taking the
rcu lock.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4callback.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfsd/nfs4callback.c b/fs/nfsd/nfs4callback.c
index 59dc80ecd3764..97f517e9b4189 100644
--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -941,8 +941,10 @@ static int setup_callback_client(struct nfs4_client *clp, struct nfs4_cb_conn *c
 		clp->cl_cb_conn.cb_xprt = conn->cb_xprt;
 	clp->cl_cb_client = client;
 	clp->cl_cb_cred = cred;
+	rcu_read_lock();
 	trace_nfsd_cb_setup(clp, rpc_peeraddr2str(client, RPC_DISPLAY_NETID),
 			    args.authflavor);
+	rcu_read_unlock();
 	return 0;
 }
 
-- 
2.43.0



