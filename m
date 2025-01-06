Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 724EA13B59A;
	Mon,  6 Jan 2025 15:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178699; cv=none; b=glX44D+1fubLntutfi3WJthPnFkqOm58cT8T7voEIvYdB+gWBxe5w/TOviBqEhjJmtBhUuGnx7gUnE1Tx9GU0uxI+uLhEoTf2wkxSRJDGSBuKqT/SVfXBV6oUxjuhtiRn6SDAJG6+mft9QQXUr0R9LzjNaRvW7C/bz4HE122gk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178699; c=relaxed/simple;
	bh=2+iGkMaVIaLCWgYnmqARuA0se1xKBoedPb3VnR5ztSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BeeK9nxiTR/91TOrgaMPxhHQigsB7y/Y8iFGZ8tEiD9ZQqoMM+4k7x4pDl8gEHyaB+JES9dsrHeS+X5MbcBGRJu+CspeDLXz/AO3GPP/fh+W5YnP6AtMkKJL0eowgO+Ha+ZWfC/haD4JEBNIIKI3j354B0AzktdPgYr0EM0L+ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lUlKYNj2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lUlKYNj2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E031CC4CED2;
	Mon,  6 Jan 2025 15:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178699;
	bh=2+iGkMaVIaLCWgYnmqARuA0se1xKBoedPb3VnR5ztSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lUlKYNj2BEGmM+xKKCTIdsXPZeRsBEajLq3EkajHz4o0sxR3GHrjpD9IALkYnN7mQ
	 wVF5elx8Hd6MYGzlvxDyDtdPeEn8s0cfiwYXShkpnWoqoqEzwxmppCHFwV1OtBG25q
	 +71QG5k5hUYlHssAo2HEHNrX4vkjjTrdhjT6SvBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 062/168] nfsd: restore callback functionality for NFSv4.0
Date: Mon,  6 Jan 2025 16:16:10 +0100
Message-ID: <20250106151140.804447110@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

[ Upstream commit 7917f01a286ce01e9c085e24468421f596ee1a0c ]

A recent patch inadvertently broke callbacks for NFSv4.0.

In the 4.0 case we do not expect a session to be found but still need to
call setup_callback_client() which will not try to dereference it.

This patch moves the check for failure to find a session into the 4.1+
branch of setup_callback_client()

Fixes: 1e02c641c3a4 ("NFSD: Prevent NULL dereference in nfsd4_process_cb_update()")
Signed-off-by: NeilBrown <neilb@suse.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4callback.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/nfsd/nfs4callback.c b/fs/nfsd/nfs4callback.c
index a6dc8c479a4b..d2885dd4822d 100644
--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -986,7 +986,7 @@ static int setup_callback_client(struct nfs4_client *clp, struct nfs4_cb_conn *c
 		args.authflavor = clp->cl_cred.cr_flavor;
 		clp->cl_cb_ident = conn->cb_ident;
 	} else {
-		if (!conn->cb_xprt)
+		if (!conn->cb_xprt || !ses)
 			return -EINVAL;
 		clp->cl_cb_session = ses;
 		args.bc_xprt = conn->cb_xprt;
@@ -1379,8 +1379,6 @@ static void nfsd4_process_cb_update(struct nfsd4_callback *cb)
 		ses = c->cn_session;
 	}
 	spin_unlock(&clp->cl_lock);
-	if (!c)
-		return;
 
 	err = setup_callback_client(clp, &conn, ses);
 	if (err) {
-- 
2.39.5



