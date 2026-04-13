Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E022EBB8C;
	Mon, 13 Apr 2026 16:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097298; cv=none; b=iDITnMwmFP7ZQUP+iRyLnEGo6azl0NypLh0E4iZcc09uw/lnUrygilhVlCYCvQg98qTtG5Y2MeHg0Bm1KzM5vqV60m2zN3y+LdPch5Ha4fi6yiEzPTBKY9Sf67lKzAdSoLQCtLVSW4ykURu5CGNvINeZDT0a6cTRkvq7WeW7l4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097298; c=relaxed/simple;
	bh=8Mm7+Otr76vq94xTECwaUzIXvrC6xV54mSNdNMtzAbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ifmXAU4C+l4CJUD6Hg1QhV/dAVM14OdLCNEDH9u2daMsNc0P/IgmaG60/JQL8v+uISz0x/dNN7OYLeMR5tSY3EVUKZZNSFpWb5ADGAOldXy4LkQ+/86auMmyioPQ797mDiv97ofzhHMjQxxt2CrmXzZ6lJsdd5RXy6rP9O4lXGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZhJiypMl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZhJiypMl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AD46C2BCAF;
	Mon, 13 Apr 2026 16:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097298;
	bh=8Mm7+Otr76vq94xTECwaUzIXvrC6xV54mSNdNMtzAbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZhJiypMlBbW6iH9h0CvdVtvdgxxetrrDFhmpYElJn/UkrD8hIqD08SIhf8g6cMY60
	 1m2eyehAqFGN89KdbqSkUss/fAvyq+reJy76XBK9guyhz7PxQqnwLxa56ADfzRw+kl
	 MmJBQz3vf9ejcCc9XFVRLQv8JZxFy+WpTgu/MzOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Ray <ian.ray@gehealthcare.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 081/570] net: nfc: nci: Fix zero-length proprietary notifications
Date: Mon, 13 Apr 2026 17:53:32 +0200
Message-ID: <20260413155833.475677324@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c26914ca40aff..4f1f56e264730 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -1474,10 +1474,20 @@ static bool nci_valid_size(struct sk_buff *skb)
 	BUILD_BUG_ON(NCI_CTRL_HDR_SIZE != NCI_DATA_HDR_SIZE);
 
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



