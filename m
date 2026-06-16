Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6143546AF3C;
	Tue, 16 Jun 2026 17:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631413; cv=none; b=MQjBHszVaeemQswuXO9QS+XYQYYYL2w3VCIOBZ8Ey9gatS9gsDPf1r2T94Ea36mZLvTHY+2VtNv9tdn+kQx16UFxsPqMK8GNVxkudlXmBaK1dgtgCcgsuhHpetL0NESYoM8EG/E+sbolDCMn19dqf5hvPgyLBJo5IK25STqHBz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631413; c=relaxed/simple;
	bh=Etf3EkTx81CSUDVmbk7j7G7q9HhzE0J7yPNdRXePCfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O7FLqTFpmUk/XTdpq4DHpM1BiwSWkejjdSOhEP0Kb6czjqnsiCKRNvxXXRr+TfJKYtDmd4Z6XHLVHNN40XLTTxsD8+OZcVSo5K2TDgneCo/uzxpr8crW6T2fcBEsHfccm0MJ0VGIZxE5cuX1kIJpd2zprhdFFCYSF9hFC5XLv5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uH0G3DR1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uH0G3DR1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07AF41F000E9;
	Tue, 16 Jun 2026 17:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631412;
	bh=Kkf/R9p99l/vnPPx7je9mcgjklXpt84WEeCbjxb3rhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uH0G3DR1N17+hpB6w63nfUnDXXup/qyrHmMIItA3osbM2S7xZ8RhmTNGe02sDjE3i
	 lSBxGMGN/w5lmgi6AgBm8vA7LABW95J6kvV5d2dOmwMAtV9ygCbCHM5ASzcq058Or2
	 N1gKuI61XSk6AwcFOsbL2APJltfuZxLqRhjQioZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+535ecc844591e50588a5@syzkaller.appspotmail.com,
	Bharath Reddy <kbreddy.rpbc@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 217/522] Bluetooth: fix memory leak in error path of hci_alloc_dev()
Date: Tue, 16 Jun 2026 20:26:04 +0530
Message-ID: <20260616145136.184551162@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bharath Reddy <kbreddy.rpbc@gmail.com>

[ Upstream commit 37b3009bf5976e8ab77c8b9a9bc3bbd7ff49e37f ]

Early failures in Bluetooth HCI UART configuration leak SRCU percpu
memory.

When device initialization fails before hci_register_dev() completes,
the HCI_UNREGISTER flag is never set. As a result, when the device
reference count reaches zero, bt_host_release() evaluates this flag as
false and falls back to a direct kfree(hdev).

Because hci_release_dev() is bypassed, the SRCU struct initialized
early in hci_alloc_dev() is never cleaned up, resulting in a leak of
percpu memory.

Fix the leak by explicitly calling cleanup_srcu_struct() in the
fallback (unregistered) branch of bt_host_release() before freeing
the device.

Reported-by: syzbot+535ecc844591e50588a5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=535ecc844591e50588a5
Tested-by: syzbot+535ecc844591e50588a5@syzkaller.appspotmail.com
Fixes: 1d6123102e9f ("Bluetooth: hci_core: Fix use-after-free in vhci_flush()")
Signed-off-by: Bharath Reddy <kbreddy.rpbc@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sysfs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_sysfs.c b/net/bluetooth/hci_sysfs.c
index cc7d4a8ed8ce24..b1886e517a78bc 100644
--- a/net/bluetooth/hci_sysfs.c
+++ b/net/bluetooth/hci_sysfs.c
@@ -81,10 +81,12 @@ static void bt_host_release(struct device *dev)
 {
 	struct hci_dev *hdev = to_hci_dev(dev);
 
-	if (hci_dev_test_flag(hdev, HCI_UNREGISTER))
+	if (hci_dev_test_flag(hdev, HCI_UNREGISTER)) {
 		hci_release_dev(hdev);
-	else
+	} else {
+		cleanup_srcu_struct(&hdev->srcu);
 		kfree(hdev);
+	}
 	module_put(THIS_MODULE);
 }
 
-- 
2.53.0



