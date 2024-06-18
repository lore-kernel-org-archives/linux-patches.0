Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2CB313BAC7;
	Tue, 18 Jun 2024 12:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715384; cv=none; b=MW63iXWMQxDr5KS6oGjtp3e29KchNzGWryJLfPn/17kZWvppaU00LvC3VGGuAd3iNUiWOZpTWglEKfIK5NXEWpSDrF1Hy129g56A8VtowR7aq9ZNqDa44lL58rz3EG2jj1CBRUldv5ec3NbIR1/anctoN0ayJPm4HeyZ7tPKeZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715384; c=relaxed/simple;
	bh=36C5oNb/5E6Zxfnem7HXnXCulR2cb+qmlCEsaRXZ66M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SUECW+4RDdYM3B2uslkyjDqUXyY9vtuCDMpQDU8a2NACjCiaaA+8FY8RvwoEYAjL1ZgdWKp857JA1JOdt5O0qhwOuxEiARrtDUc5RTCfSGAVkgI2Lvog/V/AKnvlnJ/uMenzhNTYF2KQZzEDavs8IePGNhUGMHaI5t8WH7M5PBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r5HaGptC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r5HaGptC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E14B9C3277B;
	Tue, 18 Jun 2024 12:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715384;
	bh=36C5oNb/5E6Zxfnem7HXnXCulR2cb+qmlCEsaRXZ66M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r5HaGptCOGz6RHyl5ad1ofblYpMWbqm25ljQ0yzYx66Jwx7j4S7HoebcYw/T6u/GO
	 w/9Otz5pkpJNvpT8EdrypAkqNcRRfK3Tg1HExsbiDyMu9EhhV5k972OQbp9oC+tZHt
	 jzGSgziT3H9mI748S/2mgECzHLZqLeTdymrpOinE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"J. Bruce Fields" <bfields@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 291/770] nfsd: move some commit_metadata()s outside the inode lock
Date: Tue, 18 Jun 2024 14:32:24 +0200
Message-ID: <20240618123418.494336253@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit eeeadbb9bd5652c47bb9b31aa9ad8b4f1b4aa8b3 ]

The commit may be time-consuming and there's no need to hold the lock
for it.

More of these are possible, these were just some easy ones.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/vfs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 2eb3bfbc8a35f..74b2c6c5ad0b9 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1626,9 +1626,9 @@ nfsd_symlink(struct svc_rqst *rqstp, struct svc_fh *fhp,
 
 	host_err = vfs_symlink(d_inode(dentry), dnew, path);
 	err = nfserrno(host_err);
+	fh_unlock(fhp);
 	if (!err)
 		err = nfserrno(commit_metadata(fhp));
-	fh_unlock(fhp);
 
 	fh_drop_write(fhp);
 
@@ -1693,6 +1693,7 @@ nfsd_link(struct svc_rqst *rqstp, struct svc_fh *ffhp,
 	if (d_really_is_negative(dold))
 		goto out_dput;
 	host_err = vfs_link(dold, dirp, dnew, NULL);
+	fh_unlock(ffhp);
 	if (!host_err) {
 		err = nfserrno(commit_metadata(ffhp));
 		if (!err)
@@ -1913,10 +1914,10 @@ nfsd_unlink(struct svc_rqst *rqstp, struct svc_fh *fhp, int type,
 		host_err = vfs_rmdir(dirp, rdentry);
 	}
 
+	fh_unlock(fhp);
 	if (!host_err)
 		host_err = commit_metadata(fhp);
 	dput(rdentry);
-	fh_unlock(fhp);
 	iput(rinode);    /* truncate the inode here */
 
 out_drop_write:
-- 
2.43.0



