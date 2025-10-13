Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF9530BB9E;
	Mon, 13 Oct 2025 15:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367759; cv=none; b=VGWBL3zq0rMsNkoF+aJuKBZxGgUIHtuuJMFgNUoiKLPaW5WKmpvEnznKdguHs5YVUUbaOs7bFsIj49WTu0jBojbESOf/OslUOb37F5tYxmVW5rcaoJH9XNZqqU9sk5okC+qRoTE0vmnqMRf7qEMrLNlifwW38ODBYUhSiDSKYdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367759; c=relaxed/simple;
	bh=282EpwjOuz2ApXAkvDt8kCVK3AbDoc4o+nbiinolGys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MjPBgPaYy4lrwzpBNSi/HgZ01OOA+Dj2aVlHCln3s8V3bIPWJK3HimuMH9SRWNVlbZhvhUMjXrbu7epBOOEg7C0z9nNU3fanvl1DqwPo+SRvE6WiPKadTwjeI4LGHS1XrzSfRZDXEuEnz1CsQ8TQb10/mW6JrVCbd9PIPvlDKns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ql95rFRd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ql95rFRd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A11AAC4CEE7;
	Mon, 13 Oct 2025 15:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367759;
	bh=282EpwjOuz2ApXAkvDt8kCVK3AbDoc4o+nbiinolGys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ql95rFRd76UZSHdHu/GrgkhbHqWsWRVNLHJeH8dCpZRalp+F9aOVNmb/iFTRuAAc4
	 b4ujvGrkBWZ3AjiC3t9jo9gq+bio/1ASWVdCXMLviIFPjo6NauuzcgpHLjzQVgTbHB
	 P2rar7kxLCLukkc5JC7z8sP6emR1sJ6FdcwkKns0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Pecio <michal.pecio@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 123/196] Revert "usb: xhci: Avoid Stop Endpoint retry loop if the endpoint seems Running"
Date: Mon, 13 Oct 2025 16:45:14 +0200
Message-ID: <20251013144319.758531580@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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
index a21ac9d80275f..6443e11eaac04 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1224,19 +1224,16 @@ static void xhci_handle_cmd_stop_ep(struct xhci_hcd *xhci, int slot_id,
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



