Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2D11CA6F;
	Sat, 12 Sep 2026 11:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211529; cv=none; b=uAw5l2BUH60YPz27h86SYSU7Vi77xW5UHVTGZU61fVoDkwGp0Y6AHxhljHk/pywkOw49PKQsBNTKotTa8uPVlmRHJ5wCY6trWJowjr73aS4NZn1pGt4+e7ScgOarma4tNgHZLZEh8qcDOiRtPmOG7WM6lWyk88UymZHWLIPCjUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211529; c=relaxed/simple;
	bh=FwzR2SD82Fx6kibsaWsTuQqTseuoY3gn+EX4HY3p8bQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LOgUTnqO5W0pG2nt7hvVPnBAyB5vgI3XmXWGBdo0GR3kJQmjfS583QZnGbCbGh6mdK4/J0F9b4OREABJeoRDviLld70ZgLAQwEaX5syjyOFo3DpAM+SZQSBaUDdnjzRvrudZ/b7n5/HjAteqrIWwGzsSHnpj3EzCIW7GHHngadw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DH12FiZ1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DH12FiZ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACB511F000FF;
	Sat, 12 Sep 2026 11:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211527;
	bh=spHHkf4/hsest5UPTn/3OxkG9dtOuuQjOJAb0ofnAX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DH12FiZ1OnN3pK8RUksyRCCn6yyYgOOtCauo/artk+PLSX8Oxe7h+y/0fCUa3kWDm
	 2KoUZ1lVFyXsXQ2tAyTNBlvxyNur6244R/hmqj0HCXuo03IIyac33uHqaCG93NuqMx
	 Mh7SS7LCC50GKGGXOxHl0VZ+NYOthp9vgNDDbxNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeuk Kim <jeuk20.kim@samsung.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1250/1518] NFSv4/flexfiles: fix NULL dereference for NFSv4.0 data servers
Date: Sat, 12 Sep 2026 08:56:59 +0200
Message-ID: <20260912065651.786548302@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 4604f10882722..8099bfc4fe2f8 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -1324,7 +1324,8 @@ static int ff_layout_async_handle_error_v4(struct rpc_task *task,
 	struct pnfs_layout_hdr *lo = lseg->pls_layout;
 	struct inode *inode = lo->plh_inode;
 	struct nfs4_deviceid_node *devid = FF_LAYOUT_DEVID_NODE(lseg, idx, dss_id);
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



