Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0514512CDB0;
	Tue, 23 Jan 2024 00:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968972; cv=none; b=kIYuZpFpxjjs0rliun/izFr+p+oqbmZuqm32fF5iOVWJVr7kRPmymmVvVSUD2sN8ElIKROoI0HIphBc31wjbnjxTxBCwkwj6zKyuofzwAAasgjNR8Nn/q+ONc9KzBmYWu11VkF4a0tYjmLpb6/yz4+f570G1mQ44bOuICgF7lCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968972; c=relaxed/simple;
	bh=T/oxLGwwrC1ozeFbKBP0Apar2Mx/tw1U2LP1/muZMkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P5yQHpWjcGbIb9R+JVZ3mRAlvuptLCp5x4JJv4MQQDu9wNh6jKJXrUOighvWyBMVve55klD4NWkWbiEAaQmDJ6jrFoSKWuh8eIxO77EPbRKKCBW3iTT7HyXDlZjOOf7/I+MwDQNNPCmjJ4svdzpRleZkQMuXfnsde14Hg6PEvdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0FNU8hE9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0FNU8hE9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2430EC433C7;
	Tue, 23 Jan 2024 00:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968971;
	bh=T/oxLGwwrC1ozeFbKBP0Apar2Mx/tw1U2LP1/muZMkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0FNU8hE9Wrtm8XC2uQsYXr9Ypx6aGU9KlkO8IY0Rn17bvNU1eYzgzymTVEU53zQyW
	 xIJ2gPXjuZvpd4fEGs0sEyU3LDRG7HZDOyXwrXBWkwvr5XfAgpvxjVK7TIIsnwT7Tv
	 LYvDJsakNxXXOxSHbBuQMdXAiNoeBTa3S0iGTacU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 106/194] Bluetooth: btmtkuart: fix recv_buf() return value
Date: Mon, 22 Jan 2024 15:57:16 -0800
Message-ID: <20240122235723.794369437@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 2beb2321825e..e7e3c8e0ed0e 100644
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



