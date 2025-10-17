Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD09330B26;
	Fri, 17 Oct 2025 15:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716615; cv=none; b=k8K+5AUMePktiEwfhCqYLPT046feQuf6LU49klhOnUF/ow0kUaCHfak4DGS9ycWqQTDZ0rvJp2F3A38z/LgJuqRn6viJS/2OyvUAsm1XtV3ADQ325DwOP+xPPtWhVcyajPuMW49Ez+FC+Gue/KidxgHFzJhm+sCvkn4cv7+cLnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716615; c=relaxed/simple;
	bh=anRvgZJomLusgC+VepSBWDOPMwbn90HKT50kcNnj2Ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ck2mdxQRelga993l1JDT33nh+9JOpCnih9snFijOWIVw0jMQaKmvykN1nu/hJywOfRiJJUDZiWACNd5pQjBjs4ZTZw60YEqk6NWPT6rvKANFR7iKzVeKTLKQluzsxpddNsZ6oZg7lhg2lRn9x609K9kMFq7n3KmmhKJIKBKion8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nXma1gqS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nXma1gqS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6B1CC4CEE7;
	Fri, 17 Oct 2025 15:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716615;
	bh=anRvgZJomLusgC+VepSBWDOPMwbn90HKT50kcNnj2Ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nXma1gqSYjs7LZWdamLSAjDxGKiBE5w0CrnOD3bazRRTHphFEEavEM3f5vtWdS95m
	 OD/haO+3fvEK/1ooSeIHY4IlrB8h9YZw/GPj8tBTDTWTxh++iD54L69SmcUr94Pmas
	 tFqgYQr8qsOnmNJiyoNyKSgYYT/CJGKdz0pOIC3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 218/276] nfsd: nfserr_jukebox in nlm_fopen should lead to a retry
Date: Fri, 17 Oct 2025 16:55:11 +0200
Message-ID: <20251017145150.421015094@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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


