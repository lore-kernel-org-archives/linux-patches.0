Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB4B142E7C;
	Mon,  6 Jan 2025 15:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178844; cv=none; b=bt81e+eoYNeifLxIlKshRj4kPH9cz4UwwR2sxYMZy2WkbbJfbzHcV+T8rqQkrqEGI1AB0a5WqLE4vW1HUAZHl7+EWar0Hpi23uhQd22Mp2Wlhgt40ZWTFKgkvn1qMOuiJVVTbJ9x9UINpn610/nYcQIyd0ben/ETq0cPa3LIngg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178844; c=relaxed/simple;
	bh=pKvXM3PySC8eKSukmqHTVrtIjc3x3nkk/mUoHA1QWt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m1pw1oBDLidknwsOSPVvwE5GkfC8n8G+Kxyo11gSoLiHqB5MDJF5olFm/q5Z75dfN3h+qlZPjsYtF24yEhzHyxnQnx3ClUnG5QFDpdPDo5dBqs1mtSU1MQTFuN6FBo7QGPrs+kvexdAr1pMuMzdhiRb7O3I8wuKZ78XMig/tTKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qwoke+Om; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qwoke+Om"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE4F4C4CED2;
	Mon,  6 Jan 2025 15:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178844;
	bh=pKvXM3PySC8eKSukmqHTVrtIjc3x3nkk/mUoHA1QWt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qwoke+OmxbH1MRFP2Blw2/EjR7SL0TvblvWzca6i+V+zHKaPoh/R42aer8yyPiC8r
	 0UaCQB4udgggyt/OQlkkUSB6tf4soNNefqawL+zt+6O56Zs/GsVyKx/40T1Es4todb
	 KU5fYIgq22dgkub9hQ7tus0TLjQ7AbC7Kwz+P7Ak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Pecio <michal.pecio@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 112/168] xhci: retry Stop Endpoint on buggy NEC controllers
Date: Mon,  6 Jan 2025 16:17:00 +0100
Message-ID: <20250106151142.685184232@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5e880f0bdd8a..29faa2d5c766 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1148,6 +1148,15 @@ static void xhci_handle_cmd_stop_ep(struct xhci_hcd *xhci, int slot_id,
 				break;
 			xhci_stop_watchdog_timer_in_irq(xhci, ep);
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



