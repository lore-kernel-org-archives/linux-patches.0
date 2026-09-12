Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594F7320CD3;
	Sat, 12 Sep 2026 15:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226815; cv=none; b=LcW914ZkDTIZ8aFfbEqnm1iP/H0z4AqlxP6jYvaBfs8jXKCcWF1cX+WuBqSoAynKn+i/AVwsgsfl4i2961kzseoJ1186ezAmG70uBytnWWv78B38vKYze8yPPdsRfuLfXbqZW3BP7sidYmoOXxaSPkG7SvnrHgNWHhnb4skYIl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226815; c=relaxed/simple;
	bh=6lcAFKNbykOxE4OfcvnYtk5xaZOTNGkaWgELTlTdURY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d7wJ3RofahZVaBUP5a5VfMEdEaR2gOiGHMgensCGnPRs36ROQBIi1AHuAtf8pgi/Sd6+eR9ZrORP1SmyGjTxVOki8pVdAVZmj15w9pkF6pEhpaKgwsE5gvUi8u0+lBK4mhoFsGhInoucqu8WP+906F+tSuDAhDmPQ+0OsHws0zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ycEy29R8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ycEy29R8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D971F000FF;
	Sat, 12 Sep 2026 15:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226814;
	bh=22V73MEEmjqVUUzI3mHsGpv32D+zI2KQ/gp/OTdcRoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ycEy29R8SSzxOG+K+dZhfPK8CQtPzSTCSVItavKjYMfScE0FzY7YNhZVd2ivhJtaQ
	 enRGELdojgymy3Yvngy664NoAIvPI7rFJS7N5RaQJG5Y6vIgAB+NNXx+A9PUAzSM9s
	 MRXOn4e1nckfGaauZP+KfCZrvFnxVuWFOLfmJZGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.1 0052/1191] nfsd: fix version mismatch loops in nfsd_acl_init_request()
Date: Sat, 12 Sep 2026 08:46:20 +0200
Message-ID: <20260912065549.316692054@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


