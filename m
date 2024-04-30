Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C4E12B176;
	Tue, 30 Apr 2024 10:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474211; cv=none; b=ZHVv3mgxkVFfNrkz7xsMIQj+dt/CU8rV+OWAfqOk+v1rEdWg9jwdm5adJHVYMJhbAPRVhToKLz3Cc9Xv8txIerMxkhjrVgudJlkIrde9m1XwM+iadVDUes8BA5Xw7xDpzWvUtrgazjYyTxLzo2tt3GEH8MD6WSmdDPRPE+IDMw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474211; c=relaxed/simple;
	bh=0MvhvPI2mi2P7YjGhCXWkCncm7S5Wss6+8NjzwZu5zA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nzTp7NWV78jnVQmNcsS7Z8MQN6O3f+MHQYDHPei99/CxsZIWEOX8jRnazVBNf1GbUNNjY0CectbknWorz8RpoAU8gcw4UkXW0sn2/uiESs7bldc4njwYnpuSuNPK2umDwmsJ+Tc4mceAYtrN7fWTCGnDyaoiy3/WJvJ3lZPs6zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gnj+cs/5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gnj+cs/5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6C16C2BBFC;
	Tue, 30 Apr 2024 10:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474211;
	bh=0MvhvPI2mi2P7YjGhCXWkCncm7S5Wss6+8NjzwZu5zA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gnj+cs/5Y3dlSUk0hHKHYyBbCg94uXuxhtRoxSkfbuc8+/q9C2vy+EAKziXwknOns
	 4EFVLvHZidYbnRK3ZkZapuylvjNxMugFwixvEGPCj9xRnAnwp6Io+MFSH4Uvb2Dwm5
	 OUtmLsnAUwXHC7OLjEAs8KWU6Yhm6xASf1qPU68o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Wang <sean.wang@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 089/228] Bluetooth: btusb: mediatek: Fix double free of skb in coredump
Date: Tue, 30 Apr 2024 12:37:47 +0200
Message-ID: <20240430103106.371852475@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit 18bdb386a1a30e7a3d7732a98e45e69cf6b5710d ]

hci_devcd_append() would free the skb on error so the caller don't
have to free it again otherwise it would cause the double free of skb.

Fixes: 0b7015132878 ("Bluetooth: btusb: mediatek: add MediaTek devcoredump support")
Reported-by : Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtk.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/bluetooth/btmtk.c b/drivers/bluetooth/btmtk.c
index ac8ebccd35075..812fd2a8f853e 100644
--- a/drivers/bluetooth/btmtk.c
+++ b/drivers/bluetooth/btmtk.c
@@ -380,8 +380,10 @@ int btmtk_process_coredump(struct hci_dev *hdev, struct sk_buff *skb)
 	switch (data->cd_info.state) {
 	case HCI_DEVCOREDUMP_IDLE:
 		err = hci_devcd_init(hdev, MTK_COREDUMP_SIZE);
-		if (err < 0)
+		if (err < 0) {
+			kfree_skb(skb);
 			break;
+		}
 		data->cd_info.cnt = 0;
 
 		/* It is supposed coredump can be done within 5 seconds */
@@ -407,9 +409,6 @@ int btmtk_process_coredump(struct hci_dev *hdev, struct sk_buff *skb)
 		break;
 	}
 
-	if (err < 0)
-		kfree_skb(skb);
-
 	return err;
 }
 EXPORT_SYMBOL_GPL(btmtk_process_coredump);
-- 
2.43.0



