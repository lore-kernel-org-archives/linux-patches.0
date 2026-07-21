Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC0C471250;
	Tue, 21 Jul 2026 18:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658938; cv=none; b=GBteBOFNR6A8uUbF11HWoaW9v5Cue7LWTJPq28UX9sFkzO0tiXPowHOpjdawXD/I84UHwYeRecFs+3HiyWmu0CfiqGu1EZMczuxhz/IaeSkYFhNCubzM+RgX4EPIngPazD0guuW8j8CkMjDDC0kbH2SrV9vELLsTqgrXQPnjNfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658938; c=relaxed/simple;
	bh=E1aEgSHZRvC/FAOfhtFGfEF5bswV86mj7ixjSmdeeBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hyZyVaIbPTSKkAM4sNn4dwB6vWXuAP2/SQozchq3PK8+TCEftM+ikkqfQgIv5SijYDzx2qJ0t6z0oAkdz45Kc0G9yp+UsFe+2Z6rDU565jXIjHh0lPPdEBa1T1JlspVRIE2eaTMg869/+SldsjMahmCXGzb7uaTRZioaTqgHN9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hwUqQVs8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hwUqQVs8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E911F000E9;
	Tue, 21 Jul 2026 18:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658936;
	bh=+VHuznOCNXU71n3HYRetX2gQVzsLzIPIUETkc/YK/PA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hwUqQVs849qI+B9oiiwJLjdi6mkFNitH6WM62/GAcgcRBAGrfZ3SGSC3ouUJOm92H
	 yXazfuCfp6Z8+oul890WfmpozLDbFoXWf8nzRvs3CSW7rl/eyBZpxhcvyC6xmn2Lrn
	 bK95NOvNfo8dq0ZkNrUfLBD+T6BJa7J6l63Ib144=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.18 1331/1611] can: esd_usb: kill anchored URBs before freeing netdevs
Date: Tue, 21 Jul 2026 17:24:07 +0200
Message-ID: <20260721152545.389658859@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
@@ -1387,10 +1387,13 @@ static void esd_usb_disconnect(struct us
 				netdev = dev->nets[i]->netdev;
 				netdev_info(netdev, "unregister\n");
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


