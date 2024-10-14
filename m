Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D29226296;
	Mon, 14 Oct 2024 15:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918066; cv=none; b=LYsbmHRdCE1Bq2oi9xA2E99EXW7mKKYHXbbSGR0AcxZ4ujaCSmnK479ijTvH5hWyVdhEKAiVUteZE1OOsy38uM2lF7asi43WVEglGYUHPh4Z7SypeWq8xnwBN7OWD7AueucV7JdG4lndWXIhohAUhyXpvs8nRB+M6tEdMUzER+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918066; c=relaxed/simple;
	bh=ED/a89jk26psK+q9cK0pkS991znPAAuIaKl+Y9os2WE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iWk4UQ+qgU4Jwb+gDLPTjaK+CMEtFlYFqEDc7/1S1w9gpHNct4teVSzRQ/G7kJukykndGSUd+wqd0wTnqnu4BPQNtHyzBfl6gE/f4JOIXpOZ6i0e2JEWvjoe7rGWhtYboYSVyRMkyZbDjmOz9PYxsLEL0swffJngjRy6v8aBsd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XtqpVsrQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XtqpVsrQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD45C4CEC3;
	Mon, 14 Oct 2024 15:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918066;
	bh=ED/a89jk26psK+q9cK0pkS991znPAAuIaKl+Y9os2WE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XtqpVsrQYrfH8NHUA3PQ20rnFnI04gPMMCSWa+uR6+Day7071RBdq7vwua2pCVyIf
	 Cs9p/toNTtCDgmfnNPPwGck7MTcbVpd9sCMRRkdybd0Cd3znQCLmT5iAw1/ywrh8yg
	 H5LpX3+bHmP5zs6TN2S/D3tff+gCvgSof+GRKVqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Youzhong Yang <youzhong@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 212/798] nfsd: fix refcount leak when file is unhashed after being found
Date: Mon, 14 Oct 2024 16:12:46 +0200
Message-ID: <20241014141226.260583316@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9101ad9175396..9e81f3a9097e0 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -1055,6 +1055,7 @@ nfsd_file_do_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 			status = nfserr_jukebox;
 			goto construction_err;
 		}
+		nfsd_file_put(nf);
 		open_retry = false;
 		goto retry;
 	}
-- 
2.43.0



