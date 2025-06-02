Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A893A231843;
	Mon,  2 Jun 2025 14:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873358; cv=none; b=YKTiNL8ASFBdsGx5eGNqnO+RkolSh7YZtOyra6hPbQw38PEjonzbtsKwPNiW3A1WhOg17SDK6MPc5UuuZvRffGU4paV7icPHaQ1cN659A15tOGH1jhOCrepVwxEFTMfx6xZWRp7r/VCljfN2X1/uWRNu+u93CBHU3SmDgeIo7+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873358; c=relaxed/simple;
	bh=8WxOhCnR+RxV2dgtd2iL8RKwLhVVtzVxqxe4TNRxfLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZUzhwt8E3zh4TwgpxovvyqFVk6dMpQErNm1ctu8KRJvt5Fo0VuhN6SH35N372kk2KkVVh8y5/7LKrfUr0sAGoZYpCVP8rFKjKscR5udfTojwfSwh+5TDQoM0VfCkDI2fNXJtUhllVkcueH5a4bJVxe5g2EtUHk48BsnYXk3zJB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qdv8XUaA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qdv8XUaA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 040FCC4CEEB;
	Mon,  2 Jun 2025 14:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873358;
	bh=8WxOhCnR+RxV2dgtd2iL8RKwLhVVtzVxqxe4TNRxfLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qdv8XUaAQ4n/Z44rc3eNhVHWJ3xN13Bvdu47B7f53OpsYUdizfCrhxzQv2laiGuuF
	 HopK8UovwnZp5eDlg4a7WiORw3CfF7eIOE8O8xNy+HtWxdefTLCBKvkNbOANewL7qy
	 GuJDuwAwKKbKG5eeBedgkXhqoHapWEZuo/7SzMXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Pecio <michal.pecio@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 117/444] usb: xhci: Dont change the status of stalled TDs on failed Stop EP
Date: Mon,  2 Jun 2025 15:43:01 +0200
Message-ID: <20250602134345.648421664@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Michal Pecio <michal.pecio@gmail.com>

[ Upstream commit dfc88357b6b6356dadea06b2c0bc8041f5e11720 ]

When the device stalls an endpoint, current TD is assigned -EPIPE
status and Reset Endpoint is queued. If a Stop Endpoint is pending
at the time, it will run before Reset Endpoint and fail due to the
stall. Its handler will change TD's status to -EPROTO before Reset
Endpoint handler runs and initiates giveback.

Check if the stall has already been handled and don't try to do it
again. Since xhci_handle_halted_endpoint() performs this check too,
not overwriting td->status is the only difference.

I haven't seen this case yet, but I have seen a related one where
the xHC has already executed Reset Endpoint, EP Context state is
now Stopped and EP_HALTED is set. If the xHC took a bit longer to
execute Reset Endpoint, said case would become this one.

Signed-off-by: Michal Pecio <michal.pecio@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20250311154551.4035726-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-ring.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 5a53280fa2edf..44352df58c9e4 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1180,7 +1180,14 @@ static void xhci_handle_cmd_stop_ep(struct xhci_hcd *xhci, int slot_id,
 	 */
 		switch (GET_EP_CTX_STATE(ep_ctx)) {
 		case EP_STATE_HALTED:
-			xhci_dbg(xhci, "Stop ep completion raced with stall, reset ep\n");
+			xhci_dbg(xhci, "Stop ep completion raced with stall\n");
+			/*
+			 * If the halt happened before Stop Endpoint failed, its transfer event
+			 * should have already been handled and Reset Endpoint should be pending.
+			 */
+			if (ep->ep_state & EP_HALTED)
+				goto reset_done;
+
 			if (ep->ep_state & EP_HAS_STREAMS) {
 				reset_type = EP_SOFT_RESET;
 			} else {
@@ -1191,8 +1198,11 @@ static void xhci_handle_cmd_stop_ep(struct xhci_hcd *xhci, int slot_id,
 			}
 			/* reset ep, reset handler cleans up cancelled tds */
 			err = xhci_handle_halted_endpoint(xhci, ep, td, reset_type);
+			xhci_dbg(xhci, "Stop ep completion resetting ep, status %d\n", err);
 			if (err)
 				break;
+reset_done:
+			/* Reset EP handler will clean up cancelled TDs */
 			ep->ep_state &= ~EP_STOP_CMD_PENDING;
 			return;
 		case EP_STATE_STOPPED:
-- 
2.39.5



