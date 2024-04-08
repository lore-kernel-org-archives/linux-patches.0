Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25897E118;
	Mon,  8 Apr 2024 13:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584042; cv=none; b=P886oFjOa5m1fWpYP1CdcfD3BaiR7lvPEDP/LxJFpjWSCnzPYDHlL9OwZyyX8ZaO8/1NG7yt06VOwunE65bnyNLMNR9nxsdTguMlRUUJV/IONKyVZC1yW4K2po7W9mcRp/D+kk8sV9u6m0GZsTlJcd4TwWsoCdTnwME77W9W3Rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584042; c=relaxed/simple;
	bh=MLysgIV+uAKj94uDo/CL4kzGWc2pXnpef3nXsSRwZ7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R4fFvf5J+deAwO43K8mMFsW9cU5i7wRGNFUNO1y1RggmejcEE/BCe8VzM3gB6rf/5erE0lA+Jz1IjPV2QFFljjXkiWmjAMZsyElLYFGswjtG2qdZ5u/BunhZaVPeBnfRA0c9hwft3rsPhSNRQzlhjtfOHlQ4WsmBkPU32xoOcTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U0+1EEXG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U0+1EEXG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42FB1C433C7;
	Mon,  8 Apr 2024 13:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584042;
	bh=MLysgIV+uAKj94uDo/CL4kzGWc2pXnpef3nXsSRwZ7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U0+1EEXG9m/HZMPF1fEHDs2kA6NO6C3DI4c1m3FacRIgPuv19hoO6/4/RIHGLvCFh
	 cyGaB5lSD3de0jGpeRnk+Proe3y9sLtb++VG8bl42aA3t6S7rb30TRWVIV6DdgCMnD
	 f76JTkxyWoQp89Yu9fpr69HdcwzNs3hkR+gDE0Ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 315/690] NFSD: Avoid calling fh_drop_write() twice in do_nfsd_create()
Date: Mon,  8 Apr 2024 14:53:01 +0200
Message-ID: <20240408125411.009467089@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 14ee45b70dd0d9ae76fb066cd8c0652d657353f6 ]

Clean up: The "out" label already invokes fh_drop_write().

Note that fh_drop_write() is already careful not to invoke
mnt_drop_write() if either it has already been done or there is
nothing to drop. Therefore no change in behavior is expected.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/vfs.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 541f39ab450ce..a46ab32216dee 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1487,7 +1487,6 @@ do_nfsd_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		case NFS3_CREATE_GUARDED:
 			err = nfserr_exist;
 		}
-		fh_drop_write(fhp);
 		goto out;
 	}
 
@@ -1495,10 +1494,8 @@ do_nfsd_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		iap->ia_mode &= ~current_umask();
 
 	host_err = vfs_create(&init_user_ns, dirp, dchild, iap->ia_mode, true);
-	if (host_err < 0) {
-		fh_drop_write(fhp);
+	if (host_err < 0)
 		goto out_nfserr;
-	}
 	if (created)
 		*created = true;
 
-- 
2.43.0



