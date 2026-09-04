Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707E43876CC;
	Fri,  4 Sep 2026 05:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498802; cv=none; b=DT5RS6Ys3V5q7dD98hWgpC+pr6ogFNOJxC8KhhQEdQdlyCL6mT2dp62sS4hjGDZzDwZKVqWqALjf/59rmMUSHPLlbsbPtX7aYmHxddATCsV5gn4aE61eWw1la3f2tesJRcrbEfsJdZiPp1QAHa4djQJg63olsDzi2kyn8ej8chM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498802; c=relaxed/simple;
	bh=mS5dDQtOUMrigiyAin4aOmn/3BMH8dqLC/CaCq5XtbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L6BbN2FQIpzAw3ZlW7YB3KTNSkI72nt5tePVvuyf0tgWcieOV23H3keZOmbSt/XTPHONyhtr8gSOuaLxWDLMI+3y4Iw0AWCjrRWTmj+ZNv7wl6kDRezoBx1JZwDXqXqifP3ASYQThKERrCXmp7vzLejzahMI5pFGTKRape/lXzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JW5GjSuc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JW5GjSuc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE66F1F00A3D;
	Fri,  4 Sep 2026 05:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498801;
	bh=aYRg9UbW0Y/YfQppCH5Hz8QWkihdZ4ROFiAwXXvQGvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JW5GjSuc+eQM0c/3T+5wDS/VMXKejYRUXiWFMbwqfC30nMAYf+avGlMM5tpAYAjut
	 eZFbr9Eq9GaI0EdDrDMePJntRq3AVNfI0RUcxHxNwrAf9ja6lMaP9gXKLkPTNLUNHO
	 NFlZMyzXPVNmPPevySBi/Kmf+XoLTKGSwtyDg4uk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.2 192/713] nfsd: fix version mismatch loops in nfsd_acl_init_request()
Date: Fri,  4 Sep 2026 06:52:40 +0200
Message-ID: <20260904045808.116634827@linuxfoundation.org>
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
@@ -815,7 +815,7 @@ nfsd_acl_init_request(struct svc_rqst *r
 
 	ret->mismatch.lovers = NFSD_ACL_NRVERS;
 	for (i = NFSD_ACL_MINVERS; i < NFSD_ACL_NRVERS; i++) {
-		if (nfsd_support_acl_version(rqstp->rq_vers) &&
+		if (nfsd_support_acl_version(i) &&
 		    nfsd_vers(nn, i, NFSD_TEST)) {
 			ret->mismatch.lovers = i;
 			break;
@@ -825,7 +825,7 @@ nfsd_acl_init_request(struct svc_rqst *r
 		return rpc_prog_unavail;
 	ret->mismatch.hivers = NFSD_ACL_MINVERS;
 	for (i = NFSD_ACL_NRVERS - 1; i >= NFSD_ACL_MINVERS; i--) {
-		if (nfsd_support_acl_version(rqstp->rq_vers) &&
+		if (nfsd_support_acl_version(i) &&
 		    nfsd_vers(nn, i, NFSD_TEST)) {
 			ret->mismatch.hivers = i;
 			break;


