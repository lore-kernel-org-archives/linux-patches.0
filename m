Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCEE7349CCF;
	Sat, 30 May 2026 16:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159137; cv=none; b=HYBYBCCb+wh6rpv6G3cKRuY/17b5cS2e3RKZ14pKBvJkwR4vLzNKIjjSZlw9p6injkfyiUhk3jlSLjhx06+18E9iY8wqCdy4FAZMIA7GVRdvYzOiU5FZ5kr/sZthXvhgtRy97ImJfiVArnRC1m9LabqH2mKbuoRBlGuvxzlyVyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159137; c=relaxed/simple;
	bh=i68g4yOTjEqvVVqmj+9P4Krh64t2p9f+am9rqziRScM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U9IQBfOscUx0ILCMscc7wR5BpTHfrF78pdLTcgj+fBhr6tEigZO0u7dMYh6gMRy29bOKSynH6TdqCgvjySMJgYU7CIbWZ2Rck8+UO4x9XLCjDy9DlrJbS/cAEHpbpnDftIBiz/ydm2BX3rkl9mVJjsFCxmK2rTo+tNpSd3TvwK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1/osELQS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1/osELQS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E92411F00893;
	Sat, 30 May 2026 16:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159133;
	bh=SjLwDYdXQJ9Qu3rS4F6mA+21RgsRJqnkIcLz5GJ968U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1/osELQSTND7BVBl9Y+MSRF+HPbcMw5+10XZ4uR5r4BJlSwj5Fv+OkinDUIxe+5rt
	 wIoWBA9Ku50PmzNv/2Ug1LDJpvo3OA29V2v5t/JZoHv1cxT+nQOeUN0talvejLC5z7
	 X8dmCsQczmsRUkTDu6UkYfqtczPZn5n/dTJrETZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Anderson Nascimento <anderson@allelesecurity.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	stable@kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 096/969] rxrpc: proc: size address buffers for %pISpc output
Date: Sat, 30 May 2026 17:53:40 +0200
Message-ID: <20260530160302.982131678@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit a44ce6aa2efb61fe44f2cfab72bb01544bbca272 ]

The AF_RXRPC procfs helpers format local and remote socket addresses into
fixed 50-byte stack buffers with "%pISpc".

That is too small for the longest current-tree IPv6-with-port form the
formatter can produce. In lib/vsprintf.c, the compressed IPv6 path uses a
dotted-quad tail not only for v4mapped addresses, but also for ISATAP
addresses via ipv6_addr_is_isatap().

As a result, a case such as

  [ffff:ffff:ffff:ffff:0:5efe:255.255.255.255]:65535

is possible with the current formatter. That is 50 visible characters, so
51 bytes including the trailing NUL, which does not fit in the existing
char[50] buffers used by net/rxrpc/proc.c.

Size the buffers from the formatter's maximum textual form and switch the
call sites to scnprintf().

Changes since v1:
- correct the changelog to cite the actual maximum current-tree case
  explicitly
- frame the proof around the ISATAP formatting path instead of the earlier
  mapped-v4 example

Fixes: 75b54cb57ca3 ("rxrpc: Add IPv6 support")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Anderson Nascimento <anderson@allelesecurity.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260408121252.2249051-22-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ adapted address accessors and variable declarations ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/proc.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/net/rxrpc/proc.c b/net/rxrpc/proc.c
index 245418943e01c..47d36554ad311 100644
--- a/net/rxrpc/proc.c
+++ b/net/rxrpc/proc.c
@@ -10,6 +10,10 @@
 #include <net/af_rxrpc.h>
 #include "ar-internal.h"
 
