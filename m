Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A25012A167;
	Tue, 23 Jan 2024 00:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971047; cv=none; b=A7oXU9ugDz1wWcySUFOUciJWSYOlmna93j7ZnZzA98KclxR7XRFJF8+6BvFeKIlTZDV1P1Ii4apGIFFuN+4h4mTBcSP6MN7GDxKCwXZQSI8c0iqMA8X/N3IpPqn4GFTSLta319CNoq7k5WiAivlZTX7RxokY9YcqeRqNSMQustc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971047; c=relaxed/simple;
	bh=wd6XJhc6LtuFnhRuuFZoIQsFOz6BpovgapUIBMsnp+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fbHFA/aqUGfMNiaDKYWpB8xqS13/igzg/nUbFde0vD/ak7OpLETcV/toGIT/ZhRkcNSBt8TiPFlpTgoHUo4lsKunsN6qFqHy4bswKJNzQIOJvEDb4t4cwYxIE9Vj+6VTET76CDdgG3MtMN8Z+pELn29pHmMDrOEUVlEmBxMez/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b7e0fSns; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b7e0fSns"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A4A4C43390;
	Tue, 23 Jan 2024 00:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971047;
	bh=wd6XJhc6LtuFnhRuuFZoIQsFOz6BpovgapUIBMsnp+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b7e0fSnsRZPiEl1mvBz2m6l6ZjDQCFZQqH9mx8LSTUl/TbYIVOXOtDOJxyHq66Cvp
	 sOkCNn/NoIdP+53o7oF30GXeW4PkGqTt1eaD7ESZz8eZ3QkBrdQht4N7vpzIFZFWL7
	 YPp5jvaCsdIZ9cvmQX0IUdL+D76uPvZgf8W40VAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 145/417] Bluetooth: btmtkuart: fix recv_buf() return value
Date: Mon, 22 Jan 2024 15:55:13 -0800
Message-ID: <20240122235756.856716415@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francesco Dolcini <francesco.dolcini@toradex.com>

[ Upstream commit 64057f051f20c2a2184b9db7f8037d928d68a4f4 ]

Serdev recv_buf() callback is supposed to return the amount of bytes
consumed, therefore an int in between 0 and count.

Do not return negative number in case of issue, just print an error and
return count. This fixes a WARN in ttyport_receive_buf().

Link: https://lore.kernel.org/all/087be419-ec6b-47ad-851a-5e1e3ea5cfcc@kernel.org/
Fixes: 7237c4c9ec92 ("Bluetooth: mediatek: Add protocol support for MediaTek serial devices")
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtkuart.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/bluetooth/btmtkuart.c b/drivers/bluetooth/btmtkuart.c
index c98691cdbbd5..04b72394dda5 100644
--- a/drivers/bluetooth/btmtkuart.c
+++ b/drivers/bluetooth/btmtkuart.c
@@ -337,7 +337,7 @@ mtk_stp_split(struct btmtkuart_dev *bdev, const unsigned char *data, int count,
 	return data;
 }
 
-static int btmtkuart_recv(struct hci_dev *hdev, const u8 *data, size_t count)
+static void btmtkuart_recv(struct hci_dev *hdev, const u8 *data, size_t count)
 {
 	struct btmtkuart_dev *bdev = hci_get_drvdata(hdev);
 	const unsigned char *p_left = data, *p_h4;
@@ -376,25 +376,20 @@ static int btmtkuart_recv(struct hci_dev *hdev, const u8 *data, size_t count)
 			bt_dev_err(bdev->hdev,
 				   "Frame reassembly failed (%d)", err);
 			bdev->rx_skb = NULL;
-			return err;
+			return;
 		}
 
 		sz_left -= sz_h4;
 		p_left += sz_h4;
 	}
-
-	return 0;
 }
 
 static int btmtkuart_receive_buf(struct serdev_device *serdev, const u8 *data,
 				 size_t count)
 {
 	struct btmtkuart_dev *bdev = serdev_device_get_drvdata(serdev);
-	int err;
 
-	err = btmtkuart_recv(bdev->hdev, data, count);
-	if (err < 0)
-		return err;
+	btmtkuart_recv(bdev->hdev, data, count);
 
 	bdev->hdev->stat.byte_rx += count;
 
-- 
2.43.0



