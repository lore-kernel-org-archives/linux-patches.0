Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124FD189BB0;
	Sun,  7 Sep 2025 20:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276513; cv=none; b=nL1CZtWuB3kkZC2eLKDMBWOkps76HQAYpPTnRzxkHKUc997jAWRjs6QP+xoD1ZlJUi9b3EZiYdGXJlw8U7IphIbBGidaeOXVhA8QZTs3X2DVSvldrmFeWllzj/HLYCLiW6x22IpU3Bn4w45IF0sPJzh24vS/fVUwGZDSm1hXAB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276513; c=relaxed/simple;
	bh=vlFZ+r7s4A6xI2POb9cJbPD9ZVUFBRrUgw4qkRRyFCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b5TREOwkTMpy9Tr+K1D1oCaCdyEcsAlWZ05J5vXuNOt/FS4fDmVfdP20QTPyfYryEMOO6sCpL9l4761cHQSb3btqX4T2ij+kuZNmVoLdLLxcP2h4RtscpetyWe6v3Xfp1nD2hvWf9Iy34OJsYZAzk4fI2OYAHQXyoEOGNkipNfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xjafhVbd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xjafhVbd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E11C4CEF0;
	Sun,  7 Sep 2025 20:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276512;
	bh=vlFZ+r7s4A6xI2POb9cJbPD9ZVUFBRrUgw4qkRRyFCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xjafhVbdGfqx0wsDQcxrPQWwJqrHT6K31Jlt/xWcM5n3yw0fnnRs0/MXY6MfXPTCq
	 MjKu0crwQeiF/hZ/c/r50L91X+bSX7wCMbedyiD6iNUEQr+7kCNuu5t1J2sv4nmEY1
	 mQKuWfdNRhtqLYo3cRqoKXAtshmtMOHuNA3LMOYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Pravdin <ipravdin.official@gmail.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 023/121] Bluetooth: vhci: Prevent use-after-free by removing debugfs files early
Date: Sun,  7 Sep 2025 21:57:39 +0200
Message-ID: <20250907195610.412520163@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Pravdin <ipravdin.official@gmail.com>

[ Upstream commit 28010791193a4503f054e8d69a950ef815deb539 ]

Move the creation of debugfs files into a dedicated function, and ensure
they are explicitly removed during vhci_release(), before associated
data structures are freed.

Previously, debugfs files such as "force_suspend", "force_wakeup", and
others were created under hdev->debugfs but not removed in
vhci_release(). Since vhci_release() frees the backing vhci_data
structure, any access to these files after release would result in
use-after-free errors.

Although hdev->debugfs is later freed in hci_release_dev(), user can
access files after vhci_data is freed but before hdev->debugfs is
released.

Fixes: ab4e4380d4e1 ("Bluetooth: Add vhci devcoredump support")
Signed-off-by: Ivan Pravdin <ipravdin.official@gmail.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_vhci.c | 57 ++++++++++++++++++++++++++----------
 1 file changed, 41 insertions(+), 16 deletions(-)

diff --git a/drivers/bluetooth/hci_vhci.c b/drivers/bluetooth/hci_vhci.c
index 4bfc78f9781ed..0935045051699 100644
--- a/drivers/bluetooth/hci_vhci.c
+++ b/drivers/bluetooth/hci_vhci.c
@@ -380,6 +380,28 @@ static const struct file_operations force_devcoredump_fops = {
 	.write		= force_devcd_write,
 };
 
+static void vhci_debugfs_init(struct vhci_data *data)
+{
+	struct hci_dev *hdev = data->hdev;
+
+	debugfs_create_file("force_suspend", 0644, hdev->debugfs, data,
+			    &force_suspend_fops);
+
+	debugfs_create_file("force_wakeup", 0644, hdev->debugfs, data,
+			    &force_wakeup_fops);
+
+	if (IS_ENABLED(CONFIG_BT_MSFTEXT))
+		debugfs_create_file("msft_opcode", 0644, hdev->debugfs, data,
+				    &msft_opcode_fops);
+
+	if (IS_ENABLED(CONFIG_BT_AOSPEXT))
+		debugfs_create_file("aosp_capable", 0644, hdev->debugfs, data,
+				    &aosp_capable_fops);
+
+	debugfs_create_file("force_devcoredump", 0644, hdev->debugfs, data,
+			    &force_devcoredump_fops);
+}
+
 static int __vhci_create_device(struct vhci_data *data, __u8 opcode)
 {
 	struct hci_dev *hdev;
@@ -435,22 +457,8 @@ static int __vhci_create_device(struct vhci_data *data, __u8 opcode)
 		return -EBUSY;
 	}
 
-	debugfs_create_file("force_suspend", 0644, hdev->debugfs, data,
-			    &force_suspend_fops);
-
-	debugfs_create_file("force_wakeup", 0644, hdev->debugfs, data,
-			    &force_wakeup_fops);
-
-	if (IS_ENABLED(CONFIG_BT_MSFTEXT))
-		debugfs_create_file("msft_opcode", 0644, hdev->debugfs, data,
-				    &msft_opcode_fops);
-
-	if (IS_ENABLED(CONFIG_BT_AOSPEXT))
-		debugfs_create_file("aosp_capable", 0644, hdev->debugfs, data,
-				    &aosp_capable_fops);
-
-	debugfs_create_file("force_devcoredump", 0644, hdev->debugfs, data,
-			    &force_devcoredump_fops);
+	if (!IS_ERR_OR_NULL(hdev->debugfs))
+		vhci_debugfs_init(data);
 
 	hci_skb_pkt_type(skb) = HCI_VENDOR_PKT;
 
@@ -652,6 +660,21 @@ static int vhci_open(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static void vhci_debugfs_remove(struct hci_dev *hdev)
+{
+	debugfs_lookup_and_remove("force_suspend", hdev->debugfs);
+
+	debugfs_lookup_and_remove("force_wakeup", hdev->debugfs);
+
+	if (IS_ENABLED(CONFIG_BT_MSFTEXT))
+		debugfs_lookup_and_remove("msft_opcode", hdev->debugfs);
+
+	if (IS_ENABLED(CONFIG_BT_AOSPEXT))
+		debugfs_lookup_and_remove("aosp_capable", hdev->debugfs);
+
+	debugfs_lookup_and_remove("force_devcoredump", hdev->debugfs);
+}
+
 static int vhci_release(struct inode *inode, struct file *file)
 {
 	struct vhci_data *data = file->private_data;
@@ -663,6 +686,8 @@ static int vhci_release(struct inode *inode, struct file *file)
 	hdev = data->hdev;
 
 	if (hdev) {
+		if (!IS_ERR_OR_NULL(hdev->debugfs))
+			vhci_debugfs_remove(hdev);
 		hci_unregister_dev(hdev);
 		hci_free_dev(hdev);
 	}
-- 
2.50.1



