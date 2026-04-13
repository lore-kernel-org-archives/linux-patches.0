Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4002FFFBE;
	Mon, 13 Apr 2026 16:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097211; cv=none; b=AXqwZBWNJA0HeRC5gMgbDQGT5maChg9+fgM3qk4W8eE8NT2u/ooCNfc1EW4NKyn6dGBp3qXRG239qe4oUK8OZFJKKHIJTxC9V9PJulfo6lwA9RcNqedd55E3gBPqxs1Ec32/NPy60zkLAIRtIODFGYdjsop+HYrEYpm+tyfpkZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097211; c=relaxed/simple;
	bh=2AS1jIs2LjcxrAXbH/b/3wfaid5rvCsPSuv+GKZ0FrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bi1+GqxrqxhGUEOPmsU90Jzc77+JfTYnhr7/V+YmqyfnBpNNHI6hSvTTgElduXWgPme8Jb3L9X6l40AMplSjWHnl+pQzAzS+Chd1Fo4KX5cFbVEbuS2lY42JkOiw5HFRHjvin/PRlUCqggM5KuOSUN2V5oeHeI35WEPXGi+9TWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xuRvwJ2O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xuRvwJ2O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4EDAC2BCAF;
	Mon, 13 Apr 2026 16:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097211;
	bh=2AS1jIs2LjcxrAXbH/b/3wfaid5rvCsPSuv+GKZ0FrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xuRvwJ2OMMr79seuUZPLtSmC2jHGmV17AZlsVp43idkS/UZjlNHKjvG8CQhvQUG8n
	 HCvqcbDXEBi7BHpMXo6wAxyI+upCNuyZj80IX/+W/ecWsKkzJBJUIgtpBAF+T05zpM
	 zv9x4chEOaL3J5SSyUbYjVU4uaQd9kOmkMEJ4DeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol@kernel.org>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	stable@kernel.org
Subject: [PATCH 5.15 047/570] can: ems_usb: ems_usb_read_bulk_callback(): check the proper length of a message
Date: Mon, 13 Apr 2026 17:52:58 +0200
Message-ID: <20260413155832.200402804@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 38a01c9700b0dcafe97dfa9dc7531bf4a245deff upstream.

When looking at the data in a USB urb, the actual_length is the size of
the buffer passed to the driver, not the transfer_buffer_length which is
set by the driver as the max size of the buffer.

When parsing the messages in ems_usb_read_bulk_callback() properly check
the size both at the beginning of parsing the message to make sure it is
big enough for the expected structure, and at the end of the message to
make sure we don't overflow past the end of the buffer for the next
message.

Cc: Vincent Mailhol <mailhol@kernel.org>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: stable@kernel.org
Assisted-by: gkh_clanker_2000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/2026022316-answering-strainer-a5db@gregkh
Fixes: 702171adeed3 ("ems_usb: Added support for EMS CPC-USB/ARM7 CAN/USB interface")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/ems_usb.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/net/can/usb/ems_usb.c
+++ b/drivers/net/can/usb/ems_usb.c
@@ -444,6 +444,11 @@ static void ems_usb_read_bulk_callback(s
 		start = CPC_HEADER_SIZE;
 
 		while (msg_count) {
+			if (start + CPC_MSG_HEADER_LEN > urb->actual_length) {
+				netdev_err(netdev, "format error\n");
+				break;
+			}
+
 			msg = (struct ems_cpc_msg *)&ibuf[start];
 
 			switch (msg->type) {
@@ -473,7 +478,7 @@ static void ems_usb_read_bulk_callback(s
 			start += CPC_MSG_HEADER_LEN + msg->length;
 			msg_count--;
 
-			if (start > urb->transfer_buffer_length) {
+			if (start > urb->actual_length) {
 				netdev_err(netdev, "format error\n");
 				break;
 			}


