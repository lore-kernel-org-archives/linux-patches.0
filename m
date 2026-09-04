Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4D03451AB;
	Fri,  4 Sep 2026 06:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501622; cv=none; b=YdUx1M+OBY/5PmA1kG/aWGGjSBdVCrX3giNDo2GIOMTsSt4lNnEHfoCyrin74P50jzh5QY2Ou05sZIGhqG9W8lWXGJxISkVKIZg4SuBUQdgxMtJFQacWp4r/bLVK0EZSjMt2eqoTaLexn7Q2Xc1j4vfWuPAoEgg7rs+rgoE/zcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501622; c=relaxed/simple;
	bh=UIGUbawR3rwPM1uGUpURAAq2AeKulGc/yQWL2jMm1Ig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qWysph330wvV2rX2L8AMqhWm7AgBKec2Pl3U3SxgMCd7Hn3BsNv8O1WrQsKXIxr7T0fG7KTxq1B73UPguD6yekJper5WedtqTWx2N9g/3m0mpRZuhUQveaRGgmUGl4EfWwu5wlzE1y/sOHV1DT0yfoh5Vk48g8iENftW/ZSGAqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N7uRcU+g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N7uRcU+g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 017431F00A3D;
	Fri,  4 Sep 2026 06:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501621;
	bh=IoSea6wAEfm/Tes7yXSlFtSqD4Y3Z1P4MklLd0DQ2Cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N7uRcU+g5erY94pFyuv4GLpurj3KmVcMjBGGq9eTtzGVf7JHJlxY57x8w3VRwEVDn
	 2/ICzfUQAolARJvjvBbZxZrsJxvuZCz1nja6nsUuIJ+NLrAQRDy1B2H0moWnmMRpeD
	 oI59v40YVvsljfyevKOQ44zuxfp2N2aHvdRm6FHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Tony Lu <tonylu@linux.alibaba.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 473/552] net/smc: do not dereference an unset send buffer on the SMC-D teardown path
Date: Fri,  4 Sep 2026 07:00:30 +0200
Message-ID: <20260904045801.412172760@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3237,7 +3237,8 @@ int smc_ioctl(struct socket *sock, unsig
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


