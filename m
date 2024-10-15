Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2065C1C07DB;
	Tue, 15 Oct 2024 13:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997505; cv=none; b=m5Vb56kB3bdhH5trdWkGbF5D3VQnUTVxTGFL7xT8NV5TYUM7jq8767vb0nNW5mfRaB7EmUAnVUcK7MA+IPMXpp8dr7yFikqRQJDo2iGLBkFj+CLbn3Cmq9E081McKwMItJoggGN8RZcddhtpiz68AgO/EkzYQvW5/fw8x7T5uOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997505; c=relaxed/simple;
	bh=2L5ZUCTvHZ4SxnvWvJ3Xx5Y6gfDA50MBBMMood1crmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N4tAlWZPLw97zcIlwV6L7wjpEwCQFPJurWRvJi5+3wUuf+DLIQh+gwVAWgvBlpxBhqozQzLurdH43hs4CdvDcPTU43OGd+lPKznCeYmYrSMhT2S0RdHmmEIdHvhfQIXrJmsmHPFDy39UIQG0zoziYGn2pZFbfUulw5KpXB/wYqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MBEvzqfX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MBEvzqfX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81968C4CEC6;
	Tue, 15 Oct 2024 13:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997505;
	bh=2L5ZUCTvHZ4SxnvWvJ3Xx5Y6gfDA50MBBMMood1crmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MBEvzqfX/1sDMKUSxMxvR57jgHHybZI7q35wB3sLSdbe0TqirKB9VcsqWGlvNx+Zw
	 ms/mgQXkeUKHXNPWbIwntF3df79PFq3E6o3EFPBdU1Qzjnt+a3OudZ4FkSGD0yyqjz
	 2C2cPS+wNJjeXLSy2KTWy44C7/WUcNuRrhwI3QgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Youzhong Yang <youzhong@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 171/518] nfsd: fix refcount leak when file is unhashed after being found
Date: Tue, 15 Oct 2024 14:41:15 +0200
Message-ID: <20241015123923.593088756@linuxfoundation.org>
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

[ Upstream commit 8a7926176378460e0d91e02b03f0ff20a8709a60 ]

If we wait_for_construction and find that the file is no longer hashed,
and we're going to retry the open, the old nfsd_file reference is
currently leaked. Put the reference before retrying.

Fixes: c6593366c0bf ("nfsd: don't kill nfsd_files because of lease break error")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Tested-by: Youzhong Yang <youzhong@gmail.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 96a2be833b20b..31169f0cc3d74 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -1054,6 +1054,7 @@ nfsd_file_do_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 			status = nfserr_jukebox;
 			goto construction_err;
 		}
+		nfsd_file_put(nf);
 		open_retry = false;
 		goto retry;
 	}
-- 
2.43.0



