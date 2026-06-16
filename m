Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E18F44CF37;
	Tue, 16 Jun 2026 16:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626644; cv=none; b=KOMWZJNCeTF5gY3OinQdJSF0R4kwz9bHgZlgunv0W09cuxtMTb2kZqIB7AcebeRrZJ39BoRKGWAElmw7Ww2Q4P15Cb/qPGNQGcdOO/vWpionImzjpwQrChNIBQHCFGmHdu1NzBjIAxbRXbm3aXXmI6JXc92hvY1zPs3hQOoZkz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626644; c=relaxed/simple;
	bh=gig89fDRTYDUI3Z68eeTdhsqEmjxejbs9ucJlFFpzv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W3KyIlQqpydIqEFEOAHLCJweikoNZUTQqSjI4D/u/CCQ7E8+eav5Zm0MhSb4ihUyoR4hp615CXkeKBeSxD0fEDYw5c0FoU2CJuZIl3sYV/dAft6RQGAvYoEw63Pc3AByQWbuV/QUlRlBQW0qhaGNpn4ln9fmLxVwt1e11CNQGfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JjsjMkaK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JjsjMkaK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C88D1F000E9;
	Tue, 16 Jun 2026 16:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626643;
	bh=6OxZ98e3rlaqXqhm3bBxfkMtLfmzfm5ikOHG79O81Js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JjsjMkaK7TfUKqQHjG7Jq4nknWOHIpgzjSCDFr8S74BclZPkDWO8R4gKhutlBUFHA
	 UOckG59c5bKv+tY4sUDhO943Myho7bJjS7ERGAGEwKreKYf4LrBV6a6ag37aZpt7+y
	 YvWBKVvTemNZMndX/EjL5ToGnuI+yDwt/zhrk7eM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+535ecc844591e50588a5@syzkaller.appspotmail.com,
	Bharath Reddy <kbreddy.rpbc@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 042/261] Bluetooth: fix memory leak in error path of hci_alloc_dev()
Date: Tue, 16 Jun 2026 20:28:00 +0530
Message-ID: <20260616145047.060674320@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4b54dbbf0729a3..60350c6723cb76 100644
--- a/net/bluetooth/hci_sysfs.c
+++ b/net/bluetooth/hci_sysfs.c
@@ -83,10 +83,12 @@ static void bt_host_release(struct device *dev)
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



