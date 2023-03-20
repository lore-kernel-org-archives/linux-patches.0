Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AAFE1C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:01:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFDAEC433D2;
	Mon, 20 Mar 2023 15:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679324481;
	bh=1BPBZ5ylqobCPmNGb2yrq3fPue+2OLQTZEm7AWgA4Gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0YyIg6EvLdX52MQf5qNFfw2NHV+J7eiMws6OfKVwAd5GnhHTMHzPjgx0Vrzs6X9hh
	 /G3CQM/csv3Rz7est9lXaDT/vQ0csXvtII+MifAEeeUVcBWoTVNVNn322dSog1BeOr
	 /JqCqGkD0yJX7QCx8pc+9eY4/Rzp9lN5w6iOHjPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 03/99] cifs: Move the in_send statistic to __smb_send_rqst()
Date: Mon, 20 Mar 2023 15:53:41 +0100
Message-Id: <20230320145443.494269153@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145443.333824603@linuxfoundation.org>
References: <20230320145443.333824603@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

[ Upstream commit d0dc41119905f740e8d5594adce277f7c0de8c92 ]

When send SMB_COM_NT_CANCEL and RFC1002_SESSION_REQUEST, the
in_send statistic was lost.

Let's move the in_send statistic to the send function to avoid
this scenario.

Fixes: 7ee1af765dfa ("[CIFS]")
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/transport.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index b137006f0fd25..4409f56fc37e6 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -312,7 +312,7 @@ static int
 __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 		struct smb_rqst *rqst)
 {
-	int rc = 0;
+	int rc;
 	struct kvec *iov;
 	int n_vec;
 	unsigned int send_length = 0;
@@ -323,6 +323,7 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 	struct msghdr smb_msg = {};
 	__be32 rfc1002_marker;
 
+	cifs_in_send_inc(server);
 	if (cifs_rdma_enabled(server)) {
 		/* return -EAGAIN when connecting or reconnecting */
 		rc = -EAGAIN;
@@ -331,14 +332,17 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 		goto smbd_done;
 	}
 
+	rc = -EAGAIN;
 	if (ssocket == NULL)
-		return -EAGAIN;
+		goto out;
 
+	rc = -ERESTARTSYS;
 	if (fatal_signal_pending(current)) {
 		cifs_dbg(FYI, "signal pending before send request\n");
-		return -ERESTARTSYS;
+		goto out;
 	}
 
+	rc = 0;
 	/* cork the socket */
 	tcp_sock_set_cork(ssocket->sk, true);
 
@@ -449,7 +453,8 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 			 rc);
 	else if (rc > 0)
 		rc = 0;
-
+out:
+	cifs_in_send_dec(server);
 	return rc;
 }
 
@@ -826,9 +831,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct smb_rqst *rqst,
 	 * I/O response may come back and free the mid entry on another thread.
 	 */
 	cifs_save_when_sent(mid);
-	cifs_in_send_inc(server);
 	rc = smb_send_rqst(server, 1, rqst, flags);
-	cifs_in_send_dec(server);
 
 	if (rc < 0) {
 		revert_current_mid(server, mid->credits);
@@ -1117,9 +1120,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 		else
 			midQ[i]->callback = cifs_compound_last_callback;
 	}
-	cifs_in_send_inc(server);
 	rc = smb_send_rqst(server, num_rqst, rqst, flags);
-	cifs_in_send_dec(server);
 
 	for (i = 0; i < num_rqst; i++)
 		cifs_save_when_sent(midQ[i]);
@@ -1356,9 +1357,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 
 	midQ->mid_state = MID_REQUEST_SUBMITTED;
 
-	cifs_in_send_inc(server);
 	rc = smb_send(server, in_buf, len);
-	cifs_in_send_dec(server);
 	cifs_save_when_sent(midQ);
 
 	if (rc < 0)
@@ -1495,9 +1494,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 	}
 
 	midQ->mid_state = MID_REQUEST_SUBMITTED;
-	cifs_in_send_inc(server);
 	rc = smb_send(server, in_buf, len);
-	cifs_in_send_dec(server);
 	cifs_save_when_sent(midQ);
 
 	if (rc < 0)
-- 
2.39.2



