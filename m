Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D058B41A504;
	Fri,  4 Sep 2026 05:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500704; cv=none; b=RGlzTUrc7ZNPzUWIpGwnhVLfEYlsiREHeopPE3xDLJpwTSmtILPsBbyEggxjUtChMo+s4QHzsXmujNgAFWJzV71hgr5N+pYdXl6C4CxUGq9/nvC/rQtQa1XwihO5r3RmBBhrU8ztd26pluiXr0a2hHk6icOSwWkVSUpft1TV7pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500704; c=relaxed/simple;
	bh=MJCZFrNokJPA/08J7JxMkbaYfEi/rpRril0nMIHB/QI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U5IaT+67gl5vhIcXGCXmaSZIW+k0ul3btGR9e54LeecM2BtlgR3vxNsvokeMn+TUirRgDKCnwh5QgJD0HE3Vv+KwJDQx2PTDfgDw437n3qZG2LnEayzV3w3ihxhGS4YZ144Swu3Uy1uignQOen6NuiCKJ/bXOBJyIRJcqB8Iztg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a/MJWwCj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a/MJWwCj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 393251F00A3D;
	Fri,  4 Sep 2026 05:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500702;
	bh=gNQ7j0AYxCxLO3YM1DFsEPcz+DZAb3aEB01YlHPOD1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a/MJWwCjl+G8J7ke8X1n1LLW9v7O2wserltSErDwBxrNbaVHOn1OQffNBd+0CTqyX
	 4t9cFUzGZ+4Le9k43Z9/ag/tnzbQJ8tSEwPtzM+F5FfItr2BRCz7Ifk9kn4+S35k4U
	 arAR05Yuh1d6FFYiw9txX6tOIA/FGTAfXJbGXwcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.18 149/552] nfsd: reject reclaim LOCK after RECLAIM_COMPLETE
Date: Fri,  4 Sep 2026 06:55:06 +0200
Message-ID: <20260904045752.054043446@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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
@@ -8442,6 +8442,9 @@ nfsd4_lock(struct svc_rqst *rqstp, struc
 	status = nfserr_no_grace;
 	if (!locks_in_grace(net) && lock->lk_reclaim)
 		goto out;
+	if (lock->lk_reclaim &&
+	    test_bit(NFSD4_CLIENT_RECLAIM_COMPLETE, &cstate->clp->cl_flags))
+		goto out;
 
 	if (lock->lk_reclaim)
 		flags |= FL_RECLAIM;


