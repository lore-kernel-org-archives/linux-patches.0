Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9753459B62;
	Tue, 23 Jan 2024 01:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974111; cv=none; b=aIoD/opKZXgUU64s8lY4slrHdEJoGUB3B54s5csB/Pa6CN3rn6vzdu/yv9C02HlWzlD/sW0xwpeWaDUYi42tCdqz5NXir1DRqiUELLkmNU59ztDWo3CVwKE/qOKjyOn0y6JRbwX5E1CODReWF7NwAWe9TVWKUyZwCONGzCHc0GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974111; c=relaxed/simple;
	bh=73MDIsAPft4HQX8jFLKQPHckBgeRwkx62YzsLMGXKtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M/uviGvq848QjmxZtFFvQXiA/oNj4VI0/Ik6RVnrvJsldUVJV6Gt7fwa6ZO0bpSRcFXMyuC9JtjkDLpTMlCcTS0SXOUMcdHXE7MHh9XWQSbMuyKp4XYps0tOVCyue5RnbFsKuS1VfNPzDg0NBcA1o/qnTdf3O0/TVGcztfV/QSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TusC+FhU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TusC+FhU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C22CC43394;
	Tue, 23 Jan 2024 01:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974111;
	bh=73MDIsAPft4HQX8jFLKQPHckBgeRwkx62YzsLMGXKtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TusC+FhUPn55kK6vHZ0hKZuboO9NYOJbyWN5JNgEI67Irvf358hgQsoEBx8IL0soR
	 RVPYpV/hOs1HlxLN22isk1mJlH9us2iFjZsH4kXCDmckVpB8sEuVF5QtCMYJoDEET/
	 q64+TU+nqXPy2+8hx8TBsZ9kBjE13U3cUSsTTEuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 167/374] Bluetooth: btmtkuart: fix recv_buf() return value
Date: Mon, 22 Jan 2024 15:57:03 -0800
Message-ID: <20240122235750.429483135@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9ba22b13b4fa..a831d734cd9e 100644
--- a/drivers/bluetooth/btmtkuart.c
+++ b/drivers/bluetooth/btmtkuart.c
@@ -471,7 +471,7 @@ mtk_stp_split(struct btmtkuart_dev *bdev, const unsigned char *data, int count,
 	return data;
 }
 
-static int btmtkuart_recv(struct hci_dev *hdev, const u8 *data, size_t count)
+static void btmtkuart_recv(struct hci_dev *hdev, const u8 *data, size_t count)
 {
 	struct btmtkuart_dev *bdev = hci_get_drvdata(hdev);
 	const unsigned char *p_left = data, *p_h4;
@@ -510,25 +510,20 @@ static int btmtkuart_recv(struct hci_dev *hdev, const u8 *data, size_t count)
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



