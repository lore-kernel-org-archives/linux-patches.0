Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A6D1FCFF3;
	Tue,  8 Apr 2025 12:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115487; cv=none; b=MVfwUo0/W0HXxtf1ecLnXpcFicpHBn+Lc9hBmK6JCTE1R0AipDKcoO3DVLLbqqeuzoROzuzCWo2T2dyiOgS2d0EvmdW95Pe0PL94DxHLrvSW5iC67s0iiKeYq8+gNpACZVanuMybGTkXW0U+S1tJQcW7SY2oig5avjcngS5QNyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115487; c=relaxed/simple;
	bh=15z6SxpM/Q4ynXVg0b+d1DcmdKhsEAm0gPrFInUbT9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vlt3Dg4iHkmbJLPNR3PT+Y5WN56gh5h5VJS0qPlwB3NoS4NdzC0vCluwuBV7Ds5FAUj7DZzkxIZu+Rd1ghVK0kc1R7rgqTGiGanGysEqYK5L5wkfbJM76tb5g5E0yc3+9auuAAjh2mRZBN2acxIY0EXG9dEYwK4z7dPtFuM95Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=avN0GSLU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="avN0GSLU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59313C4CEE5;
	Tue,  8 Apr 2025 12:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115487;
	bh=15z6SxpM/Q4ynXVg0b+d1DcmdKhsEAm0gPrFInUbT9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=avN0GSLULvJ2rhR/IMIVaj6OUDKTUqbB9mBcITodE9voIrrTfQ0kFHWsbFYizzYlO
	 TEjcWvkgXInBP0tuIXfQYVx6ynYWamGIMQYEhv8OLqBZuuRzg1mUzzInJ3B/3xqMYY
	 w8bWFNAWRnS8Th8Pxly/ymhezRaTXrRJD9HtVpE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.13 492/499] nfsd: allow SC_STATUS_FREEABLE when searching via nfs4_lookup_stateid()
Date: Tue,  8 Apr 2025 12:51:44 +0200
Message-ID: <20250408104903.629136267@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

commit d1bc15b147d35b4cb7ca99a9a7d79d41ca342c13 upstream.

The pynfs DELEG8 test fails when run against nfsd. It acquires a
delegation and then lets the lease time out. It then tries to use the
deleg stateid and expects to see NFS4ERR_DELEG_REVOKED, but it gets
bad NFS4ERR_BAD_STATEID instead.

When a delegation is revoked, it's initially marked with
SC_STATUS_REVOKED, or SC_STATUS_ADMIN_REVOKED and later, it's marked
with the SC_STATUS_FREEABLE flag, which denotes that it is waiting for
s FREE_STATEID call.

nfs4_lookup_stateid() accepts a statusmask that includes the status
flags that a found stateid is allowed to have. Currently, that mask
never includes SC_STATUS_FREEABLE, which means that revoked delegations
are (almost) never found.

Add SC_STATUS_FREEABLE to the always-allowed status flags, and remove it
from nfsd4_delegreturn() since it's now always implied.

Fixes: 8dd91e8d31fe ("nfsd: fix race between laundromat and free_stateid")
Cc: stable@vger.kernel.org
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -6902,7 +6902,7 @@ nfsd4_lookup_stateid(struct nfsd4_compou
 		 */
 		statusmask |= SC_STATUS_REVOKED;
 
-	statusmask |= SC_STATUS_ADMIN_REVOKED;
+	statusmask |= SC_STATUS_ADMIN_REVOKED | SC_STATUS_FREEABLE;
 
 	if (ZERO_STATEID(stateid) || ONE_STATEID(stateid) ||
 		CLOSE_STATEID(stateid))
@@ -7557,9 +7557,7 @@ nfsd4_delegreturn(struct svc_rqst *rqstp
 	if ((status = fh_verify(rqstp, &cstate->current_fh, S_IFREG, 0)))
 		return status;
 
-	status = nfsd4_lookup_stateid(cstate, stateid, SC_TYPE_DELEG,
-				      SC_STATUS_REVOKED | SC_STATUS_FREEABLE,
-				      &s, nn);
+	status = nfsd4_lookup_stateid(cstate, stateid, SC_TYPE_DELEG, SC_STATUS_REVOKED, &s, nn);
 	if (status)
 		goto out;
 	dp = delegstateid(s);


