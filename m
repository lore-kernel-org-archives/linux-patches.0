Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3467413D69;
	Tue, 21 Jul 2026 21:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670186; cv=none; b=OrkoUcWjZAJtSED2UcqKCzdVR7a+2B05vmlbmMA2LMMBz2d8r4WWbL3S2UdIRDSQrV0Tj1aaaxqH47fkXBZ28WCqac8tarZUKHIWT0eUmopw42P7zEFC27j2CJBAseZQROYnfLDLKzMbtY3IiQGH7vZudJEJjavm0S1SXMnWFsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670186; c=relaxed/simple;
	bh=vrTXL67bZcH0oQ40EwGHXoDAUWtMrd3N6YiPB/ztv88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=igPC8T+FHenoviForHAeO80SMey+UXi6+qKRiD22DPPCJRtRC7hJBP8KbJc6SmxhlYYxjPWW1dNowxASDIehsbXBPr1iA5x24/Z9UTK1ETrq+ShdZ8EIiEnPfZ9I7pU2+t4DIp/L2Tc+RQRzS0SaWSZiE6Y1IMLUGuGZ1QVUwMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dV/+/tC2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dV/+/tC2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F5BF1F00A3F;
	Tue, 21 Jul 2026 21:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670184;
	bh=g0VrX/rEvStSW4A2f5DSEvdwf8Vy4cZTfeqmcHpSduE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dV/+/tC27QNZIOz2XIMjO0401DOoF60PaFhy8p2jhiZPzwO53hFMy7/rnFUghLxrR
	 5bYoabPaPhpdR4VvjWAHhVT9pmqsM5XgIdBq4xl8Re7jM8MJneUDfvs+t9mKrQXy7R
	 ShJhAyXsebTnAeiyxnmpaAj1ktDZYu921hv8pEao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.1 0835/1067] can: esd_usb: kill anchored URBs before freeing netdevs
Date: Tue, 21 Jul 2026 17:23:56 +0200
Message-ID: <20260721152443.228890173@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
@@ -1149,10 +1149,13 @@ static void esd_usb_disconnect(struct us
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


