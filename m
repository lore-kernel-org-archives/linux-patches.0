Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB851C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:01:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E202DC433D2;
	Mon, 20 Mar 2023 15:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679324500;
	bh=Hno1DLqX4JwKi+VHSkCA1FMVyyBG6qsTWWn4gSb+15Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=obp39yxB4FKL5qfhAT+OQUa1WgB9EBUvhEubiXnMeTDmrpIOq+VIGZznritH879Pw
	 rvrp9a1BMM5IvTJGtXIwIPmuwFm1/k7cty5+6n8Mc5mbTtP+VRDaVNJlllG80RBBrf
	 5k3tw3lFAPFRxzkyvGCD9f2tg6TDDTF7bFayk0B4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 04/60] cifs: Move the in_send statistic to __smb_send_rqst()
Date: Mon, 20 Mar 2023 15:54:13 +0100
Message-Id: <20230320145431.056374081@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145430.861072439@linuxfoundation.org>
References: <20230320145430.861072439@linuxfoundation.org>
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
index b98ae69edb8fe..60141a7468b00 100644
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
@@ -324,6 +324,7 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 	int val = 1;
 	__be32 rfc1002_marker;
 
+	cifs_in_send_inc(server);
 	if (cifs_rdma_enabled(server)) {
 		/* return -EAGAIN when connecting or reconnecting */
 		rc = -EAGAIN;
@@ -332,14 +333,17 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
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
 	kernel_setsockopt(ssocket, SOL_TCP, TCP_CORK,
 				(char *)&val, sizeof(val));
@@ -453,7 +457,8 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 			 rc);
 	else if (rc > 0)
 		rc = 0;
-
+out:
+	cifs_in_send_dec(server);
 	return rc;
 }
 
@@ -830,9 +835,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct smb_rqst *rqst,
 	 * I/O response may come back and free the mid entry on another thread.
 	 */
 	cifs_save_when_sent(mid);
-	cifs_in_send_inc(server);
 	rc = smb_send_rqst(server, 1, rqst, flags);
-	cifs_in_send_dec(server);
 
 	if (rc < 0) {
 		revert_current_mid(server, mid->credits);
@@ -1095,9 +1098,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 		else
 			midQ[i]->callback = cifs_compound_last_callback;
 	}
-	cifs_in_send_inc(server);
 	rc = smb_send_rqst(server, num_rqst, rqst, flags);
-	cifs_in_send_dec(server);
 
 	for (i = 0; i < num_rqst; i++)
 		cifs_save_when_sent(midQ[i]);
@@ -1332,9 +1333,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 
 	midQ->mid_state = MID_REQUEST_SUBMITTED;
 
-	cifs_in_send_inc(server);
 	rc = smb_send(server, in_buf, len);
-	cifs_in_send_dec(server);
 	cifs_save_when_sent(midQ);
 
 	if (rc < 0)
@@ -1471,9 +1470,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 	}
 
 	midQ->mid_state = MID_REQUEST_SUBMITTED;
-	cifs_in_send_inc(server);
 	rc = smb_send(server, in_buf, len);
-	cifs_in_send_dec(server);
 	cifs_save_when_sent(midQ);
 
 	if (rc < 0)
-- 
2.39.2



