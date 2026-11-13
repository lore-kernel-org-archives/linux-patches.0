Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590824;
	b=colvNOuUXyIBaUYOKWvhjgY5lK2tqqZooUAZgeREnmhfVF9BBxtXGjZTNUvdMIhll5ye
	 Lel3Q8//Jas/S+/Vmj1jQok8d2/SOnZ0zW5ffHJ4jTjqZVjErH7XyOtDUlz7jm9RJtKvX
	 BBYcj25tAMdN6+xCqv6c3ozVN0wtzzNVe2W7v1W0Xfo8UtTO2eC4PHdChGkAVqVjTht4V
	 9U9ON98PNgUPllLVJN1RaHy6oNMZ75vCBqfGhNl+R283xihkF/MfaxHO13uwNi8uV7eQ2
	 NNs1UOkr5K4kbPzPJsx0W0mkcNcd6oIRGCloj1+FuoHL62pstdHn296NcT16Wjmr85Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590824;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CAlmhyW/OtXufw3u3wHxxj63LdaY64JAxkqkRhjAzhI=;
	b=KXt4rNnXBQeMvF9PRa4oyMXRH+7ckeF7W0sNL77LLIwjPP7kO5bLyiDSisgQ7fXAZO/z
	 0LcNwAks3+P0s+hTd450RD+k+fpI0t5Pq+cmjTn4daHFuJR/wezbKEiwwt2SkakVPFaKm
	 3ojZo1BS2IDY3eINvUyBWuxpqARO1X85tcQ+G9PUdHGI6cqGOLw/+3Rq9RRGttKm7/a+M
	 95H2JBSbKqyNBgHcUKbQw+p14punbnOPhpbzfv0llBw6W+o6XPXkpde6Nb/uW2PBZpCnJ
	 E/gINufLH4Vgu1/YLWR8YDl+ZgyUre6Iql2+RAGcK41SSPl4JsposLzBKceWvBiHs3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mdlSLcb7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47C2607E063;
	Fri, 13 Nov 2026 17:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mdlSLcb7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7117C1F000C4;
	Fri, 13 Nov 2026 17:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590824;
	bh=CAlmhyW/OtXufw3u3wHxxj63LdaY64JAxkqkRhjAzhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mdlSLcb7WWmhKTcllYLFPJYfbu3KU8RS0K79p43oJlMh8clwdcfnAMdE99M/LbxAY
	 ZUFMv9CN7jS/vkytYOED/5HpEHNNhMDB2NYhWTRZNwRBRqEhh15ZndD/D3NVFb0fOb
	 FzHrYTbc3jqk7THZTiksNquzPsaZnpVcMTi+gCEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 030/670] nfsd: eliminate cl_ra_cblist and NFSD4_CLIENT_CB_RECALL_ANY
Date: Fri, 13 Nov 2026 10:43:14 -0500
Message-ID: <20261113153812.193610904@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 424dd3df1f991b14a70f044a68c8a595abbdf1ad ]

deleg_reaper() will walk the client_lru list and put any suitable
entries onto "cblist" using the cl_ra_cblist pointer. It then walks the
objects outside the spinlock and queues callbacks for them.

None of the operations that deleg_reaper() does outside the
nn->client_lock are blocking operations. Just queue their workqueue jobs
under the nn->client_lock instead.

Also, the NFSD4_CLIENT_CB_RECALL_ANY and NFSD4_CALLBACK_RUNNING flags
serve an identical purpose now. Drop the NFSD4_CLIENT_CB_RECALL_ANY flag
and just use the one in the callback.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: 9af39c0773ef ("NFSD: Send a meaningful CB_RECALL_ANY keep count")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 16 +++-------------
 fs/nfsd/state.h     |  2 --
 2 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 2188c15d3ec6c..b9d3e134dc1b4 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -3246,7 +3246,6 @@ nfsd4_cb_recall_any_release(struct nfsd4_callback *cb)
 {
 	struct nfs4_client *clp = cb->cb_clp;
 
-	clear_bit(NFSD4_CLIENT_CB_RECALL_ANY, &clp->cl_flags);
 	drop_client(clp);
 }
 
@@ -7005,7 +7004,6 @@ deleg_reaper(struct nfsd_net *nn)
 {
 	struct list_head *pos, *next;
 	struct nfs4_client *clp;
-	LIST_HEAD(cblist);
 
 	spin_lock(&nn->client_lock);
 	list_for_each_safe(pos, next, &nn->client_lru) {
@@ -7019,31 +7017,23 @@ deleg_reaper(struct nfsd_net *nn)
 			continue;
 		if (atomic_read(&clp->cl_delegs_in_recall))
 			continue;
-		if (test_bit(NFSD4_CLIENT_CB_RECALL_ANY, &clp->cl_flags))
+		if (test_and_set_bit(NFSD4_CALLBACK_RUNNING, &clp->cl_ra->ra_cb.cb_flags))
 			continue;
 		if (ktime_get_boottime_seconds() - clp->cl_ra_time < 5)
 			continue;
 		if (clp->cl_cb_state != NFSD4_CB_UP)
 			continue;
-		list_add(&clp->cl_ra_cblist, &cblist);
 
 		/* release in nfsd4_cb_recall_any_release */
 		kref_get(&clp->cl_nfsdfs.cl_ref);
-		set_bit(NFSD4_CLIENT_CB_RECALL_ANY, &clp->cl_flags);
 		clp->cl_ra_time = ktime_get_boottime_seconds();
-	}
-	spin_unlock(&nn->client_lock);
-
-	while (!list_empty(&cblist)) {
-		clp = list_first_entry(&cblist, struct nfs4_client,
-					cl_ra_cblist);
-		list_del_init(&clp->cl_ra_cblist);
 		clp->cl_ra->ra_keep = 0;
 		clp->cl_ra->ra_bmval[0] = BIT(RCA4_TYPE_MASK_RDATA_DLG) |
 						BIT(RCA4_TYPE_MASK_WDATA_DLG);
 		trace_nfsd_cb_recall_any(clp->cl_ra);
-		nfsd4_try_run_cb(&clp->cl_ra->ra_cb);
+		nfsd4_run_cb(&clp->cl_ra->ra_cb);
 	}
+	spin_unlock(&nn->client_lock);
 }
 
 static void
diff --git a/fs/nfsd/state.h b/fs/nfsd/state.h
index e4c3e5907db15..4e0e36b81b203 100644
--- a/fs/nfsd/state.h
+++ b/fs/nfsd/state.h
@@ -412,7 +412,6 @@ struct nfs4_client {
 #define NFSD4_CLIENT_UPCALL_LOCK	(5)	/* upcall serialization */
 #define NFSD4_CLIENT_CB_FLAG_MASK	(1 << NFSD4_CLIENT_CB_UPDATE | \
 					 1 << NFSD4_CLIENT_CB_KILL)
-#define NFSD4_CLIENT_CB_RECALL_ANY	(6)
 	unsigned long		cl_flags;
 
 	struct workqueue_struct *cl_callback_wq;
@@ -461,7 +460,6 @@ struct nfs4_client {
 
 	struct nfsd4_cb_recall_any	*cl_ra;
 	time64_t		cl_ra_time;
-	struct list_head	cl_ra_cblist;
 };
 
 /* struct nfs4_client_reset
-- 
2.53.0



