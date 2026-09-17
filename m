Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF08A3B71AE;
	Thu, 17 Sep 2026 18:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671581; cv=none; b=dhghkgARaGuKICG0+U6OBzwMksw5uJQ2ONikHPR2MftocFis0zvYmYBp0uLVDOPXx43+ieww5BlBit26ewATavpdeWzlOMEwCyA3bNYg1C4E0XX1bmPkpTc41Yh4QbGNveK2ZbfNAP5h973VOMYohICLkYIkD18V2rofW8cqFmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671581; c=relaxed/simple;
	bh=UudPzUKoimB00U4N3rx76utYxSV4Uu6+zrmPX624myU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nQi+DTypglsVdsKsgFDLzqfs1wLRngn56f2YX6lV8TfJKIDvBLcsyCMOxe7DQ5DsT9nkpM0TMCTEyI9Nzr4psohqaawgg9vWt6fPJ4BUlzd0CnqdCFcdl8G2YBwGiJAzwr/PNadQz2ORWh8C3DdTUa/Qxf5GNSnZQ30xb7EZBzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TZ0ESET8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TZ0ESET8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3E3E1F000FF;
	Thu, 17 Sep 2026 18:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671579;
	bh=PaIPwLgSU/k/qkWYiAT2BILELcORVATxpOZvJCGIJ5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TZ0ESET8wZHlrz//AYjYjlXrLR6bbmvVbqnFPFiNDOEiYVKQiWxT/m3g4Vfa0Gi8v
	 F+UYnBe+frp2fTz3QenbD9RDDYPwuHwh+1rnS6VHapIEiNJWVlRmm4B1ZJskrGiFw2
	 YPv41b5gvQMXfILT/eVYxNjrcjj3DDktrtRJhYlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	tianshuo han <hantianshuo233@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1023/1102] Revert "NFSD: Remove the cap on number of operations per NFSv4 COMPOUND"
Date: Thu, 17 Sep 2026 16:16:06 +0100
Message-ID: <20260917151606.442817947@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 3e7f011c255582d7c914133785bbba1990441713 ]

I've found that pynfs COMP6 now leaves the connection or lease in a
strange state, which causes CLOSE9 to hang indefinitely. I've dug
into it a little, but I haven't been able to root-cause it yet.
However, I bisected to commit 48aab1606fa8 ("NFSD: Remove the cap on
number of operations per NFSv4 COMPOUND").

Tianshuo Han also reports a potential vulnerability when decoding
an NFSv4 COMPOUND. An attacker can place an arbitrarily large op
count in the COMPOUND header, which results in:

[   51.410584] nfsd: vmalloc error: size 1209533382144, exceeds total
pages, mode:0xdc0(GFP_KERNEL|__GFP_ZERO),
nodemask=(null),cpuset=/,mems_allowed=0

when NFSD attempts to allocate the COMPOUND op array.

Let's restore the operation-per-COMPOUND limit, but increased to 200
for now.

Reported-by: tianshuo han <hantianshuo233@gmail.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Cc: stable@vger.kernel.org
Tested-by: Tianshuo Han <hantianshuo233@gmail.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>

The 6.12 tree already contains the functional changes from this revert
and enforces a stricter 50-operation cap. Retain that cap and use this
dependency to relocate struct nfsd_genl_rqstp into its sole user so the
follow-up address-width fix applies at the same location as upstream.

[ sashal: Reduced backport -- upstream 3e7f011c25558 touches 5 file(s), this
  backport carries 2. Not backported here:
  fs/nfsd/nfs4proc.c
  fs/nfsd/nfs4state.c
  fs/nfsd/nfs4xdr.c
  fs/nfsd/xdr4.h
  This note is generated from the file lists only; see the resolution record
  for the reasoning. ]

Stable-dep-of: a99d720ed2a5 ("nfsd: widen nfsd_genl_rqstp address fields to sockaddr_storage")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsctl.c |   15 +++++++++++++++
 fs/nfsd/nfsd.h   |   15 ---------------
 2 files changed, 15 insertions(+), 15 deletions(-)

--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1492,6 +1492,21 @@ static int create_proc_exports_entry(voi
 
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
@@ -70,21 +70,6 @@ struct readdir_cd {
 /* Maximum number of operations per session compound */
 #define NFSD_MAX_OPS_PER_COMPOUND	50
 
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


