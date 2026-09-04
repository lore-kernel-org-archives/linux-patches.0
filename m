Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F97414A2A;
	Fri,  4 Sep 2026 05:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500019; cv=none; b=LSSQSbHoH/6Rj3HS1BvDgowbohohqRa9NXr0Vy6bD+bZS+6fETFXRMmUEBulr5zLdnu+U7C/pAjRc93gcioHbfCmSlzD3xkR6pzIhqtYnsZ9fM/ZcqwUkrVWTj/sUPGU4mlrmXuMCaYb2OcSneJ3T2RRHrwB2AL2zFhmwj8CxF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500019; c=relaxed/simple;
	bh=1UWYmDPsXK9kApktXkDur7btPI1ELgSM+OJ2a9HHNWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQZYEXqOOdfw2ecy0Zt+7N7265uxFt/iYPa3bzFWecAUtCJ/sr5c7SDtNjbnn+FlJCDkO0fmQHh0YntfucEY+HhVbkCmXCBAHkx9C0rdLHGU6HQHy2VjeO8d/xJMpueRfmN0R8c/JpGvUXEW/qe2zSkX59jr1esjNfUQIr46aWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z4fvvpEy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z4fvvpEy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 166DB1F00ACA;
	Fri,  4 Sep 2026 05:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500018;
	bh=dLMvquAHbe8kHWj5DjuWAz9GNqngkuQ/7plDzODeLGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z4fvvpEyhAUfy4K/dq2G8BsMaQB/ipfDjWNeplv/elpzd+sCwSvgDg36ind/6YTwQ
	 yG1csR7rwDS6h5u9MmSfC+qwmZ/u7XIxs+pA4hlWCr2xz6B8O1Gh01lMR8iXeciClC
	 840839vvkJBZjZUi4HhzpYjV7CSGFcUOx4NhNAb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Tony Lu <tonylu@linux.alibaba.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 621/713] net/smc: do not dereference an unset send buffer on the SMC-D teardown path
Date: Fri,  4 Sep 2026 06:59:49 +0200
Message-ID: <20260904045817.746180463@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3233,7 +3233,8 @@ int smc_ioctl(struct socket *sock, unsig
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


