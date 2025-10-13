Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D1CB30F7EE;
	Mon, 13 Oct 2025 14:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367216; cv=none; b=dJpcZOVZ3TixwsR9HbyVh8jtdsxuj715UcP2mFDJW0O/WQKHUUg8t3DK8ri7XvPGdzh01ChLrTmfNlXwnE38khM7JcZ4negpcIr6QdQh1d7jdBZsMWn5ov2I4zzwy6Itiu1Ybk76EWabd/pkb2jj5CNo4YHAOiy3PRz9FKPfVi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367216; c=relaxed/simple;
	bh=8Z+TTPaDnfSvaQKbGERH9iRpRw+SJP0QHBPlgsgwC44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OfmbBIENdnupiUDrqL/mgkAQEWQkmoKEzkfS1F7ewv+ZXclDgVhQVshY7IbCHMzocSvL/ZGAT2+0ak+sFsUgP7e/mD7ysPxJcZAexnDuN87iQjjuBTJHRQTcvdryBRmeiXyp2zSSeIM0al0Sq22F7JaErDvjO1WmBMV7UGf+Phw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=myJTPhbQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="myJTPhbQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4023DC113D0;
	Mon, 13 Oct 2025 14:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367215;
	bh=8Z+TTPaDnfSvaQKbGERH9iRpRw+SJP0QHBPlgsgwC44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=myJTPhbQdZ8LLjHeZUGQJjhFATHrkwStloII+bBdVuwz1CwoBcrjLSVmShrsrm/GK
	 rSNCHYrWbIPZaM7xwHUjwWOGqrKZqgduOFIRCYlIMo+CJehKRMOtYIT8l8LNM7mP6i
	 ZhagBI8S0JNod47p1HXIXnfadGM9oHxnEBWoXL/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Pecio <michal.pecio@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 133/196] Revert "usb: xhci: Avoid Stop Endpoint retry loop if the endpoint seems Running"
Date: Mon, 13 Oct 2025 16:45:06 +0200
Message-ID: <20251013144319.505121113@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Pecio <michal.pecio@gmail.com>

[ Upstream commit 08fa726e66039dfa80226dfa112931f60ad4c898 ]

This reverts commit 28a76fcc4c85dd39633fb96edb643c91820133e3.

No actual HW bugs are known where Endpoint Context shows Running state
but Stop Endpoint fails repeatedly with Context State Error and leaves
the endpoint state unchanged. Stop Endpoint retries on Running EPs have
been performed since early 2021 with no such issues reported so far.

Trying to handle this hypothetical case brings a more realistic danger:
if Stop Endpoint fails on an endpoint which hasn't yet started after a
doorbell ring and enough latency occurs before this completion event is
handled, the driver may time out and begin removing cancelled TDs from
a running endpoint, even though one more retry would stop it reliably.

Such high latency is rare but not impossible, and removing TDs from a
running endpoint can cause more damage than not giving back a cancelled
URB (which wasn't happening anyway). So err on the side of caution and
revert to the old policy of always retrying if the EP appears running.

[Remove stable tag as we are dealing with theoretical cases -Mathias]

Fixes: 28a76fcc4c85d ("usb: xhci: Avoid Stop Endpoint retry loop if the endpoint seems Running")
Signed-off-by: Michal Pecio <michal.pecio@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20250917210726.97100-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-ring.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index c8e1ead0c09e6..cb0bf8b6e0172 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1175,19 +1175,16 @@ static void xhci_handle_cmd_stop_ep(struct xhci_hcd *xhci, int slot_id,
 			 * Stopped state, but it will soon change to Running.
 			 *
 			 * Assume this bug on unexpected Stop Endpoint failures.
-			 * Keep retrying until the EP starts and stops again.
+			 * Keep retrying until the EP starts and stops again, on
+			 * chips where this is known to help. Wait for 100ms.
 			 */
+			if (time_is_before_jiffies(ep->stop_time + msecs_to_jiffies(100)))
+				break;
 			fallthrough;
 		case EP_STATE_RUNNING:
 			/* Race, HW handled stop ep cmd before ep was running */
 			xhci_dbg(xhci, "Stop ep completion ctx error, ctx_state %d\n",
 					GET_EP_CTX_STATE(ep_ctx));
-			/*
-			 * Don't retry forever if we guessed wrong or a defective HC never starts
-			 * the EP or says 'Running' but fails the command. We must give back TDs.
-			 */
-			if (time_is_before_jiffies(ep->stop_time + msecs_to_jiffies(100)))
-				break;
 
 			command = xhci_alloc_command(xhci, false, GFP_ATOMIC);
 			if (!command) {
-- 
2.51.0



