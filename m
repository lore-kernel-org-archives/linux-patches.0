Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9AC213E67;
	Tue, 29 Apr 2025 18:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950569; cv=none; b=PFPxyxcV23wkv8X7zFuzG8T8MqDCpyRW2rjFo5f/oMttOjtoSrYuxBdzQ+CYRuaJsAWtUUOHZsus5bqFwKKsaYBRlEFkBlpneV0p0RvkbUeqHkBRda0HhExjd/euznE25Zzbc4Yx02oHL+TtuQVkmXK5cKbNWDcd8Nofu2Wf3U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950569; c=relaxed/simple;
	bh=Vm+AtyYTK7WrFQH/+7e4MmWKl057+P1H8wPQ4FPetto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S+xZUxyGApDtXkxzlZr3DQjk93cCQjk/3XZmfDm2Ml5kgVTUURViGQ34Rawg3XeUfoNJW6AicYoe5PwXreC4OZ2g2a03AG6eqbBlpoqCIsE4/1phocmZXgwhW65uQf82rcQYrENTI8d8dkfQSedLElX3fiVsNeL6HU8UtNzdsOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cV9LiyIE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cV9LiyIE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4277C4CEE3;
	Tue, 29 Apr 2025 18:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950569;
	bh=Vm+AtyYTK7WrFQH/+7e4MmWKl057+P1H8wPQ4FPetto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cV9LiyIEI1ChXynWCscfRRBQaEUqdKKBBgujH1ROPXzQP8RTjHLIC7XAIfo9qQCkn
	 OXH6+6hctgCV4KF46HsmJNKvN5yUcJKJAk/ew2FDpl2W6H79aP9HmJIqXi4YGPE12/
	 mBVEy4LcNGMy/Z6XtAseqOoKMpAulSV7JjfbCEzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Pecio <michal.pecio@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 137/204] usb: xhci: Avoid Stop Endpoint retry loop if the endpoint seems Running
Date: Tue, 29 Apr 2025 18:43:45 +0200
Message-ID: <20250429161105.039206013@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

[ Upstream commit 28a76fcc4c85dd39633fb96edb643c91820133e3 ]

Nothing prevents a broken HC from claiming that an endpoint is Running
and repeatedly rejecting Stop Endpoint with Context State Error.

Avoid infinite retries and give back cancelled TDs.

No such cases known so far, but HCs have bugs.

Signed-off-by: Michal Pecio <michal.pecio@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20250311154551.4035726-4-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-ring.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index e66bb87c42179..cb94439629451 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1214,16 +1214,19 @@ static void xhci_handle_cmd_stop_ep(struct xhci_hcd *xhci, int slot_id,
 			 * Stopped state, but it will soon change to Running.
 			 *
 			 * Assume this bug on unexpected Stop Endpoint failures.
-			 * Keep retrying until the EP starts and stops again, on
-			 * chips where this is known to help. Wait for 100ms.
+			 * Keep retrying until the EP starts and stops again.
 			 */
-			if (time_is_before_jiffies(ep->stop_time + msecs_to_jiffies(100)))
-				break;
 			fallthrough;
 		case EP_STATE_RUNNING:
 			/* Race, HW handled stop ep cmd before ep was running */
 			xhci_dbg(xhci, "Stop ep completion ctx error, ctx_state %d\n",
 					GET_EP_CTX_STATE(ep_ctx));
+			/*
+			 * Don't retry forever if we guessed wrong or a defective HC never starts
+			 * the EP or says 'Running' but fails the command. We must give back TDs.
+			 */
+			if (time_is_before_jiffies(ep->stop_time + msecs_to_jiffies(100)))
+				break;
 
 			command = xhci_alloc_command(xhci, false, GFP_ATOMIC);
 			if (!command) {
-- 
2.39.5



