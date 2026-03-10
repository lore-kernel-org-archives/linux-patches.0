Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED90A387590;
	Tue, 10 Mar 2026 11:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142016; cv=none; b=AwOulvlCiRDZzDb8p/cDQmZyBGlvgsU8zDJ4BAkrMzlVZorTmbac+pH3fzCRyi325p80RqBB9RNXotyynllgZ1VhPihlm1AwJR0na5IoSyDE8KygFsWPkUXrYSmmzSz5bNwx6MjNH9Q1lBRgGXMCykz3IHoMUrMyxoyTFq2QJpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142016; c=relaxed/simple;
	bh=LLNu+C9q5U3rSMnp/w/CXOerczZW47xusNqKJc47IPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aVF3Kks5tA/hpJ2vlnEsMuSH9Auku24xY06fhSTjsbp+T6e1m1yyH0TUTY/fXx8e8JZuU2SminvaqFa7FPDl6RFmoGVfBANhub9jK07zpyZ4WXN6eyP2Ka+0Ss4dfhRIk2Pl1xiKtaH8TjriNmiESENNoc4hTXee490na6O1IWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P4I12RRG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P4I12RRG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16788C2BC9E;
	Tue, 10 Mar 2026 11:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142015;
	bh=LLNu+C9q5U3rSMnp/w/CXOerczZW47xusNqKJc47IPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P4I12RRGYfrsaAz6PgEAEY+Qt6ZpJkXxbSQUDAdancuxJy+I4i4YwOgLyIrf+/EXk
	 IFTLh3/nDcrHakQOnczccvsp8OST4Ictnu2ZoxBtRL30bf1/gtNtGrSR2FZ/xgV6GE
	 JSQ+bRIv6aHvsZ8ieJobnQ4C95ipRce4rvIHe/vFQH8e8XXOu2vJDKM3wXTmblsNIS
	 LpHxiYw2ChuSYnt2ORqaeKMViR5CNoZ+GvTAaW/PsPe/aURkoi8EV8yXlLTW1HNzhK
	 Pw0g1XVPGK8z/aO0klTeLUQOhD9mmWGjJ4jyBqKP26bEOICAiolX7xCjj6nF/9dzTE
	 nIVozzLe+BkCA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Ji-Ze Hong (Peter Hong)" <peter_hong@fintek.com.tw>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Vincent Mailhol <mailhol@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.18 142/314] can: usb: f81604: handle bulk write errors properly
Date: Tue, 10 Mar 2026 07:16:41 -0400
Message-ID: <6d0b77ca3a6c77ac9071bed161797288359ec933.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 51f94780720fa90c424f67e3e9784cb8ef8190e5 upstream.

If a write urb fails then more needs to be done other than just logging
the message, otherwise the transmission could be stalled.  Properly
increment the error counters and wake up the queues so that data will
continue to flow.

Cc: Ji-Ze Hong (Peter Hong) <peter_hong@fintek.com.tw>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Vincent Mailhol <mailhol@kernel.org>
Cc: stable@kernel.org
Assisted-by: gkh_clanker_2000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/2026022334-slackness-dynamic-9195@gregkh
Fixes: 88da17436973 ("can: usb: f81604: add Fintek F81604 support")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/f81604.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/usb/f81604.c b/drivers/net/can/usb/f81604.c
index e87e2674ac585..6b8b2795c0188 100644
--- a/drivers/net/can/usb/f81604.c
+++ b/drivers/net/can/usb/f81604.c
@@ -891,9 +891,27 @@ static void f81604_write_bulk_callback(struct urb *urb)
 	if (!netif_device_present(netdev))
 		return;
 
-	if (urb->status)
-		netdev_info(netdev, "%s: Tx URB error: %pe\n", __func__,
-			    ERR_PTR(urb->status));
+	if (!urb->status)
+		return;
+
+	switch (urb->status) {
+	case -ENOENT:
+	case -ECONNRESET:
+	case -ESHUTDOWN:
+		return;
+	default:
+		break;
+	}
+
+	if (net_ratelimit())
+		netdev_err(netdev, "%s: Tx URB error: %pe\n", __func__,
+			   ERR_PTR(urb->status));
+
+	can_free_echo_skb(netdev, 0, NULL);
+	netdev->stats.tx_dropped++;
+	netdev->stats.tx_errors++;
+
+	netif_wake_queue(netdev);
 }
 
 static void f81604_clear_reg_work(struct work_struct *work)
-- 
2.51.0

