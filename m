Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742A71552E4;
	Tue, 18 Jun 2024 12:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715369; cv=none; b=YWlE5BcuGwab1AUdhP7jAWXrKEmyXp26CLyrfcGLNc/Dfg9qwMLPov9clM9JEBgxmN2kNz+XYlK5ki6i4VBh97iOEX4ieKbD0C+QzT0zu6f3Oo3dBAxwmunQjadFp4WGsj5DmI02TJTihpf8wTYN899NyDMGXZzkEtLZr6uKj6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715369; c=relaxed/simple;
	bh=790OlkvarUUmcLSeLvlQD4tUqdkgNhITlvjNyYAF/1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oDpDwJmqFhIMof5+YT3ECin4JNLD4Tm0fLyA8KSOJJnB3gusfHr0egsKjoYaixgfZtoiSWuW0Z1kw+KHyc2n+sl7FLNSxftvbn8Kt7SJjmNyx3XL6g8WDbs5fdyGhRuwrzZMswruV0IcdzMsQNtkkZUOvdaZ4wGrKMRL+yO6HlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SDx8eomW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SDx8eomW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFEEDC3277B;
	Tue, 18 Jun 2024 12:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715369;
	bh=790OlkvarUUmcLSeLvlQD4tUqdkgNhITlvjNyYAF/1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SDx8eomWRhOz7rm1HG5Cu4jhVZmc2/b2dV47kTMhGPfyRQM7lnoXda4TbVDfpxY29
	 bKh4icQTT6reIS3c2UMexJvE6VBU7ITlai+Y/5whFZEEdo28Vi7HXwdYCqsbF0+Exv
	 0O5fGWAI0w6HGZzCeBO6wwdbVYRKSVmP9QvKJL+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 286/770] NFSD: Replace the nfsd_deleg_break tracepoint
Date: Tue, 18 Jun 2024 14:32:19 +0200
Message-ID: <20240618123418.303722977@linuxfoundation.org>
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

[ Upstream commit 17d76ddf76e4972411402743eea7243d9a46f4f9 ]

Renamed so it can be enabled as a set with the other nfsd_cb_
tracepoints. And, consistent with those tracepoints, report the
address of the client, the client ID the server has given it, and
the state ID being recalled.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c |  2 +-
 fs/nfsd/trace.h     | 32 +++++++++++++++++++++++++++++++-
 2 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 89054fe68aca6..09967037eb1a3 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4675,7 +4675,7 @@ nfsd_break_deleg_cb(struct file_lock *fl)
 	struct nfs4_delegation *dp = (struct nfs4_delegation *)fl->fl_owner;
 	struct nfs4_file *fp = dp->dl_stid.sc_file;
 
-	trace_nfsd_deleg_break(&dp->dl_stid.sc_stateid);
+	trace_nfsd_cb_recall(&dp->dl_stid);
 
 	/*
 	 * We don't want the locks code to timeout the lease for us;
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index fe32dfe1e55af..9061fd28c996d 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -459,7 +459,6 @@ DEFINE_STATEID_EVENT(layout_recall_release);
 
 DEFINE_STATEID_EVENT(open);
 DEFINE_STATEID_EVENT(deleg_read);
-DEFINE_STATEID_EVENT(deleg_break);
 DEFINE_STATEID_EVENT(deleg_recall);
 
 DECLARE_EVENT_CLASS(nfsd_stateseqid_class,
@@ -1027,6 +1026,37 @@ TRACE_EVENT(nfsd_cb_done,
 		__entry->status)
 );
 
+TRACE_EVENT(nfsd_cb_recall,
+	TP_PROTO(
+		const struct nfs4_stid *stid
+	),
+	TP_ARGS(stid),
+	TP_STRUCT__entry(
+		__field(u32, cl_boot)
+		__field(u32, cl_id)
+		__field(u32, si_id)
+		__field(u32, si_generation)
+		__array(unsigned char, addr, sizeof(struct sockaddr_in6))
+	),
+	TP_fast_assign(
+		const stateid_t *stp = &stid->sc_stateid;
+		const struct nfs4_client *clp = stid->sc_client;
+
+		__entry->cl_boot = stp->si_opaque.so_clid.cl_boot;
+		__entry->cl_id = stp->si_opaque.so_clid.cl_id;
+		__entry->si_id = stp->si_opaque.so_id;
+		__entry->si_generation = stp->si_generation;
+		if (clp)
+			memcpy(__entry->addr, &clp->cl_cb_conn.cb_addr,
+				sizeof(struct sockaddr_in6));
+		else
+			memset(__entry->addr, 0, sizeof(struct sockaddr_in6));
+	),
+	TP_printk("addr=%pISpc client %08x:%08x stateid %08x:%08x",
+		__entry->addr, __entry->cl_boot, __entry->cl_id,
+		__entry->si_id, __entry->si_generation)
+);
+
 TRACE_EVENT(nfsd_cb_notify_lock,
 	TP_PROTO(
 		const struct nfs4_lockowner *lo,
-- 
2.43.0



