Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C961552E4;
	Tue, 18 Jun 2024 12:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715363; cv=none; b=dEobs1NwxrJhbbSEIBZ6OrCzfXnWMKFQwMTNlUOfgDsiqpuDsftp63qn2qljNfK18xtxx2tL711Ho5M4EB+e6aWmvrwjCov02t8TlUyp/4WnY1N0Gkjs9RTxk46/2H8znqULr5G2RiKS/v2PrP75DVVeHPJ3SqjLBaTLVChujyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715363; c=relaxed/simple;
	bh=fUOd7P0icbLskhUs5O7/JFWdBT9T+UD1pFlXM+MMPVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Twt7EYKkoXHAuOzYZQt3PizWrUU1RN4W2tAZFn8SUQKzO5VoqJVA87ftCBjurZvH3YADfuw2UPvU0OoVuTGHbRyUyELPa2eCi+JoMRbTUz3rlIClDYp+Ynpz/C/x0fNDJJBKl8ptFBsuoNA0rwyQNDH18n36i6IX9m12BBV0p9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PETnH6b1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PETnH6b1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09798C3277B;
	Tue, 18 Jun 2024 12:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715363;
	bh=fUOd7P0icbLskhUs5O7/JFWdBT9T+UD1pFlXM+MMPVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PETnH6b1EMvL2dF12zYhXNCiYye2hoDr/MMl7nH6BwgRPUFlUOFkLIyT6pjETgnaL
	 7bQUvY14sDZRPOImkvFKzMSfRYFML4ZOjKfr7S542Itve09Q2hP+lbOmXKCqx7O9/5
	 bLFtQ1JXkix+w46CEmx+9Sn2WPCeyEExHEOgszw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@redhat.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 284/770] NFSD: Add an nfsd_cb_lm_notify tracepoint
Date: Tue, 18 Jun 2024 14:32:17 +0200
Message-ID: <20240618123418.227425238@linuxfoundation.org>
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

[ Upstream commit 2cde7f8118f0fea29ad73ddcf28817f95adeffd5 ]

When the server kicks off a CB_LM_NOTIFY callback, record its
arguments so we can better observe asynchronous locking behavior.
For example:

            nfsd-998   [002]  1471.705873: nfsd_cb_notify_lock:  addr=192.168.2.51:0 client 6092a47c:35a43fc1 fh_hash=0x8950b23a

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: Jeff Layton <jlayton@redhat.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c |  4 +++-
 fs/nfsd/trace.h     | 26 ++++++++++++++++++++++++++
 2 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index a8aa3680605bb..89054fe68aca6 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -6494,8 +6494,10 @@ nfsd4_lm_notify(struct file_lock *fl)
 	}
 	spin_unlock(&nn->blocked_locks_lock);
 
-	if (queue)
+	if (queue) {
+		trace_nfsd_cb_notify_lock(lo, nbl);
 		nfsd4_run_cb(&nbl->nbl_cb);
+	}
 }
 
 static const struct lock_manager_operations nfsd_posix_mng_ops  = {
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index 86e0656bdb779..bed7d5d49fee4 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -1027,6 +1027,32 @@ TRACE_EVENT(nfsd_cb_done,
 		__entry->status)
 );
 
+TRACE_EVENT(nfsd_cb_notify_lock,
+	TP_PROTO(
+		const struct nfs4_lockowner *lo,
+		const struct nfsd4_blocked_lock *nbl
+	),
+	TP_ARGS(lo, nbl),
+	TP_STRUCT__entry(
+		__field(u32, cl_boot)
+		__field(u32, cl_id)
+		__field(u32, fh_hash)
+		__array(unsigned char, addr, sizeof(struct sockaddr_in6))
+	),
+	TP_fast_assign(
+		const struct nfs4_client *clp = lo->lo_owner.so_client;
+
+		__entry->cl_boot = clp->cl_clientid.cl_boot;
+		__entry->cl_id = clp->cl_clientid.cl_id;
+		__entry->fh_hash = knfsd_fh_hash(&nbl->nbl_fh);
+		memcpy(__entry->addr, &clp->cl_cb_conn.cb_addr,
+			sizeof(struct sockaddr_in6));
+	),
+	TP_printk("addr=%pISpc client %08x:%08x fh_hash=0x%08x",
+		__entry->addr, __entry->cl_boot, __entry->cl_id,
+		__entry->fh_hash)
+);
+
 #endif /* _NFSD_TRACE_H */
 
 #undef TRACE_INCLUDE_PATH
-- 
2.43.0



