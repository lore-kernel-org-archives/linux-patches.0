Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8E0387587;
	Tue, 10 Mar 2026 11:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142192; cv=none; b=HOPTPifJ+CLRZ0zV85OESm/KXpwmaklWcMIhiy6+tNsXBbfVn9tVax83xo7E3ZdikwvPGNQa/G83THHcqUyfodLY+H+u/Ho0G9IcsyC7Bc59GeuoBFIXX+7hIJUvA8zW/uZYoHpAfiKBjKbe2wmC4+5pDuZzIshZdAacirnNrUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142192; c=relaxed/simple;
	bh=hmu0wLCp7Swkj1DuOjs/S7Jw0XiqtqhzzLqSv41/yiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hs926YcfzizztMy+Hkoch0uE5GJZ2RifW1GAoyINLLBc48ccyrf1maY5ryvT4Z3HhtbxlfgNm7TWBcqrkWrO+Y+T2C9WeZnuEWgbvdz4k6dp1mDWG2OYg+lKsHSr8ue2xlbyk+qCApN507FhICRQzLiWvr+EOkNvSi8wrDxbo8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LxHpex0B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LxHpex0B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8C07C19423;
	Tue, 10 Mar 2026 11:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142192;
	bh=hmu0wLCp7Swkj1DuOjs/S7Jw0XiqtqhzzLqSv41/yiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LxHpex0B83yKVw8bGK9P6gPowTJK2q5L72hybs6/gFV0uRPYwKvGYsU3frme+WkAA
	 9PsZ1Z7ACEo/1VsZoXyk4aYeePitEgc9qoXy8DN6E08P0WwoMG61OHFxeHzvyvb8Ge
	 4JMp0/ThNUJo8SR2W46WjNWOnzuJbe/D3EjffKyzSIWDCGNmqw/MfjTzeZ5FWGYC9+
	 5IkHYRDDdtHKXy3+nQanZ6QT0MU8FJ+7RH/hzgA3kXqYybr35rTu+a5zZzlD0ojvZD
	 NKBZiGPMR06hPJIfOepPJHzwf9Q8XIkN/RQJ/Dp/mSHHrAl+UVUqXZVfQa0twPD9vw
	 vz5IZQUT5Nf7w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ian Ray <ian.ray@gehealthcare.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 281/314] net: nfc: nci: Fix zero-length proprietary notifications
Date: Tue, 10 Mar 2026 07:19:00 -0400
Message-ID: <ba1182c8784ac5a1fb70d88f89868efcc849ff7a.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
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

