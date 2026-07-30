Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01BAA37475C;
	Thu, 30 Jul 2026 14:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422776; cv=none; b=j3yoquqe3SEByd9PFBuf0DmFihiTVRgHX/J142vXyz4zcVm0VSM3t9+YvYIV+U+TRrOwu4Ui2H2TpY6nuJwpgscEb9W1ZbB678xwADewaQTjtdneEHRID1ruHREuZJvDcXxeovw9yfqA3oILfnWcs3/GyOX17S7eqMUJBJntFPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422776; c=relaxed/simple;
	bh=ZYmenxw408Fbz7aXQC+NEwXLGgRNFxSdtdG5Ld++CdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T4+tAWyg8Z+azWA6YV1wxNLc6S13v1axpD+6yyGrND/AjN+mEZwIx9o4RXOlwko/3v1voTLfpbtT/3iYp0lDkIPrknsN4ba6CCF0bbunwlQQMjgA2aq7q7oNgd3MUEm7a0gqVUUDPihhIKOdTGijssDqLl8AX4P62wZ6+eM+Omg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DV51DESy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DV51DESy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 575691F000E9;
	Thu, 30 Jul 2026 14:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422774;
	bh=gkf+xZMyDEnNphDwjufkAOQFO647iJDlaEIlmgQ46fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DV51DESyM5VP4MEbanJW9+9mRImafkvj5DhDPQRs12lIBxr++QnE1d5mpae12d4Nu
	 lSv0Tswz/tRqjPOIxAV03cgTeBo0FNQpozRyzFsFIB74NiL90LfRp91b7iSU228R9I
	 txmmorYz0UyE+XwwyUwB2ZU4qTkfL/OWjd/yfC+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Morrow <morrownr@gmail.com>,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 7.1 550/744] wifi: mt76: restrict NPU/PPE active checks to MMIO devices
Date: Thu, 30 Jul 2026 16:13:43 +0200
Message-ID: <20260730141455.966215914@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Devin Wittmayer <lucid_duck@justthetip.ca>

commit 7981aca2bd28a1f7ad7eeab89715442a95b1f72e upstream.

mt76_npu_device_active() and mt76_ppe_device_active() read dev->mmio.npu
and dev->mmio.ppe_dev. The mmio, usb and sdio bus structs share a union in
struct mt76_dev, so on USB and SDIO these read unrelated data from the
usb/sdio struct, which is non-NULL in practice.

mt76_npu_device_active() then returns true on USB, and
mt76_rx_poll_complete() takes the offload path and skips
mt76_rx_aggr_reorder(). RX A-MPDU subframes are delivered out of order and
the peer's TCP stack treats that as loss: heavy retransmissions and reduced
throughput in AP mode. Seen on mt7921u, mt7925u, mt76x2u and mt76x0u.

Gate both helpers on mt76_is_mmio() so they only run for the bus type that
owns the mmio union member.

Fixes: 7fb554b1b623 ("wifi: mt76: Introduce the NPU generic layer")
Cc: stable@vger.kernel.org
Tested-by: Nick Morrow <morrownr@gmail.com>
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Link: https://patch.msgid.link/20260720232640.41293-1-lucid_duck@justthetip.ca
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt76.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -1735,12 +1735,12 @@ static inline int mt76_npu_send_txrx_add
 
 static inline bool mt76_npu_device_active(struct mt76_dev *dev)
 {
-	return !!rcu_access_pointer(dev->mmio.npu);
+	return mt76_is_mmio(dev) && !!rcu_access_pointer(dev->mmio.npu);
 }
 
 static inline bool mt76_ppe_device_active(struct mt76_dev *dev)
 {
-	return !!rcu_access_pointer(dev->mmio.ppe_dev);
+	return mt76_is_mmio(dev) && !!rcu_access_pointer(dev->mmio.ppe_dev);
 }
 
 static inline int mt76_npu_send_msg(struct airoha_npu *npu, int ifindex,


