Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703033C1F45;
	Sat, 17 Oct 2026 17:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259977; cv=none; b=E9dxV77MpAa7x1ZgmdLa5Orhcf1Wm3pjDLkugGcaTDZz8EWlZ1Ql7sPLO0/a2Jyf2kYaAOHc3VgfKBuIl918zZDC40XV5x6pKVS7HfdA1GOr2lQoVl6cch1kqIO3BT+z0uTnJOdrnvI63D7VEVldCBgC05woOpIpZfGhRS7J9lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259977; c=relaxed/simple;
	bh=ybQAU8C0wkLWhkka+e0sw0nPlpkyPD3u+b9ISc084bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y+Rgkc4hXQze/MzjDtiyRZPNe/UGqZj2CBE5U9BMNIPujYQW+QSAktYY5hz9/l8/k8TiGQzCOfezjEqKjoYLx6s5Wk2OAvASHms/htZ3bgQcTm2ZkKDxlG25AkVBwLNXMW1RPbkqC8i9W9p0QI5IwOC5UUPZRRTr7VijOlnQZcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cebm/Z42; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cebm/Z42"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EEC91F000C4;
	Sat, 17 Oct 2026 17:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259976;
	bh=dERmyWOevFO9vb5oqOwB4h2Hj6crk2hdndMeoYU09lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cebm/Z4292zZif7Hs9Sjp7KQxDNGUi6k0NKeY22usCO1d2JzDY8plmSPkYHOCqBlD
	 bE7FFw82qDl8w6bmUKKhipMqA9efUppxypdQ5vPuliwk8NJ82HURm/qYj9h0FB+9CQ
	 lrjwbSUDnKYuEdQR4e16K37ynK5UBwYo/uGjsxIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeuk Kim <jeuk20.kim@samsung.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1392/1674] NFSv4/flexfiles: fix NULL dereference for NFSv4.0 data servers
Date: Sat, 17 Oct 2026 18:01:04 +0200
Message-ID: <20261017160506.900497291@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3c60edc22b8d9..a1dc557245977 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -1127,7 +1127,8 @@ static int ff_layout_async_handle_error_v4(struct rpc_task *task,
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



