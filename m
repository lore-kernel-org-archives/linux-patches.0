Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFEED339BF
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TTOHX902"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47092C433CA;
	Mon,  9 Oct 2023 13:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696859089;
	bh=hG+Uw+83ZYYZOm8BXeJOMzC1VzA59To3iFE5LMGF55Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TTOHX902j7KOV27/CzsRRbC6qCffjpRh+3aQiROfnkYRpR5wUyC4N8APaTkMFDVI0
	 t5zxUS99EDU2yGzIT+8QEtbC2w6Fuz5syPILIcFrf5+RpQxLXWR4pgcOS1k1ymrtil
	 UFHDg4s/6Cao7MNx5WNibngC5ahrVudExGpUUais=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 196/226] NFSv4: Fix a nfs4_state_manager() race
Date: Mon,  9 Oct 2023 15:02:37 +0200
Message-ID: <20231009130131.716347324@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
References: <20231009130126.697995596@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit ed1cc05aa1f7fe8197d300e914afc28ab9818f89 ]

If the NFS4CLNT_RUN_MANAGER flag got set just before we cleared
NFS4CLNT_MANAGER_RUNNING, then we might have won the race against
nfs4_schedule_state_manager(), and are responsible for handling the
recovery situation.

Fixes: aeabb3c96186 ("NFSv4: Fix a NFSv4 state manager deadlock")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4state.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index 10946b24c66f9..afb617a4a7e42 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -2690,6 +2690,13 @@ static void nfs4_state_manager(struct nfs_client *clp)
 		nfs4_end_drain_session(clp);
 		nfs4_clear_state_manager_bit(clp);
 
+		if (test_bit(NFS4CLNT_RUN_MANAGER, &clp->cl_state) &&
+		    !test_and_set_bit(NFS4CLNT_MANAGER_RUNNING,
+				      &clp->cl_state)) {
+			memflags = memalloc_nofs_save();
+			continue;
+		}
+
 		if (!test_and_set_bit(NFS4CLNT_RECALL_RUNNING, &clp->cl_state)) {
 			if (test_and_clear_bit(NFS4CLNT_DELEGRETURN, &clp->cl_state)) {
 				nfs_client_return_marked_delegations(clp);
-- 
2.40.1



