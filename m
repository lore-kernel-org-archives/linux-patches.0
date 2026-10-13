Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243A94F5DE1;
	Tue, 13 Oct 2026 11:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892622; cv=none; b=f11kraKyV7YMLVqJoTEIbTZxIvZEvUP+WV8/iDnihlzSO7SMqJw6/uDU3IqAZ/aux59bJsCDPrMpKpK+mTA6PPEtS4xiMMFQnEaax7W9AMVtBrETZkbic1wFVJkXnlNRVGcph5OOtWe52YW/nKLIpByfM/EPeJo5ZAWrhXsH+J8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892622; c=relaxed/simple;
	bh=sUKLmcCaJubcjErh07r9wGmWZrbEmyytHGhHUnjSbtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fOM5p+WK4BTnuayd9AeeGjIx8nB6gFXaXSkHR1IdaFhwIvlKJ0ILsN98pMVa2wEO5o4x3U/cmUDEQHs0ERLk6gNpuTn+ejuPMzEMzcXN8aps8z8tdh7I4fAImmHBKFqdfZoIKsr5i1PFT2ms9/XOMbYaQbrJpfTsJ3PPW3wnlSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ObyNw/cL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ObyNw/cL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A77861F000FF;
	Tue, 13 Oct 2026 11:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892621;
	bh=F19WYtpP6RBNqmyAa8RGMsVYN/rnDueOfYMk7US7BGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ObyNw/cLnBcqJKs3FFVnWpn4wMExiGUKV1NsMlviOd4C4YUhV8S6nx4rbwQFghO75
	 +NGl3dq1lwAqrAZTJDcrHxQk6tET+cCAXYREmn3zso9N58EKShOFlaO732jZYqzV/g
	 GBITXaZVKnfZOEhqjb/B/pIXglz3Krszb+GyFHNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Gong <gongtao0607@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 235/281] wifi: mt76: mt7996: fix struct mt7996_mcu_wed_rro_ba_delete_event layout
Date: Tue, 13 Oct 2026 13:39:11 +0200
Message-ID: <20261013112900.852370379@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tao Gong <gongtao0607@gmail.com>

[ Upstream commit 9c9e4e4c8b45873e53774ab8207825b37b7565ec ]

Correct the definition of struct mt7996_mcu_wed_rro_ba_delete_event to
match the 12-byte event record layout observed from firmware.

The event TLV sent by firmware is 12 bytes in length rather than 8 bytes.
It contains an additional 4 bytes that appear to be wlan_id and tid.
For example, a captured batch deletion of sessions 8, 9, and 10 (TIDs 6,
0, and 1) shows:

  00000000: 02 00 0c 00 08 00 01 00 06 00 00 00 02 00 0c 00
  00000010: 09 00 01 00 00 00 00 00 02 00 0c 00 0a 00 01 00
  00000020: 01 00 00 00

The previous 8-byte structure corrupts the parsing of subsequent TLVs,
leading to unhandled delete events and erroneous session deletions.
Consequently, clients that create and tear down BA sessions in batches
(such as Apple Wi-Fi clients) fail to properly clean up stale sessions,
causing HW_RRO to be lost upon subsequent reassociations.

Fixes: a5d028d66836 ("wifi: mt76: mt7996: add wed rro delete session garbage collector")
Signed-off-by: Tao Gong <gongtao0607@gmail.com>
Link: https://patch.msgid.link/20260823053739.186748-1-gongtao0607@gmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
index c673e986ecb52..288b923750c0d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
@@ -284,6 +284,9 @@ struct mt7996_mcu_wed_rro_ba_delete_event {
 	__le16 len;
 
 	__le16 session_id;
+	__le16 wlan_id;
+	u8 tid;
+	u8 __rsv1;
 	u8 __rsv2[2];
 } __packed;
 
-- 
2.53.0



