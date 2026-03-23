Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA657370D76;
	Mon, 23 Mar 2026 14:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277996; cv=none; b=j9nt41g/aoDK+6tPOrRejvfZbgYFP1YLysxlF6arakHAsKXv/wEdJDnNXRGIgmdlo4+FQdWmwENETN7El8xx0M7aPpUEoMnTfLAxpKEnWr8rdrXshV8aI6nxtBba2qNqX70g4Hb2Bweo2WNcCRrjQx8YQuSPtQgEV2wCaFY6044=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277996; c=relaxed/simple;
	bh=WXc1Ykqv5s5GprCnyyyFPfQvQivSVhCTWP6JiYryg28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C5OZQ85RXKZ2EhcuWjWBKahjgyWCOdqbjvdI5cuBlhX3JOxDmI9wbtZcsVZgGTFqYssZD2p0El6Yd2xHjHHT4uBDfoxM2pejoioXsmwLJJ2FHMPLCRByvwV/Yz+jOZmjsdZrCbd8LSgkjC/9bTuxM+Di0x3vYi4uxMGZNEBaVAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UGAQBOxo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UGAQBOxo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39955C4CEF7;
	Mon, 23 Mar 2026 14:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277996;
	bh=WXc1Ykqv5s5GprCnyyyFPfQvQivSVhCTWP6JiYryg28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UGAQBOxosAsot4tkL4IsFe68UvhBMA5gab2ic9zIeMbq5wnFKTt7HaTvYTyAuUrI+
	 HVL9p83PxNRCVEBm73YH8CvQRv5oK9rR+8k2Pw0UBNZJCYTo7GBf+DyF+TLlnmEiyD
	 eCH+O9/ajGBi0aeMRuyCkuCm5OmvngnVZ6JtXJn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Ray <ian.ray@gehealthcare.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 168/567] net: nfc: nci: Fix zero-length proprietary notifications
Date: Mon, 23 Mar 2026 14:41:28 +0100
Message-ID: <20260323134537.982021296@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

From: Ian Ray <ian.ray@gehealthcare.com>

[ Upstream commit f7d92f11bd33a6eb49c7c812255ef4ab13681f0f ]

NCI NFC controllers may have proprietary OIDs with zero-length payload.
One example is: drivers/nfc/nxp-nci/core.c, NXP_NCI_RF_TXLDO_ERROR_NTF.

Allow a zero length payload in proprietary notifications *only*.

Before:

-- >8 --
kernel: nci: nci_recv_frame: len 3
-- >8 --

After:

-- >8 --
kernel: nci: nci_recv_frame: len 3
kernel: nci: nci_ntf_packet: NCI RX: MT=ntf, PBF=0, GID=0x1, OID=0x23, plen=0
kernel: nci: nci_ntf_packet: unknown ntf opcode 0x123
kernel: nfc nfc0: NFC: RF transmitter couldn't start. Bad power and/or configuration?
-- >8 --

After fixing the hardware:

-- >8 --
kernel: nci: nci_recv_frame: len 27
kernel: nci: nci_ntf_packet: NCI RX: MT=ntf, PBF=0, GID=0x1, OID=0x5, plen=24
kernel: nci: nci_rf_intf_activated_ntf_packet: rf_discovery_id 1
-- >8 --

Fixes: d24b03535e5e ("nfc: nci: Fix uninit-value in nci_dev_up and nci_ntf_packet")
Signed-off-by: Ian Ray <ian.ray@gehealthcare.com>
Link: https://patch.msgid.link/20260302163238.140576-1-ian.ray@gehealthcare.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/nci/core.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index b7d4952a7dcf8..7a4742a092626 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -1471,10 +1471,20 @@ static bool nci_valid_size(struct sk_buff *skb)
 	unsigned int hdr_size = NCI_CTRL_HDR_SIZE;
 
 	if (skb->len < hdr_size ||
-	    !nci_plen(skb->data) ||
 	    skb->len < hdr_size + nci_plen(skb->data)) {
 		return false;
 	}
+
+	if (!nci_plen(skb->data)) {
+		/* Allow zero length in proprietary notifications (0x20 - 0x3F). */
+		if (nci_opcode_oid(nci_opcode(skb->data)) >= 0x20 &&
+		    nci_mt(skb->data) == NCI_MT_NTF_PKT)
+			return true;
+
+		/* Disallow zero length otherwise. */
+		return false;
+	}
+
 	return true;
 }
 
-- 
2.51.0



