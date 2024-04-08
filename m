Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8094142046;
	Mon,  8 Apr 2024 13:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584480; cv=none; b=XdRHs3kJIIWR1Bz7Mrohg/SagYlUFWOab+qcy9ziC8ck1OWpMmWLu/b3RWG1CRiBjHl0MRB9olnQl+aVll+2V55rvtoBhwr+OulR64PDReOYMzEdgbK6DfERR0LdIV/k2cygoM4qmj2mjCQdhJ6XSALMZtqp/8rq8qlaGzY8zds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584480; c=relaxed/simple;
	bh=UOlvs8JznmNoUi65FoFcwnVtRXl+UTE0Hc/aHIOTPfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=luqaHUyK/6tv8BpdBe+4wr8HilZB9wtrhBVhWXZXdITu+RfuTyBWC6DXs6g08Ca5cSNg0z2XYvpws43eP6zoWx/AxuIriQ8vQuXOpffn2DHxp6W0z6AJyfST/0YnknIu7zxukYmYUDgp3QZ5YAGgiUpdKZInsFhLa7JZXhJITdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LOf7+rd+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LOf7+rd+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09208C433F1;
	Mon,  8 Apr 2024 13:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584480;
	bh=UOlvs8JznmNoUi65FoFcwnVtRXl+UTE0Hc/aHIOTPfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LOf7+rd+2iY0WveSRyPQxIH5Z0zhnKJf0ecD0p6gEIMq76cxcPlB06wd6MGtGdV/s
	 V77ZPWwMGSqya1dPrdqcAxKcACBJTCzlTS5dlFQJLY+ZS/m6gN3ucKXxzk9H1Cvtvy
	 0GmCUcZdQZAG9oKQ0YXqOf7AZZEa+j1XHaVV3IbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 422/690] NFSD: Increase NFSD_MAX_OPS_PER_COMPOUND
Date: Mon,  8 Apr 2024 14:54:48 +0200
Message-ID: <20240408125414.889548919@linuxfoundation.org>
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
---
 fs/nfsd/nfs4xdr.c | 7 ++++---
 fs/nfsd/state.h   | 2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 5aafbd0f7ae30..0f30d93577e7b 100644
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
@@ -2364,10 +2366,9 @@ nfsd4_decode_compound(struct nfsd4_compoundargs *argp)
 			    NFSD_MAX_OPS_PER_COMPOUND);
 
 	if (argp->opcnt > ARRAY_SIZE(argp->iops)) {
-		argp->ops = kzalloc(argp->opcnt * sizeof(*argp->ops), GFP_KERNEL);
+		argp->ops = vcalloc(argp->opcnt, sizeof(*argp->ops));
 		if (!argp->ops) {
 			argp->ops = argp->iops;
-			dprintk("nfsd: couldn't allocate room for COMPOUND\n");
 			return false;
 		}
 	}
@@ -5399,7 +5400,7 @@ void nfsd4_release_compoundargs(struct svc_rqst *rqstp)
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



