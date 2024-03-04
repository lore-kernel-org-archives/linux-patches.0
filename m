Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96FDD7BB05;
	Mon,  4 Mar 2024 21:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589036; cv=none; b=pnGBUaK+TnIENDtycgXj3FVS9uo+vRRwEIMvQEvgzLrYjtMX9VSgfqWPyy9FccLsJ3w8FIcalCESrZN1mo7oyEiodS7NNkADKrZFe6nYaZU5CzjWDxMQ49sxcmzdfHzHCh2LXu1P3bVIIh57kSZZQ03cL7WzrbFtJY41slvoggA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589036; c=relaxed/simple;
	bh=FfbRYMP+vVc7py1LLw1CHFnJXHviEVM6/dAs+WBUmSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EOpPSuN1ahW2nRb57l9yQ057t4qjhWDHUgIJlo89xHhYy7J+4iDXcQmNUl2BITqvfaoIWm2UVqyxhUwE5sh7uJhCwlQcOPuq3y8RSogycYWbcislANcrbkWIZa/Gx+kdAdahogUGsUB14Zrcx/QQMsnTxC18cLDODi/yX5RSAmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HxrFqSaN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HxrFqSaN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 297A1C433F1;
	Mon,  4 Mar 2024 21:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589036;
	bh=FfbRYMP+vVc7py1LLw1CHFnJXHviEVM6/dAs+WBUmSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HxrFqSaNtcS9zahlfR9cNgtk+T84hIE7sg/zuqMk9SyvH5xVBnn9Nfz2aEVIVeBaR
	 hAEsKjNsKoMWNLC9NnP+SbsICPqNpX56kCmmiJEFsbCPYLbKfD5p0O/Wnc8qvhbvp/
	 scKuyL2bPXgRfTjxgVmJXoA/pyd3a/RL4kSMqoWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 6.1 152/215] NFSD: Trace delegation revocations
Date: Mon,  4 Mar 2024 21:23:35 +0000
Message-ID: <20240304211601.841981116@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |    2 +
 fs/nfsd/trace.h     |   55 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1367,6 +1367,8 @@ static void revoke_delegation(struct nfs
 
 	WARN_ON(!list_empty(&dp->dl_recall_lru));
 
+	trace_nfsd_stid_revoke(&dp->dl_stid);
+
 	if (clp->cl_minorversion) {
 		spin_lock(&clp->cl_lock);
 		dp->dl_stid.sc_type = NFS4_REVOKED_DELEG_STID;
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -637,6 +637,61 @@ DEFINE_EVENT(nfsd_stateseqid_class, nfsd
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


