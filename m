Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CEB72AE68;
	Mon, 30 Dec 2024 15:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574012; cv=none; b=E5ISTZaC4SvqeO9At/YA04Ub+uheau9vQNOZG3YlR5+0vkxDEAHKE37E6RXLi7AWgKQDVA1Dt8u1Ft6n5f/h+rx28qlqiWNQ2yoI0/WMB7MldlvWJE90sRXRnFN3vG8RGbHOwM7VmkASVNIqyxwVyBQRokU6PhfCG2DORe+Uoto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574012; c=relaxed/simple;
	bh=ssmQDjR4SjEv6k/wjnzsZE9sEie0QZLMt/mv7Jzmf78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ajr7QgOLpVpDj8F0mi3W0g7JJDDKxj80qxShuiJjQU8WafrVZWgB5gyZpQcxDR/R79rCHPfIgAz4FmRg/WWScnKGw6WNmUOnd60MMosYkW4nkEVOHLmABC8CUPqtKNMrKnN5ZAzGvepz8LBjuZYAmX0vHMw83eGBI3VxFEw2bO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p00+CdTM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p00+CdTM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07AE3C4CED0;
	Mon, 30 Dec 2024 15:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574012;
	bh=ssmQDjR4SjEv6k/wjnzsZE9sEie0QZLMt/mv7Jzmf78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p00+CdTM2chBwRSo9NumAr2Fr06lY1Zz1x/3lqwhQyG8aFAdwI+L10cWu9Adns5Wu
	 m6U3PRQT1v1hqvzc8CP0WKmrZStfMlvhdMOIsFe13JmoJS5cr0thbRP5kjBs6kbBfO
	 R51cMTXdaUEIErtuTPMdk3Csq4KpxG0dXQ30vZ48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 014/114] nfsd: restore callback functionality for NFSv4.0
Date: Mon, 30 Dec 2024 16:42:11 +0100
Message-ID: <20241230154218.606301954@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b8cbb1556004..de0763652549 100644
--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -1058,7 +1058,7 @@ static int setup_callback_client(struct nfs4_client *clp, struct nfs4_cb_conn *c
 		args.authflavor = clp->cl_cred.cr_flavor;
 		clp->cl_cb_ident = conn->cb_ident;
 	} else {
-		if (!conn->cb_xprt)
+		if (!conn->cb_xprt || !ses)
 			return -EINVAL;
 		clp->cl_cb_session = ses;
 		args.bc_xprt = conn->cb_xprt;
@@ -1461,8 +1461,6 @@ static void nfsd4_process_cb_update(struct nfsd4_callback *cb)
 		ses = c->cn_session;
 	}
 	spin_unlock(&clp->cl_lock);
-	if (!c)
-		return;
 
 	err = setup_callback_client(clp, &conn, ses);
 	if (err) {
-- 
2.39.5



