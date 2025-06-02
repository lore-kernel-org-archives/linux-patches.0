Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F6A5225776;
	Mon,  2 Jun 2025 14:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875434; cv=none; b=eMcdGhOfSEfoN1DGG4ORIgl8uJDu0swIFFuy4gmtgzFVegciIYjsPD3arXkueh6Ypjx2bI3saoEYVN0wsfXr1LWJfLUJ+S1T0oTt2iS6aXRSQOoi4znZ2778bvAW/75199EFckO0i8n5JCNWYlrx7HC3c01IsE60buImEDcWXjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875434; c=relaxed/simple;
	bh=B/poK+rMq01ikgysjMtaXkYDBqRat6ngN8rUFeWaVJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H1PlLawrveM0ekd7TEWo3VyuHHWDwq7eqiR3Bja5DAa18ev7PsALLyHU8doInB+ng+0ne8IvkOeMvDxycQSWsZG5FQ/tl0XjUxU6WlWiTZ7Om6TSZ6TvaJNXGZ+spCRNCMy4nrSlyPwRsYhUCMaFyNCwhl3za7DbzuX/fQC7ru0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BvAZU3bE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BvAZU3bE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C34C3C4CEEB;
	Mon,  2 Jun 2025 14:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875434;
	bh=B/poK+rMq01ikgysjMtaXkYDBqRat6ngN8rUFeWaVJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BvAZU3bEXfaOYg0nZL6rApUUfRhfG+qb1VqfZtm1RX9EDBn0PeItvVOy+fOOGF59R
	 eKJZfZ7ImZOX9URpYNDCE0xYSrkmwz/LZDKMjFFnnBwxWz5QxDlDVN65+OVI4T/wN3
	 x03VldZIDd4CaxJ/zn+GRDyc2+9hYhUoimqfr0H8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Benjamin Coddington <bcodding@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 126/270] SUNRPC: rpc_clnt_set_transport() must not change the autobind setting
Date: Mon,  2 Jun 2025 15:46:51 +0200
Message-ID: <20250602134312.380952599@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7ec5b0bc48ebf..0a4b4870c4d99 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -273,9 +273,6 @@ static struct rpc_xprt *rpc_clnt_set_transport(struct rpc_clnt *clnt,
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



