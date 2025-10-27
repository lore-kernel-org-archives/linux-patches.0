Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27351E47CA;
	Mon, 27 Oct 2025 18:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591358; cv=none; b=aTVNIHqCjyOB3Z5nCJqpvui28A+w4vHSwMoUUST/JYFg8qYBH7/QL9RfZ2tWmoBR8bfH1o4SJH2ezbaXND2XKH44cISPjphjySG9b/sMcDAjBZjnaUCMWWclegVeX9EiFU5MTbrKk+I83G5rOnZGB6yVdf1A6ld6DtYderpC/Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591358; c=relaxed/simple;
	bh=6V/LRbkvQPWD3tVpnnXYeEhEbAY8UyC4B+vd5WJAJO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dOQYcFTcAM75XsxTzepxnPUs0d+3vQ/buVl0Pigkk6DZdD31uDba4YCgFkiqOpTCfC5jQg91QXuenR6qpoyPGN9PBatLEMTQ8FBxAuZFoymQGW9jhxw/NfEFOt5UneeYXO/w8evvOVqPeB5nClDbCaWGwwmZy8qQQ8FTi9I+QPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y4md9B2m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y4md9B2m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 565BBC4CEF1;
	Mon, 27 Oct 2025 18:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591358;
	bh=6V/LRbkvQPWD3tVpnnXYeEhEbAY8UyC4B+vd5WJAJO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y4md9B2mDQY5pw1z8klZRUSjM9JxsQUrAa8iqBSNSA+YtdFm2rIG99L64UHAXxnow
	 ylXWhcayqM9mjN/muraHyhyV/WXamejCalFNT+AvqfNhYoAaelqSHO0xUpFzLonwPH
	 ypxAJ2axks8hW4/y6nv+Fs9MaWyKn/p4JATM+BUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.10 167/332] nfsd: nfserr_jukebox in nlm_fopen should lead to a retry
Date: Mon, 27 Oct 2025 19:33:40 +0100
Message-ID: <20251027183529.032525121@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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


