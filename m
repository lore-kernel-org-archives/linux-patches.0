Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F8E4315A;
	Sun,  7 Sep 2025 20:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277545; cv=none; b=LiQ2+SDrSO+kytwprOn45n0deOmSndROBeMhOwzZYC58uRjn+M7gj5vJyWPsZcKphJc/iBr8anKXBl4fWP7HzVHK5nBZQWSwziSmQp7I9Hx8kbGfYC9YpujN0wsrxZ0S/gYknp4LYJ6PGIl/RoCwnPn1CpgHJ2NJDJF3FAsFxAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277545; c=relaxed/simple;
	bh=Lm3JiAMFosrAE6+PT44RB107eosPaQoBDCzJH8979Fo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HZ1EpgUiOpbE3kz47wNszMcsHcawvD5OrJGyxseri0IosVqdwHqjCn7OLr4XN9c0kNZggnL/a2B9fSFFXcExFx6eoV8UGYr9vy/h5VD5mwM5PKNibLRJvOq9m6SQahBhpsfJ+IE5KiP0/OGmO6WgYgXsVmibksmR8nViP/N27e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W45VB5J8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W45VB5J8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03751C4CEF0;
	Sun,  7 Sep 2025 20:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277545;
	bh=Lm3JiAMFosrAE6+PT44RB107eosPaQoBDCzJH8979Fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W45VB5J8ASwLnuVABGAq2Yd5QYLdMOGZUTGHeZfHbhEWwUcR7bylhYZqeAIwSoRrw
	 YFKjoAa/yJGeb3nnpcYCpeWzHD/CRIqwScu8btG+l/IxK34F54yKv+zkvr1HWQ3bOW
	 4p1Hm39CLlwK9wxl/cwBDqg8hHPGxwBr8yAf6zG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Pravdin <ipravdin.official@gmail.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 048/183] Bluetooth: vhci: Prevent use-after-free by removing debugfs files early
Date: Sun,  7 Sep 2025 21:57:55 +0200
Message-ID: <20250907195616.919191345@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index f7d8c3c00655a..2fef08254d78d 100644
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
@@ -434,22 +456,8 @@ static int __vhci_create_device(struct vhci_data *data, __u8 opcode)
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
 
@@ -651,6 +659,21 @@ static int vhci_open(struct inode *inode, struct file *file)
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
@@ -662,6 +685,8 @@ static int vhci_release(struct inode *inode, struct file *file)
 	hdev = data->hdev;
 
 	if (hdev) {
+		if (!IS_ERR_OR_NULL(hdev->debugfs))
+			vhci_debugfs_remove(hdev);
 		hci_unregister_dev(hdev);
 		hci_free_dev(hdev);
 	}
-- 
2.50.1



