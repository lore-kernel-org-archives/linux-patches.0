Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D0528EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 13:56:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2087DC433D2;
	Mon, 30 Jan 2023 13:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675086979;
	bh=aiDoIJ+gWHMj7E7ALkDEl/YDF8LnB+NRaiUUS29VMpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U69l/jw28bjTMayLgMemloSuOB8TvwEgU0omylQCCMNNx8Kt7tBxz7KOo4Ld2AF7m
	 8esOORIwm+8j15B4JFsihvhiZbO97HfPJKd0EOsgkMfroGjAoJ12SUEf14Lkk+Uogd
	 aAJg4IuVg58Z1XC8NnDXwOIUnqyQiWZzIZQjgvII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingyuan Mo <hdthky0@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 059/313] NFSD: fix use-after-free in nfsd4_ssc_setup_dul()
Date: Mon, 30 Jan 2023 14:48:14 +0100
Message-Id: <20230130134339.436235070@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xingyuan Mo <hdthky0@gmail.com>

[ Upstream commit e6cf91b7b47ff82b624bdfe2fdcde32bb52e71dd ]

If signal_pending() returns true, schedule_timeout() will not be executed,
causing the waiting task to remain in the wait queue.
Fixed by adding a call to finish_wait(), which ensures that the waiting
task will always be removed from the wait queue.

Fixes: f4e44b393389 ("NFSD: delay unmount source's export after inter-server copy completed.")
Signed-off-by: Xingyuan Mo <hdthky0@gmail.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 30a08ec31a70..ba04ce9b9fa5 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1331,6 +1331,7 @@ static __be32 nfsd4_ssc_setup_dul(struct nfsd_net *nn, char *ipaddr,
 			/* allow 20secs for mount/unmount for now - revisit */
 			if (signal_pending(current) ||
 					(schedule_timeout(20*HZ) == 0)) {
+				finish_wait(&nn->nfsd_ssc_waitq, &wait);
 				kfree(work);
 				return nfserr_eagain;
 			}
-- 
2.39.0



