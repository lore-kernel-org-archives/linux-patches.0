Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65AF1C07DB;
	Tue, 15 Oct 2024 13:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997501; cv=none; b=eu4PzSqv2yYWW2w5tvHwgrBR/lOyHzEWn0ysgx8fquOcc5vuYTxdN1aYZ8ohPQkvjantZ3qFsimeni4jNqXvBIDfHD8QeJIj6pPTUqfL9HjDLrTYTLv4N0xiuF2mugyjoI4nkK2zv3KWCy2gmnN2TqElK4FTnAUQkdl4kTDLybo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997501; c=relaxed/simple;
	bh=oUB/guv6oBfeEM/FG/oLcVQzTGGfCfSAUtl75FI7sKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dcxGVVlwjC4CgLmfaIf+XsdFR7j6AsgRoPpZWoYKj4/EtO6goe2o1UTZqN+tyc7QyNK8rTv0oVjHkNMC6z79nZ48NF6SXQMTWNlQcd6P/3qq7kCDmPyBubCqrjGT27vugNjGPlIRpJ06syipIXmHZuc2GEUPIWn/OBPXbR0ahFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nZ+63/KG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nZ+63/KG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E083C4CECE;
	Tue, 15 Oct 2024 13:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997501;
	bh=oUB/guv6oBfeEM/FG/oLcVQzTGGfCfSAUtl75FI7sKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nZ+63/KGLdKlFd3yP3uZT4HHQQY5VDRPmFCJCoFDY7gH56hbbLeZoXaQs33tbz+fS
	 XQrIAxDS5Tz/CaO29Jnk3WpCzTFN+vNVL5o7USYP5iW25YTFZEgmmA0dBmjz3haW49
	 AGAMJ2vlygPkAQWL97a8UR0i1lCg7O9RiccWOnF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Youzhong Yang <youzhong@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 170/518] nfsd: remove unneeded EEXIST error check in nfsd_do_file_acquire
Date: Tue, 15 Oct 2024 14:41:14 +0200
Message-ID: <20241015123923.555165289@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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



