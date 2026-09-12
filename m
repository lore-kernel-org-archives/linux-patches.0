Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6933C30568E;
	Sat, 12 Sep 2026 17:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232605; cv=none; b=JcXNTmSZs2aCaBHHHDyid7LLTkuHG4SsyDArbLyLB0MTtntkDilWdFfPSpeS4y3BrhUJC5gEdIhiGoxc7i4YvwEVZT6sLA/CD1hSbNRNrxR3f6NRPHypKV/pwHqKjgrASWVd9OJ0nI/MKVc87HsArlJ5diX+3jeLSV53776+JHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232605; c=relaxed/simple;
	bh=YBOTGFiEODlWuQfSKnuuISKaj4BDAQg7vxARHJImjr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tBjrpkk1OHkfywu60thXk0C++fku6r3QRoRrb9ywQex5TtnrB4VCn4cgQ/ojW7ZZJOx8oRYhDkjE5XyQHBkEL1gu0yX0VHN3FdO/yvREeAMJVxBVlpBVsXhxTG0bitvkjfu8IOXC0X8R/yT0zqxr50b9SuiqQLB4WCsw4T81DO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cQJOMM+0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cQJOMM+0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F9B1F000FF;
	Sat, 12 Sep 2026 17:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232604;
	bh=jiiINklKe2ZRx0KcGcGRXdpcm+UG83KDily7JXyKUCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cQJOMM+0LujJkkzHBoDhXzazP8573F5sze7Oo+XuYW7OGKF2/kvjrgW//Jnz4K8yG
	 Ab1xiwDORKtYArjh3b6Juh4lucFfHf0Vkxkx5dqzF7t1Kdr2ufxKMFU/3enPLXGmp4
	 FpP+E2eXo5jeKInwMfqbKzISNHPzhFkPVzw+bNf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 5.15 045/935] nfsd: fix version mismatch loops in nfsd_acl_init_request()
Date: Sat, 12 Sep 2026 08:51:15 +0200
Message-ID: <20260912065527.872277816@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -859,7 +859,7 @@ nfsd_acl_init_request(struct svc_rqst *r
 
 	ret->mismatch.lovers = NFSD_ACL_NRVERS;
 	for (i = NFSD_ACL_MINVERS; i < NFSD_ACL_NRVERS; i++) {
-		if (nfsd_support_acl_version(rqstp->rq_vers) &&
+		if (nfsd_support_acl_version(i) &&
 		    nfsd_vers(nn, i, NFSD_TEST)) {
 			ret->mismatch.lovers = i;
 			break;
@@ -869,7 +869,7 @@ nfsd_acl_init_request(struct svc_rqst *r
 		return rpc_prog_unavail;
 	ret->mismatch.hivers = NFSD_ACL_MINVERS;
 	for (i = NFSD_ACL_NRVERS - 1; i >= NFSD_ACL_MINVERS; i--) {
-		if (nfsd_support_acl_version(rqstp->rq_vers) &&
+		if (nfsd_support_acl_version(i) &&
 		    nfsd_vers(nn, i, NFSD_TEST)) {
 			ret->mismatch.hivers = i;
 			break;


