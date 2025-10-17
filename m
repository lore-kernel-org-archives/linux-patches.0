Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C981C45C0B;
	Fri, 17 Oct 2025 15:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713870; cv=none; b=eXfAtkkU2nXfcm6uDZAeshaDZvbn6Plli/3StkK45xDspnW2sJhJbRAll344L5TxiJ+7mIDx9BRYwOBXzxS7claFWOcQAXJuCC2QqKxRbifbzkltPtjGL90+8i0wXc2JBKRoyFwKpMsPq2VG9cR4yQQ4r5iSqG6ioKkvkaLzOcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713870; c=relaxed/simple;
	bh=lnnlrMXfTjWD4MG89bpEVS4l7d0hGpFoPrrMQjYnIgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R4w5Ov8jSbgSr38CVLDMEq1l2OAfCuaVBUZyoTQrhyxQxAwqBB7v7+UxWvQV0py3SmjlpYpi3uB9sMY7kNeBBvUrY0I70Avnkt+H14oEPqTJ5VsW3Jva481p+9G8OOCnrwKj9+Fks5iw7H9bsthkArxx2omVDw8quL9xUKSqWpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2gEf7F6D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2gEf7F6D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52AA8C4CEFE;
	Fri, 17 Oct 2025 15:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713870;
	bh=lnnlrMXfTjWD4MG89bpEVS4l7d0hGpFoPrrMQjYnIgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2gEf7F6DPTUTjshWAd/bN2Vc3ajhWx1J5Euj26RSyM4FEZOzsdtC3rTIJqOlrz+3o
	 2+o0FHGDKttEZiydoPSrhwed57V1bQ0syseI03Z8vmTuJ2PEgImcp+xKVr7X+7uoDj
	 JuKYUOfDAylh2xWYkdxM8WcJsAdElY+SKDX/UTi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.6 147/201] nfsd: nfserr_jukebox in nlm_fopen should lead to a retry
Date: Fri, 17 Oct 2025 16:53:28 +0200
Message-ID: <20251017145140.133902644@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -48,6 +48,21 @@ nlm_fopen(struct svc_rqst *rqstp, struct
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


