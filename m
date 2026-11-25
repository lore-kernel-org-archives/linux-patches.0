Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625805;
	b=EvTaXXZot4SOVagrBoWdE197UJDaBhBryrXUJTCiS9BBgbO+h7LMUE8nGqWDb+GloZtx
	 FonlED82HK82UHuZgBxYDGY4aUxmefjgMjLNY2IfsSkDkpt0VpAeeW0fMLDFhUDuvH6QF
	 xJ0tUjSl5SGvakt59rP3giDY+90+5W2WsBnrb9eil+emXdm4RtDNBAIdEzAXscgWLuER2
	 rIpvVZCWKyfeT0gBQDEZEb011Oew/y1HRg9mbNOeTUPS6l/JkWAl84ahEzXJg0mYOiOEf
	 r1ZnQ+eoeFW34Y58URDMN42MfA4cDKhn2D4CnISYxnEbgQWywMg7rjTLo+E/4o3TJVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625805;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TVxq2EH6UTZ1bMnyJ5Y3jJWPx1PHWRh0gsoFDgUz+KA=;
	b=1PC+WI5YSHgfBIDpJXCO9cTJvAMhZgZXaU3/j5Q3OBYCrRYa1twLQ26Iq+87n+eC77nd
	 KOLVpdIRY0mhqbNKQAsMneOPzB9Y+urVWDSuNUhzjh4bXFBxoQjufWhOil9AR2AeoHpBF
	 h8b9+AE+PPJLIcP0h4Nr6MacVAdlc1U2Hb2sutwdBR0earOnongi82St/fwmzSzmnjGLY
	 pAkwNGCEDsvK2NErJZXnMzm/bNOr+F3PyaBT4lbQxTAerMkii3IrypP58vnlXf+APuSyV
	 DKi0+ieSUf8CKyzOLBGzS4y7wPqGnf0dOnt3zFWr2RMPmJSubRjYO+B7UmZruPB1vEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DF5Zp5D9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD79606A31E;
	Wed, 25 Nov 2026 16:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DF5Zp5D9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEDF31F000D0;
	Wed, 25 Nov 2026 16:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625805;
	bh=TVxq2EH6UTZ1bMnyJ5Y3jJWPx1PHWRh0gsoFDgUz+KA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DF5Zp5D9RZ7B/dwZu5u0EJg7xfVOWjysF/Pky2gbrmc3hfT8VYuTY4G3Da2EluT9q
	 4Ri0zK44iFniP6agh5b7I6kuDf/YzNiU0m+2yFavsHfa7TWqj4xqSLv0T93mFlJKZ7
	 10nSjgOIfbYPDQT/tGRbRdK3XHcF1BqiXSwDIyrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YuanZhe Liu <25031212351@stu.xidian.edu.cn>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 610/816] Bluetooth: hci_qca: fix use-after-free in ibs debugfs files
Date: Wed, 25 Nov 2026 15:35:58 +0100
Message-ID: <20261125143903.299196952@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: YuanZhe Liu <25031212351@stu.xidian.edu.cn>

commit eeca795cec6d9c6c193c2c1bd0cb26cde44f9fc3 upstream.

qca_debugfs_init() creates an "ibs" directory under hdev->debugfs and
stores pointers to fields of struct qca_data in the debugfs files.
qca_close() frees qca_data without removing that directory, while
hdev->debugfs is only removed when the HCI device is released. The HCI
device can outlive the driver data, for example when an HCI socket still
references it, so reading or writing one of the ibs files then
dereferences freed memory.

Store the directory dentry in struct qca_data and remove the directory
with debugfs_remove_recursive() before qca_data is freed.
debugfs_remove() waits for callers that are already inside the file
operations, and any later access fails with -EIO instead of reaching the
debugfs helpers. This covers the two writable files as well.

Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261102113654.8724-1-25031212351%40stu.xidian.edu.cn
Fixes: 0ff252c1976d ("Bluetooth: hciuart: Add support QCA chipset for UART")
Cc: stable@vger.kernel.org
Signed-off-by: YuanZhe Liu <25031212351@stu.xidian.edu.cn>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/hci_qca.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -160,6 +160,7 @@ struct qca_data {
 	struct delayed_work ctrl_memdump_timeout;
 	struct qca_memdump_info *qca_memdump;
 	unsigned long flags;
+	struct dentry *debugfs_ibs_dir;
 	struct completion drop_ev_comp;
 	wait_queue_head_t suspend_wait_q;
 	enum qca_memdump_states memdump_state;
@@ -652,6 +653,7 @@ static void qca_debugfs_init(struct hci_
 		return;
 
 	ibs_dir = debugfs_create_dir("ibs", hdev->debugfs);
+	qca->debugfs_ibs_dir = ibs_dir;
 
 	/* read only */
 	mode = 0444;
@@ -727,6 +729,9 @@ static int qca_close(struct hci_uart *hu
 
 	hu->priv = NULL;
 
+	debugfs_remove_recursive(qca->debugfs_ibs_dir);
+	qca->debugfs_ibs_dir = NULL;
+
 	kfree(qca);
 
 	return 0;


