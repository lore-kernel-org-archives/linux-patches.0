Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8E21845
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jFsV7iMC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6DA0C433CB;
	Mon, 23 Oct 2023 11:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698058884;
	bh=it2SWKvcYpEIOySHF5yTzSd9WGXfUHUXMydg4C5XmV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jFsV7iMC1b5QGCxvJQ3bvUrZnglQEVFlQTCT1GLEXxcyzOcYhhXI0wgxpZSk4n17/
	 gIT7jvvGgE9xNFeG/XoV1tdinXVteSVqniZ/+/D4X8zpwBE/+aFbMvvlf4iIFoKgv3
	 P43In0F/R5CQ4vK/2JTlHAnMzC5SG7Am/RUyCGsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 51/66] Bluetooth: hci_core: Fix build warnings
Date: Mon, 23 Oct 2023 12:56:41 +0200
Message-ID: <20231023104812.741873467@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104810.781270702@linuxfoundation.org>
References: <20231023104810.781270702@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit dcda165706b9fbfd685898d46a6749d7d397e0c0 ]

This fixes the following warnings:

net/bluetooth/hci_core.c: In function ‘hci_register_dev’:
net/bluetooth/hci_core.c:2620:54: warning: ‘%d’ directive output may
be truncated writing between 1 and 10 bytes into a region of size 5
[-Wformat-truncation=]
 2620 |         snprintf(hdev->name, sizeof(hdev->name), "hci%d", id);
      |                                                      ^~
net/bluetooth/hci_core.c:2620:50: note: directive argument in the range
[0, 2147483647]
 2620 |         snprintf(hdev->name, sizeof(hdev->name), "hci%d", id);
      |                                                  ^~~~~~~
net/bluetooth/hci_core.c:2620:9: note: ‘snprintf’ output between 5 and
14 bytes into a destination of size 8
 2620 |         snprintf(hdev->name, sizeof(hdev->name), "hci%d", id);
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_core.h | 2 +-
 net/bluetooth/hci_core.c         | 8 +++++---
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index d42288a06af61..8f899ad4a7546 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -205,7 +205,7 @@ struct hci_dev {
 	struct list_head list;
 	struct mutex	lock;
 
-	char		name[8];
+	const char	*name;
 	unsigned long	flags;
 	__u16		id;
 	__u8		bus;
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 7052434c1061f..2bf0bdee7186d 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3113,7 +3113,11 @@ int hci_register_dev(struct hci_dev *hdev)
 	if (id < 0)
 		return id;
 
-	snprintf(hdev->name, sizeof(hdev->name), "hci%d", id);
+	error = dev_set_name(&hdev->dev, "hci%u", id);
+	if (error)
+		return error;
+
+	hdev->name = dev_name(&hdev->dev);
 	hdev->id = id;
 
 	BT_DBG("%p name %s bus %d", hdev, hdev->name, hdev->bus);
@@ -3135,8 +3139,6 @@ int hci_register_dev(struct hci_dev *hdev)
 	if (!IS_ERR_OR_NULL(bt_debugfs))
 		hdev->debugfs = debugfs_create_dir(hdev->name, bt_debugfs);
 
-	dev_set_name(&hdev->dev, "%s", hdev->name);
-
 	error = device_add(&hdev->dev);
 	if (error < 0)
 		goto err_wqueue;
-- 
2.40.1



