Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C28230BC2;
	Mon, 23 Jun 2025 13:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685960; cv=none; b=eoEuNX5B2GKdf/jGIoX9EHVS9AJRfZXBbv3teQlyfgU33MWFicO4coJzPqZQ4CuK84HvD5IoBpopOhh21AUUSLMhCiIKecZZ0AqGf7gcsrVvutYzn8emOTRudE9EpIDwSKZDfpyBEV2C+cmaX/Fg+cciGyKnbsxiuSCoc4toIDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685960; c=relaxed/simple;
	bh=Sc/WW4NEt4M+Xfn41zsQiChQNc56AVK/CqpOHny5QwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rhCu7lQYWnFwlK07dy2us/Iiun7FnJ/gr4pnFRWvdbpMyM1cGlrSWyD8Li/9p0LGbJ797tOZUWhnZzdKZ6CpuW+VIqjK3+M49Cy66akuA7iiGrrwUJ09Y/rHAoG9TOINn0bw86tv6mDcpMkOvIELSuprySi7r0X9e00VAFPssys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xkBSdIQC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xkBSdIQC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44215C4CEEA;
	Mon, 23 Jun 2025 13:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685958;
	bh=Sc/WW4NEt4M+Xfn41zsQiChQNc56AVK/CqpOHny5QwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xkBSdIQCNrWQ3FyLUmaIz5vVVGGOcv9kQf9Tx3hMtSL2rudJbUhei9ij/9KxmQbgP
	 +MgG0UIFb1SHPaiSSib40dOrHOzTPKOpp4aIuDk37y4MUkUNu/g8UTr8z0FlG3PNyD
	 y13zOpm0vGkXrvyv4HBExX3oNaaXz+VF2zbdWpic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	Heming zhao <heming.zhao@suse.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 265/592] dlm: use SHUT_RDWR for SCTP shutdown
Date: Mon, 23 Jun 2025 15:03:43 +0200
Message-ID: <20250623130706.617645578@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 55612ddb62fc12437a7ff2f27b51a8981bc187a4 ]

Currently SCTP shutdown() call gets stuck because there is no incoming
EOF indicator on its socket. On the peer side the EOF indicator as
recvmsg() returns 0 will be triggered as mechanism to flush the socket
queue on the receive side. In SCTP recvmsg() function sctp_recvmsg() we
can see that only if sk_shutdown has the bit RCV_SHUTDOWN set SCTP will
recvmsg() will return EOF. The RCV_SHUTDOWN bit will only be set when
shutdown with SHUT_RD is called. We use now SHUT_RDWR to also get a EOF
indicator from recvmsg() call on the shutdown() initiator.

SCTP does not support half closed sockets and the semantic of SHUT_WR is
different here, it seems that calling SHUT_WR on sctp sockets keeps the
socket open to have the possibility to do some specific SCTP operations on
it that we don't do here.

There exists still a difference in the limitations of TCP vs SCTP in
case if we are required to have a half closed socket functionality. This
was tried to archieve with DLM protocol changes in the past and
hopefully we really don't require half closed socket functionality.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Tested-by: Heming zhao <heming.zhao@suse.com>
Reviewed-by: Heming zhao <heming.zhao@suse.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lowcomms.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 70abd4da17a63..90abcd07f8898 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -160,6 +160,7 @@ struct dlm_proto_ops {
 	bool try_new_addr;
 	const char *name;
 	int proto;
+	int how;
 
 	void (*sockopts)(struct socket *sock);
 	int (*bind)(struct socket *sock);
@@ -810,7 +811,7 @@ static void shutdown_connection(struct connection *con, bool and_other)
 		return;
 	}
 
-	ret = kernel_sock_shutdown(con->sock, SHUT_WR);
+	ret = kernel_sock_shutdown(con->sock, dlm_proto_ops->how);
 	up_read(&con->sock_lock);
 	if (ret) {
 		log_print("Connection %p failed to shutdown: %d will force close",
@@ -1858,6 +1859,7 @@ static int dlm_tcp_listen_bind(struct socket *sock)
 static const struct dlm_proto_ops dlm_tcp_ops = {
 	.name = "TCP",
 	.proto = IPPROTO_TCP,
+	.how = SHUT_WR,
 	.sockopts = dlm_tcp_sockopts,
 	.bind = dlm_tcp_bind,
 	.listen_validate = dlm_tcp_listen_validate,
@@ -1896,6 +1898,7 @@ static void dlm_sctp_sockopts(struct socket *sock)
 static const struct dlm_proto_ops dlm_sctp_ops = {
 	.name = "SCTP",
 	.proto = IPPROTO_SCTP,
+	.how = SHUT_RDWR,
 	.try_new_addr = true,
 	.sockopts = dlm_sctp_sockopts,
 	.bind = dlm_sctp_bind,
-- 
2.39.5



