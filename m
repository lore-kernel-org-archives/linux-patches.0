Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E8530EF95;
	Thu,  2 Jul 2026 16:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011439; cv=none; b=Z3tbWjl036Fe5llUI313Q3vsQaKQhgvQuj+j1X1o/1lKQMLoZWX6gkKBpO+WvdIf1n1Ivz0I/mlgYWa9mAqwurXR0iugfPxtIdykMAgv6F9fP67oZzGMv5PYWtlVTVKvMiFwqYWLjmmGkxIQSklhe5kldVbbU3ZLgucZqRoFgek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011439; c=relaxed/simple;
	bh=o5BTlOUvuYC25nxoXsVZkzNz4SXu+bj31/UaWi64uxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qGezpdvI5XG1YVHCHL8FCiauPIE4Au2JVJReeJ5VBeRlt5eW3crjYEHFRHoiMopve3RZgg/41vlox/gjh0ggBu1Ayj321qVbUhND0GfGHS8nTiDiFJPIH8ZKt1vEnx7DUTV1T36V7ygRDv+H9PVTpwagoazM/vIfb3bsxu1+lF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jKYDz9vS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jKYDz9vS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC5F1F000E9;
	Thu,  2 Jul 2026 16:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011438;
	bh=tSKAVSf5y1+J+qrv+ONHgx6DFOjshP5ThV2OarhYqcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jKYDz9vSRLc3lF9sC/byyU7hLCFyICw8OWCpVIezdL1mEHuqTtZFbA7NYav1lRBjx
	 dxGO+CaZCz45432z7gd9Mf7XP7Mtx8oY+a0PYHc5mMSjABTinCIArXuZmMwn3BUm74
	 qCtJK7Yb/m7xOZ7+iCkF105pzPUv23HV1rWgCDq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.18 097/108] nfsd: fix inverted cp_ttl check in async copy reaper
Date: Thu,  2 Jul 2026 18:21:34 +0200
Message-ID: <20260702155114.121629805@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.110058792@linuxfoundation.org>
References: <20260702155112.110058792@linuxfoundation.org>
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

commit 0150459b05490b88b7e7378a31550a9e07b5517c upstream.

nfsd4_async_copy_reaper() is supposed to keep completed async copy
state around for NFSD_COPY_INITIAL_TTL (10) laundromat ticks so
that OFFLOAD_STATUS can report the result, then reap the state once
the countdown expires.

The TTL predicate is inverted: `if (--copy->cp_ttl)` is true while
ticks remain and false when the counter reaches zero.  This causes
the copy to be reaped on the very first tick (cp_ttl goes from 10
to 9, which is non-zero) instead of after all 10 ticks elapse.
Once reaped, OFFLOAD_STATUS returns NFS4ERR_BAD_STATEID because
the copy state has already been freed.

Fix by negating the test so that cleanup runs when the TTL expires.

Fixes: aa0ebd21df9c ("NFSD: Add nfsd4_copy time-to-live")
Cc: stable@vger.kernel.org
Reported-by: Chris Mason <clm@meta.com>
Assisted-by: kres:claude-opus-4-6
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1404,7 +1404,7 @@ void nfsd4_async_copy_reaper(struct nfsd
 		list_for_each_safe(pos, next, &clp->async_copies) {
 			copy = list_entry(pos, struct nfsd4_copy, copies);
 			if (test_bit(NFSD4_COPY_F_OFFLOAD_DONE, &copy->cp_flags)) {
-				if (--copy->cp_ttl) {
+				if (!--copy->cp_ttl) {
 					list_del_init(&copy->copies);
 					list_add(&copy->copies, &reaplist);
 				}


