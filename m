Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F8C14A617;
	Mon,  6 Jan 2025 15:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178232; cv=none; b=BPMpC9aR0gQU6F7g5+GPB9WKWFgMAe5e0uEnBkf1yt1ehe3jz5JBVsFjFWazsNPugfughdu6XsxcDSCDm5nFTt8NEs5e/iDF3jVQYCUFcfWKOdABLMYaDw4S7JXUkRoHj+z2qRlhTSNYrRhPBUgn2V31CT2rIPFwZ2WQN+t8iRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178232; c=relaxed/simple;
	bh=/LHTsjrP/FHh/WZNO/qVJyJKVqo65U8Ph2udlv1j4DU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QakbXO8LhhzqaLR0FmVaKA/sFwm6+dxIwB6Q4UVLB4MH5Bimge3gW45JuAoXym/fRMvsuUFBSyR+RF5umr52ACKBqtZpaT5Ey5xB3hHVPf9G9wx3Rzh9DNqQutuI7RdV1+aBD5x1jUK1CBY2l/WdnB9URP1MJSeRIUc5bpvtr1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1B/K8DZ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1B/K8DZ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3388C4CED2;
	Mon,  6 Jan 2025 15:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178232;
	bh=/LHTsjrP/FHh/WZNO/qVJyJKVqo65U8Ph2udlv1j4DU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1B/K8DZ/eREXIooa2NxySb5Ek7Z+gVnRW7RXrJv3U/VdkmlpMyHJTj0N3h/YxciGi
	 Ncht8otO7UiZZnGDqrn3lWPWkJrqCOe4Cx2XBrNWSYF93OsypkBB6Yf1gtrOza4d6S
	 ZR4apMWWVVoBml466Cw8FFqEcVjr1tb1ziKrtJaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 048/138] nfsd: restore callback functionality for NFSv4.0
Date: Mon,  6 Jan 2025 16:16:12 +0100
Message-ID: <20250106151135.055673353@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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



