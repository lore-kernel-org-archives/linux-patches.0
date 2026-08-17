Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B645D3EAC68;
	Mon, 17 Aug 2026 14:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976202; cv=none; b=K5ldnX3+wJndFZC3MyaiW4mYzAzyX6aVCSDtCU35LZtlIagWTneXZVQeico5fZ/MKK79rpCtURrQgQwZIqZOepNeqVCuZ9bKnF2aeGsuEERrV78M+DlR7z93RDo+ABumyZtBCL8MghQBadw27zcW3VPRuW3JVdxyZFajLQA0+hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976202; c=relaxed/simple;
	bh=bBIoVp1t2YVKrE9xgKtfRnb0wtkpzIu6CSKca6PlTgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rrxeFkdzDqZ0z161m2M//xxnd36WcpyNAuWhUS+XUj2RCtIMKd5WnzXxxaP4F241eTc4aivzaIDhlIlaTtholMWx339Vrwv4afSb6koz8+Y7v7Xgf1kecMtpkSTWD+ybgy4ChaGjcaK4YB9w0vPQUgPVifCKSHLZTvF/a6nW8CY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LxanUPgK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LxanUPgK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A5C11F000E9;
	Mon, 17 Aug 2026 14:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976201;
	bh=OuT9DeyJCN4ms5/0AazHCx3Ylc77IWRk9W+9ohv7uHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LxanUPgKUyloIzeS07zhk+CrPMPjHlRY0077rIlg+NL2U704Q2Xk6ZbAmGrKyN8ry
	 u6e/11ZqQWvPiTRrF/u5iQQTBtBy2WB3VQlZNQ2H0I9l9/jgu53bOdSKJLLTKVTqfB
	 KZjbgHi0Pc3sWwRTLMktiCKVX5Rowe5go4RHKJ9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.10 293/389] can: kvaser_usb_leaf: kvaser_usb_leaf_wait_cmd(): validate received command extents
Date: Mon, 17 Aug 2026 15:32:12 +0200
Message-ID: <20260817132550.506646345@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -615,13 +615,22 @@ static int kvaser_usb_leaf_wait_cmd(cons
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
@@ -1576,7 +1585,7 @@ static void kvaser_usb_leaf_read_bulk_ca
 			continue;
 		}
 
-		if (pos + cmd->len > len) {
+		if (cmd->len < CMD_HEADER_LEN || cmd->len > len - pos) {
 			dev_err_ratelimited(&dev->intf->dev, "Format error\n");
 			break;
 		}


