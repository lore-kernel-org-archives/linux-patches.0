Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C3B12C476;
	Tue, 30 Apr 2024 11:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475014; cv=none; b=gKwlTCoyHPqFBMI6FvSKhBqCjumk5UsJ54EW5nNQOxwah6eVCGQRO6bbpEb9NTe59n34luZhotL1067aUXuuh4nft0xIoHVaOJjCfPOC7ob3k91kcB44WRFo7eWVBvUxgwbkuJs9vNdC1J2SKaLgvY+QF/UyuuqvXDI+Tvndmh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475014; c=relaxed/simple;
	bh=TFLj5MhOgeEeig523P/ra88ZL0jSoX5U6gz4ueCVhZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kW11jjAhE8cxwOs8Rb+1ehKPp/yFhr1b3PYzawFFVFgvE2gqtZju6DXHDSLmLPf2W3yb9d5WNtdQMX3Ts1EIjDG6fMDJ6YpTBSA9vQ2PPWXDEwsRhkg7z9ZWQAPEV4xeE1ttY6cCD/rzDRXgIWUnivl01CjblXK7UTzKtqad0Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wVRm7R4E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wVRm7R4E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDF4BC2BBFC;
	Tue, 30 Apr 2024 11:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475014;
	bh=TFLj5MhOgeEeig523P/ra88ZL0jSoX5U6gz4ueCVhZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wVRm7R4EnLSzf9WwLEHjLMxArd38GjlhmmeaZb09JBYlGEREN8cXqJmWDMUxwWyTi
	 qrUXZZD8eVc/qRWAfGVDhoeLZQlLgHZidcEsGr2sHWSNAT92g0UIXKpyYTXDAUQvaP
	 6wlsoaG07t0B8YMGiT9A/h+3VvpKDjCHjSi9yLIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Reeder <jreeder@ti.com>,
	Ravi Gunasekaran <r-gunasekaran@ti.com>,
	Ed Trexel <ed.trexel@hp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 105/138] net: ethernet: ti: am65-cpts: Fix PTPv1 message type on TX packets
Date: Tue, 30 Apr 2024 12:39:50 +0200
Message-ID: <20240430103052.505879813@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jason Reeder <jreeder@ti.com>

[ Upstream commit 1b9e743e923b256e353a9a644195372285e5a6c0 ]

The CPTS, by design, captures the messageType (Sync, Delay_Req, etc.)
field from the second nibble of the PTP header which is defined in the
PTPv2 (1588-2008) specification. In the PTPv1 (1588-2002) specification
the first two bytes of the PTP header are defined as the versionType
which is always 0x0001. This means that any PTPv1 packets that are
tagged for TX timestamping by the CPTS will have their messageType set
to 0x0 which corresponds to a Sync message type. This causes issues
when a PTPv1 stack is expecting a Delay_Req (messageType: 0x1)
timestamp that never appears.

Fix this by checking if the ptp_class of the timestamped TX packet is
PTP_CLASS_V1 and then matching the PTP sequence ID to the stored
sequence ID in the skb->cb data structure. If the sequence IDs match
and the packet is of type PTPv1 then there is a chance that the
messageType has been incorrectly stored by the CPTS so overwrite the
messageType stored by the CPTS with the messageType from the skb->cb
data structure. This allows the PTPv1 stack to receive TX timestamps
for Delay_Req packets which are necessary to lock onto a PTP Leader.

Signed-off-by: Jason Reeder <jreeder@ti.com>
Signed-off-by: Ravi Gunasekaran <r-gunasekaran@ti.com>
Tested-by: Ed Trexel <ed.trexel@hp.com>
Fixes: f6bd59526ca5 ("net: ethernet: ti: introduce am654 common platform time sync driver")
Link: https://lore.kernel.org/r/20240424071626.32558-1-r-gunasekaran@ti.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpts.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/ti/am65-cpts.c b/drivers/net/ethernet/ti/am65-cpts.c
index 5dc60ecabe561..e0fcdbadf2cba 100644
--- a/drivers/net/ethernet/ti/am65-cpts.c
+++ b/drivers/net/ethernet/ti/am65-cpts.c
@@ -649,6 +649,11 @@ static bool am65_cpts_match_tx_ts(struct am65_cpts *cpts,
 		struct am65_cpts_skb_cb_data *skb_cb =
 					(struct am65_cpts_skb_cb_data *)skb->cb;
 
+		if ((ptp_classify_raw(skb) & PTP_CLASS_V1) &&
+		    ((mtype_seqid & AM65_CPTS_EVENT_1_SEQUENCE_ID_MASK) ==
+		     (skb_cb->skb_mtype_seqid & AM65_CPTS_EVENT_1_SEQUENCE_ID_MASK)))
+			mtype_seqid = skb_cb->skb_mtype_seqid;
+
 		if (mtype_seqid == skb_cb->skb_mtype_seqid) {
 			u64 ns = event->timestamp;
 
-- 
2.43.0



