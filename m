Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9302C3F327A;
	Fri,  7 Aug 2026 15:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116281; cv=none; b=RPTNIYhdZ2dtXXPHv2oQjcaQZFKGiSW/HPCmV/l8Bc4m4Oor2xBPJhlpTU7otwQhYF+QwSlK7ujusTcK3cTpRlsYfffmATG6IScmI3Kg87CoGdoS6ENXSv84urYQvm386krrpmZ/CvBPXay7WHSw+2yBlRaWbmM9sLfrfY9FB2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116281; c=relaxed/simple;
	bh=pXxnAWHBlWhiOAARRzyCg07awGYI6PMiOmA1T4q9mBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=flZC8oNDE/BDqJ8PnThWR6GjGwcO1Rm5Y39h85Vnemh1SU8YKjNcah9JSJyFYnbxOoI2+rjVByKcMVraxIuvn2rQMJwoIx5zW5O1YhfhnOyzg3KK9Yal6zhFEFJr7umnLgdphBO6pCOLtdkvZhnAkUUBCV3LDzPMN1390eaSk8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cH9nMsZE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cH9nMsZE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC101F00A3D;
	Fri,  7 Aug 2026 15:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116280;
	bh=PhmbHDxhtOLWRhNL/+qXwJdpEgoyjSTKFnSyoFogOAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cH9nMsZE+xAfs0MDn0XMRc6DurcI5tMUVkIdn2hQH+NM2IxfqCesKXl/iTWKaJeVc
	 ffBroPlRr3POwTLYTr9tTclUQFV5zcvwm9TwBdtKmEi1/DfuoPDApd3ANxUOQT7Jy6
	 kB4hy/k3GkyWoYeuCBF2vVGbwbAbvBPMFXBTDKTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.6 177/261] can: kvaser_usb_leaf: kvaser_usb_leaf_wait_cmd(): validate received command extents
Date: Fri,  7 Aug 2026 16:38:54 +0200
Message-ID: <20260807143419.181519046@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

commit 0293dd153f9dbc1ddf5dacdccc76b363bce4a8ee upstream.

The wait and bulk receive paths walk variable-length commands from a
USB buffer. A nonzero command shorter than CMD_HEADER_LEN can still be
dispatched, and the wait path copies a matching command into a fixed
caller-owned struct kvaser_cmd using the device-provided length.

Reject nonzero commands that do not contain the fixed header or that
extend beyond the current USB buffer item. In the wait path, also reject
a matching command that exceeds the destination before copying it.

Fixes: 080f40a6fa28 ("can: kvaser_usb: Add support for Kvaser CAN/USB devices")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260722042221.44066-1-pengpeng@iscas.ac.cn
Cc: stable@kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -617,13 +617,22 @@ static int kvaser_usb_leaf_wait_cmd(cons
 				continue;
 			}
 
-			if (pos + tmp->len > actual_len) {
+			if (tmp->len < CMD_HEADER_LEN ||
+			    tmp->len > actual_len - pos) {
 				dev_err_ratelimited(&dev->intf->dev,
 						    "Format error\n");
 				break;
 			}
 
 			if (tmp->id == id) {
+				if (tmp->len > sizeof(*cmd)) {
+					dev_err_ratelimited(&dev->intf->dev,
+							    "Received command %u too large (%u)\n",
+							    tmp->id, tmp->len);
+					err = -EIO;
+					goto end;
+				}
+
 				memcpy(cmd, tmp, tmp->len);
 				goto end;
 			}
@@ -1595,7 +1604,7 @@ static void kvaser_usb_leaf_read_bulk_ca
 			continue;
 		}
 
-		if (pos + cmd->len > len) {
+		if (cmd->len < CMD_HEADER_LEN || cmd->len > len - pos) {
 			dev_err_ratelimited(&dev->intf->dev, "Format error\n");
 			break;
 		}


