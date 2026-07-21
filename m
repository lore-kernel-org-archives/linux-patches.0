Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E9630D3FF;
	Tue, 21 Jul 2026 20:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667373; cv=none; b=ZbbE1m7k0YfDlk4ZmpwKyABxls+jM63GqqrThtXxBl78V+yl8NNecuocsM1AnQHGD0h/gXeolH1Gcoa66cihTETkadnOgfsFNAF0OAc7eEScMlmaO+7BwbiDWObVuCcTLEDC1Kes25BXkpM/fYcuwho00t+cbciVKO9HViO/WH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667373; c=relaxed/simple;
	bh=QHm/DOmpo8PSH4zMH/4L4D4ONrjojWRx9NL8T6XSUCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ev+qft3+ELS5rO9kLRxB1ljZ+jlcBJv7SWNJO5DDy07P5nQn+O5PUnwj0NJXpYHeAE3BRv/uHz5Ct50CZJeo9uYeES2301eH1agul+DoB0OLigbDcdd9Jw0Mh0EXO+TgmRa/qWxDHQmgoEezi+8XeOXEjUAm6nZA+EiapcB7hPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OXMSjKS0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OXMSjKS0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C75071F00A3A;
	Tue, 21 Jul 2026 20:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667371;
	bh=Z5kzDwZks6jjAKzFWg8PW9nJrH0439XpPljJE/8LlT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OXMSjKS0YB2qK+RVI3aVFQtOQ6gG7kfTu2Tx0SM+KFi4fL9yhvtXhJZnF2KED2idd
	 A/M0nDT5JAVX0K8Ed4XBqWEX69UvtHaE8dbtc9Dm9ZYkVpHl41jhXOITqJZNfjxP+u
	 DL/DZ/hrq/YKmRaJ+HOkNU6cZTiBGr68VHF2bDv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.6 1036/1266] can: esd_usb: kill anchored URBs before freeing netdevs
Date: Tue, 21 Jul 2026 17:24:33 +0200
Message-ID: <20260721152505.005684989@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Fan Wu <fanwu01@zju.edu.cn>

commit c43122fef328a70045fe7621c06de6b2b8e19264 upstream.

esd_usb_disconnect() frees each CAN netdev with free_candev() inside
its per-netdev loop and only calls unlink_all_urbs(dev) afterwards.
The per-netdev private data (struct esd_usb_net_priv) is embedded in
the net_device allocation returned by alloc_candev(), so once
free_candev() has run, dev->nets[i] points to freed memory.
unlink_all_urbs() then dereferences the freed dev->nets[i] to kill the
per-netdev TX anchor (usb_kill_anchored_urbs(&priv->tx_submitted)),
clear active_tx_jobs, and reset priv->tx_contexts[].

Reorder the teardown so the anchored URBs are killed before the netdevs
are freed, matching other CAN/USB drivers in the same directory such as
ems_usb, usb_8dev and mcba_usb, which unregister, then unlink, then
free: unregister the netdevs first (which stops their TX queues), call
unlink_all_urbs(dev) once, then free the netdevs.

This issue was found by an in-house static analysis tool.

Fixes: 96d8e90382dc ("can: Add driver for esd CAN-USB/2 device")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.5
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Link: https://patch.msgid.link/20260709164159.497640-1-fanwu01@zju.edu.cn
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/esd_usb.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/can/usb/esd_usb.c
+++ b/drivers/net/can/usb/esd_usb.c
@@ -1365,10 +1365,13 @@ static void esd_usb_disconnect(struct us
 			if (dev->nets[i]) {
 				netdev = dev->nets[i]->netdev;
 				unregister_netdev(netdev);
-				free_candev(netdev);
 			}
 		}
 		unlink_all_urbs(dev);
+		for (i = 0; i < dev->net_count; i++) {
+			if (dev->nets[i])
+				free_candev(dev->nets[i]->netdev);
+		}
 		kfree(dev);
 	}
 }


