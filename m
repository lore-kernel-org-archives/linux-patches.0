Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E2A200A6
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:02:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD62AC433C8;
	Fri, 21 Jul 2023 19:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966137;
	bh=eboyxibNpoCw7evqcnECkxD5Bh4kBBFbq+zPzfO3nrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1eyRlvvH4cqR49Tn3J6OWaIu4lyaLjX1f4012I0g/dDPlKdnT5aiXxWbxvRBHRyLq
	 c6nbxlpssB0douTM/ye/r15LHnhG17SBB/oY2Jf1e1JLQm8NDNIXl7/bjzkaScY4xx
	 MvVgcFX2vjFUsfl74/za1TtRP4e8hJ80rgqk4gpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <kolga@netapp.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 238/532] NFSv4.1: freeze the session table upon receiving NFS4ERR_BADSESSION
Date: Fri, 21 Jul 2023 18:02:22 +0200
Message-ID: <20230721160627.273058094@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Olga Kornievskaia <kolga@netapp.com>

[ Upstream commit c907e72f58ed979a24a9fdcadfbc447c51d5e509 ]

When the client received NFS4ERR_BADSESSION, it schedules recovery
and start the state manager thread which in turn freezes the
session table and does not allow for any new requests to use the
no-longer valid session. However, it is possible that before
the state manager thread runs, a new operation would use the
released slot that received BADSESSION and was therefore not
updated its sequence number. Such re-use of the slot can lead
the application errors.

Fixes: 5c441544f045 ("NFSv4.x: Handle bad/dead sessions correctly in nfs41_sequence_process()")
Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 0546fa1ac98f4..b1ec9b5d06e58 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -923,6 +923,7 @@ static int nfs41_sequence_process(struct rpc_task *task,
 out_noaction:
 	return ret;
 session_recover:
+	set_bit(NFS4_SLOT_TBL_DRAINING, &session->fc_slot_table.slot_tbl_state);
 	nfs4_schedule_session_recovery(session, status);
 	dprintk("%s ERROR: %d Reset session\n", __func__, status);
 	nfs41_sequence_free_slot(res);
-- 
2.39.2



