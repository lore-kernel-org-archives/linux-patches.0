Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02334C83
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:33:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66935C433EF;
	Mon, 16 Jan 2023 16:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886809;
	bh=T+GN3KzClFQ0pazylmw4yqQ4cszGxeiRLVI7wGusluE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iVO7pQl6R0fhrUYZB3bf6QmoCAhITYbSwUR28uP7zLFDgXmaP+FY8iKAkuvvzEjjT
	 CRLRnUuczuR3oDU65+jUysswpnjXhx707anW5aTRzeOZG80cs33uixaAzghzDf1TIm
	 jPhOjwE9koN8BOHS+4iqeZuDEmXpcRU1FiW0L4TY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	Wang Yugui <wangyugui@e16-tech.com>
Subject: [PATCH 5.4 570/658] nfsd: shut down the NFSv4 state objects before the filecache
Date: Mon, 16 Jan 2023 16:50:58 +0100
Message-Id: <20230116154935.581452913@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 789e1e10f214c00ca18fc6610824c5b9876ba5f2 ]

Currently, we shut down the filecache before trying to clean up the
stateids that depend on it. This leads to the kernel trying to free an
nfsd_file twice, and a refcount overput on the nf_mark.

Change the shutdown procedure to tear down all of the stateids prior
to shutting down the filecache.

Reported-and-tested-by: Wang Yugui <wangyugui@e16-tech.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Fixes: 5e113224c17e ("nfsd: nfsd_file cache entries should be per net namespace")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfssvc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index d63cdda1782d..70684c7ae94b 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -420,8 +420,8 @@ static void nfsd_shutdown_net(struct net *net)
 {
 	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
 
-	nfsd_file_cache_shutdown_net(net);
 	nfs4_state_shutdown_net(net);
+	nfsd_file_cache_shutdown_net(net);
 	if (nn->lockd_up) {
 		lockd_down(net);
 		nn->lockd_up = 0;
-- 
2.35.1



