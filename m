Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2A6344DB5;
	Thu, 12 Mar 2026 20:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346839; cv=none; b=Eg5tdU6ZklXniHVNJ9K2M3ZlMwLnv0Enq9epW5S69z+SgJQ5OeN07La3PNj8EOM7r4p+2m/C+hbanI5wt+8MOF5YM7BQG7zyKfY+vQLS0w1MCM3a7t66A3QB1ML4tuC4UXRsuwDOHp6GnD+RIEfyoFvWQj6lRP9plenTTodkW4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346839; c=relaxed/simple;
	bh=nmAzuYp3o6/78Ezvzv7nmfOqDQzfzxEvolLf3f8Of1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F2Z8sp/1fX/SyRgTZYQHcW/d7vizLu+iNPPKPunU+B3xUQUjkG4OooT1YEisfhuthOeVo3M7uwpL5comnEiwjvvVZaiCDTM94uMrUyPwUg9n+m0zHREzOIRVdbNjEPW2QUThDWUDZ0iNAXz/fLnYPMTK7//Ga4ZKa+rYxeEQThk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cpu1oUsS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cpu1oUsS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0D3C4CEF7;
	Thu, 12 Mar 2026 20:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346839;
	bh=nmAzuYp3o6/78Ezvzv7nmfOqDQzfzxEvolLf3f8Of1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cpu1oUsST0hnkJ3i4YPi88EY/SRYf/saxMBGbE9XYacWCshxL+TcLttNBbjKnk8vb
	 YjcoJh/upngEXls7Z9WvYhphb9Civjp7pLlPoA9zMiStSB6PZHgK3Lh4CzJWWdE8oy
	 xaLmp+EeeZJohn4q7+Uj/uPDxro2GCAFTI614uxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ji-Ze Hong (Peter Hong)" <peter_hong@fintek.com.tw>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Vincent Mailhol <mailhol@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.12 138/265] can: usb: f81604: handle bulk write errors properly
Date: Thu, 12 Mar 2026 21:08:45 +0100
Message-ID: <20260312201023.241568723@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

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
 drivers/net/can/usb/f81604.c |   24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

--- a/drivers/net/can/usb/f81604.c
+++ b/drivers/net/can/usb/f81604.c
@@ -891,9 +891,27 @@ static void f81604_write_bulk_callback(s
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


