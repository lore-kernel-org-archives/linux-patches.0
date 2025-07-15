Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F1C1A23AF;
	Tue, 15 Jul 2025 13:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585521; cv=none; b=A++q7hUGWAOQRly0dn90CTGbxWD3uX2VB7C5Tx+ByUbB4jaCjSlriWZZM5AZH90yiV2Wauwo+pbKooR/+ZUHypS8CTgAN4yHVWcCJaoZl5v2ux4wJktPWOhj2zGkLXStRK9wQntNW41RfHg4c7OgG+gwcSVfa9XZ28U0QdwEnbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585521; c=relaxed/simple;
	bh=w9EHeDbFB/tBbgQBkwGZ2AmS+aZ9/XolJkrM1oJcus8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fryvLKufBQ2PLYi7Bbft5mYYpbSGcYWeEHpOT80DOj0lEd0eyLk5GVMRGdGF4PpSjfvKQUetYniJdu1q0UzOk1vFP2Vgx3SzCHOLdafVLOWacQeYDYQcZporFaN6fR7g/v0mDe6j6107fmjUsyKdDOljVK4P2mlNDopUOiCBgMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ka4iXUwg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ka4iXUwg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C4F8C4CEE3;
	Tue, 15 Jul 2025 13:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585521;
	bh=w9EHeDbFB/tBbgQBkwGZ2AmS+aZ9/XolJkrM1oJcus8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ka4iXUwghEiYo3VvNNwiOes3douyypxAdHC/BgcGTMUFX/rj/GUO34oz9LcpEF84N
	 jvsAK0uxFhMNt0kg0PZc3aTZtQ3ofda/6kXOpGI13hE4eaeseT6edVHkRLRyfZ0T6U
	 goN8V0/Z5zmexsseULO2zJdUAfV+jmSlQ8mITTsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Lo <michael.lo@mediatek.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.12 071/163] wifi: mt76: mt7925: fix invalid array index in ssid assignment during hw scan
Date: Tue, 15 Jul 2025 15:12:19 +0200
Message-ID: <20250715130811.587128055@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Lo <michael.lo@mediatek.com>

commit c701574c54121af2720648572efbfe77564652d1 upstream.

Update the destination index to use 'n_ssids', which is incremented only
when a valid SSID is present. Previously, both mt76_connac_mcu_hw_scan()
and mt7925_mcu_hw_scan() used the loop index 'i' for the destination
array, potentially leaving gaps if any source SSIDs had zero length.

Cc: stable@vger.kernel.org
Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: Michael Lo <michael.lo@mediatek.com>
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Link: https://patch.msgid.link/20250612062046.160598-1-mingyen.hsieh@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c |    4 ++--
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c      |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -1696,8 +1696,8 @@ int mt76_connac_mcu_hw_scan(struct mt76_
 		if (!sreq->ssids[i].ssid_len)
 			continue;
 
-		req->ssids[i].ssid_len = cpu_to_le32(sreq->ssids[i].ssid_len);
-		memcpy(req->ssids[i].ssid, sreq->ssids[i].ssid,
+		req->ssids[n_ssids].ssid_len = cpu_to_le32(sreq->ssids[i].ssid_len);
+		memcpy(req->ssids[n_ssids].ssid, sreq->ssids[i].ssid,
 		       sreq->ssids[i].ssid_len);
 		n_ssids++;
 	}
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -2823,8 +2823,8 @@ int mt7925_mcu_hw_scan(struct mt76_phy *
 		if (!sreq->ssids[i].ssid_len)
 			continue;
 
-		ssid->ssids[i].ssid_len = cpu_to_le32(sreq->ssids[i].ssid_len);
-		memcpy(ssid->ssids[i].ssid, sreq->ssids[i].ssid,
+		ssid->ssids[n_ssids].ssid_len = cpu_to_le32(sreq->ssids[i].ssid_len);
+		memcpy(ssid->ssids[n_ssids].ssid, sreq->ssids[i].ssid,
 		       sreq->ssids[i].ssid_len);
 		n_ssids++;
 	}


