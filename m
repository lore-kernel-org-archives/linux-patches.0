Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D1031B10B;
	Sat, 12 Sep 2026 13:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220876; cv=none; b=ARWkUzZbi85J3zSfiEDMFtQUi+phtYFD58ylQFv21LwwXG0rcDBAFJUEH9In1XbYr1CSuj4tNQryOxWkkvJj7QQyOgy5k8jHq9UqDNBXuhXmCnq1YgEJ60D57yS2EqU+oypBBSsF8uqzHsyJQ4wpTJHl3NYhe5+PjOxaH6Oft3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220876; c=relaxed/simple;
	bh=9l09/o4Bk4gLaUNFOzDIEZ4hXqwo1M60HpaTSU48Xzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oq/hyP7cU3hsyaX/ZB+XTIyQF1bpfR8GKAi4N+UnWpKacWwkhXjXFvnzUTvnnR3gZfsB9jES2iWlPN8HCUTNPBBtog1RgAfoxbdTJvNVFJZYtlBr7lGYWPS/66YomHe5ycC7297TXcYXXsju4TmQrI2mZU8/zv5zk+ng+z61sZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pSDn5nWu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pSDn5nWu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0420D1F000FF;
	Sat, 12 Sep 2026 13:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220874;
	bh=68Ur7pETS3ollToVWH30vUjpIZK1ecq8OJ7os71z34Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pSDn5nWudDhZn5vPWoP5ccTVYM3Oik9798F3PRB4Sw9cctor1cPCvGRxwspCMQAjS
	 LZxmQNJhPfpz9a2lvCxIkDS+uMWEsCYdq/mhDJcFjAICqLd37TAZDtvA7xZKuz8I5C
	 TkAnr9NUNnOpFA+UsIkeBxUb2KkYl3lnw34iJDes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Tony Lu <tonylu@linux.alibaba.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 0268/1424] net/smc: do not dereference an unset send buffer on the SMC-D teardown path
Date: Sat, 12 Sep 2026 08:45:00 +0200
Message-ID: <20260912065613.276599272@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Bryam Vargas <hexlabsecurity@proton.me>

commit b395dd319cea422239cb45b998fb38d7e373af87 upstream.

smc_close_stream_wait() calls smc_tx_prepared_sends() from inside its
sk_wait_event() condition, and sk_wait_event() evaluates that condition
once with the socket lock released. smcd_buf_detach() clears
conn->sndbuf_desc from smc_conn_kill() under lock_sock(), so a link group
terminating while a socket waits there leaves the helper dereferencing
NULL, faulting out of close(). SIOCOUTQ reads the field by hand, and
smc_close_cancel_work() drops the lock across two cancel_*_sync() calls.

Sample the pointer once in the helper, report nothing prepared while it is
unset, and bound the ioctl the same way. The receive tasklet dereferences
the field directly in smc_cdc_msg_recv_action(), not through this helper;
1/2 is what keeps it from running that late.

Fixes: ae2be35cbed2 ("net/smc: {at|de}tach sndbuf to peer DMB if supported")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Sidraya Jayagond <sidraya@linux.ibm.com>
Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>
Link: https://patch.msgid.link/20260808-b4-disp-22f119e6-v2-2-61647601a6f3@proton.me
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/smc/af_smc.c |    3 ++-
 net/smc/smc_tx.h |    6 +++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -3224,7 +3224,8 @@ static int smc_ioctl(struct socket *sock
 			return -EINVAL;
 		}
 		if (smc->sk.sk_state == SMC_INIT ||
-		    smc->sk.sk_state == SMC_CLOSED)
+		    smc->sk.sk_state == SMC_CLOSED ||
+		    !READ_ONCE(smc->conn.sndbuf_desc))
 			answ = 0;
 		else
 			answ = smc->conn.sndbuf_desc->len -
--- a/net/smc/smc_tx.h
+++ b/net/smc/smc_tx.h
@@ -20,11 +20,15 @@
 
 static inline int smc_tx_prepared_sends(struct smc_connection *conn)
 {
+	struct smc_buf_desc *sndbuf_desc = READ_ONCE(conn->sndbuf_desc);
 	union smc_host_cursor sent, prep;
 
+	if (!sndbuf_desc)
+		return 0;
+
 	smc_curs_copy(&sent, &conn->tx_curs_sent, conn);
 	smc_curs_copy(&prep, &conn->tx_curs_prep, conn);
-	return smc_curs_diff(conn->sndbuf_desc->len, &sent, &prep);
+	return smc_curs_diff(sndbuf_desc->len, &sent, &prep);
 }
 
 void smc_tx_pending(struct smc_connection *conn);


