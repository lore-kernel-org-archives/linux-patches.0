Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B48038735B;
	Tue, 10 Mar 2026 11:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141273; cv=none; b=YYKdFc5qSdc4riG15nxLe57F7q7BHtt5TehuaFVcWU9d9xVEyiBhyVdkezJAi75/mg82cE7On5NHxKeGDyU2StOU9uXHDGkTkDBqBReiB0oI2KfGS7XFJmGp3g+FmDWkHHuu+lp5GPfCFm0uaa70fsdCZOgjbeFWzkar2qNOCJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141273; c=relaxed/simple;
	bh=hmu0wLCp7Swkj1DuOjs/S7Jw0XiqtqhzzLqSv41/yiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XJkwwuWpJW/yC9EMGyTanWJuqNeldF5a3lpkEg+hklvtkAJ/hNNPbU5m1jh/+6jjalNC4N9Os+z1uTTh80J8wK7qIV/qHWBMYjLxwLPvR+ELi8JsfISXkyjA1GA1EL+gmpFgBaCCmYGEVn1oCsmMjXtfS/v15ssR08an8+ATm74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=POKRM60A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="POKRM60A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86C62C19423;
	Tue, 10 Mar 2026 11:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141273;
	bh=hmu0wLCp7Swkj1DuOjs/S7Jw0XiqtqhzzLqSv41/yiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=POKRM60A0iOdm716rT0Cbp00TDtRCncjcxH+I/MK+lZ+6EpFbP8H3gcb2nAnZYjiw
	 7wlPJU3wkTQwx6d90YJ8IVEcHJZHMWCKikHIRkuDNMQC7g1X237kwpIXdj/xc131/k
	 +uY/xrNNp6EerdAay4fRISzLbYBLOeUv6tjRCBsAW774VQxTuzRMbI7WL513D4Y/yW
	 ID/y1xLBZKynbjWwirMQh47qU5uXz13PgmHm1CGU/r1kQv+PRAMf7aBGxPbtcrw6gS
	 73ffn3ReEJFOJCbXLNb8niHkw+36Ddh9PTzpsYFSfR5E+QsiR20jLHeD6vwlhJMNPG
	 eB+fqmmZE5xBw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ian Ray <ian.ray@gehealthcare.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 275/311] net: nfc: nci: Fix zero-length proprietary notifications
Date: Tue, 10 Mar 2026 07:05:22 -0400
Message-ID: <d1b98ee86a5907c941e5b02d6bc415d6d63a976b.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index e419e020a70a3..46681bdaeabff 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -1482,10 +1482,20 @@ static bool nci_valid_size(struct sk_buff *skb)
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

