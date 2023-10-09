Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F6F19464
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AWzMu9ry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EBEDC433C7;
	Mon,  9 Oct 2023 13:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857172;
	bh=g2iHJstdEizDqWoapOwj8lHxDkyNsBHuBy30ht5IYK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AWzMu9ryPaAzTSj/Uf1CeZtLDoxoYNMXy1MYB5YfQEf3b0teMmooe/CeGwaUSp95D
	 6hJdmoOcKaYeyV+iCgZRi94S49cEAAiISR2bTpyclY7D0yO+Bp/YQK3Gd8gIaX+aoR
	 fC35PWsRNQqEnhbOTyZ4RcR8ArH2jxFHsfNXXq6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 095/163] NFSv4: Fix a nfs4_state_manager() race
Date: Mon,  9 Oct 2023 15:00:59 +0200
Message-ID: <20231009130126.653594757@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
index 597ae4535fe33..9a5d911a7edc7 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -2714,6 +2714,13 @@ static void nfs4_state_manager(struct nfs_client *clp)
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



