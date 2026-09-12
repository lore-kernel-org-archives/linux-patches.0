Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA697418A5B;
	Sat, 12 Sep 2026 15:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226915; cv=none; b=iQbtkK8YUGyJlNdhNsMi2S6EQU6GIq1Yj0qFJb+pR0zxJHXKVn/A2MWt5eDC7kLGDcUi2ewvViOTd4SymCS7zO39QDuh77E7iLulLKLmMJ5s/M7G/rsmt+AWTU9YZZ13OUWTuThR5IbZ/d2XUNjIhEbTDiyAbPHowNGEFf/K8jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226915; c=relaxed/simple;
	bh=7jzyrpcrmLY1lpIc0DZ+SBFEqS+/hdm6Gx+vUwWTB8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YzfsjGUE+FDcf/YXN9WadQ6S5Gl7AvH8F7dFzFaEiqSn4D7oYu7KiPuzYqHeqEuIZ0s2CCOyzV9GvuIuKvUk+om+c/YZ7geUCzA19gj8CwtWYUp/QuSNLwpA9atbjeF5X75PV1bDZywZRlc+5LeyyVxfJdXGManA4Hir9lA03Tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=meNuVU6d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="meNuVU6d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD8891F000FF;
	Sat, 12 Sep 2026 15:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226913;
	bh=+4QzuxEQcKCSGlD7QAzkhViMezd+qT2h5kA2u6lfVro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=meNuVU6daoL8RgWGDwgziNAZMfYJ9ocTKpRGb9eQA49eItunDFYC4LsQ1ny5bz0p9
	 Z8W2NCOII0TAGtmnCyRG2rLzW0Ct5iGoxlzyjOeLK8YxL4uWK6E+lAFHBNxAf7qANb
	 e6oQLNMXy22xJkZFjacX3M4xloC4aYl4DFqfvXvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.1 0057/1191] nfsd: reject reclaim LOCK after RECLAIM_COMPLETE
Date: Sat, 12 Sep 2026 08:46:25 +0200
Message-ID: <20260912065549.429998876@linuxfoundation.org>
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

commit 2327ba1d9546727a35b17888777e991f68a9b305 upstream.

nfsd4_lock() only checks the namespace-wide grace flag when deciding
whether to accept a reclaim LOCK. It does not check the per-client
NFSD4_CLIENT_RECLAIM_COMPLETE bit. An NFSv4.1+ client that has
already sent RECLAIM_COMPLETE can submit lk_reclaim=1 while grace is
still active (e.g. lockd holds the grace list open), and the server
accepts it instead of returning NFS4ERR_NO_GRACE as required by
RFC 8881 section 18.51.3.

The OPEN path already enforces both tiers: the grace check plus the
per-client RECLAIM_COMPLETE check in nfs4_check_open_reclaim(). Add
the equivalent per-client check to the LOCK path.

Fixes: 3b3e7b72239a ("nfsd: reject reclaim request when client has already sent RECLAIM_COMPLETE")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Jeff Layton <jlayton@kernel.org>
[ cel: Correct the RFC citations in the commit message ]
Link: https://patch.msgid.link/20260611-nfsd-testing-v2-14-5b90e276f2d9@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -7618,6 +7618,9 @@ nfsd4_lock(struct svc_rqst *rqstp, struc
 	status = nfserr_no_grace;
 	if (!locks_in_grace(net) && lock->lk_reclaim)
 		goto out;
+	if (lock->lk_reclaim &&
+	    test_bit(NFSD4_CLIENT_RECLAIM_COMPLETE, &cstate->clp->cl_flags))
+		goto out;
 
 	if (lock->lk_reclaim)
 		fl_flags |= FL_RECLAIM;


