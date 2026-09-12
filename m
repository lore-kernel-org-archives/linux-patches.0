Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506503438BE;
	Sat, 12 Sep 2026 19:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240980; cv=none; b=LHL1n7+Po0CnyY55kDlf+rc0EbJ1UjDDGqmF3Z5cLVEACddE/Kb51/D/qk2YkjYyToe+WeOE1rnthGAG1yzIlubEu3x8CWxPKGrJY529YLA2TzZIFEjWFMlrOo1K/YZjaViqJngLABzOzzA7qXEhoffDAA+P/kSTOk5qv56ZnsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240980; c=relaxed/simple;
	bh=K6jFnlc5Ad0ELhZgmk+DRWTUOABHiNsDVpVhBqM3Kig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NaN6LcXLru/aa6RAY7iLmRaehEec1M2L1MXS6mezBDWKc2ayM8i92Q8dz6xIHTkrWEZXkXNv59h5EPbYfZ1V/DPj4q0RHuvAjkRtdcC0Ng2cXptyTj3sLEbX9R6AQK8eZfSrsukd25vguBjFhEOa6FhXreRAyxOx7JpVszkE6P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P8qvJSkH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P8qvJSkH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17E0C1F000FF;
	Sat, 12 Sep 2026 19:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240979;
	bh=sagJ26nR3BWd4wzedhfLHEAwVrfgKPhNoXUdjYFJHWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P8qvJSkHUSp86TFz+nYQf40+gtx+krL01Mf9Q71gJk3VmdS9vlSQ8CHhNnQIwJgsG
	 ooT3chdfP1hvc67z1YIks2P6w3SHQNtx2DBRoN208gv17oS+rtx1zLClfsm+5q3UG6
	 y31RfhLZolObfdC+FdGVHMMw1NWFs3rrfR/0UYyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 5.10 041/798] nfsd: fix version mismatch loops in nfsd_acl_init_request()
Date: Sat, 12 Sep 2026 08:54:29 +0200
Message-ID: <20260912065517.903550462@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

commit 9bc761051dcd9a4a8b59e64b2b185172d13c716d upstream.

The loops that compute the supported version range for PROG_MISMATCH
test nfsd_support_acl_version(rqstp->rq_vers) instead of
nfsd_support_acl_version(i), so every iteration fails and the
function returns rpc_prog_unavail instead of rpc_prog_mismatch.

Replace rqstp->rq_vers with the loop variable i, matching the
pattern used by the sibling nfsd_init_request() function.

Fixes: e333f3bbefe3 ("nfsd: Allow containers to set supported nfs versions")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260611-nfsd-testing-v2-9-5b90e276f2d9@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfssvc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -853,7 +853,7 @@ nfsd_acl_init_request(struct svc_rqst *r
 
 	ret->mismatch.lovers = NFSD_ACL_NRVERS;
 	for (i = NFSD_ACL_MINVERS; i < NFSD_ACL_NRVERS; i++) {
-		if (nfsd_support_acl_version(rqstp->rq_vers) &&
+		if (nfsd_support_acl_version(i) &&
 		    nfsd_vers(nn, i, NFSD_TEST)) {
 			ret->mismatch.lovers = i;
 			break;
@@ -863,7 +863,7 @@ nfsd_acl_init_request(struct svc_rqst *r
 		return rpc_prog_unavail;
 	ret->mismatch.hivers = NFSD_ACL_MINVERS;
 	for (i = NFSD_ACL_NRVERS - 1; i >= NFSD_ACL_MINVERS; i--) {
-		if (nfsd_support_acl_version(rqstp->rq_vers) &&
+		if (nfsd_support_acl_version(i) &&
 		    nfsd_vers(nn, i, NFSD_TEST)) {
 			ret->mismatch.hivers = i;
 			break;


