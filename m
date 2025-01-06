Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B2714900B;
	Mon,  6 Jan 2025 15:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177163; cv=none; b=rpHXtgkMC8rMtQ/s+vkD5/wE1ZuV9nUc4lf5AR9pYkE6RAVP8LtDl+E3YqNBIGm6xub62jp2QihvNcy/x36y9ToQsKF+cLrkj/TbNlgNt8KuumQoO9mfIvGv10Z+NEX8Vmma+H+fRQa1jJfBGOp6Tn/Uy1N4FlYwuXTSyVbw/30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177163; c=relaxed/simple;
	bh=9szRVrFHaxNZfrSIrPO2j4Se1KftPxyVAoSbsiRzxbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I7sZy6PC5jLztFZKL/NWoVdikj3TSL92RhvUaJpAhem+vxuaIAKQWzE9NQrXZ1f7mIj9a6Qm700N0+/Mk9/XE2qJbX+5HyozftNejwjqcBFpmXM02UXC2PaIUScXaHIVYqIOgEhhVvnBtP+JDVF13gSyP6LH7997/oGerpMOJos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cLUkh1Lf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cLUkh1Lf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDCD1C4CED2;
	Mon,  6 Jan 2025 15:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177163;
	bh=9szRVrFHaxNZfrSIrPO2j4Se1KftPxyVAoSbsiRzxbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cLUkh1LfwiZfc0Ix3W28vreMqbDdt8vvMJDlOTLsvHBfKhE7wXSi/vtVGHDYQW2QY
	 52YvflmlTpAyQ5/wrDp4oC7oaKSt3AxP18L/oC86bg9gwLwJFhhABdS6GQ6s7DPbVw
	 PC6ZnuRmsD8lxVsdkYQiYVCPsZ3qFabCWIWdkIQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Pecio <michal.pecio@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 073/222] xhci: retry Stop Endpoint on buggy NEC controllers
Date: Mon,  6 Jan 2025 16:14:37 +0100
Message-ID: <20250106151153.368425735@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

[ Upstream commit fd9d55d190c0e5fefd3a9165ea361809427885a1 ]

Two NEC uPD720200 adapters have been observed to randomly misbehave:
a Stop Endpoint command fails with Context Error, the Output Context
indicates Stopped state, and the endpoint keeps running. Very often,
Set TR Dequeue Pointer is seen to fail next with Context Error too,
in addition to problems from unexpectedly completed cancelled work.

The pathology is common on fast running isoc endpoints like uvcvideo,
but has also been reproduced on a full-speed bulk endpoint of pl2303.
It seems all EPs are affected, with risk proportional to their load.

Reproduction involves receiving any kind of stream and closing it to
make the device driver cancel URBs already queued in advance.

Deal with it by retrying the command like in the Running state.

Signed-off-by: Michal Pecio <michal.pecio@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20240229141438.619372-8-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: e21ebe51af68 ("xhci: Turn NEC specific quirk for handling Stop Endpoint errors generic")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-ring.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 50f588011400..7c3e39482834 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1180,6 +1180,15 @@ static void xhci_handle_cmd_stop_ep(struct xhci_hcd *xhci, int slot_id,
 				break;
 			ep->ep_state &= ~EP_STOP_CMD_PENDING;
 			return;
+		case EP_STATE_STOPPED:
+			/*
+			 * NEC uPD720200 sometimes sets this state and fails with
+			 * Context Error while continuing to process TRBs.
+			 * Be conservative and trust EP_CTX_STATE on other chips.
+			 */
+			if (!(xhci->quirks & XHCI_NEC_HOST))
+				break;
+			fallthrough;
 		case EP_STATE_RUNNING:
 			/* Race, HW handled stop ep cmd before ep was running */
 			xhci_dbg(xhci, "Stop ep completion ctx error, ep is running\n");
-- 
2.39.5



