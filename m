Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13841217704;
	Sat, 30 May 2026 18:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165504; cv=none; b=VTb6V7eqALdrWJPxLQo+MfYlEb+LyZci5/QpZhyQu9ymvrgADk8hJMCgSqxNme2Q4aJuyVBwZGNLFuNLGtMKORopM9SNy2kvwSnHBPS0HTA5PMk5oC0/bGOVyRZ54aPGgF4QINbGNn+ckANQ1g7hyUmX25zXoetouKfH9akSfJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165504; c=relaxed/simple;
	bh=ff8+4n1TirikL69mbHo3/Su17Z7xWtNOIsqOJN+jDSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0JtXorWxJSlN1BcZvY22z3yBRRP5Zdj6LFuFIfLq/l0O71weExTZKe8VijZT1tcZqj1mXwN5jahORWoI7BxKnmJeWeiINXbmZVoJTB5VpOuLYJy9AxXW5uBSuQEzePkVJ/DLxwIISPg2SBdig9X0qQ8o3fsrT/UlIJ3UJYQqhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wprved0O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wprved0O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59E281F00893;
	Sat, 30 May 2026 18:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165503;
	bh=DMrsU6fom/RAGFJPwiyiStKRC4HFbd1yqWQTZyL3vK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wprved0Od8SN2/4NtZIWZnoraBtzmUrxXou0lKr0QbjipC7DP2hsXngtJbyXNCK4t
	 VpDFQL4WM4+0qOD+Vd1syrxX1CFpBrSA5aGuz07Aaa2L+FLZW3I0AcdXEiY0I12xj6
	 yeuIp7zvILXAWpAU/Nq0DxwdNnlnAxul9C6o6nLQ=
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
Subject: [PATCH 5.10 068/589] rxrpc: proc: size address buffers for %pISpc output
Date: Sat, 30 May 2026 17:59:09 +0200
Message-ID: <20260530160226.389074087@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8967201fd8e54..67553dfe6a3e4 100644
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
@@ -61,7 +65,7 @@ static int rxrpc_call_seq_show(struct seq_file *seq, void *v)
 	struct rxrpc_net *rxnet = rxrpc_net(seq_file_net(seq));
 	unsigned long timeout = 0;
 	rxrpc_seq_t tx_hard_ack, rx_hard_ack;
-	char lbuff[50], rbuff[50];
+	char lbuff[RXRPC_PROC_ADDRBUF_SIZE], rbuff[RXRPC_PROC_ADDRBUF_SIZE];
 
 	if (v == &rxnet->calls) {
 		seq_puts(seq,
@@ -78,7 +82,7 @@ static int rxrpc_call_seq_show(struct seq_file *seq, void *v)
 	if (rx) {
 		local = READ_ONCE(rx->local);
 		if (local)
-			sprintf(lbuff, "%pISpc", &local->srx.transport);
+			scnprintf(lbuff, sizeof(lbuff), "%pISpc", &local->srx.transport);
 		else
 			strcpy(lbuff, "no_local");
 	} else {
@@ -87,7 +91,7 @@ static int rxrpc_call_seq_show(struct seq_file *seq, void *v)
 
 	peer = call->peer;
 	if (peer)
-		sprintf(rbuff, "%pISpc", &peer->srx.transport);
+		scnprintf(rbuff, sizeof(rbuff), "%pISpc", &peer->srx.transport);
 	else
 		strcpy(rbuff, "no_connection");
 
@@ -158,7 +162,7 @@ static int rxrpc_connection_seq_show(struct seq_file *seq, void *v)
 {
 	struct rxrpc_connection *conn;
 	struct rxrpc_net *rxnet = rxrpc_net(seq_file_net(seq));
-	char lbuff[50], rbuff[50];
+	char lbuff[RXRPC_PROC_ADDRBUF_SIZE], rbuff[RXRPC_PROC_ADDRBUF_SIZE];
 
 	if (v == &rxnet->conn_proc_list) {
 		seq_puts(seq,
@@ -177,9 +181,9 @@ static int rxrpc_connection_seq_show(struct seq_file *seq, void *v)
 		goto print;
 	}
 
-	sprintf(lbuff, "%pISpc", &conn->params.local->srx.transport);
+	scnprintf(lbuff, sizeof(lbuff), "%pISpc", &conn->params.local->srx.transport);
 
-	sprintf(rbuff, "%pISpc", &conn->params.peer->srx.transport);
+	scnprintf(rbuff, sizeof(rbuff), "%pISpc", &conn->params.peer->srx.transport);
 print:
 	seq_printf(seq,
 		   "UDP   %-47.47s %-47.47s %4x %08x %s %3u"
@@ -216,7 +220,7 @@ static int rxrpc_peer_seq_show(struct seq_file *seq, void *v)
 {
 	struct rxrpc_peer *peer;
 	time64_t now;
-	char lbuff[50], rbuff[50];
+	char lbuff[RXRPC_PROC_ADDRBUF_SIZE], rbuff[RXRPC_PROC_ADDRBUF_SIZE];
 
 	if (v == SEQ_START_TOKEN) {
 		seq_puts(seq,
@@ -229,9 +233,9 @@ static int rxrpc_peer_seq_show(struct seq_file *seq, void *v)
 
 	peer = list_entry(v, struct rxrpc_peer, hash_link);
 
-	sprintf(lbuff, "%pISpc", &peer->local->srx.transport);
+	scnprintf(lbuff, sizeof(lbuff), "%pISpc", &peer->local->srx.transport);
 
-	sprintf(rbuff, "%pISpc", &peer->srx.transport);
+	scnprintf(rbuff, sizeof(rbuff), "%pISpc", &peer->srx.transport);
 
 	now = ktime_get_seconds();
 	seq_printf(seq,
@@ -341,7 +345,7 @@ const struct seq_operations rxrpc_peer_seq_ops = {
 static int rxrpc_local_seq_show(struct seq_file *seq, void *v)
 {
 	struct rxrpc_local *local;
-	char lbuff[50];
+	char lbuff[RXRPC_PROC_ADDRBUF_SIZE];
 
 	if (v == SEQ_START_TOKEN) {
 		seq_puts(seq,
@@ -352,7 +356,7 @@ static int rxrpc_local_seq_show(struct seq_file *seq, void *v)
 
 	local = hlist_entry(v, struct rxrpc_local, link);
 
-	sprintf(lbuff, "%pISpc", &local->srx.transport);
+	scnprintf(lbuff, sizeof(lbuff), "%pISpc", &local->srx.transport);
 
 	seq_printf(seq,
 		   "UDP   %-47.47s %3u %3u\n",
-- 
2.53.0



