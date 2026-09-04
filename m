Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6FB378838;
	Fri,  4 Sep 2026 06:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502118; cv=none; b=WPF9JX6Txe2Ac+vDEUME11MkgbRvs7caGxcnP/KcInsxj6gErby6LTOd9tbjnPN0wWz3ZJVSCuaV15bpUsVtsqt4SbQR+kdPMyG356NziHaG5jaENOEMBC1a32DNhZxfrOCvEc6gPwSwlQNETl1yN9Gl+twj4oiwqmmE8EA3e8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502118; c=relaxed/simple;
	bh=t4Tq8X2O9NvyP7uvZHKLzzmCDm47WaI3+WfIVbwp08M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i0PF/y563Z7AzWm7MJKPZbTWhBegdGy2/mOM4c8DMoaBsbAqDAiB8iA5UaGy/yDBlVbR8VNsvJpjzeVBkp8EDGfXXPSjfYc2i95MnG6hZAbZbAkhEnfS9pozfabYJkUy3XVjvt/zjMyFJ+17uspfDKjMTpCP2J13YRnZck3SULg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cit2CBRj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cit2CBRj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C24B1F00A3D;
	Fri,  4 Sep 2026 06:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502116;
	bh=ytWH7UHvtZzCkZm8R4tw1ksnriuSa8jvNQQfQAqqufs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cit2CBRjL5aQ9lcRqiOEqFiCvtew06B4HILGbeutnkv0Pj6MMuzBimXTMyT/qIJOW
	 RPCenquDCS8YKL4m0PEUjCFxkfWRybCmxsavqyz9QlRnE9r2zqjZ9Wx/0qAqAuLiYK
	 xMJcOAU3li1OREjqpxmpKiZqepX9w0GPRn2boa7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.12 096/403] nfsd: fix version mismatch loops in nfsd_acl_init_request()
Date: Fri,  4 Sep 2026 06:58:19 +0200
Message-ID: <20260904045737.015903061@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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
@@ -871,7 +871,7 @@ nfsd_acl_init_request(struct svc_rqst *r
 
 	ret->mismatch.lovers = NFSD_ACL_NRVERS;
 	for (i = NFSD_ACL_MINVERS; i < NFSD_ACL_NRVERS; i++) {
-		if (nfsd_support_acl_version(rqstp->rq_vers) &&
+		if (nfsd_support_acl_version(i) &&
 		    nfsd_vers(nn, i, NFSD_TEST)) {
 			ret->mismatch.lovers = i;
 			break;
@@ -881,7 +881,7 @@ nfsd_acl_init_request(struct svc_rqst *r
 		return rpc_prog_unavail;
 	ret->mismatch.hivers = NFSD_ACL_MINVERS;
 	for (i = NFSD_ACL_NRVERS - 1; i >= NFSD_ACL_MINVERS; i--) {
-		if (nfsd_support_acl_version(rqstp->rq_vers) &&
+		if (nfsd_support_acl_version(i) &&
 		    nfsd_vers(nn, i, NFSD_TEST)) {
 			ret->mismatch.hivers = i;
 			break;


