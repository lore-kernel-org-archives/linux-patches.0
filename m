Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB13377A92;
	Sat, 17 Oct 2026 16:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254953; cv=none; b=bC94JhtNf3dcUJCpeBA/IglNIcoXLzRpfw2FV9bz6VJjLML+x75z1yW4BQyTjScX33YYdyDxjB0DAt0D70Ckle2xDQvUYtnxpmH+Zwy+n2v5q6/EVZBdPczBJBnpV+qXbex2t2IasZXTJCKJzIXmrAUyq+ZE9HreCBRV4Da1f9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254953; c=relaxed/simple;
	bh=hKZ7oW5SXy0KPCHbHvka6hvFSYP55CBQTiv/J86GN9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fhCVTE4aad3UdKgdqEf3MNce2JhsEnkLcWMD5H9jUgtZTKdE4EdDBymNhdqT5RFX/x6ZDuZDplHluSGQWthVphbbdcSLBCLSHItQRHQVu+QqDxOEoTV4xWFE+gmLsPfXezaGYMfPUWP2R4fBbHmjp7A0xAJ+JJAKpVCKLz3I2Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mWx7leIl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mWx7leIl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E80551F000C4;
	Sat, 17 Oct 2026 16:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254952;
	bh=AZWrSwR7jGBwP9sNqNy4wJ/rEAt3Qk9ElwCrdzVHrHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mWx7leIlarY+cxb4+yzjjP56EmvbhmW8U0i1RzJ43sWL/0PsDZN82X8wgTlPnPk/p
	 8kkajBXbDNXlZPCA3aNx0vLrgKjn6jaDvWiThF8Wbf1vsb0KqXbVPoY7hw5p/L7f6q
	 GH7ck7Dn4op90+WocGl+0GFJOzZSua/alnwa8nIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeuk Kim <jeuk20.kim@samsung.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 617/869] NFSv4/flexfiles: fix NULL dereference for NFSv4.0 data servers
Date: Sat, 17 Oct 2026 17:57:38 +0200
Message-ID: <20261017160052.849706652@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Jeuk Kim <jeuk20.kim@gmail.com>

[ Upstream commit 2b03ebbf8d5e8f6af4ecd6c65375232dd1ec32cc ]

flexfiles accepts NFSv4.0 data servers, but two NFSv4 code paths assume
the data server client has a session. Unlike NFSv4.1+, an NFSv4.0 client
has no session (clp->cl_session is NULL; it uses clp->cl_slot_tbl), so
I/O to a v4.0 flexfiles DS oopses:

  - nfs4_init_ds_session() dereferences clp->cl_session->session_state
    while seeding the DS lease. It also only seeds cl_lease_time when
    NFS4_SESSION_INITING is set; without a session that never happens, so
    cl_lease_time stays 0 and nfs4_renew_state() busy-loops, requeuing
    every 5 seconds. Seed the lease whenever there is no session and
    return before touching session state.

  - ff_layout_async_handle_error_v4() dereferences
    clp->cl_session->fc_slot_table on every DS I/O error. Fall back to the
    v4.0 transport slot table (clp->cl_slot_tbl) when there is no session.

Fixes: a7878ca14008 ("nfs: flexfilelayout: remove v3-only data server limitation")
Signed-off-by: Jeuk Kim <jeuk20.kim@samsung.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/flexfilelayout/flexfilelayout.c |  3 ++-
 fs/nfs/nfs4session.c                   | 16 +++++++++++-----
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/nfs/flexfilelayout/flexfilelayout.c b/fs/nfs/flexfilelayout/flexfilelayout.c
index 7de5575f4bee2..61705e7f0be7a 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -1154,7 +1154,8 @@ static int ff_layout_async_handle_error_v4(struct rpc_task *task,
 	struct pnfs_layout_hdr *lo = lseg->pls_layout;
 	struct inode *inode = lo->plh_inode;
 	struct nfs4_deviceid_node *devid = FF_LAYOUT_DEVID_NODE(lseg, idx);
-	struct nfs4_slot_table *tbl = &clp->cl_session->fc_slot_table;
+	struct nfs4_slot_table *tbl = nfs4_has_session(clp) ?
+		&clp->cl_session->fc_slot_table : clp->cl_slot_tbl;
 
 	switch (op_status) {
 	case NFS4_OK:
diff --git a/fs/nfs/nfs4session.c b/fs/nfs/nfs4session.c
index 5db460476bf2a..c59e710eb7ccc 100644
--- a/fs/nfs/nfs4session.c
+++ b/fs/nfs/nfs4session.c
@@ -634,16 +634,22 @@ int nfs4_init_ds_session(struct nfs_client *clp, unsigned long lease_time)
 	int ret;
 
 	spin_lock(&clp->cl_lock);
-	if (test_and_clear_bit(NFS4_SESSION_INITING, &session->session_state)) {
-		/*
-		 * Do not set NFS_CS_CHECK_LEASE_TIME instead set the
-		 * DS lease to be equal to the MDS lease.
-		 */
+	/*
+	 * Do not set NFS_CS_CHECK_LEASE_TIME instead set the
+	 * DS lease to be equal to the MDS lease.
+	 *
+	 * A v4.0 DS has no session, so seed the lease every time.
+	 */
+	if (!session ||
+	    test_and_clear_bit(NFS4_SESSION_INITING, &session->session_state)) {
 		clp->cl_lease_time = lease_time;
 		clp->cl_last_renewal = jiffies;
 	}
 	spin_unlock(&clp->cl_lock);
 
+	if (!session)
+		return 0;
+
 	ret = nfs41_check_session_ready(clp);
 	if (ret)
 		return ret;
-- 
2.53.0



