Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4CFA330B1D;
	Fri, 17 Oct 2025 15:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715747; cv=none; b=A9z8UKfBFxpAsXcx8voVgl/0RMijAKEEAj7RlvjgRriL4/sKX33l7MVhXE+wYObBqLZm+zfT8IpQ11gjnPbcyeKiU4Dw9LsQ4SuLHAIuy5xPJwd5ZBbcn2QvhMDZmjXln/Q7RyVq+CsTyCHBwSQ07Vlmq5nSeGf/hjVkV30xJWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715747; c=relaxed/simple;
	bh=NePpJ8alNyRh1OQX1PSFyEBQ16m3U6HmwQdrF/KqQ/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zx3cpK8Opwe3ukdarqI3kMcYvGJPbphOH6wXHHMcn9wbRCepk5HGxlZROmT3KIYSiaYFHm9/TpXn3zmA5mTKBBDkfB9IaKGqBu0TbR+C4rZHPfA+fDsywQ4ATUOR5ZPgIAHHVz3jeTpw5GRZSzHlvjwLmMchhHH/0xnzbiQpMKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bTOrJOOK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bTOrJOOK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ACE3C4CEE7;
	Fri, 17 Oct 2025 15:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715747;
	bh=NePpJ8alNyRh1OQX1PSFyEBQ16m3U6HmwQdrF/KqQ/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bTOrJOOKcuwsH7GWsCFsVK8wjmcJFcA7BmODU9jyC9e7wEMHgMRIJwF+6C6eKrOHW
	 MpkA/796oG349wXChV6OG4B9HM8L2G58TQx+SPYPAeKpwTMZ1Lv/+vljcZc6dIUY8Z
	 fg8FDpZXmlKRl9Yc9dT6Psqc87V426WSRjN0mb6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.17 323/371] nfsd: nfserr_jukebox in nlm_fopen should lead to a retry
Date: Fri, 17 Oct 2025 16:54:58 +0200
Message-ID: <20251017145213.762835066@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olga Kornievskaia <okorniev@redhat.com>

commit a082e4b4d08a4a0e656d90c2c05da85f23e6d0c9 upstream.

When v3 NLM request finds a conflicting delegation, it triggers
a delegation recall and nfsd_open fails with EAGAIN. nfsd_open
then translates EAGAIN into nfserr_jukebox. In nlm_fopen, instead
of returning nlm_failed for when there is a conflicting delegation,
drop this NLM request so that the client retries. Once delegation
is recalled and if a local lock is claimed, a retry would lead to
nfsd returning a nlm_lck_blocked error or a successful nlm lock.

Fixes: d343fce148a4 ("[PATCH] knfsd: Allow lockd to drop replies as appropriate")
Cc: stable@vger.kernel.org # v6.6
Signed-off-by: Olga Kornievskaia <okorniev@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/lockd.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/fs/nfsd/lockd.c
+++ b/fs/nfsd/lockd.c
@@ -57,6 +57,21 @@ nlm_fopen(struct svc_rqst *rqstp, struct
 	switch (nfserr) {
 	case nfs_ok:
 		return 0;
+	case nfserr_jukebox:
+		/* this error can indicate a presence of a conflicting
+		 * delegation to an NLM lock request. Options are:
+		 * (1) For now, drop this request and make the client
+		 * retry. When delegation is returned, client's lock retry
+		 * will complete.
+		 * (2) NLM4_DENIED as per "spec" signals to the client
+		 * that the lock is unavailable now but client can retry.
+		 * Linux client implementation does not. It treats
+		 * NLM4_DENIED same as NLM4_FAILED and errors the request.
+		 * (3) For the future, treat this as blocked lock and try
+		 * to callback when the delegation is returned but might
+		 * not have a proper lock request to block on.
+		 */
+		fallthrough;
 	case nfserr_dropit:
 		return nlm_drop_reply;
 	case nfserr_stale:


