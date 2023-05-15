Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077711772F
	for <patches@lists.linux.dev>; Mon, 15 May 2023 18:02:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61AD9C433D2;
	Mon, 15 May 2023 18:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173770;
	bh=Q5pOBJorzYHmj9WKTer9nWedDV5JfE/NgU/mJNMni4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lmXhlIEISexgjp/d0ddzcBBH/RMtWkhgnR6J4YEezAxyTkaIw2N87NajPITI+Ip+I
	 bw1GQ1ijKYVOuSihxLfgx8u2HKaZYPH6MPe4sYkiekpGL7OMd/yUDLIny3s1uZgLU5
	 NY85kn16AlEBhNvlaWgbyaQt8UIRDUFpUBmrpEME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 170/282] NFSv4.1: Always send a RECLAIM_COMPLETE after establishing lease
Date: Mon, 15 May 2023 18:29:08 +0200
Message-Id: <20230515161727.305912333@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 40882deb83c29d8df4470d4e5e7f137b6acf7ad1 ]

The spec requires that we always at least send a RECLAIM_COMPLETE when
we're done establishing the lease and recovering any state.

Fixes: fce5c838e133 ("nfs41: RECLAIM_COMPLETE functionality")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4state.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index 2ee30ffeb6b97..01b1856705941 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -66,6 +66,8 @@
 
 #define OPENOWNER_POOL_SIZE	8
 
+static void nfs4_state_start_reclaim_reboot(struct nfs_client *clp);
+
 const nfs4_stateid zero_stateid = {
 	{ .data = { 0 } },
 	.type = NFS4_SPECIAL_STATEID_TYPE,
@@ -329,6 +331,8 @@ int nfs41_init_clientid(struct nfs_client *clp, const struct cred *cred)
 	status = nfs4_proc_create_session(clp, cred);
 	if (status != 0)
 		goto out;
+	if (!(clp->cl_exchange_flags & EXCHGID4_FLAG_CONFIRMED_R))
+		nfs4_state_start_reclaim_reboot(clp);
 	nfs41_finish_session_reset(clp);
 	nfs_mark_client_ready(clp, NFS_CS_READY);
 out:
-- 
2.39.2



