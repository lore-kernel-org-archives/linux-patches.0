Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8A8345EB9;
	Sat, 12 Sep 2026 15:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227601; cv=none; b=o5f9ePPS6+scWk1W8Vb+805zs2RqdFl2JRcrxZ5r+am3xbB3ez3pd73wRCBjRHpujjV9bBb6z36oTkSfgC55THZ02OqjVEB0OlJ+LBYzT9jBKMc9adhkK39mKHYoRce70OQZFS0qoHb2NpE2Ow/hQ3nNjnPXcf3zNOVkHNzplck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227601; c=relaxed/simple;
	bh=QRsJIblZdsVhrkankK9IHohFR5lfkYjkZuwVjEGQBh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WYv2V/zJJX3+09qokCUWQpSsGGCsQF42M1AU+Azz3djI808Cz2hQAzDKW+aYzZwEPHgwhtkkfNss36ZHuaGe4sCtQyFBdb8Q1anEUEhs84DGn7Fp8Ug5U1/yUXDgiWtiOFQ23hprawEtkrqC3o00YmgOdDfEQVDUV8AtVtqoSS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aXytAlkk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aXytAlkk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7512A1F000FF;
	Sat, 12 Sep 2026 15:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227599;
	bh=yV/eFuwU8Plz4LAgc7bfcZIOPjuMpdKDsEC+Pt+N/3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aXytAlkkqD/jwoSgG31H4IF38bSNr5/JEQJEGsGK1EzNxV3Tlp56GTsUTZJqXIDjJ
	 kWH6l4u9ju4VhI6HTIo9EbDMj/YuwY3kmx4qcynDLbpYtjRLLg6Kg7rLxQ6mACE8kA
	 kuwH2jnh2qzMvZpbj77+/QPG8oSdZlrS4DOK3Y6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Breno Leitao <leitao@debian.org>,
	Hidayath Khan <hidayath@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 0214/1191] net/smc: fix socket refcount leak in smc_switch_conns()
Date: Sat, 12 Sep 2026 08:49:02 +0200
Message-ID: <20260912065553.018074024@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Hidayath Khan <hidayath@linux.ibm.com>

commit 719296c4aa8213d4ac8002e77d5956d436bc98d0 upstream.

smc_switch_conns() takes a reference on the SMC socket before dropping
lgr->conns_lock, so the connection stays alive while the CDC slot is
fetched:

        sock_hold(&smc->sk);
        read_unlock_bh(&lgr->conns_lock);
        /* pre-fetch buffer outside of send_lock, might sleep */
        rc = smc_cdc_get_free_slot(conn, to_lnk, &wr_buf, NULL, &pend);
        if (rc)
                goto err_out;

The err_out label only drops the wr_tx link reference, so this early exit
returns without the matching sock_put(). The second error exit is not
affected, because sock_put() has already run by then.

A leaked sk_refcnt means the smc_sock is never destroyed. Its send and
receive buffers stay allocated, and for a user socket the reference held
on the network namespace is never released, so the netns can no longer be
torn down.

smc_cdc_get_free_slot() fails when the target link goes down or when the
connection has been killed while the switch is in progress. Both are
reachable during the link failover this function implements, so the leak
is triggered by the same hardware events that make smc_switch_conns() run
in the first place.

Restructure so there is a single sock_put() covering both outcomes,
instead of adding a second one to the error path.

Fixes: 95f7f3e7dc6b ("net/smc: improved fix wait on already cleared link")
Cc: stable@vger.kernel.org
Reviewed-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
Reviewed-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Hidayath Khan <hidayath@linux.ibm.com>
Link: https://patch.msgid.link/20260820144729.1019399-1-hidayath@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/smc/smc_core.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1070,13 +1070,13 @@ again:
 		read_unlock_bh(&lgr->conns_lock);
 		/* pre-fetch buffer outside of send_lock, might sleep */
 		rc = smc_cdc_get_free_slot(conn, to_lnk, &wr_buf, NULL, &pend);
-		if (rc)
-			goto err_out;
-		/* avoid race with smcr_tx_sndbuf_nonempty() */
-		spin_lock_bh(&conn->send_lock);
-		smc_switch_link_and_count(conn, to_lnk);
-		rc = smc_switch_cursor(smc, pend, wr_buf);
-		spin_unlock_bh(&conn->send_lock);
+		if (!rc) {
+			/* avoid race with smcr_tx_sndbuf_nonempty() */
+			spin_lock_bh(&conn->send_lock);
+			smc_switch_link_and_count(conn, to_lnk);
+			rc = smc_switch_cursor(smc, pend, wr_buf);
+			spin_unlock_bh(&conn->send_lock);
+		}
 		sock_put(&smc->sk);
 		if (rc)
 			goto err_out;


