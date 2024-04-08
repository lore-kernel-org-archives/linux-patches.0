Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00219524AF;
	Mon,  8 Apr 2024 13:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584736; cv=none; b=lHemG41VMfPj9g3Mj/yNMdmWRKmlLvvPNacx6hW5sxDDAo31X/zlDviFdl6twQATq+sVBuWWUiF2NkicNb8R5frTCpFvKDLZUZ+jYYJrLDLZ7OTq1f7N1BeoTbzDvqvFwB08G3vkbcXKwBBpLDBKYOEvUvhjCH5O8aQBLy806OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584736; c=relaxed/simple;
	bh=OaKarnyVaqLUt8KF6fAjmivkU9f9AaIpar89fSWJDNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EZNPERJBx6m1aHw5MJKBj2/KcF4oH6lrcEQiJhx8w9MVBo+2qX3QjdSCgCsIKeoN814iLfI6TaMRABA65r4yH284IF1vH0MvUkRosGyYIC5t2mk9aCF6dNXIrcrH5DavEWo2igdgmm5HxWLcct9w19sXF+w3Yg5Ze88taw90qXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mrHg0InO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mrHg0InO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D0F4C433F1;
	Mon,  8 Apr 2024 13:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584735;
	bh=OaKarnyVaqLUt8KF6fAjmivkU9f9AaIpar89fSWJDNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mrHg0InOVNyAQ14RzC+yIjp6bK+WxMeLz0+7EY++/dkecm0BBuvDUtCc+zFT7//wn
	 O1naRFxSQTI3tKIrazWPfZnb7v7LB/R373Jw4hJREKPGknLZlfYJKajhmvPPsHkdze
	 5fIPHmYnOFZRkZBMCHWn4QCp71DfbdgPYbJzxoRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 539/690] NFSD: Fix problem of COMMIT and NFS4ERR_DELAY in infinite loop
Date: Mon,  8 Apr 2024 14:56:45 +0200
Message-ID: <20240408125419.182366832@linuxfoundation.org>
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

[ Upstream commit 147abcacee33781e75588869e944ddb07528a897 ]

The following request sequence to the same file causes the NFS client and
server getting into an infinite loop with COMMIT and NFS4ERR_DELAY:

OPEN
REMOVE
WRITE
COMMIT

Problem reported by recall11, recall12, recall14, recall20, recall22,
recall40, recall42, recall48, recall50 of nfstest suite.

This patch restores the handling of race condition in nfsd_file_do_acquire
with unlink to that prior of the regression.

Fixes: ac3a2585f018 ("nfsd: rework refcounting in filecache")
Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 6b8706f23eaf0..615ea8324911e 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -1098,8 +1098,6 @@ nfsd_file_do_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	 * then unhash.
 	 */
 	if (status != nfs_ok || inode->i_nlink == 0)
-		status = nfserr_jukebox;
-	if (status != nfs_ok)
 		nfsd_file_unhash(nf);
 	clear_and_wake_up_bit(NFSD_FILE_PENDING, &nf->nf_flags);
 	if (status == nfs_ok)
-- 
2.43.0



