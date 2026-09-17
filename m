Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685EA4CDDC7;
	Thu, 17 Sep 2026 15:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659920; cv=none; b=AYlDYXvjLUTPE9KG2KFwtZhUbUsORiky23TeaNu4og+pGgow9Q8H50OppUdfKqmHnMh7/LQ87+p5F4Dpvq24fYB12qeAxVxaco0Xjvz69XZhKCIjl2KDiU+SeohuDqsrjunfxRBbAclTP23Z32UXawyhlZe1NujfhPB3ctvcSVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659920; c=relaxed/simple;
	bh=WnLbTwpeGdjg6hmA+RvMUdDux1g1DiLi2t99Twi5lEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PTG0svW/zHa+LKsCpORnYVW8CWiLXLV4lyY5xumlrAlmpyS3mLO5r10+j/VN1+9bKe85rBXpP+5VXaj0i0GUPmD5OePHt5BmoNPujxb9VW9cRAo2ylNrkCtxa0QR63wtJFuyn/KRXr2ig8hWmxdJxQK5peXXkMoVsgpoMpG19uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x/g/Gzz6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x/g/Gzz6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1B201F000FF;
	Thu, 17 Sep 2026 15:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659911;
	bh=4sYH7R1f8sW3TWPgYGhjRtisNJSzu2pdy1CMcSgDTkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x/g/Gzz6u/hvz787Vajugizi2/vFFg0AmgCKxyhWHD+RVWG36RWQQp6IvhINh90fA
	 YzktqSDbxuBjAZJXnvr/toHzF6jSMvWQEyMQ1OIrekvwL/LRQJ+AnX27JLVeoMMp4C
	 W86TiEsmOW/ClennCnjvG2+h+3kttqNZ1bT3ZUAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 376/733] Bluetooth: btusb: Fix UAF of btusb_data by rx_work
Date: Thu, 17 Sep 2026 16:11:24 +0100
Message-ID: <20260917151401.029557089@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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
index ed4bf9a478087..53baf56b9dd96 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2074,18 +2074,24 @@ static int btusb_close(struct hci_dev *hdev)
 
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
@@ -2111,7 +2117,7 @@ static int btusb_flush(struct hci_dev *hdev)
 
 	BT_DBG("%s", hdev->name);
 
-	cancel_delayed_work(&data->rx_work);
+	cancel_delayed_work_sync(&data->rx_work);
 
 	skb_queue_purge(&data->acl_q);
 
-- 
2.53.0



