Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C66C1E633E;
	Tue, 15 Oct 2024 11:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992868; cv=none; b=C+s88Xhn3Uz6EDlQEy//EEIvGbaMoij/URrh8HdGzQHXgokAEKMb8uoZmpVuLgKrRY4Aa50JWT9iw6BzwoMEJB7SKXx0G9Q9Ce+IKkqTFxSg0MnzwHMTiGdtQ8fVCw/CrsBSvkOd3iVy/lvvZH9gUKLeXC4TJKerkshQu0VMbbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992868; c=relaxed/simple;
	bh=4VpGahSb9hwo63yQ76f4ovfCt026AUxdz+PekLVj/dc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R7I49+z4ycgs1+8zd6r/MDiLJNeci0AbPRNTubx47YtD80YTU3AVqMo31qQQ0fEhZ3Ll9ghA8z326OwyjrkNbwUThzkpRLTHZkbu7WEo6Kl8IDt68n05Muk9F+ztvYTD5z3KYm2LSPALCRpsdUyGYXMJS0J85PLuL7CKCIYfPUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=URNJPqQY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="URNJPqQY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00B42C4CEC6;
	Tue, 15 Oct 2024 11:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992868;
	bh=4VpGahSb9hwo63yQ76f4ovfCt026AUxdz+PekLVj/dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=URNJPqQYsJyjCMYKrS8xvWKnmEQRy+ZOD9EHlx6A1ymJCXdEd8E89z2Gf1ZHg7Clg
	 D1lnDmum8cSPbfO7xGN9bBbcXEO+sg+tlyPg9TqVxbbhx/fAix/IHtVnfpHtIqD8oR
	 sJhku+++7NkxFl9xkbjfe8Ze8jiCTajuCjqqs/yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Youzhong Yang <youzhong@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 241/691] nfsd: remove unneeded EEXIST error check in nfsd_do_file_acquire
Date: Tue, 15 Oct 2024 13:23:09 +0200
Message-ID: <20241015112449.921179320@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 81a95c2b1d605743220f28db04b8da13a65c4059 ]

Given that we do the search and insertion while holding the i_lock, I
don't think it's possible for us to get EEXIST here. Remove this case.

Fixes: c6593366c0bf ("nfsd: don't kill nfsd_files because of lease break error")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Tested-by: Youzhong Yang <youzhong@gmail.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 615ea8324911e..96a2be833b20b 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -1040,8 +1040,6 @@ nfsd_file_do_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	if (likely(ret == 0))
 		goto open_file;
 
-	if (ret == -EEXIST)
-		goto retry;
 	trace_nfsd_file_insert_err(rqstp, inode, may_flags, ret);
 	status = nfserr_jukebox;
 	goto construction_err;
-- 
2.43.0



