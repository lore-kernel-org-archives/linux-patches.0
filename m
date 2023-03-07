Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DED7BA3E
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:47:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789A0C433EF;
	Tue,  7 Mar 2023 17:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211253;
	bh=6wfUmhMQi0bPNGKlkYOoBMKNLdkhwd4E6o2MLs0kT/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PVgp4AJnh1yDM9TRGvBVff8bEk5UzYx6nu//eqmtvMXKkIeN5Z5KUZbLupQN3uDx9
	 gNsE21YixEiO89UInxNcSVYEpBsGJgsXBU7TFeHwPfRbAYG4F7T/HzNg7j+7zrXIbU
	 4654XtNylUcuR6xDSLadpIIt3OI1ZQxh368rJDEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>
Subject: [PATCH 6.2 0803/1001] fs: dlm: send FIN ack back in right cases
Date: Tue,  7 Mar 2023 17:59:35 +0100
Message-Id: <20230307170056.566303848@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Aring <aahringo@redhat.com>

commit 00908b3388255fc1d3782b744d07f327712f401f upstream.

This patch moves to send a ack back for receiving a FIN message only
when we are in valid states. In other cases and there might be a sender
waiting for a ack we just let it timeout at the senders time and
hopefully all other cleanups will remove the FIN message on their
sending queue. As an example we should never send out an ACK being in
LAST_ACK state or we cannot assume a working socket communication when
we are in CLOSED state.

Cc: stable@vger.kernel.org
Fixes: 489d8e559c65 ("fs: dlm: add reliable connection if reconnect")
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/dlm/midcomms.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/fs/dlm/midcomms.c
+++ b/fs/dlm/midcomms.c
@@ -375,7 +375,7 @@ static int dlm_send_ack(int nodeid, uint
 	struct dlm_msg *msg;
 	char *ppc;
 
-	msg = dlm_lowcomms_new_msg(nodeid, mb_len, GFP_NOFS, &ppc,
+	msg = dlm_lowcomms_new_msg(nodeid, mb_len, GFP_ATOMIC, &ppc,
 				   NULL, NULL);
 	if (!msg)
 		return -ENOMEM;
@@ -498,15 +498,14 @@ static void dlm_midcomms_receive_buffer(
 
 		switch (p->header.h_cmd) {
 		case DLM_FIN:
-			/* send ack before fin */
-			dlm_send_ack(node->nodeid, node->seq_next);
-
 			spin_lock(&node->state_lock);
 			pr_debug("receive fin msg from node %d with state %s\n",
 				 node->nodeid, dlm_state_str(node->state));
 
 			switch (node->state) {
 			case DLM_ESTABLISHED:
+				dlm_send_ack(node->nodeid, node->seq_next);
+
 				node->state = DLM_CLOSE_WAIT;
 				pr_debug("switch node %d to state %s\n",
 					 node->nodeid, dlm_state_str(node->state));
@@ -523,12 +522,14 @@ static void dlm_midcomms_receive_buffer(
 				}
 				break;
 			case DLM_FIN_WAIT1:
+				dlm_send_ack(node->nodeid, node->seq_next);
 				node->state = DLM_CLOSING;
 				set_bit(DLM_NODE_FLAG_STOP_RX, &node->flags);
 				pr_debug("switch node %d to state %s\n",
 					 node->nodeid, dlm_state_str(node->state));
 				break;
 			case DLM_FIN_WAIT2:
+				dlm_send_ack(node->nodeid, node->seq_next);
 				midcomms_node_reset(node);
 				pr_debug("switch node %d to state %s\n",
 					 node->nodeid, dlm_state_str(node->state));


