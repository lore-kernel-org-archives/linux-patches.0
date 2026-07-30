Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9A2270545;
	Thu, 30 Jul 2026 15:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425641; cv=none; b=cgCjvAAKTRdlRYFnxW2tgHsFwZGXnATQ2x4e54yZ0KSRcq3oEaWFqq2SIegEOanl62WkJqbvedEVWvgZl9pY+JOVkLaohKeNDkmLSVIOOpZ40WqdOYDV9/1VdvnH+wcirJZnqFLllu9SrY6TbrjFvIVYfUNPt7Eolo2PbA5efCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425641; c=relaxed/simple;
	bh=BJTSD69B469xWki8zdT13cA26jBAszCbGhmQeO16nFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LZz7lnMxymT1yC7ByJjj3ZKE3RlruTpOhe+wW5UiY565WBQRs7hxH7Hphl9vmQnACqp/X7MV2XW9IT419AuQVDOJlRSXtkJZi4d5PsSatOilT7YZ06LgXyX6QDqX89g+jmChVdpCp0tW77OFVvxdIoZAIIZHk2+eveL3wRcpGkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V1Pfuols; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V1Pfuols"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D87E1F000E9;
	Thu, 30 Jul 2026 15:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425640;
	bh=ZWQydT38iGl7uYzHFAfcwajZuLdhR69JNNPM8zDsf04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V1PfuolsgJ/0sheNxDx5x9GkcT2CgX+40dh6buBHwrLyTZJrfU1eWKulxegmaFLXi
	 02tDKsEkYOwqQ8tpmWA1vS+oHAr/aJhROyXPyd1FVOIVVvNboXCptQXDtnf4dFHhG2
	 GZ0jzIUS7v2Y6wJFPPw1dq2LEy/PvCGuCCjDfY+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 095/602] Bluetooth: hci_qca: Clear memdump state on invalid dump size
Date: Thu, 30 Jul 2026 16:08:07 +0200
Message-ID: <20260730141437.991134681@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit bf587a10c33e5571a299742e45bc18960b9912e7 ]

qca_controller_memdump() allocates qca->qca_memdump before processing
the first dump packet. For a sequence-zero packet it then disables IBS,
marks memdump collection active, and reads the advertised dump size.

If the controller reports a zero dump size, the error path frees the
local qca_memdump object and returns without clearing qca->qca_memdump
or undoing the collection state. A later memdump work item initializes
its local pointer from qca->qca_memdump and skips allocation when that
pointer is non-NULL, so it can operate on freed memory. The stale
collection and IBS-disabled flags can also leave waiters or later
transmit handling blocked behind an aborted dump.

Clear the saved pointer and memdump state before returning from the
invalid-size path, matching the cleanup used when hci_devcd_init() fails.

A static analysis checker reported the stale memdump state, and manual
source review confirmed the invalid-size failure path.

Fixes: 06d3fdfcdf5c ("Bluetooth: hci_qca: Add qcom devcoredump support")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Reviewed-by: Zijun Hu <zijun.hu@oss.qualcomm.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_qca.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index de9fd0e77d398a..524fc638ceb49f 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -1070,6 +1070,10 @@ static void qca_controller_memdump(struct work_struct *work)
 			if (!(qca_memdump->ram_dump_size)) {
 				bt_dev_err(hu->hdev, "Rx invalid memdump size");
 				kfree(qca_memdump);
+				qca->qca_memdump = NULL;
+				qca->memdump_state = QCA_MEMDUMP_COLLECTED;
+				clear_and_wake_up_bit(QCA_MEMDUMP_COLLECTION, &qca->flags);
+				clear_bit(QCA_IBS_DISABLED, &qca->flags);
 				kfree_skb(skb);
 				mutex_unlock(&qca->hci_memdump_lock);
 				return;
-- 
2.53.0



