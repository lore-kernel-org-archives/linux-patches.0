Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF3B4D7D30;
	Tue, 13 Oct 2026 12:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892875; cv=none; b=Vbe6aOgniOQF+4lI8YFs6UiPcGqEM4uqARGYe/6xiQW5syBHKqPIdhtCt8NDMlXQnZ4SIJAogb2P0LhpGfyT8bMITldNFnqIR798mD9+wQFWsXEQEHorLXTcB7ZuKr7Cut2ViyjlCwg4UhyWrcnOPXUzwh5PeCFvFpZGh58c9aE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892875; c=relaxed/simple;
	bh=BLHxJLCxd5x2AvVvH4o9AmchpvW+yM5lTIlWT41LTuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XQJqGKltcQxVuLmZ9n0XBMW3ruxb47vzV/1BNVNGwzxs3XvhvsPNJUFyxU0OA+MuZXZjdbfix9DtGSAbtsLrEfESS3bsfkM+kZRi0+3fE0JX6BnHGj+XzWVyncKlsk5NmN/qRf2XsPjw/HfPGDcHh6Y2pTOtYmUIUAxxVY+9dcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fMIQ9pRz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fMIQ9pRz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF2411F00893;
	Tue, 13 Oct 2026 12:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892874;
	bh=uFvTtnn4K8XQWzEmSfudkzgHppAdRafowVYnNJD9UEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fMIQ9pRzNZW9S/PyPR5IBItKcwrBOt9loFTrFXqB5lyNOnsTZBQuw2/2V8tSru6k7
	 JjeSwezS+QAqdu46SfFuKwQLI0mNYqL4X7EiXDPY1zxqvxWKE9nJgPIQ+L25Q633Fp
	 mfiyrHJGFgb9qjdJZqi2/N4QF9kFT9s/+EGaALvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Papa <pcristian292@gmail.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.18 037/621] wifi: mt76: mt7603: initialize global station WCID
Date: Tue, 13 Oct 2026 13:30:32 +0200
Message-ID: <20261013112921.746011701@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Papa <pcristian292@gmail.com>

commit 456de496b53ae73e6e3020fec815dbdc88aa7c07 upstream.

mt7603 uses a driver-private global station WCID for frames that have
neither a station nor a vif, including frames injected through a monitor
interface. Unlike the core global WCID initialized by
mt76_register_device(), this WCID is published without ever being passed
to mt76_wcid_init().

Since commit 0335c034e726 ("wifi: mt76: fix race condition related to
checking tx queue fill status"), mt76_tx() queues every such frame on the
WCID's tx_pending or tx_offchannel queue and links its tx_list. The first
injected frame therefore reaches __skb_queue_tail() with an uninitialized
sk_buff_head and dereferences a NULL prev pointer.

Initialize the WCID before publishing it.

The fix was tested on an MT7603 PCIe device. Three wildcard probe requests
were injected through a monitor interface. The hardware queue head and tail
advanced from 0 to 3 and a second radio captured the third request over the
air. No oops or reset occurred. After restoring AP mode, a 150 MB transfer
also completed without a reset.

Fixes: 0335c034e726 ("wifi: mt76: fix race condition related to checking tx queue fill status")
Cc: stable@vger.kernel.org
Signed-off-by: Cristian Papa <pcristian292@gmail.com>
Link: https://patch.msgid.link/20260904010702.16306-1-pcristian292@gmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7603/init.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/mediatek/mt76/mt7603/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/init.c
@@ -230,6 +230,7 @@ mt7603_mac_init(struct mt7603_dev *dev)
 
 	eth_broadcast_addr(bc_addr);
 	mt7603_wtbl_init(dev, MT7603_WTBL_RESERVED, -1, bc_addr);
+	mt76_wcid_init(&dev->global_sta.wcid, 0);
 	dev->global_sta.wcid.idx = MT7603_WTBL_RESERVED;
 	rcu_assign_pointer(dev->mt76.wcid[MT7603_WTBL_RESERVED],
 			   &dev->global_sta.wcid);


