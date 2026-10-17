Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E003A1E92;
	Sat, 17 Oct 2026 17:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258588; cv=none; b=vFmWkXHREVcmpOZS+Ae1T+N6/6EXhdCgTblEdoICfabCEJ2sVaXULNQHZ0J2YoUIaV1EGDCUeth2iKCZKNLBlHR3AHzWWmN5pwLk4jFFR/+KRfoMw2+p6qHtyLOqBePEu3sI+E8snugT/6nqY2KxjCY2VrFDyX2Ot3/pgE2beVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258588; c=relaxed/simple;
	bh=lNaMpqjPhM9iangWLPeshPupTUrhdxSoW2EsbvxvaKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iA7zFkjX/+rK1UwB8nGiGTQcrWi253J1ukW+EEp4rdggoyQscvCYlCSKykLIwlExh1tYemHJXmtY4G73BozIavF38Mxq01L35XEWpjCA416qHmRn1hovGG4wwyCvp4Fk7Q0PANT0aToRenRml4Nn7pdoYw1DitzmAS2fuPUZdU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fDvbaPeA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fDvbaPeA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B27311F000C4;
	Sat, 17 Oct 2026 17:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258587;
	bh=KC1B7JeSMqyaSqYRKBJ6PU4NJMGFFDcHLhU5+xIp32I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fDvbaPeARmgXmd79+eQu9Y0+QsaeP3Q1f57KikeDbGqfeCI4f0m1+0sK0P5LMhO8S
	 FPzP3DwO18eH6GG26lGkgA8Cr+BRDpI0F0/XutxarjxFzKcxku3C6sDPlFbbZR4rD8
	 VbyUibn/E3TSbjPhnG330ypYkm2/G/FTl2Nd+N2c=
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
Subject: [PATCH 6.6 0883/1674] rxrpc: proc: size address buffers for %pISpc output
Date: Sat, 17 Oct 2026 17:52:35 +0200
Message-ID: <20261017160453.779393037@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/proc.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/net/rxrpc/proc.c b/net/rxrpc/proc.c
index 55a95f064df08..f698796976c50 100644
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
 	[RXRPC_CONN_CLIENT_UNSECURED]		= "ClUnsec ",
@@ -54,7 +58,7 @@ static int rxrpc_call_seq_show(struct seq_file *seq, void *v)
 	enum rxrpc_call_state state;
 	unsigned long timeout = 0;
 	rxrpc_seq_t acks_hard_ack;
-	char lbuff[50], rbuff[50];
+	char lbuff[RXRPC_PROC_ADDRBUF_SIZE], rbuff[RXRPC_PROC_ADDRBUF_SIZE];
 
 	if (v == &rxnet->calls) {
 		seq_puts(seq,
@@ -69,11 +73,11 @@ static int rxrpc_call_seq_show(struct seq_file *seq, void *v)
 
 	local = call->local;
 	if (local)
-		sprintf(lbuff, "%pISpc", &local->srx.transport);
+		scnprintf(lbuff, sizeof(lbuff), "%pISpc", &local->srx.transport);
 	else
 		strcpy(lbuff, "no_local");
 
-	sprintf(rbuff, "%pISpc", &call->dest_srx.transport);
+	scnprintf(rbuff, sizeof(rbuff), "%pISpc", &call->dest_srx.transport);
 
 	state = rxrpc_call_state(call);
 	if (state != RXRPC_CALL_SERVER_PREALLOC) {
@@ -144,7 +148,7 @@ static int rxrpc_connection_seq_show(struct seq_file *seq, void *v)
 	struct rxrpc_connection *conn;
 	struct rxrpc_net *rxnet = rxrpc_net(seq_file_net(seq));
 	const char *state;
-	char lbuff[50], rbuff[50];
+	char lbuff[RXRPC_PROC_ADDRBUF_SIZE], rbuff[RXRPC_PROC_ADDRBUF_SIZE];
 
 	if (v == &rxnet->conn_proc_list) {
 		seq_puts(seq,
@@ -163,8 +167,8 @@ static int rxrpc_connection_seq_show(struct seq_file *seq, void *v)
 		goto print;
 	}
 
-	sprintf(lbuff, "%pISpc", &conn->local->srx.transport);
-	sprintf(rbuff, "%pISpc", &conn->peer->srx.transport);
+	scnprintf(lbuff, sizeof(lbuff), "%pISpc", &conn->local->srx.transport);
+	scnprintf(rbuff, sizeof(rbuff), "%pISpc", &conn->peer->srx.transport);
 print:
 	state = rxrpc_is_conn_aborted(conn) ?
 		rxrpc_call_completions[conn->completion] :
@@ -205,7 +209,7 @@ static int rxrpc_peer_seq_show(struct seq_file *seq, void *v)
 {
 	struct rxrpc_peer *peer;
 	time64_t now;
-	char lbuff[50], rbuff[50];
+	char lbuff[RXRPC_PROC_ADDRBUF_SIZE], rbuff[RXRPC_PROC_ADDRBUF_SIZE];
 
 	if (v == SEQ_START_TOKEN) {
 		seq_puts(seq,
@@ -218,9 +222,9 @@ static int rxrpc_peer_seq_show(struct seq_file *seq, void *v)
 
 	peer = list_entry(v, struct rxrpc_peer, hash_link);
 
-	sprintf(lbuff, "%pISpc", &peer->local->srx.transport);
+	scnprintf(lbuff, sizeof(lbuff), "%pISpc", &peer->local->srx.transport);
 
-	sprintf(rbuff, "%pISpc", &peer->srx.transport);
+	scnprintf(rbuff, sizeof(rbuff), "%pISpc", &peer->srx.transport);
 
 	now = ktime_get_seconds();
 	seq_printf(seq,
@@ -330,7 +334,7 @@ const struct seq_operations rxrpc_peer_seq_ops = {
 static int rxrpc_local_seq_show(struct seq_file *seq, void *v)
 {
 	struct rxrpc_local *local;
-	char lbuff[50];
+	char lbuff[RXRPC_PROC_ADDRBUF_SIZE];
 
 	if (v == SEQ_START_TOKEN) {
 		seq_puts(seq,
@@ -341,7 +345,7 @@ static int rxrpc_local_seq_show(struct seq_file *seq, void *v)
 
 	local = hlist_entry(v, struct rxrpc_local, link);
 
-	sprintf(lbuff, "%pISpc", &local->srx.transport);
+	scnprintf(lbuff, sizeof(lbuff), "%pISpc", &local->srx.transport);
 
 	seq_printf(seq,
 		   "UDP   %-47.47s %3u %3u %3u\n",
-- 
2.53.0



