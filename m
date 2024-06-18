Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC8613D291;
	Tue, 18 Jun 2024 13:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716532; cv=none; b=L1vPWpJCEKe03XLI0xNsk38b1np3QWcJW+giBM+djjM10SxrTuh3DHRjZ6eM6VgMglIdn9RRs7SmvO989wqq/McxOUD30dE9VBcMENH2esHshZu2ApJX+JWup+K0dTXr2gaEOB572YAqUqPMSAWKfrMPNxAG11nCu3hIAMMQj7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716532; c=relaxed/simple;
	bh=rWVwxT2IECi4/6FBOVn+SDPfdWJc+p2PorMJXeA5xeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qp5OVsPuOQlMazlitODbOP2tdr01Hk25/HvR77kBwF8igbdr/8OGhGesF9wwuy74iKrxRnzDhh4y06+Bc7SEtNATFlKKURrqeqM8hZsvlNvcnGMjSbYVDmO810r8ZRqpgbG4oe3pVroKJZwSSTRFCXr2P0VssEBWukQqY7k97Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2wg8RSW3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2wg8RSW3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26ACEC3277B;
	Tue, 18 Jun 2024 13:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716531;
	bh=rWVwxT2IECi4/6FBOVn+SDPfdWJc+p2PorMJXeA5xeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2wg8RSW3kprOR7AoWrVGEDxiGhtGGNcNJT95E+pomQDb++hFLEMOV4Km2QltqDF+l
	 Ed5bvdTLipKq5ckl1E9qA0vRVa4DtqNVsqM7GtcX0Q5CXSjRIBAuWroijSxjSD3Op0
	 VmUtHh+zxM+64NXiryOHdpPxhQ48MdTxpKO3qp8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 676/770] nfsd: fix use-after-free in nfsd_file_do_acquire tracepoint
Date: Tue, 18 Jun 2024 14:38:49 +0200
Message-ID: <20240618123433.372856720@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit bdd6b5624c62d0acd350d07564f1c82fe649235f ]

When we fail to insert into the hashtable with a non-retryable error,
we'll free the object and then goto out_status. If the tracepoint is
enabled, it'll end up accessing the freed object when it tries to
grab the fields out of it.

Set nf to NULL after freeing it to avoid the issue.

Fixes: 243a5263014a ("nfsd: rework hashtable handling in nfsd_do_file_acquire")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 024adcbe67e95..dceb522f5cee9 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -1075,6 +1075,7 @@ nfsd_file_do_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		goto open_file;
 
 	nfsd_file_slab_free(&nf->nf_rcu);
+	nf = NULL;
 	if (ret == -EEXIST)
 		goto retry;
 	trace_nfsd_file_insert_err(rqstp, key.inode, may_flags, ret);
-- 
2.43.0



