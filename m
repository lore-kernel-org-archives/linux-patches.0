Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA08F13D2B7;
	Tue, 14 May 2024 10:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683334; cv=none; b=Cnf/WtSfaYrSxQup5mQt2QnbDy0SaIsXxTgF9k0p3V8DGogmTukjG6lzmqkbSiO6WyxHKmDeuLBv9994JrgNwgvX/vNTmyVMpgF2WaDNUdcBDQfr54d0F1Mp5cbvWOv47NAHW3kW2ed4vNLfcyiJwXr6/QP22+D1Ad11xAXwtXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683334; c=relaxed/simple;
	bh=KxM0Y63EV3dkJ8MZzzqlJkkEG2uVu/jn3A7hnThh3o4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nv5adSZzhGDcSJ5mjPdbtEN/IvnQNyaVAJTDzAxg0dNi1IIjPGKWRuzfgDYkGiFR78/PltXDuZ6acTRLiSQF0SalHWflkkdb6OiC9QkypXQTIXfZNrWAwMwn6gaRB/5DKq7aw8iiWX3HLAoYKZxefBe9SBsNKVKQfrJZVQJ+pDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZuJzX6DL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZuJzX6DL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02DCDC2BD10;
	Tue, 14 May 2024 10:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683334;
	bh=KxM0Y63EV3dkJ8MZzzqlJkkEG2uVu/jn3A7hnThh3o4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZuJzX6DLoqdRr6EtpWqrPuLGuKMs5N5EfHHsDQd8rWHgYlVuMmKGwcYSBuDEIyO8t
	 yMHG8Lj/qNwQ4uLCgZGK4X6Q3/9PjCtQNcJycqVHYDhvPc1MyLWZhlLqy2c+8zEYFv
	 Y+r/duutRUa+n9I6382xSyf+REllkjEJnlgFqGFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sungwoo Kim <iam@sung-woo.kim>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 201/336] Bluetooth: msft: fix slab-use-after-free in msft_do_close()
Date: Tue, 14 May 2024 12:16:45 +0200
Message-ID: <20240514101046.192524798@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

From: Sungwoo Kim <iam@sung-woo.kim>

[ Upstream commit 10f9f426ac6e752c8d87bf4346930ba347aaabac ]

Tying the msft->data lifetime to hdev by freeing it in
hci_release_dev() to fix the following case:

[use]
msft_do_close()
  msft = hdev->msft_data;
  if (!msft)                      ...(1) <- passed.
    return;
  mutex_lock(&msft->filter_lock); ...(4) <- used after freed.

[free]
msft_unregister()
  msft = hdev->msft_data;
  hdev->msft_data = NULL;         ...(2)
  kfree(msft);                    ...(3) <- msft is freed.

==================================================================
BUG: KASAN: slab-use-after-free in __mutex_lock_common
kernel/locking/mutex.c:587 [inline]
BUG: KASAN: slab-use-after-free in __mutex_lock+0x8f/0xc30
kernel/locking/mutex.c:752
Read of size 8 at addr ffff888106cbbca8 by task kworker/u5:2/309

Fixes: bf6a4e30ffbd ("Bluetooth: disable advertisement filters during suspend")
Signed-off-by: Sungwoo Kim <iam@sung-woo.kim>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 3 +--
 net/bluetooth/msft.c     | 2 +-
 net/bluetooth/msft.h     | 4 ++--
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 0592369579ab2..befe645d3f9bf 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2736,8 +2736,6 @@ void hci_unregister_dev(struct hci_dev *hdev)
 
 	hci_unregister_suspend_notifier(hdev);
 
-	msft_unregister(hdev);
-
 	hci_dev_do_close(hdev);
 
 	if (!test_bit(HCI_INIT, &hdev->flags) &&
@@ -2791,6 +2789,7 @@ void hci_release_dev(struct hci_dev *hdev)
 	hci_discovery_filter_clear(hdev);
 	hci_blocked_keys_clear(hdev);
 	hci_codec_list_clear(&hdev->local_codecs);
+	msft_release(hdev);
 	hci_dev_unlock(hdev);
 
 	ida_destroy(&hdev->unset_handle_ida);
diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
index 9612c5d1b13f6..d039683d3bdd4 100644
--- a/net/bluetooth/msft.c
+++ b/net/bluetooth/msft.c
@@ -769,7 +769,7 @@ void msft_register(struct hci_dev *hdev)
 	mutex_init(&msft->filter_lock);
 }
 
-void msft_unregister(struct hci_dev *hdev)
+void msft_release(struct hci_dev *hdev)
 {
 	struct msft_data *msft = hdev->msft_data;
 
diff --git a/net/bluetooth/msft.h b/net/bluetooth/msft.h
index 2a63205b377b7..fe538e9c91c01 100644
--- a/net/bluetooth/msft.h
+++ b/net/bluetooth/msft.h
@@ -14,7 +14,7 @@
 
 bool msft_monitor_supported(struct hci_dev *hdev);
 void msft_register(struct hci_dev *hdev);
-void msft_unregister(struct hci_dev *hdev);
+void msft_release(struct hci_dev *hdev);
 void msft_do_open(struct hci_dev *hdev);
 void msft_do_close(struct hci_dev *hdev);
 void msft_vendor_evt(struct hci_dev *hdev, void *data, struct sk_buff *skb);
@@ -35,7 +35,7 @@ static inline bool msft_monitor_supported(struct hci_dev *hdev)
 }
 
 static inline void msft_register(struct hci_dev *hdev) {}
-static inline void msft_unregister(struct hci_dev *hdev) {}
+static inline void msft_release(struct hci_dev *hdev) {}
 static inline void msft_do_open(struct hci_dev *hdev) {}
 static inline void msft_do_close(struct hci_dev *hdev) {}
 static inline void msft_vendor_evt(struct hci_dev *hdev, void *data,
-- 
2.43.0



