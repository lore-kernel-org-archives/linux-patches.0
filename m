Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E40938837F;
	Mon, 23 Mar 2026 14:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277781; cv=none; b=iHv5DbpL5bcA9x64hDdxPR6PYNoG/5e3DJA445Rl9lu3qbc8StVXrEMHQAy5YHN/G3/vUn2EA3OkV+Ra1NQM7g/qS9x7LCqimDCees7fuGiGly9F64idpZAjgxLR8PIFsWnBtc3aqIkRoN6UltVBYAqhMXPflmoyd8dCrTfcycM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277781; c=relaxed/simple;
	bh=60gKl/g6Q+ZkD+Atgz0w4q+4/p0Yzz8WTSYopWxTpzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EBesHisJ+8FOBTsuU67evsXhIeFRPEwjkSzi79Uy+Odb6Oktpm6iBHSrSGAlCduMw6Yk6hz3OUO/778iH50+WgFeY+gWRSWHZjnfyjTmChklJtjiazsvHbArwxeU4gdLQFGrPogA4ELFH2hJWiEq5ZEXhbAbCHbdTDKt+FFm23c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OmdaMrMf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OmdaMrMf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1941CC4CEF7;
	Mon, 23 Mar 2026 14:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277781;
	bh=60gKl/g6Q+ZkD+Atgz0w4q+4/p0Yzz8WTSYopWxTpzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OmdaMrMfWCcisQFwoMYTmoX615mjrJW4rPMhZV5ZM2Zf5ziZWIPI2/xIB5IRbN61w
	 eWCnFGwSYWWBc9+ahqbBMIgjPvUXjpe42hFXRfeFjvzj2kllQL7urKEdct4eYtCh5C
	 X2vfMzMMddkbUdetvrc49CWtEqjreeiKw+ZM/lpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ji-Ze Hong (Peter Hong)" <peter_hong@fintek.com.tw>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Vincent Mailhol <mailhol@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.6 094/567] can: usb: f81604: correctly anchor the urb in the read bulk callback
Date: Mon, 23 Mar 2026 14:40:14 +0100
Message-ID: <20260323134536.154525091@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 952caa5da10bed22be09612433964f6877ba0dde upstream.

When submitting an urb, that is using the anchor pattern, it needs to be
anchored before submitting it otherwise it could be leaked if
usb_kill_anchored_urbs() is called.  This logic is correctly done
elsewhere in the driver, except in the read bulk callback so do that
here also.

Cc: Ji-Ze Hong (Peter Hong) <peter_hong@fintek.com.tw>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Vincent Mailhol <mailhol@kernel.org>
Cc: stable@kernel.org
Assisted-by: gkh_clanker_2000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/2026022334-starlight-scaling-2cea@gregkh
Fixes: 88da17436973 ("can: usb: f81604: add Fintek F81604 support")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/f81604.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/net/can/usb/f81604.c
+++ b/drivers/net/can/usb/f81604.c
@@ -413,6 +413,7 @@ static void f81604_read_bulk_callback(st
 {
 	struct f81604_can_frame *frame = urb->transfer_buffer;
 	struct net_device *netdev = urb->context;
+	struct f81604_port_priv *priv = netdev_priv(netdev);
 	int ret;
 
 	if (!netif_device_present(netdev))
@@ -445,10 +446,15 @@ static void f81604_read_bulk_callback(st
 	f81604_process_rx_packet(netdev, frame);
 
 resubmit_urb:
+	usb_anchor_urb(urb, &priv->urbs_anchor);
 	ret = usb_submit_urb(urb, GFP_ATOMIC);
+	if (!ret)
+		return;
+	usb_unanchor_urb(urb);
+
 	if (ret == -ENODEV)
 		netif_device_detach(netdev);
-	else if (ret)
+	else
 		netdev_err(netdev,
 			   "%s: failed to resubmit read bulk urb: %pe\n",
 			   __func__, ERR_PTR(ret));
@@ -646,10 +652,15 @@ static void f81604_read_int_callback(str
 		f81604_handle_tx(priv, data);
 
 resubmit_urb:
+	usb_anchor_urb(urb, &priv->urbs_anchor);
 	ret = usb_submit_urb(urb, GFP_ATOMIC);
+	if (!ret)
+		return;
+	usb_unanchor_urb(urb);
+
 	if (ret == -ENODEV)
 		netif_device_detach(netdev);
-	else if (ret)
+	else
 		netdev_err(netdev, "%s: failed to resubmit int urb: %pe\n",
 			   __func__, ERR_PTR(ret));
 }


