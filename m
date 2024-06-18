Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4091E1A2C00;
	Tue, 18 Jun 2024 13:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716394; cv=none; b=KvvBFRLDxqoi7+DC9uWQa6jdZw+w6NypA09M94cwk3MT8BAG5Fne1Dxe3C03gpBsT/+HY3X1Da7cdu+FOxp4zTXulsxwYUcyja60NBEViTC/UFwuFGoSGjfWiFOfVzZoi4p2PmyJSroi/BS1f3+0AIyGT8Tt66WXG0EyAXX+nRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716394; c=relaxed/simple;
	bh=TLEZDxYBaMzknhxyLKCRTV2IhcLkQ01+q8+AleeiVjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ggETWFKJDiycdruEJ90XLx6mBLdjfpJr1CQ4pSthu/cxYwQgNNSNS/7tMmwC2CRHRC1vV1h81n60q0OFx9bWEeBMgJhWX1irDUreC7SJK4JMK1xxO000yrjW7EQtZUP6eAO2qNtmtpsp/OFPtVw8MiVy2NI8NbHYbK4dkg7C0Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MPl3InIQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MPl3InIQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75766C3277B;
	Tue, 18 Jun 2024 13:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716393;
	bh=TLEZDxYBaMzknhxyLKCRTV2IhcLkQ01+q8+AleeiVjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MPl3InIQzH2EjcunSMlB5obUTMqXK+QWbuE/sr9OX/XEUWn6N9nkKnwIajvxopZzM
	 F91kNNaplGQahCjVl3KbM8KpR+0ITVGo+qF7nN/dRxTtrXlMNk/Uqzc5aj5wEvc7pT
	 8aMCan7qBHMhnHwqOzY/3hPkzOSlFyeJj2N9jzWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 632/770] NFSD: Increase NFSD_MAX_OPS_PER_COMPOUND
Date: Tue, 18 Jun 2024 14:38:05 +0200
Message-ID: <20240618123431.679977649@linuxfoundation.org>
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

[ Upstream commit 80e591ce636f3ae6855a0ca26963da1fdd6d4508 ]

When attempting an NFSv4 mount, a Solaris NFSv4 client builds a
single large COMPOUND that chains a series of LOOKUPs to get to the
pseudo filesystem root directory that is to be mounted. The Linux
NFS server's current maximum of 16 operations per NFSv4 COMPOUND is
not large enough to ensure that this works for paths that are more
than a few components deep.

Since NFSD_MAX_OPS_PER_COMPOUND is mostly a sanity check, and most
NFSv4 COMPOUNDS are between 3 and 6 operations (thus they do not
trigger any re-allocation of the operation array on the server),
increasing this maximum should result in little to no impact.

The ops array can get large now, so allocate it via vmalloc() to
help ensure memory fragmentation won't cause an allocation failure.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216383
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 7 ++++---
 fs/nfsd/state.h   | 2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 5476541530ead..92e0535ddb922 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -42,6 +42,8 @@
 #include <linux/sunrpc/svcauth_gss.h>
 #include <linux/sunrpc/addr.h>
 #include <linux/xattr.h>
+#include <linux/vmalloc.h>
+
 #include <uapi/linux/xattr.h>
 
 #include "idmap.h"
@@ -2369,10 +2371,9 @@ nfsd4_decode_compound(struct nfsd4_compoundargs *argp)
 		return true;
 
 	if (argp->opcnt > ARRAY_SIZE(argp->iops)) {
-		argp->ops = kzalloc(argp->opcnt * sizeof(*argp->ops), GFP_KERNEL);
+		argp->ops = vcalloc(argp->opcnt, sizeof(*argp->ops));
 		if (!argp->ops) {
 			argp->ops = argp->iops;
-			dprintk("nfsd: couldn't allocate room for COMPOUND\n");
 			return false;
 		}
 	}
@@ -5402,7 +5403,7 @@ void nfsd4_release_compoundargs(struct svc_rqst *rqstp)
 	struct nfsd4_compoundargs *args = rqstp->rq_argp;
 
 	if (args->ops != args->iops) {
-		kfree(args->ops);
+		vfree(args->ops);
 		args->ops = args->iops;
 	}
 	while (args->to_free) {
diff --git a/fs/nfsd/state.h b/fs/nfsd/state.h
index ae596dbf86675..5d28beb290fef 100644
--- a/fs/nfsd/state.h
+++ b/fs/nfsd/state.h
@@ -175,7 +175,7 @@ static inline struct nfs4_delegation *delegstateid(struct nfs4_stid *s)
 /* Maximum number of slots per session. 160 is useful for long haul TCP */
 #define NFSD_MAX_SLOTS_PER_SESSION     160
 /* Maximum number of operations per session compound */
-#define NFSD_MAX_OPS_PER_COMPOUND	16
+#define NFSD_MAX_OPS_PER_COMPOUND	50
 /* Maximum  session per slot cache size */
 #define NFSD_SLOT_CACHE_SIZE		2048
 /* Maximum number of NFSD_SLOT_CACHE_SIZE slots per session */
-- 
2.43.0



