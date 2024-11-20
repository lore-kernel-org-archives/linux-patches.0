Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE77B1A706A;
	Wed, 20 Nov 2024 13:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107658; cv=none; b=A7dgmQKoAg00XNA0W4K76hL4v/VfHIn7gQKuVtF6SkgueAIPJdBxHrdsJwcc3qFI0H4Dd1jlh+2JKftnnN2MkEGQ8VVVm3WsKcP0DYAyKRSiwksplRIqczapJn/SnTx4ozM76folQfbw8LXl12WszJ0MAotPtBXDdg9jEEkBJ4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107658; c=relaxed/simple;
	bh=420ILLjjxPtgWxdNwkRHMQm0ju6Bze0GGyAMDWXCwP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pm0HKsKCq3UhMz5ZwVLgYVUxxDcP1zXeedRAeNWEYCnxRQgs2m/2FJZPo7jCqneYmFHv8pAKBbgD6YeqfRWhQ+ozXYVzNuMUb6i39+nEuwNxcq4QRXbjbX/bmKgY9iCuW11HHdmKGf4TyKNo/sKdZzxCIsdhVO2WajnR25Vkn9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oaeO7ClN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oaeO7ClN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E780C4AF4D;
	Wed, 20 Nov 2024 13:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107658;
	bh=420ILLjjxPtgWxdNwkRHMQm0ju6Bze0GGyAMDWXCwP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oaeO7ClNoe6rExLr+tau4Dv/o4jeZqgiuwEc7HuLtRJmM6BScGxcBn1U0IvVw2mUm
	 GJg/CxcvGw8g8u8y2ZOLRVUmqXpIO1ocgyIlobnrqxqWZQdRK5iLxOFWEWQOmTSvMh
	 dVZ5T/aZhd9G9cL/LKS5DzVCCyereweubXBFP65Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 10/73] Bluetooth: hci_core: Fix calling mgmt_device_connected
Date: Wed, 20 Nov 2024 13:57:56 +0100
Message-ID: <20241120125809.874103790@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>
References: <20241120125809.623237564@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 7967dc8f797f454d4f4acec15c7df0cdf4801617 ]

Since 61a939c68ee0 ("Bluetooth: Queue incoming ACL data until
BT_CONNECTED state is reached") there is no long the need to call
mgmt_device_connected as ACL data will be queued until BT_CONNECTED
state.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=219458
Link: https://github.com/bluez/bluez/issues/1014
Fixes: 333b4fd11e89 ("Bluetooth: L2CAP: Fix uaf in l2cap_connect")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index f93f3e7a3d905..789f7f4a09089 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3846,8 +3846,6 @@ static void hci_acldata_packet(struct hci_dev *hdev, struct sk_buff *skb)
 
 	hci_dev_lock(hdev);
 	conn = hci_conn_hash_lookup_handle(hdev, handle);
-	if (conn && hci_dev_test_flag(hdev, HCI_MGMT))
-		mgmt_device_connected(hdev, conn, NULL, 0);
 	hci_dev_unlock(hdev);
 
 	if (conn) {
-- 
2.43.0



