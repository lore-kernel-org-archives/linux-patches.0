Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3426647CA62;
	Sat, 12 Sep 2026 13:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219914; cv=none; b=uQMh9i75FuUSBA7Y0Ss9SGr2g59+X+B5Z/aXq4Awn3oN9xAY9O2HSTBDw5fZ5eTE4SPnJQPNa00MAxVKYh/B/jVT17/+7Qy4HdGucsy1IIwMy1DFGVmWBjd8tMa7Zf9prYs0tXPfbQTlTTTbI9P9J+ntTHKbiYQYNk/b52BF/Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219914; c=relaxed/simple;
	bh=4V7IH0j1MaKFvgttQiRzUPjwQC3hz648hA8deWdtPZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ssl+hm5uH0p/s0psosoQJ5EvmDnd+4V9WIob7qEl0vTzKxD1HMfvQyCJgR6j/uDVWDk6AqrmcQEGvE/trFV2AmeCpdPfJ4Qngbx7FP0CH1o1jNDGlZ+bjfLWcYmojVgAZIAyhA4gaaa+D7Bzn2TTgL+fnSz+QrHIBWvgjIng4Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SsFQkKyS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SsFQkKyS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A4F1F000FF;
	Sat, 12 Sep 2026 13:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219913;
	bh=tKhhpQMoVZmWzE76vu6JYPdqzcsHRTGIcNzcSG8/64w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SsFQkKySp4ddhzlXUrD458/D1/0gXiobdG3xBLTW/kFCha0sOtV82IZGKviF63gOT
	 FYlhqqm2tPDgncI/SDO98yeJqagtTrJr7RKysmAnTPYuUMvAXjKL3YZ/8hL6OExbBI
	 dPYfZGVSK74HS1B3ZIztjtPFJlPnkZ0UFXzXGf14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.6 0068/1424] nfsd: reject reclaim LOCK after RECLAIM_COMPLETE
Date: Sat, 12 Sep 2026 08:41:40 +0200
Message-ID: <20260912065608.828925317@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
@@ -7684,6 +7684,9 @@ nfsd4_lock(struct svc_rqst *rqstp, struc
 	status = nfserr_no_grace;
 	if (!locks_in_grace(net) && lock->lk_reclaim)
 		goto out;
+	if (lock->lk_reclaim &&
+	    test_bit(NFSD4_CLIENT_RECLAIM_COMPLETE, &cstate->clp->cl_flags))
+		goto out;
 
 	if (lock->lk_reclaim)
 		fl_flags |= FL_RECLAIM;


