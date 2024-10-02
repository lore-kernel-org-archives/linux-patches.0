Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C13A91D04AD;
	Wed,  2 Oct 2024 13:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876298; cv=none; b=lOB6lE8Oi8vw3rluOFyIlP0JeqctYa/mTUK++ZkBwxbk8Q+xhYGZpGE8qW0kr718ZtvNEay9XhM6jcyk0Hc57tVej8/Mr3f/iiP/0nFwy7BdnnQzQSis4ZuXIPoFY4S8t8jhR5PmmoRHYSany2ORzuslV6jOO9n3VY6p2M4RSAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876298; c=relaxed/simple;
	bh=ualhNfpoc/4qUX2obKhjRUOfB96skSVcCyjbSAxnX2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cDiGBN/X0eAZ5s/e8ztKUD/glCdO4FTk89SvdXB69c46PZ5NxTZLsQpOPus6EyN6yqQX/aJjBf0DS1xJXbF/F3k/KfgNEi29F+RoySRYhj8+E4/+CQU7Gv1gXUv9JlS/p0ZytYspoaKuqtqyxSZ5OVXXXgOkpurfDTEpTzy18e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aMz2LAKg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aMz2LAKg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49CF0C4CEC5;
	Wed,  2 Oct 2024 13:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876298;
	bh=ualhNfpoc/4qUX2obKhjRUOfB96skSVcCyjbSAxnX2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aMz2LAKgWFKtnGoLmah9s2DgSFoYdBaTgP8pmCuunxhV9lcVdLMozHDu8PwDcvnd1
	 wUuX6QuSGQMTTBEv+jhyRrEZkg54Pi+WjrDf/GJbfuhY3Xq4WdxoPBzMcbBojFYUwL
	 4kVrcqYM3Bqqa1NIUwehPn3Qb1l/JJt8MIPd/pSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Youzhong Yang <youzhong@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 397/695] nfsd: fix refcount leak when file is unhashed after being found
Date: Wed,  2 Oct 2024 14:56:35 +0200
Message-ID: <20241002125838.303136061@linuxfoundation.org>
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
index f09d96ff20652..e2e248032bfd0 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -1049,6 +1049,7 @@ nfsd_file_do_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 			status = nfserr_jukebox;
 			goto construction_err;
 		}
+		nfsd_file_put(nf);
 		open_retry = false;
 		fh_put(fhp);
 		goto retry;
-- 
2.43.0



