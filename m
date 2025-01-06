Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A705D145335;
	Mon,  6 Jan 2025 15:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736176767; cv=none; b=Z3UYGlHVH8ucvw9UrBn7EgXa547Q0y5v+v4fj6Fu88/WyWc16sj/FvczsamDqjYMzU96HzBzuMhZhIoenmD9uUyViqorh9nxh6DyzFWUg32PgZEBqBYINIb4ZpG3sTIq6OeaVfCl/xrnjKKoLtxYgy6nqk33ooAiUyCJwkRVdBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736176767; c=relaxed/simple;
	bh=SPKhKYjyQoFWZdZLEgaayk9thiKmR7iTxH8TZ8ePZAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tHlfIJ0/YKnqgwAPexu4HI+ILlPuuM4rfo5EOJKqw1phAFSY+CsPKqxOVv9LpJHURppcHZ6RBICFG+pJ9hghxwvUlU1tx4AQHfwaFQkJbszXoyPgg5spZQDw1blo4oYd4oUFND/qYE6j5C7Yq4d8EGAXuXyxrpoxuzNsM1WyXS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AKkt0BP1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AKkt0BP1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 247B8C4CED2;
	Mon,  6 Jan 2025 15:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736176767;
	bh=SPKhKYjyQoFWZdZLEgaayk9thiKmR7iTxH8TZ8ePZAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AKkt0BP1AV5bbRkVVyOD4HFuQzqsozHif+r9SUOyFl1P+kHmLMOG/x2tim8FrC7Qf
	 scTTRdiU0NF1hXLcMZvsNheCmF8uo2XpBshOVQsofHSAcACMLKcMZo2qMoDCxtMaXb
	 T4m/p2gznXgiB3Zw6nk3p1S8UVhMO2/NTLO5vvh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Pecio <michal.pecio@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 08/81] xhci: retry Stop Endpoint on buggy NEC controllers
Date: Mon,  6 Jan 2025 16:15:40 +0100
Message-ID: <20250106151129.753656143@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151129.433047073@linuxfoundation.org>
References: <20250106151129.433047073@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 975d825091cb..d193d5ad8789 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1141,6 +1141,15 @@ static void xhci_handle_cmd_stop_ep(struct xhci_hcd *xhci, int slot_id,
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



