Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95428F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:47:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A6BC433CA;
	Sun, 16 Jul 2023 20:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540473;
	bh=WGNZDsdAN7LNWIOnXMKTX6TtVvzDr2i8glE894AbQz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jGG+hJXlpq3k1qOXyNYtZm3CtXEgmXIuqu3k1iYvOiwuBWqMqCW/9rfLt0LqZozus
	 dDvxluVAavssq3cxkqSF1BLwGaM11pBTw0Lj5ljoMiLRzx7Q0qpsGYDoW1KSbUeFQA
	 jFo+a3wUAKSnMgrKs2szrRy5M8RJQnPWAIVaS2ZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <kolga@netapp.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 348/591] NFSv4.1: freeze the session table upon receiving NFS4ERR_BADSESSION
Date: Sun, 16 Jul 2023 21:48:07 +0200
Message-ID: <20230716194932.915344135@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
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
index 70e76359909cc..177cb7b089b9a 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -921,6 +921,7 @@ static int nfs41_sequence_process(struct rpc_task *task,
 out_noaction:
 	return ret;
 session_recover:
+	set_bit(NFS4_SLOT_TBL_DRAINING, &session->fc_slot_table.slot_tbl_state);
 	nfs4_schedule_session_recovery(session, status);
 	dprintk("%s ERROR: %d Reset session\n", __func__, status);
 	nfs41_sequence_free_slot(res);
-- 
2.39.2



