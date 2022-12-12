Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E666328ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:43:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E28F2C43392;
	Mon, 12 Dec 2022 13:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670852581;
	bh=xfJWD5IjMo4LJ2Bh7ac6RqUh6wxQdfK+zB4Yd9HzDag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GD3ezgq6EGu7ys3ktdqOOh1tcS9cPJdvh9ll0iR61V7Fi4yNNgek3vz6gvfoM0dj9
	 5vtm14RbjmKyarc+nMXSUNOykSr+uFabqa8lVl3e38gulEWnXepGYaOa5bSs4AtWuI
	 Dzp1Q8Lgm4YOIIxmQ1gRyrYRsltAHt20ltrHjcBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chethan T N <chethan.tumkur.narayan@intel.com>,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 109/157] Bluetooth: Fix support for Read Local Supported Codecs V2
Date: Mon, 12 Dec 2022 14:17:37 +0100
Message-Id: <20221212130939.225039021@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chethan T N <chethan.tumkur.narayan@intel.com>

[ Upstream commit 828cea2b71de501827f62d3c92d149f6052ad01e ]

Handling of Read Local Supported Codecs was broken during the
HCI serialization design change patches.

Fixes: d0b137062b2d ("Bluetooth: hci_sync: Rework init stages")
Signed-off-by: Chethan T N <chethan.tumkur.narayan@intel.com>
Signed-off-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_codec.c | 19 ++++++++++---------
 net/bluetooth/hci_sync.c  | 10 ++++++----
 2 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/net/bluetooth/hci_codec.c b/net/bluetooth/hci_codec.c
index 38201532f58e..3cc135bb1d30 100644
--- a/net/bluetooth/hci_codec.c
+++ b/net/bluetooth/hci_codec.c
@@ -72,9 +72,8 @@ static void hci_read_codec_capabilities(struct hci_dev *hdev, __u8 transport,
 				continue;
 			}
 
-			skb = __hci_cmd_sync(hdev, HCI_OP_READ_LOCAL_CODEC_CAPS,
-					     sizeof(*cmd), cmd,
-					     HCI_CMD_TIMEOUT);
+			skb = __hci_cmd_sync_sk(hdev, HCI_OP_READ_LOCAL_CODEC_CAPS,
+						sizeof(*cmd), cmd, 0, HCI_CMD_TIMEOUT, NULL);
 			if (IS_ERR(skb)) {
 				bt_dev_err(hdev, "Failed to read codec capabilities (%ld)",
 					   PTR_ERR(skb));
@@ -127,8 +126,8 @@ void hci_read_supported_codecs(struct hci_dev *hdev)
 	struct hci_op_read_local_codec_caps caps;
 	__u8 i;
 
-	skb = __hci_cmd_sync(hdev, HCI_OP_READ_LOCAL_CODECS, 0, NULL,
-			     HCI_CMD_TIMEOUT);
+	skb = __hci_cmd_sync_sk(hdev, HCI_OP_READ_LOCAL_CODECS, 0, NULL,
+				0, HCI_CMD_TIMEOUT, NULL);
 
 	if (IS_ERR(skb)) {
 		bt_dev_err(hdev, "Failed to read local supported codecs (%ld)",
@@ -158,7 +157,8 @@ void hci_read_supported_codecs(struct hci_dev *hdev)
 	for (i = 0; i < std_codecs->num; i++) {
 		caps.id = std_codecs->codec[i];
 		caps.direction = 0x00;
-		hci_read_codec_capabilities(hdev, LOCAL_CODEC_ACL_MASK, &caps);
+		hci_read_codec_capabilities(hdev,
+					    LOCAL_CODEC_ACL_MASK | LOCAL_CODEC_SCO_MASK, &caps);
 	}
 
 	skb_pull(skb, flex_array_size(std_codecs, codec, std_codecs->num)
@@ -178,7 +178,8 @@ void hci_read_supported_codecs(struct hci_dev *hdev)
 		caps.cid = vnd_codecs->codec[i].cid;
 		caps.vid = vnd_codecs->codec[i].vid;
 		caps.direction = 0x00;
-		hci_read_codec_capabilities(hdev, LOCAL_CODEC_ACL_MASK, &caps);
+		hci_read_codec_capabilities(hdev,
+					    LOCAL_CODEC_ACL_MASK | LOCAL_CODEC_SCO_MASK, &caps);
 	}
 
 error:
@@ -194,8 +195,8 @@ void hci_read_supported_codecs_v2(struct hci_dev *hdev)
 	struct hci_op_read_local_codec_caps caps;
 	__u8 i;
 
-	skb = __hci_cmd_sync(hdev, HCI_OP_READ_LOCAL_CODECS_V2, 0, NULL,
-			     HCI_CMD_TIMEOUT);
+	skb = __hci_cmd_sync_sk(hdev, HCI_OP_READ_LOCAL_CODECS_V2, 0, NULL,
+				0, HCI_CMD_TIMEOUT, NULL);
 
 	if (IS_ERR(skb)) {
 		bt_dev_err(hdev, "Failed to read local supported codecs (%ld)",
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 831e816e1d20..a5e89e1b5452 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -12,6 +12,7 @@
 #include <net/bluetooth/mgmt.h>
 
 #include "hci_request.h"
+#include "hci_codec.h"
 #include "hci_debugfs.h"
 #include "smp.h"
 #include "eir.h"
@@ -3918,11 +3919,12 @@ static int hci_set_event_mask_page_2_sync(struct hci_dev *hdev)
 /* Read local codec list if the HCI command is supported */
 static int hci_read_local_codecs_sync(struct hci_dev *hdev)
 {
-	if (!(hdev->commands[29] & 0x20))
-		return 0;
+	if (hdev->commands[45] & 0x04)
+		hci_read_supported_codecs_v2(hdev);
+	else if (hdev->commands[29] & 0x20)
+		hci_read_supported_codecs(hdev);
 
-	return __hci_cmd_sync_status(hdev, HCI_OP_READ_LOCAL_CODECS, 0, NULL,
-				     HCI_CMD_TIMEOUT);
+	return 0;
 }
 
 /* Read local pairing options if the HCI command is supported */
-- 
2.35.1



