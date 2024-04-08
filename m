Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 140227C080;
	Mon,  8 Apr 2024 13:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584621; cv=none; b=QhFRzBNAOO/6KPU8//FgFSlwLtgoPtFItFvtNWsMcsmZ9fdtcAmCOQkN9PfnC1jNvWcUpAdpIrOi+DnNoCLnbqbTJeR+jjfHWEuxR3ExOe9Gp4+PgnKyVIDD9bUVxMzq8Iq8snwBg2hNJu9oi9STBlstAFoYREUAum9zMoD5oBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584621; c=relaxed/simple;
	bh=xC7SCZuMdjdaYip8Y8UJ06e0d4zqq2VKLLOJy92HWtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i/ASED0Alp2uX/lIbmibvZGn3PfUNlEBm0gP5EogbPz9eOfNOvaqyidtg7FRGzJLkogZdrkRPI/iniKFehY111sWIjxOrZ3Wt1gSoBLUhkV3nDAhuQ3TU6LLL3ANKLIhz7+wBr5degoRsi2kMzMoTG42QVV/HW+6Vm8J+fGsMuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AifQo41A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AifQo41A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3987AC43390;
	Mon,  8 Apr 2024 13:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584620;
	bh=xC7SCZuMdjdaYip8Y8UJ06e0d4zqq2VKLLOJy92HWtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AifQo41AgXThZ9ARsrf2UilYg229FHsW6558BwDVELE5770pQdlnC4ERYPpriLCwJ
	 OueLdKJNGtl/jknSDcSyMuh1l5toOxwDM04NzpM+9HYxot8CUVellP7eNo9slOGS7i
	 7zii0/0Wv1F4/Xugd0LE6V2dzyEn9MwKRsSzXF7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 5.15 483/690] NFSD: Trace delegation revocations
Date: Mon,  8 Apr 2024 14:55:49 +0200
Message-ID: <20240408125417.137981662@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit a1c74569bbde91299f24535abf711be5c84df9de ]

Delegation revocation is an exceptional event that is not otherwise
visible externally (eg, no network traffic is emitted). Generate a
trace record when it occurs so that revocation can be observed or
other activity can be triggered. Example:

nfsd-1104  [005]  1912.002544: nfsd_stid_revoke:        client 633c9343:4e82788d stateid 00000003:00000001 ref=2 type=DELEG

Trace infrastructure is provided for subsequent additional tracing
related to nfs4_stid activity.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Tested-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4state.c |  2 ++
 fs/nfsd/trace.h     | 55 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 9351111730834..b2a4d442af669 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1366,6 +1366,8 @@ static void revoke_delegation(struct nfs4_delegation *dp)
 
 	WARN_ON(!list_empty(&dp->dl_recall_lru));
 
+	trace_nfsd_stid_revoke(&dp->dl_stid);
+
 	if (clp->cl_minorversion) {
 		spin_lock(&clp->cl_lock);
 		dp->dl_stid.sc_type = NFS4_REVOKED_DELEG_STID;
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index d55a05f1a58f7..d50d4d6e822df 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -637,6 +637,61 @@ DEFINE_EVENT(nfsd_stateseqid_class, nfsd_##name, \
 DEFINE_STATESEQID_EVENT(preprocess);
 DEFINE_STATESEQID_EVENT(open_confirm);
 
+TRACE_DEFINE_ENUM(NFS4_OPEN_STID);
+TRACE_DEFINE_ENUM(NFS4_LOCK_STID);
+TRACE_DEFINE_ENUM(NFS4_DELEG_STID);
+TRACE_DEFINE_ENUM(NFS4_CLOSED_STID);
+TRACE_DEFINE_ENUM(NFS4_REVOKED_DELEG_STID);
+TRACE_DEFINE_ENUM(NFS4_CLOSED_DELEG_STID);
+TRACE_DEFINE_ENUM(NFS4_LAYOUT_STID);
+
+#define show_stid_type(x)						\
+	__print_flags(x, "|",						\
+		{ NFS4_OPEN_STID,		"OPEN" },		\
+		{ NFS4_LOCK_STID,		"LOCK" },		\
+		{ NFS4_DELEG_STID,		"DELEG" },		\
+		{ NFS4_CLOSED_STID,		"CLOSED" },		\
+		{ NFS4_REVOKED_DELEG_STID,	"REVOKED" },		\
+		{ NFS4_CLOSED_DELEG_STID,	"CLOSED_DELEG" },	\
+		{ NFS4_LAYOUT_STID,		"LAYOUT" })
+
+DECLARE_EVENT_CLASS(nfsd_stid_class,
+	TP_PROTO(
+		const struct nfs4_stid *stid
+	),
+	TP_ARGS(stid),
+	TP_STRUCT__entry(
+		__field(unsigned long, sc_type)
+		__field(int, sc_count)
+		__field(u32, cl_boot)
+		__field(u32, cl_id)
+		__field(u32, si_id)
+		__field(u32, si_generation)
+	),
+	TP_fast_assign(
+		const stateid_t *stp = &stid->sc_stateid;
+
+		__entry->sc_type = stid->sc_type;
+		__entry->sc_count = refcount_read(&stid->sc_count);
+		__entry->cl_boot = stp->si_opaque.so_clid.cl_boot;
+		__entry->cl_id = stp->si_opaque.so_clid.cl_id;
+		__entry->si_id = stp->si_opaque.so_id;
+		__entry->si_generation = stp->si_generation;
+	),
+	TP_printk("client %08x:%08x stateid %08x:%08x ref=%d type=%s",
+		__entry->cl_boot, __entry->cl_id,
+		__entry->si_id, __entry->si_generation,
+		__entry->sc_count, show_stid_type(__entry->sc_type)
+	)
+);
+
+#define DEFINE_STID_EVENT(name)					\
+DEFINE_EVENT(nfsd_stid_class, nfsd_stid_##name,			\
+	TP_PROTO(const struct nfs4_stid *stid),			\
+	TP_ARGS(stid))
+
+DEFINE_STID_EVENT(revoke);
+
 DECLARE_EVENT_CLASS(nfsd_clientid_class,
 	TP_PROTO(const clientid_t *clid),
 	TP_ARGS(clid),
-- 
2.43.0



