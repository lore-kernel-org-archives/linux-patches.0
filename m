Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF851D90CD;
	Tue, 15 Oct 2024 11:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992872; cv=none; b=YsJKQC32scwmoY8R949ql/4nWe0+Ym9aGaEQ9Y4yrWsgAIo/57wkUX1H1etsFvi3BMe/7VgbxDfswY7LrBhTcyH0p6p/rd3K6nU2BdZcrqeQQXali2zCJ2LGJBUr9m96DzjaE4ub7f+5VdCEOOqfl3/clOMw5gz/tRZat1OEmjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992872; c=relaxed/simple;
	bh=nWvyi8kNsSFNZwKM5IRukRcwPWGkY3g7dmf5rc4vO7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NiNbn+Lyac6NaFGtnn3c9hy/uB33yvFyomo7ZRojyypAoDXRt/aCzjqq3mXxbU2Hi7nY80aSQqEPLD5qpYzzbe85mSZJ6PlCqNY99KGElX2NBNodblRJC0jxGkin0jpb0eK1buCsuHy0qj6XlIXjTB4ppA1JIyH5T20y8sbwnT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QYfRwRlm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QYfRwRlm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C2FFC4CEC6;
	Tue, 15 Oct 2024 11:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992871;
	bh=nWvyi8kNsSFNZwKM5IRukRcwPWGkY3g7dmf5rc4vO7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QYfRwRlmpqMJD35gOfz9s7cVRlbFTdKBRW+27N6zGnpum2bANzmhNjLvi7q8DbOhO
	 YAM+tPPu3Go3Ucxoey5zNkF7+oAWs0vlGp3m2KWnSa4qmcAVym71ilbVa+ttedYTJz
	 dOmSBHmUaWg7193CRpqJWWO85Ql4ajLorbI49xDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Youzhong Yang <youzhong@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 242/691] nfsd: fix refcount leak when file is unhashed after being found
Date: Tue, 15 Oct 2024 13:23:10 +0200
Message-ID: <20241015112449.960940733@linuxfoundation.org>
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



