Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47C070CCB;
	Mon,  8 Apr 2024 13:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583555; cv=none; b=eXUU9VM/stX1Ikn2evGJPhJluhvpoSAelo2sx9qrwFrS35fPK6kLUJ5eMowuFZWkeRMCDPNzlNluWpBVl6FI4GgmoPPz2NKXFqad1A2Vc81nGImZPAIHSQqup5IxCGvpK549VihuFxZfSQnfW15L3mTuxJ/ScZaD6mEF/ZPkbWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583555; c=relaxed/simple;
	bh=AxqKgJh8wGFEXdiDhYYcvaXfrx2zG/K/1wTZ0+r46rw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CVl5U0Y96XzSrnnruZFlqfySl+Bvzerbagjhq3+TTkrZ0h1YXXC8YR0itHsx9ry8NCXM5ylTheUNL9qL0ok4upzKzhBlUPVAqPwPgKIaG1VwU/mg9a9H52jA9Wk165ZzfXcIoLfBB4ViDUNZaOwrzAw1Tt6g0f7nxPxW0rht88k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R1F4QNjV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R1F4QNjV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BAFDC43390;
	Mon,  8 Apr 2024 13:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583555;
	bh=AxqKgJh8wGFEXdiDhYYcvaXfrx2zG/K/1wTZ0+r46rw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R1F4QNjVRozEzU+Y0AuU/gFJgJ0xrh2rSNW/PwzTRZEXTPb/spSAyGjn9B8t8UVXQ
	 ZXnxikTGSr7a7RH5czExS/Jyacl4gahQNlJeYhHv5AizuIBfQc5RwmXuio0Ody6Cnc
	 P0cu4BuRk8uU6X6ycbPAtBhssUuSEIh5IsbM3zQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Benes <vbenes@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 191/273] nfsd: hold a lighter-weight client reference over CB_RECALL_ANY
Date: Mon,  8 Apr 2024 14:57:46 +0200
Message-ID: <20240408125315.237854390@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 10396f4df8b75ff6ab0aa2cd74296565466f2c8d ]

Currently the CB_RECALL_ANY job takes a cl_rpc_users reference to the
client. While a callback job is technically an RPC that counter is
really more for client-driven RPCs, and this has the effect of
preventing the client from being unhashed until the callback completes.

If nfsd decides to send a CB_RECALL_ANY just as the client reboots, we
can end up in a situation where the callback can't complete on the (now
dead) callback channel, but the new client can't connect because the old
client can't be unhashed. This usually manifests as a NFS4ERR_DELAY
return on the CREATE_SESSION operation.

The job is only holding a reference to the client so it can clear a flag
after the RPC completes. Fix this by having CB_RECALL_ANY instead hold a
reference to the cl_nfsdfs.cl_ref. Typically we only take that sort of
reference when dealing with the nfsdfs info files, but it should work
appropriately here to ensure that the nfs4_client doesn't disappear.

Fixes: 44df6f439a17 ("NFSD: add delegation reaper to react to low memory condition")
Reported-by: Vladimir Benes <vbenes@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 7d6c657e0409d..692ede488254a 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -2888,12 +2888,9 @@ static void
 nfsd4_cb_recall_any_release(struct nfsd4_callback *cb)
 {
 	struct nfs4_client *clp = cb->cb_clp;
-	struct nfsd_net *nn = net_generic(clp->net, nfsd_net_id);
 
-	spin_lock(&nn->client_lock);
 	clear_bit(NFSD4_CLIENT_CB_RECALL_ANY, &clp->cl_flags);
-	put_client_renew_locked(clp);
-	spin_unlock(&nn->client_lock);
+	drop_client(clp);
 }
 
 static const struct nfsd4_callback_ops nfsd4_cb_recall_any_ops = {
@@ -6274,7 +6271,7 @@ deleg_reaper(struct nfsd_net *nn)
 		list_add(&clp->cl_ra_cblist, &cblist);
 
 		/* release in nfsd4_cb_recall_any_release */
-		atomic_inc(&clp->cl_rpc_users);
+		kref_get(&clp->cl_nfsdfs.cl_ref);
 		set_bit(NFSD4_CLIENT_CB_RECALL_ANY, &clp->cl_flags);
 		clp->cl_ra_time = ktime_get_boottime_seconds();
 	}
-- 
2.43.0