+#define RXRPC_PROC_ADDRBUF_SIZE \
+	(sizeof("[xxxx:xxxx:xxxx:xxxx:xxxx:xxxx:255.255.255.255]") + \
+	 sizeof(":12345"))
+
 static const char *const rxrpc_conn_states[RXRPC_CONN__NR_STATES] = {
 	[RXRPC_CONN_UNUSED]			= "Unused  ",
 	[RXRPC_CONN_CLIENT]			= "Client  ",
@@ -55,7 +59,7 @@ static int rxrpc_call_seq_show(struct seq_file *seq, void *v)
 	struct rxrpc_net *rxnet = rxrpc_net(seq_file_net(seq));
 	unsigned long timeout = 0;
 	rxrpc_seq_t tx_hard_ack, rx_hard_ack;
-	char lbuff[50], rbuff[50];
+	char lbuff[RXRPC_PROC_ADDRBUF_SIZE], rbuff[RXRPC_PROC_ADDRBUF_SIZE];
 
 	if (v == &rxnet->calls) {
 		seq_puts(seq,
@@ -72,7 +76,7 @@ static int rxrpc_call_seq_show(struct seq_file *seq, void *v)
 	if (rx) {
 		local = READ_ONCE(rx->local);
 		if (local)
-			sprintf(lbuff, "%pISpc", &local->srx.transport);
+			scnprintf(lbuff, sizeof(lbuff), "%pISpc", &local->srx.transport);
 		else
 			strcpy(lbuff, "no_local");
 	} else {
@@ -81,7 +85,7 @@ static int rxrpc_call_seq_show(struct seq_file *seq, void *v)
 
 	peer = call->peer;
 	if (peer)
-		sprintf(rbuff, "%pISpc", &peer->srx.transport);
+		scnprintf(rbuff, sizeof(rbuff), "%pISpc", &peer->srx.transport);
 	else
 		strcpy(rbuff, "no_connection");
 
@@ -152,7 +156,7 @@ static int rxrpc_connection_seq_show(struct seq_file *seq, void *v)
 {
 	struct rxrpc_connection *conn;
 	struct rxrpc_net *rxnet = rxrpc_net(seq_file_net(seq));
-	char lbuff[50], rbuff[50];
+	char lbuff[RXRPC_PROC_ADDRBUF_SIZE], rbuff[RXRPC_PROC_ADDRBUF_SIZE];
 
 	if (v == &rxnet->conn_proc_list) {
 		seq_puts(seq,
@@ -171,9 +175,9 @@ static int rxrpc_connection_seq_show(struct seq_file *seq, void *v)
 		goto print;
 	}
 
-	sprintf(lbuff, "%pISpc", &conn->params.local->srx.transport);
+	scnprintf(lbuff, sizeof(lbuff), "%pISpc", &conn->params.local->srx.transport);
 
-	sprintf(rbuff, "%pISpc", &conn->params.peer->srx.transport);
+	scnprintf(rbuff, sizeof(rbuff), "%pISpc", &conn->params.peer->srx.transport);
 print:
 	seq_printf(seq,
 		   "UDP   %-47.47s %-47.47s %4x %08x %s %3u"
@@ -210,7 +214,7 @@ static int rxrpc_peer_seq_show(struct seq_file *seq, void *v)
 {
 	struct rxrpc_peer *peer;
 	time64_t now;
-	char lbuff[50], rbuff[50];
+	char lbuff[RXRPC_PROC_ADDRBUF_SIZE], rbuff[RXRPC_PROC_ADDRBUF_SIZE];
 
 	if (v == SEQ_START_TOKEN) {
 		seq_puts(seq,
@@ -223,9 +227,9 @@ static int rxrpc_peer_seq_show(struct seq_file *seq, void *v)
 
 	peer = list_entry(v, struct rxrpc_peer, hash_link);
 
-	sprintf(lbuff, "%pISpc", &peer->local->srx.transport);
+	scnprintf(lbuff, sizeof(lbuff), "%pISpc", &peer->local->srx.transport);
 
-	sprintf(rbuff, "%pISpc", &peer->srx.transport);
+	scnprintf(rbuff, sizeof(rbuff), "%pISpc", &peer->srx.transport);
 
 	now = ktime_get_seconds();
 	seq_printf(seq,
@@ -335,7 +339,7 @@ const struct seq_operations rxrpc_peer_seq_ops = {
 static int rxrpc_local_seq_show(struct seq_file *seq, void *v)
 {
 	struct rxrpc_local *local;
-	char lbuff[50];
+	char lbuff[RXRPC_PROC_ADDRBUF_SIZE];
 
 	if (v == SEQ_START_TOKEN) {
 		seq_puts(seq,
@@ -346,7 +350,7 @@ static int rxrpc_local_seq_show(struct seq_file *seq, void *v)
 
 	local = hlist_entry(v, struct rxrpc_local, link);
 
-	sprintf(lbuff, "%pISpc", &local->srx.transport);
+	scnprintf(lbuff, sizeof(lbuff), "%pISpc", &local->srx.transport);
 
 	seq_printf(seq,
 		   "UDP   %-47.47s %3u %3u\n",
-- 
2.53.0



