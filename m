Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F1F1C5D72;
	Mon,  2 Jun 2025 14:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874659; cv=none; b=frpUusmpi26csT7bqSHJWYwu1vV7oAujkLgRrKKWDdNEnYei5aLqgs83B/grTfQqG33Wdq6H1tgw38dJzoRcWQqja1koTps++F4KU4r/k+VqhxnnkW4V9hTz0Rkucq3ReP8Q9TY1et5wB9CMGoGALeSgQKNEgCKqJOrMgNct2vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874659; c=relaxed/simple;
	bh=GCpHXEOv6HedqR63cwiYRLgnhO/c5RxOfLKKb3OWSIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=krq/R2cYh1cFSu7MzmlNPChjUhadXAWCT+0YM21AGH2HtQiz1oxfyGPpq5pxjYAYE77/L9Ex7fl+2h6zffRDhkkCpi9wepXxbxwQkiV1dT//+gaCPbDbgrgklYfFHK2/PulHucNg6hFucdxWuzW4FyYO2JpAtdThjlvJrebX9uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1gfncotJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1gfncotJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD89EC4CEEB;
	Mon,  2 Jun 2025 14:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874659;
	bh=GCpHXEOv6HedqR63cwiYRLgnhO/c5RxOfLKKb3OWSIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1gfncotJT9dv18AbXA21+UKFnNv5sBoWwcPtgfJOrm/JSlbdWLExZyqDiupsqMCel
	 mix++gihlb9ryn81opIYzTle8EsJOd2WxlQHqhkouQIMyuw+JOzoffmXExxqCqboa0
	 4hMZGfmtAF5rvEMwe0c1T3J3c8RdK005rJi6W3Ls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Benjamin Coddington <bcodding@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 094/204] SUNRPC: rpc_clnt_set_transport() must not change the autobind setting
Date: Mon,  2 Jun 2025 15:47:07 +0200
Message-ID: <20250602134259.353057312@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit bf9be373b830a3e48117da5d89bb6145a575f880 ]

The autobind setting was supposed to be determined in rpc_create(),
since commit c2866763b402 ("SUNRPC: use sockaddr + size when creating
remote transport endpoints").

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/clnt.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index f689c7b0c304d..d67cb10a11db6 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -277,9 +277,6 @@ static struct rpc_xprt *rpc_clnt_set_transport(struct rpc_clnt *clnt,
 	old = rcu_dereference_protected(clnt->cl_xprt,
 			lockdep_is_held(&clnt->cl_lock));
 
-	if (!xprt_bound(xprt))
-		clnt->cl_autobind = 1;
-
 	clnt->cl_timeout = timeout;
 	rcu_assign_pointer(clnt->cl_xprt, xprt);
 	spin_unlock(&clnt->cl_lock);
-- 
2.39.5



