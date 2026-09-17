Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBAD852CCCC;
	Thu, 17 Sep 2026 17:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665966; cv=none; b=a40Ek/AHNTvSTS0IzNhkpbNSkVsSCCzYkILUunv1vWSsBrCIJgYrFqybijEq2/EOzTxPGgKeLyAAgGUjVR6dHoRo0U1BVcbWzTR99KoEgnb6h8kOOILzjnirnGPnuWd3PaGr8atc86tk3JDi9C9u6CXiIn9e1lc53ZGe0ffHViQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665966; c=relaxed/simple;
	bh=/fAMv5SBwiPT/pP7Xn1eqmeue6uBunIG1QnaDoqR5qo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XAk3poBfHLx7u1vM5w+HdkmXsd2JEnJfzbtdsnSWXxvYzSNPbzj7aDgpPWCfdwhfDs7YzPwaODFvxOW9icBmrp7xh633oWDO5hZSRIGcXqRZAkFQ1Uu1yjW5AZgmKFUk0c1rNo9mYsAGvht5J8wt/IQ6562DUfeWpOReZYHXuvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZmgzRIrV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZmgzRIrV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E327B1F000FF;
	Thu, 17 Sep 2026 17:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665964;
	bh=pjFDfu+6mPFRykmlbQRzPSPBKM+YXEBNUIhCWD+XnAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZmgzRIrVPtuq3TyJuCcEt2V3WeGTJkqL0neGT6Ag21ey0Flh1ayQa97RgOgo9UCz/
	 oSAEyIFcqmZNConN3q40u+SteftCOIGYGD67dQkJHxYr3h6ffKeVd/GxEEMQQzgZ9G
	 3OG2qsHa4DJkZdibXzAGS7lYP68h4k1Un3a2gwsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0879/1250] Bluetooth: btusb: Fix UAF of btusb_data by rx_work
Date: Thu, 17 Sep 2026 16:11:14 +0100
Message-ID: <20260917151615.809632263@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 1c12c3117639e78940959d956519c758c57d0849 ]

btusb_close() and btusb_flush() cancel data->rx_work with the
asynchronous cancel_delayed_work(), so if btusb_rx_work() is already
running on another CPU it keeps running after the cancel returns.

btusb_disconnect() calls hci_unregister_dev(), which invokes
btusb_close(), and then frees the btusb_data. A still running
btusb_rx_work() then dereferences the freed data:

	while ((skb = skb_dequeue(&data->acl_q)))
		data->recv_acl(data->hdev, skb);

Use cancel_delayed_work_sync() instead. In btusb_close() the cancel also
has to happen after btusb_stop_traffic(), otherwise an URB completion
racing with the cancel can requeue the work right after it has been
waited for.

Fixes: 800fe5ec302e ("Bluetooth: btusb: Add support for queuing during polling interval")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index befda7caca40a..98d6b27fe07f6 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2022,18 +2022,24 @@ static int btusb_close(struct hci_dev *hdev)
 
 	BT_DBG("%s", hdev->name);
 
-	cancel_delayed_work(&data->rx_work);
 	cancel_work_sync(&data->work);
 	cancel_work_sync(&data->waker);
 
-	skb_queue_purge(&data->acl_q);
-
 	clear_bit(BTUSB_ISOC_RUNNING, &data->flags);
 	clear_bit(BTUSB_BULK_RUNNING, &data->flags);
 	clear_bit(BTUSB_INTR_RUNNING, &data->flags);
 	clear_bit(BTUSB_DIAG_RUNNING, &data->flags);
 
 	btusb_stop_traffic(data);
+
+	/* rx_work must only be canceled once the URBs that can rearm it are
+	 * gone, and it must be canceled synchronously since btusb_disconnect()
+	 * frees the btusb_data it dereferences right after hci_unregister_dev().
+	 */
+	cancel_delayed_work_sync(&data->rx_work);
+
+	skb_queue_purge(&data->acl_q);
+
 	btusb_free_frags(data);
 
 	err = usb_autopm_get_interface(data->intf);
@@ -2059,7 +2065,7 @@ static int btusb_flush(struct hci_dev *hdev)
 
 	BT_DBG("%s", hdev->name);
 
-	cancel_delayed_work(&data->rx_work);
+	cancel_delayed_work_sync(&data->rx_work);
 
 	skb_queue_purge(&data->acl_q);
 
-- 
2.53.0



