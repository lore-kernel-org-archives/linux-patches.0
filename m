Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E2A28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:10:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B6A2C4339B;
	Mon, 30 Jan 2023 14:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087856;
	bh=Ea3HdgcfLRb0s72iSO6igcJtvk5vchWAX5O7bCvpTn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cetrKnl4QkTamVcZUkpBKqD1gs9xNxOSTYLBWiqcF8A8flrup2fC+dJ+LWv+6teES
	 OcNR77mrpt/JubYuu2gR3CV+dcjW0afNQg1zKXzb0lD5BWgXvPXzclNtVO3zNZkAsD
	 M1vV4OdSn6ShgMmmil+qK03VxzmzRtacYhfH72CI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingyuan Mo <hdthky0@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 032/204] NFSD: fix use-after-free in nfsd4_ssc_setup_dul()
Date: Mon, 30 Jan 2023 14:49:57 +0100
Message-Id: <20230130134317.724674113@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
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
index 09dd70f79158..0a900b9e39ea 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1205,6 +1205,7 @@ static __be32 nfsd4_ssc_setup_dul(struct nfsd_net *nn, char *ipaddr,
 			/* allow 20secs for mount/unmount for now - revisit */
 			if (signal_pending(current) ||
 					(schedule_timeout(20*HZ) == 0)) {
+				finish_wait(&nn->nfsd_ssc_waitq, &wait);
 				kfree(work);
 				return nfserr_eagain;
 			}
-- 
2.39.0



