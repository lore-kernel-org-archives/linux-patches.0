Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B85242D88;
	Tue, 26 Aug 2025 13:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213512; cv=none; b=TlUi7aEfv0jGViqFla9dStAjko82BJbAB0bcZ+sD10/m7bK2zEC5lj+GNPpc4e6I2oVWRlrCT8MItxVLnStFf6+XSnRt4/0Nw5NBwKnwbRDKrgBHWeLxOZbUugA5jlXwGNekXh0/GRINvfrFy81STfQcKnQsmZfrypIV3Fu/KZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213512; c=relaxed/simple;
	bh=uS9kGXgVo/kQAZlQ9Qf4FrZcU6sMCzfnCUapwuLCQuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W6ph2HhbTPs8b1anhVHXdtJhEraQEtZRrIGUv3NDEEc27hXiFyzjkWPTxTUdziA30GKtL1HbmUiHhgJ7gFUzm9wfap8dN4XkEO0PMaR2Rk/ifqBKCj5/h9XQcGNFt3/HAdFiMXd35ibIOMEVTX8aHMikdiHq9RE07T3FfRDEw6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nzADiWd4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nzADiWd4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74476C4CEF4;
	Tue, 26 Aug 2025 13:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213511;
	bh=uS9kGXgVo/kQAZlQ9Qf4FrZcU6sMCzfnCUapwuLCQuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nzADiWd43ruzHl3gRpvwbkNAPxUF5vIqgnEZIpKBki6UrO8JLepsJTq+AAcXUc5BN
	 XH6exag5S+nvhNQP4V7JAQpvqbMrJQZ8avyOHuM1nMu/E3Jzvfyh8m6Vx28ACPFXEM
	 zdfyNDumpUOgKk4TTYOkrnSkr/yr8aPOjIKCCeqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youssef Samir <quic_yabdulra@quicinc.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Subject: [PATCH 6.6 338/587] bus: mhi: host: Detect events pointing to unexpected TREs
Date: Tue, 26 Aug 2025 13:08:07 +0200
Message-ID: <20250826111001.516263220@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

From: Youssef Samir <quic_yabdulra@quicinc.com>

commit 5bd398e20f0833ae8a1267d4f343591a2dd20185 upstream.

When a remote device sends a completion event to the host, it contains a
pointer to the consumed TRE. The host uses this pointer to process all of
the TREs between it and the host's local copy of the ring's read pointer.
This works when processing completion for chained transactions, but can
lead to nasty results if the device sends an event for a single-element
transaction with a read pointer that is multiple elements ahead of the
host's read pointer.

For instance, if the host accesses an event ring while the device is
updating it, the pointer inside of the event might still point to an old
TRE. If the host uses the channel's xfer_cb() to directly free the buffer
pointed to by the TRE, the buffer will be double-freed.

This behavior was observed on an ep that used upstream EP stack without
'commit 6f18d174b73d ("bus: mhi: ep: Update read pointer only after buffer
is written")'. Where the device updated the events ring pointer before
updating the event contents, so it left a window where the host was able to
access the stale data the event pointed to, before the device had the
chance to update them. The usual pattern was that the host received an
event pointing to a TRE that is not immediately after the last processed
one, so it got treated as if it was a chained transaction, processing all
of the TREs in between the two read pointers.

This commit aims to harden the host by ensuring transactions where the
event points to a TRE that isn't local_rp + 1 are chained.

Fixes: 1d3173a3bae7 ("bus: mhi: core: Add support for processing events from client device")
Signed-off-by: Youssef Samir <quic_yabdulra@quicinc.com>
[mani: added stable tag and reworded commit message]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250714163039.3438985-1-quic_yabdulra@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/mhi/host/main.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/bus/mhi/host/main.c
+++ b/drivers/bus/mhi/host/main.c
@@ -603,7 +603,7 @@ static int parse_xfer_event(struct mhi_c
 	{
 		dma_addr_t ptr = MHI_TRE_GET_EV_PTR(event);
 		struct mhi_ring_element *local_rp, *ev_tre;
-		void *dev_rp;
+		void *dev_rp, *next_rp;
 		struct mhi_buf_info *buf_info;
 		u16 xfer_len;
 
@@ -622,6 +622,16 @@ static int parse_xfer_event(struct mhi_c
 		result.dir = mhi_chan->dir;
 
 		local_rp = tre_ring->rp;
+
+		next_rp = local_rp + 1;
+		if (next_rp >= tre_ring->base + tre_ring->len)
+			next_rp = tre_ring->base;
+		if (dev_rp != next_rp && !MHI_TRE_DATA_GET_CHAIN(local_rp)) {
+			dev_err(&mhi_cntrl->mhi_dev->dev,
+				"Event element points to an unexpected TRE\n");
+			break;
+		}
+
 		while (local_rp != dev_rp) {
 			buf_info = buf_ring->rp;
 			/* If it's the last TRE, get length from the event */


