Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57CC42049;
	Thu, 15 Jan 2026 16:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768495903; cv=none; b=O5ddJCC+5ekifpyZElC2nvDyenP0mCTlNJksh4l1A5/o+LbMm/ubNd2NceUDutM5MdL4Ih46EqVgjoYd3p957L7j7lGlboaNZLZ7w3CCI8eoqrE8yauwGAXCMhjRIQl4gz4V2wtEfIm3g5wFfme2kGV0pbsq0lCX2wg/BbEC9Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768495903; c=relaxed/simple;
	bh=V3qvVUcceNu3ifoXvnevanvqIfaSiwxAqXXmhQgIt78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GB7xykEIZPXu8tZkLFGyIcLA9IhoxGgBiJ678icrR9psfth42E9WYNiX87t5y7pBCONO4KA+AeUXRF3FLWD3ASzYe6NKv6ttfp66W/u2LRliJfaVIPUDo12YzPb/s00Nq4KXtJnqiwweeuJkrtUbXSLEhcHyo44I0G6eNGdP1UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rrXx2RxG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rrXx2RxG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C09FAC116D0;
	Thu, 15 Jan 2026 16:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768495903;
	bh=V3qvVUcceNu3ifoXvnevanvqIfaSiwxAqXXmhQgIt78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rrXx2RxGqILpUK1Uch6n9f1GufmoobRvB7yPgc2UaxXsURtSZd3dQ60RiX/AHPVAW
	 h5BZawjcGGbqK4OMGlUrT76RweBHrFSLsUlMOlhIwZQhZ52LaF7lgcOYhMtP1qjn37
	 0Ti9+Ivori4y3f9mxY9V+/YKpunkOfrjB0jhYvk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Scott Mayhew <smayhew@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.18 001/181] NFSD: Fix permission check for read access to executable-only files
Date: Thu, 15 Jan 2026 17:45:38 +0100
Message-ID: <20260115164202.364389562@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

From: Scott Mayhew <smayhew@redhat.com>

commit e901c7fce59e72d9f3c92733c379849c4034ac50 upstream.

Commit abc02e5602f7 ("NFSD: Support write delegations in LAYOUTGET")
added NFSD_MAY_OWNER_OVERRIDE to the access flags passed from
nfsd4_layoutget() to fh_verify().  This causes LAYOUTGET to fail for
executable-only files, and causes xfstests generic/126 to fail on
pNFS SCSI.

To allow read access to executable-only files, what we really want is:
1. The "permissions" portion of the access flags (the lower 6 bits)
   must be exactly NFSD_MAY_READ
2. The "hints" portion of the access flags (the upper 26 bits) can
   contain any combination of NFSD_MAY_OWNER_OVERRIDE and
   NFSD_MAY_READ_IF_EXEC

Fixes: abc02e5602f7 ("NFSD: Support write delegations in LAYOUTGET")
Cc: stable@vger.kernel.org # v6.6+
Signed-off-by: Scott Mayhew <smayhew@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: NeilBrown <neil@brown.name>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/vfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -2683,8 +2683,8 @@ nfsd_permission(struct svc_cred *cred, s
 
 	/* Allow read access to binaries even when mode 111 */
 	if (err == -EACCES && S_ISREG(inode->i_mode) &&
-	     (acc == (NFSD_MAY_READ | NFSD_MAY_OWNER_OVERRIDE) ||
-	      acc == (NFSD_MAY_READ | NFSD_MAY_READ_IF_EXEC)))
+	     (((acc & NFSD_MAY_MASK) == NFSD_MAY_READ) &&
+	      (acc & (NFSD_MAY_OWNER_OVERRIDE | NFSD_MAY_READ_IF_EXEC))))
 		err = inode_permission(&nop_mnt_idmap, inode, MAY_EXEC);
 
 	return err? nfserrno(err) : 0;


