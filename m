Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066EA3A1C7;
	Mon,  8 Apr 2024 13:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584768; cv=none; b=FEol43WD/tfY53vylV6AIDmvbW1aDJ/FFHao/wj7/vbA9N8cK3OfIQ9K4EVEk71l6W+cYZc/bimkkbhXeXIoOuOCN8whvwJR8eZCMDkYRgp57MMoAvCGrmW0x55SPHQ5Me4v1JcKI98xR0dDNU+r7FwdufLWwevUWd1lwBaz2NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584768; c=relaxed/simple;
	bh=awCUgaLxusFNQ3x6Wv7fz6IiILHF30U1xYXWa99iIsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WG1yAj95sJx50+CFoG+HXIGcmfs1nuJ/l6XyaC8hV3uA79Heu6+7aeBdLfszFIkkGbEXznurXBSNwRbdblj0rTYGBS0KGkdKQmN2PrT78cJs0ryB/VDbg1AQ2UqeiQyb4+QidQPAvGCDADWL5T0Sw/+6tqVrHw+W//KLSdoMc1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wWp8nEbm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wWp8nEbm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8082FC433C7;
	Mon,  8 Apr 2024 13:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584767;
	bh=awCUgaLxusFNQ3x6Wv7fz6IiILHF30U1xYXWa99iIsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wWp8nEbmrYqhbUDlPwPMp3GsvJgjgaddJlHLU4S8d4rqppqaSYR0C8qp56xXmPN/v
	 nHIiFHICPT9QE0tgaczmVzlmaFPSQiZgsWDIbr66jX7s/UJBA7ewP3zdzRPzQE9N1T
	 uLvRxTktwrQFYidEa7S2tvKq/+165eOtcHmqNaWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 520/690] NFSD: fix leaked reference count of nfsd4_ssc_umount_item
Date: Mon,  8 Apr 2024 14:56:26 +0200
Message-ID: <20240408125418.486456966@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Dai Ngo <dai.ngo@oracle.com>

[ Upstream commit 34e8f9ec4c9ac235f917747b23a200a5e0ec857b ]

The reference count of nfsd4_ssc_umount_item is not decremented
on error conditions. This prevents the laundromat from unmounting
the vfsmount of the source file.

This patch decrements the reference count of nfsd4_ssc_umount_item
on error.

Fixes: f4e44b393389 ("NFSD: delay unmount source's export after inter-server copy completed.")
Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4proc.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index ada46ef5a093d..c95e7ec5fb530 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1813,13 +1813,17 @@ nfsd4_copy(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	release_copy_files(copy);
 	return status;
 out_err:
+	if (nfsd4_ssc_is_inter(copy)) {
+		/*
+		 * Source's vfsmount of inter-copy will be unmounted
+		 * by the laundromat. Use copy instead of async_copy
+		 * since async_copy->ss_nsui might not be set yet.
+		 */
+		refcount_dec(&copy->ss_nsui->nsui_refcnt);
+	}
 	if (async_copy)
 		cleanup_async_copy(async_copy);
 	status = nfserrno(-ENOMEM);
-	/*
-	 * source's vfsmount of inter-copy will be unmounted
-	 * by the laundromat
-	 */
 	goto out;
 }
 
-- 
2.43.0



