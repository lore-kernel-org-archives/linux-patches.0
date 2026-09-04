Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C103EC684;
	Fri,  4 Sep 2026 05:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498768; cv=none; b=hpmjWc4fWjCdlxrfJmRuS81YF1haR3J6eiM2ne7l6h/3WXGY1ryTUCeUmRbVVgqywYF73e52cmwdsDPcpJgug/AGrW/OZG/WUVSXXjUuo0008t62AvGw50ySukKGolaX0XM+SP0jSsRieox6O9TD49gkO6zzK/n2RKI5b6seW5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498768; c=relaxed/simple;
	bh=Z+fCkmnhbp6qxG4cXOKnYxh6kCKCDeELQapT45R2Ifw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LARrz/Ii9m9UA9rI86TDrlk8EvPqhOPP6xr70Nob7rhPeGL5zPsvBl/9WPIJ+SNCQcWWg85ezYygnmOER4aqBEECSIn1PMgL+KlRQACXEdVgYxqRp6+O/CaksHx6dVrAUFvGsmZZ+XLR01ECroLTsgYTpKCw/kUBJsLbC2Y9WRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QpTsbJPo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QpTsbJPo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEE081F00A3D;
	Fri,  4 Sep 2026 05:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498767;
	bh=AGZ8fY+XxaX5vsMRvknd6QUAIGuyU+o45fzeD/TUdWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QpTsbJPoV/v4d6XCf6rRBWDXJurORli9HAbTI9vRis2WMqcKS7lwsUNgR7suLJYYI
	 tQnAIg7BPngjcTnVI1uL8/mAbH9WrPXJfo7762RHOnsO1Kv3e/PEwU/8uBJoJM0FsW
	 CXfZWz7KxU5y6kLht6fJN2LINNb2VliBqnSCZEU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.2 181/713] nfsd: fix FL_SLEEP being set unconditionally for all LOCK types
Date: Fri,  4 Sep 2026 06:52:29 +0200
Message-ID: <20260904045807.874871661@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

commit 246a90a5109bb2857db41f491277882ee2743b26 upstream.

The FL_SLEEP guard uses lk_type & (NFS4_READW_LT | NFS4_WRITEW_LT) which
computes lk_type & 7, non-zero for all valid lock types including
non-blocking ones. This was introduced by commit 7e64c5bc497c
("NLM/NFSD: Fix lock notifications for async-capable filesystems") when
refactoring from per-case switch arms.

Replace the bitmask test with explicit equality checks.

Fixes: 7e64c5bc497c ("NLM/NFSD: Fix lock notifications for async-capable filesystems")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260611-nfsd-testing-v2-10-5b90e276f2d9@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -8614,10 +8614,11 @@ nfsd4_lock(struct svc_rqst *rqstp, struc
 		goto out;
 	}
 
-	if (lock->lk_type & (NFS4_READW_LT | NFS4_WRITEW_LT) &&
-		nfsd4_has_session(cstate) &&
-		locks_can_async_lock(nf->nf_file->f_op))
-			flags |= FL_SLEEP;
+	if ((lock->lk_type == NFS4_READW_LT ||
+	     lock->lk_type == NFS4_WRITEW_LT) &&
+	    nfsd4_has_session(cstate) &&
+	    locks_can_async_lock(nf->nf_file->f_op))
+		flags |= FL_SLEEP;
 
 	nbl = find_or_allocate_block(lock_sop, &fp->fi_fhandle, nn);
 	if (!nbl) {


