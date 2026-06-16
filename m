Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD730466B5D;
	Tue, 16 Jun 2026 18:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634090; cv=none; b=jxclCv8ysySUBvRwhoXmD10bvsAAb/4h15Gsd/7HmNHc1W5kgOjzkajL9+hu75oDahRfrv8BIubFIFs8FBtZHBg35391AVFXsmx1GlBBtRoCyzGmIKHAwKdC4msCfnhz3nYoKLobA0Z+5bfjza5YzmAtlYkMB/Yfa+nzxaINuSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634090; c=relaxed/simple;
	bh=UFW123sAkX8D8mLv4T26/RK6RVov0pMrSppoV7wWf2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dq9GPafGwaIKmDRnFm6Ajt6JRPyfPoFCYHDHNev4DU0+K5bGjD4XgNFSTqbnONVdZ4WefnWXZkvFwj/OsYcUcLfZAWFfWfgxNQ+h1lMA8dL37euAPhsLa7ZgUrJMNcNiJPiVxIPGW5lNcCNTqOxHFw4Z8U3aEzi0guM4YKe7OF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tt9sxVLg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tt9sxVLg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A023A1F000E9;
	Tue, 16 Jun 2026 18:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634089;
	bh=djkMczJou+fvfkQ6/y1SL4gEa4gYkC5XYTBmO2egKyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tt9sxVLgygiLTutDHKD0MaTRPWyGViegw5bvxJfodmGsw9OOS/VZf+Nokv8YMHP7P
	 03q7uHxyBTnH9vrU25OXgyWby49bq0v8OPe0a4n0hEqGPY2TY+uA8VAH93QtrIYMk7
	 NM4neCdPgLONDGsNZp2+O4YlbvW/jmDKlELzwLVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+535ecc844591e50588a5@syzkaller.appspotmail.com,
	Bharath Reddy <kbreddy.rpbc@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 167/411] Bluetooth: fix memory leak in error path of hci_alloc_dev()
Date: Tue, 16 Jun 2026 20:26:45 +0530
Message-ID: <20260616145109.477970021@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



