Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEECF1D0414;
	Wed,  2 Oct 2024 14:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879990; cv=none; b=p00emL9e0oVMqUnf+beVQOzyelTSGt817HkaXu+Nk82YXrzCDmPLMzgV3SaHWqEIc5ONfkKhp+7ay+fil1gzYJiqB3vgokYuWHvs89SeLskmnrPXht4jxy7mWtzUgzxbqrNcCjvm0YdDTzbVF+WHNwfvaMn8R68pRWbgjt1XYlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879990; c=relaxed/simple;
	bh=T6YB9E01xqAkaCWptIAJSCSw+kPosTqbkJeS8vDKOxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VfPLtZfEajW4fM/9UUSHRASI70bz2courgBM0LB9YBMxrnJs16qft3x88bT+yXQcK1dSUOzG8K8fcdPs2EFRDNL7qIbiLbTj8qvyM/1zxXW7nenLLQdnp3L4hHAsFWX46UD9/wPT0ogkS/Mjk52pWIHsJ0Mpnvcaol2AMlD25+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eekZLKeL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eekZLKeL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D0CC4CEC2;
	Wed,  2 Oct 2024 14:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879989;
	bh=T6YB9E01xqAkaCWptIAJSCSw+kPosTqbkJeS8vDKOxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eekZLKeL1Eq6m3BmejRLhyWlyjsf3f39O97JG7zM0TC8uyjqexG3H8VTpObUDe7gs
	 0LArw9+pPNg1N95kefiZinBmaGhVQsnp4kf2pJ3ZmyFbFdz9zR1Gyd0VjsAnlCs/jA
	 A1r1UIsA38vfVPz7hj7WGhiAU8I4/rTxeQLvI7/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Youzhong Yang <youzhong@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 307/538] nfsd: remove unneeded EEXIST error check in nfsd_do_file_acquire
Date: Wed,  2 Oct 2024 14:59:06 +0200
Message-ID: <20241002125804.536023745@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 07bf219f9ae48..88cefb630e171 100644
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



