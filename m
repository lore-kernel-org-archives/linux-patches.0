Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4A756B853;
	Wed,  9 Sep 2026 14:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964744; cv=none; b=s76EiKwh8n9DotTr6djaSiMNS+L3jFs+zd0fJrdRphlfv/5MWwy1EQ/J+ywBHAeOTKUejioo8vxZMDD+6ffNWZwTnnBof1r311AZif6hNGZ2KijKdpbvtxzWnGpF54KSvd+iGBHnZD1hMItBw1p/rKngTCf6VBVsTJE6mhYVLV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964744; c=relaxed/simple;
	bh=e8E1CQmNjgTd7fNThAu043sWfv8vj33FsbJ+JIQqfZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mk5o/LOSMDbHgMxyLw6WV2wc5LZJZ1gXL9ObbVhL96HrO/WN5YnxK0hmZXyaYLzNfyW+N6BiouIoFb4z2oTzOqbaRlWeId7pexxDf6teYGOa0DNfAkvDiJEyb1/n9lVXZpAAF/WL/YRVOYvca/DCuo9xcp+GetZFrEuzx8Q9y6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oHGLXeph; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oHGLXeph"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 546951F00A3A;
	Wed,  9 Sep 2026 14:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964742;
	bh=IP5lPP3lhyhW2Q2IW4AlNXxHC4HVuKTIY+alQ2DmD8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oHGLXephVNATdnjF0c5KlRlDbVjDGnNuM0YsAYnvGxHHWad3Bcezu6l/DwJrQc6Z+
	 9YKlu6+z73haIRPugYE8P5kTa5gvOskbopo16bOaPYYVCQcu7wqbx+Y6EsAT8mkZjW
	 TnnA7k25tn9s9XG1iFmfiv8tXxJzXxlwmKV3uR+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 529/583] nfsd: move struct nfsd_genl_rqstp to nfsctl.c
Date: Wed,  9 Sep 2026 15:43:34 +0200
Message-ID: <20260909134256.135083813@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

commit 1ed3df33bdbda5fd639571afe9c7cd282ff82cd9 upstream.

It's not used outside of that file.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: a99d720ed2a5 ("nfsd: widen nfsd_genl_rqstp address fields to sockaddr_storage")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsctl.c |   15 +++++++++++++++
 fs/nfsd/nfsd.h   |   15 ---------------
 2 files changed, 15 insertions(+), 15 deletions(-)

--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1411,6 +1411,21 @@ static int create_proc_exports_entry(voi
 
 unsigned int nfsd_net_id;
 
+struct nfsd_genl_rqstp {
+	struct sockaddr		rq_daddr;
+	struct sockaddr		rq_saddr;
+	unsigned long		rq_flags;
+	ktime_t			rq_stime;
+	__be32			rq_xid;
+	u32			rq_vers;
+	u32			rq_prog;
+	u32			rq_proc;
+
+	/* NFSv4 compound */
+	u32			rq_opcnt;
+	u32			rq_opnum[16];
+};
+
 static int nfsd_genl_rpc_status_compose_msg(struct sk_buff *skb,
 					    struct netlink_callback *cb,
 					    struct nfsd_genl_rqstp *genl_rqstp)
--- a/fs/nfsd/nfsd.h
+++ b/fs/nfsd/nfsd.h
@@ -60,21 +60,6 @@ struct readdir_cd {
 /* Maximum number of operations per session compound */
 #define NFSD_MAX_OPS_PER_COMPOUND	200
 
-struct nfsd_genl_rqstp {
-	struct sockaddr		rq_daddr;
-	struct sockaddr		rq_saddr;
-	unsigned long		rq_flags;
-	ktime_t			rq_stime;
-	__be32			rq_xid;
-	u32			rq_vers;
-	u32			rq_prog;
-	u32			rq_proc;
-
-	/* NFSv4 compound */
-	u32			rq_opcnt;
-	u32			rq_opnum[16];
-};
-
 extern struct svc_program	nfsd_programs[];
 extern const struct svc_version	nfsd_version2, nfsd_version3, nfsd_version4;
 extern struct mutex		nfsd_mutex;


