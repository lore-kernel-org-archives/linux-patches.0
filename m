Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5551D0DCE;
	Wed,  2 Oct 2024 13:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876389; cv=none; b=lu0n0Ea6Igr1xKLAqexyVf+CzFx3bwSqev2UWSrQ1JKp6zj6L59rH3V80ecKV4bcWy80g1f70k8hfiqEZqqwGOfPLNHSa572UFbPQmxXQfgkA937ZdiPvkSr34a8P9rEEN+JyRNbBwIagXgE4HDyUE1VQ3FiyVB0o6x1YkuiMF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876389; c=relaxed/simple;
	bh=b2nXVYfmSr0hBljKTmG9awfXvFDcA8T8IPfMdcaqe9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hp27nLn6qCUXU0A4AW6t++UIr3S14xBZWoMdzDjZzS+ENNeyVnZDIHTsPaaOeDzaRYcJiHLQWePbghesBD4qxpYK36a+LCpgl+gRIo5V6g72FMmCOY1jDWPKkHjEWKSNv2hfezelRziJtBRWJjxtxxZ7QjSAhzdJDuhN6jn9SZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=InPN/DmX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="InPN/DmX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01246C4CEC5;
	Wed,  2 Oct 2024 13:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876389;
	bh=b2nXVYfmSr0hBljKTmG9awfXvFDcA8T8IPfMdcaqe9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=InPN/DmXbcxcjsnQjctNkg9UD9mUa+wharDAZeIrw14U4jxNAWMU8HdiIQmIuFSb8
	 CR17x1FryuPEC31jjSgRD0S/iHHF9vrKLgnpb/+BbmqU1IKLgNEJmEJxgT0/0w8nMN
	 82+LGDRb5EBzzqphL6aJs1iCKLLR1BpuWqqLzE/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Youzhong Yang <youzhong@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 396/695] nfsd: remove unneeded EEXIST error check in nfsd_do_file_acquire
Date: Wed,  2 Oct 2024 14:56:34 +0200
Message-ID: <20241002125838.263287616@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index f4704f5d40867..f09d96ff20652 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -1035,8 +1035,6 @@ nfsd_file_do_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	if (likely(ret == 0))
 		goto open_file;
 
-	if (ret == -EEXIST)
-		goto retry;
 	trace_nfsd_file_insert_err(rqstp, inode, may_flags, ret);
 	status = nfserr_jukebox;
 	goto construction_err;
-- 
2.43.0



