Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C3A281369;
	Fri,  7 Aug 2026 15:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115516; cv=none; b=ZcnQlk+ZVAm+1MtEnxZRcP5RjrtL8vvE/9CvbYxdgDahbwHvU9EMzZ4gKFiNpffLzVnVmhmV7dKX+aITLCRaFRng0iMeb/senEkZTtBgWcxAT6wzCS/8/2RxUuZclvjL9STko8AvmNdVlyL2+woALzTJLYat27AFd9suVwyd2F8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115516; c=relaxed/simple;
	bh=QWfZW46XErCbat+Eje3LgnG69fJTDE9XnQGEaj2EO50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VCtJhQrne46qlsm6L8TDquuawkRklZzle7UofK7QqDoOEnBKLbtfLcB3Q28sf5Ii4hb4Hk47AsNQgjfNPTCsxJCCqF/0uUwGFb8IcEtAJbN/ZnsAlCDYm59MO4mXkELViu0JGYLq4co7USS874Z0n0Ndjne5z2mVu3pS9WQrY8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NnYMS+t5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NnYMS+t5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D3C1F00A3A;
	Fri,  7 Aug 2026 15:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115511;
	bh=9YNVgt8NCBEbsl4B+DaznJGT+Nx00lxz7bbReUrdEm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NnYMS+t5LDUGH1UhsVzM1x+KQNhQcEuJsZtgdrT4I6feFOgPzlSB/xDontnuniasp
	 tPsRprotQhBSDdH56TbUCKt3htzZG2Z7gaHOkk40lSt1R9EB5hdLg6I/9AUccTCGur
	 0y9+Be2C1cHYX4lzT9Ci/owqInNwyr7C1u94JtDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.18 302/396] can: kvaser_usb_leaf: kvaser_usb_leaf_wait_cmd(): validate received command extents
Date: Fri,  7 Aug 2026 16:37:42 +0200
Message-ID: <20260807143430.785408515@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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
@@ -691,13 +691,22 @@ static int kvaser_usb_leaf_wait_cmd(cons
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
@@ -1737,7 +1746,7 @@ static void kvaser_usb_leaf_read_bulk_ca
 			continue;
 		}
 
-		if (pos + cmd->len > len) {
+		if (cmd->len < CMD_HEADER_LEN || cmd->len > len - pos) {
 			dev_err_ratelimited(&dev->intf->dev, "Format error\n");
 			break;
 		}


