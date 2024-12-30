Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B27C15E8B;
	Mon, 30 Dec 2024 15:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573700; cv=none; b=AjPP8WLOZ3IOjL154z3FFIHbGVt1L9niGVvlu+bFmosUq4r6t5oF9qfGSSa1CEQ1vLzljf8asZY9BKQLScTS/Mlb6GxOVsZPddyypMFjboQxAYfMsMtV/x7yEc1dgUGTzPkNVWkmW1R/0ud629rtQPboZVGyxFPMfmjt7dFWPOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573700; c=relaxed/simple;
	bh=7d2pxtzgdb+l5fXEwGJIYI0o5rmUYJ6EakHPnnuRSUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k8AgPZLNkphvVJ3QuP+GT6oMACa0xXZG/i5qZWiENeIH4oqHXivmo7qNaaOrGcZt61HB7FhTZJKXo/FwVirXJMBDnvo4ALYTKbf4+s1bQrWVyAXhhCTLmHBfsGk7yVpdHj0jPP37qw6XJblbABPHZVOuPxBo+j0bR1ALg9Av3bU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DpUOyM92; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DpUOyM92"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0CCBC4CED0;
	Mon, 30 Dec 2024 15:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573700;
	bh=7d2pxtzgdb+l5fXEwGJIYI0o5rmUYJ6EakHPnnuRSUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DpUOyM9240/e7C3S1l3aAen58dZz+JnA7EZ1d92UIGLFvf5Ag01FCiVEpQ0zk8l1h
	 nXagKgwVadYVLbVANhDiY7sWA9SPmcV5PRP0bPpKlk/wcXQ0rgk4WTNm/ltaZY2lzy
	 oemoNvsHpqNXNA6rPzs8/81sI3mzzAG9B+YPemMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 10/86] nfsd: restore callback functionality for NFSv4.0
Date: Mon, 30 Dec 2024 16:42:18 +0100
Message-ID: <20241230154212.106513472@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 49a49529c6b8..54ffadf02e03 100644
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



