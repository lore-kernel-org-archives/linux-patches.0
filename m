Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF7015E87
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qvnkawcG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D11BC433C7;
	Mon, 23 Oct 2023 11:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060789;
	bh=kUGEyMCGZtEsAOLP4J1NDSqju0KB7GSr0HWrG1w0hVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qvnkawcGx1JCnPKCn/L8IEXiJxPyt86p+SM3NXy2EeA8kMmQ/WurIkgwfsnjCc9YK
	 gRNg25+t6U4Gz7L3etul77PvJeClDboa36M/Sp04wqRVJNSlqCa9QwJJEgpO/zk6IN
	 oWzmvdYUO0PBfuKrImoqa6nlznjHH0i4jx7OEHXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 093/123] Bluetooth: hci_core: Fix build warnings
Date: Mon, 23 Oct 2023 12:57:31 +0200
Message-ID: <20231023104820.811785294@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104817.691299567@linuxfoundation.org>
References: <20231023104817.691299567@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index ecad25900ad78..b54f17677ac0c 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -219,7 +219,7 @@ struct hci_dev {
 	struct list_head list;
 	struct mutex	lock;
 
-	char		name[8];
+	const char	*name;
 	unsigned long	flags;
 	__u16		id;
 	__u8		bus;
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 21469934fc3c0..54c55c30db17b 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3317,7 +3317,11 @@ int hci_register_dev(struct hci_dev *hdev)
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
@@ -3339,8 +3343,6 @@ int hci_register_dev(struct hci_dev *hdev)
 	if (!IS_ERR_OR_NULL(bt_debugfs))
 		hdev->debugfs = debugfs_create_dir(hdev->name, bt_debugfs);
 
-	dev_set_name(&hdev->dev, "%s", hdev->name);
-
 	error = device_add(&hdev->dev);
 	if (error < 0)
 		goto err_wqueue;
-- 
2.40.1



