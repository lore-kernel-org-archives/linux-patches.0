Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5171E5B71;
	Mon, 23 Jun 2025 21:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713879; cv=none; b=V0kquNxXzpw3BOhRQrJFX8tobPvGQhIi2LQxn1tcBWgAbIitJnzipBEQpYLmbjIhUg1EUR4hg3I808D5UvnzWgeQirRZ+TZkq/vSVYOl8+Txp5Mkcb7lfuX/xGlRiz1WpxQsSkhiJvcjYIs/Ph2UZWZEIUZm6JhXYJbuB28hcxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713879; c=relaxed/simple;
	bh=EbXp/I4Qoo6/1ji4/bkqYnga5I4pn4nvZot4fuQJR+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GZVYEa0VT53wlw83pKICW5DRPdyyhBI3FQIYpf4W2oFj5tfqx/nPAhAWZFKIdSQkWMkQVbAtXEBL17MYKLyjxHgpyDwqOkRnoOEjE+PbEkaZs7fH0IQSh5fuM+1rugv47ikzQ9vbsxmlLiixNXXVBvBOfwViXP2sqUttQjKecWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mbhGJxy6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mbhGJxy6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC308C4CEED;
	Mon, 23 Jun 2025 21:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713879;
	bh=EbXp/I4Qoo6/1ji4/bkqYnga5I4pn4nvZot4fuQJR+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mbhGJxy6rebYMu9O1CAu5oHWJsNJ0JxjptHttFdmmWICcPTQCXImc4REwsArs4Qjb
	 BWwCuIyLO4ikDb8TKZhorGiFEF8R9bgCpoycvXzkPtsx7j/+nBZxPU/PJHiYlruzXl
	 gB0J8JnWd/YWsVdpxOx2xHgGoZoD9By6/pok1Lb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Aloni <dan.aloni@vastdata.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Larry Bassel <larry.bassel@oracle.com>
Subject: [PATCH 5.4 214/222] xprtrdma: fix pointer derefs in error cases of rpcrdma_ep_create
Date: Mon, 23 Jun 2025 15:09:09 +0200
Message-ID: <20250623130618.732847526@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

From: Dan Aloni <dan.aloni@vastdata.com>

commit a9c10b5b3b67b3750a10c8b089b2e05f5e176e33 upstream.

If there are failures then we must not leave the non-NULL pointers with
the error value, otherwise `rpcrdma_ep_destroy` gets confused and tries
free them, resulting in an Oops.

Signed-off-by: Dan Aloni <dan.aloni@vastdata.com>
Acked-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
[ Larry: backport to 5.4.y. Minor conflict resolved due to missing commit 93aa8e0a9de80
  xprtrdma: Merge struct rpcrdma_ia into struct rpcrdma_ep ]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Larry Bassel <larry.bassel@oracle.com>
---
 net/sunrpc/xprtrdma/verbs.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -525,6 +525,7 @@ int rpcrdma_ep_create(struct rpcrdma_xpr
 				 IB_POLL_WORKQUEUE);
 	if (IS_ERR(sendcq)) {
 		rc = PTR_ERR(sendcq);
+		sendcq = NULL;
 		goto out1;
 	}
 
@@ -533,6 +534,7 @@ int rpcrdma_ep_create(struct rpcrdma_xpr
 				 IB_POLL_WORKQUEUE);
 	if (IS_ERR(recvcq)) {
 		rc = PTR_ERR(recvcq);
+		recvcq = NULL;
 		goto out2;
 	}
 


