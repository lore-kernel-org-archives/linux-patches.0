Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE5B155359;
	Tue, 18 Jun 2024 12:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715449; cv=none; b=YC076Aln9HnMidr2IVBGL6IFeq3zM4Pe9Xtbg6MZc98K1T4KxhTlJhn2GK+hUbTyhwWw28bG5gluPASZVVv/H0CSTDn9+NKiwVEEnHhA/hLsg852ePYBGzs/dUafbiMTbl9aRpEIA0tcUN2zLA+9bPVcNc63OvFXo0ZENXDX0rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715449; c=relaxed/simple;
	bh=cJR6awos1h13bKx+5n5N2wuihglFcJvul6mXP4MR0Bg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RdCN99SgmN28rCkMMPjHi3D3xv0SPX7XgFwUkU97g/kHgH5r/gFFlgAtNZnB8ih7LCsTdg0zgX/Pc8ZlTAwFbXUwmKp2wV2o0x58yu7f4MoffEnp2bphHI9D67KzlcC7ixAIQLS1O+c5PVy7ObwUILEIKrGNARRYnRsQ8hlQZy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bq8Zh0tA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bq8Zh0tA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC11CC3277B;
	Tue, 18 Jun 2024 12:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715449;
	bh=cJR6awos1h13bKx+5n5N2wuihglFcJvul6mXP4MR0Bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bq8Zh0tAYSj185M6xSeh8LmOVTrKyIHdNywrBJHgQ4r2RZ0evVV8DyEQEccfLKQLT
	 vHaSkz7GC4yQ4mJxAumhktdFPvqL3jP8on1X5kX01FSg/ZMSRdl1s3WK6OAPO5rdPH
	 Ke9rujo+1Vhn1m/MjjC/syt+5gyzwJxN7U7tlHQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 281/770] NFSD: Add cb_lost tracepoint
Date: Tue, 18 Jun 2024 14:32:14 +0200
Message-ID: <20240618123418.109507646@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 806d65b617d89be887fe68bfa051f78143669cd7 ]

Provide more clarity about when the callback channel is in trouble.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 2 ++
 fs/nfsd/trace.h     | 1 +
 2 files changed, 3 insertions(+)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index adf476cbf36c3..a8aa3680605bb 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1763,6 +1763,8 @@ static void nfsd4_conn_lost(struct svc_xpt_user *u)
 	struct nfsd4_conn *c = container_of(u, struct nfsd4_conn, cn_xpt_user);
 	struct nfs4_client *clp = c->cn_session->se_client;
 
+	trace_nfsd_cb_lost(clp);
+
 	spin_lock(&clp->cl_lock);
 	if (!list_empty(&c->cn_persession)) {
 		list_del(&c->cn_persession);
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index 3683076e0fcd3..afffb4912acbc 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -912,6 +912,7 @@ DEFINE_EVENT(nfsd_cb_class, nfsd_cb_##name,		\
 
 DEFINE_NFSD_CB_EVENT(setup);
 DEFINE_NFSD_CB_EVENT(state);
+DEFINE_NFSD_CB_EVENT(lost);
 DEFINE_NFSD_CB_EVENT(shutdown);
 
 TRACE_DEFINE_ENUM(RPC_AUTH_NULL);
-- 
2.43.0



