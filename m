Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD9532AABE
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301241; cv=none; b=sXTSb+soUFLTWKFkutPqaBaj/uu6iqTiqBaGSr8BTMajYjIZcwCBBI5e2VALqeCX6mXzur1P/Xrf1Yi4p2IjtnChs3iup3oMd9iXoZbTkXUUMgEFfloMw3qmDXaFjd1k1bWggmUn6r5HoMV2nXhkhyz44jx+tAnjU0NjlxpvatQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301241; c=relaxed/simple;
	bh=vFJOB/tj3DORoPczvwwyK/P3t1OiK9PdPbshDbq73c8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pcAGsS73KbrCzPkIvVvkj46owPfYP7fJMD0FT3iPBZdJOrEgvBFJd6gW1c9y1Td9LOsPmLDiKpmhOBzcUN3DOiTKVxn44JSoKfcdUSBD8d4WzXa1l99xZ9DnVzR7gOJ5yzJPjOgxEJOqf1ABCEIZxJRNVLT67G25x9spqFbzDhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V9dukjUi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V9dukjUi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77325C19423;
	Sat, 28 Feb 2026 17:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301241;
	bh=vFJOB/tj3DORoPczvwwyK/P3t1OiK9PdPbshDbq73c8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V9dukjUi/FSP/kcn0kzqwzh7qzEJ+glt5K06VGxQtSfRtxQTlMBDYGhdoeCJp1ViK
	 DZIrEPFLS9s9TF52LSKXc4U3XTlKfNTYZ4Rcb88TC7Bd8HMaU9uZ5pUORXe+P/aMrV
	 ERCggjg1J1HlcGQMySZbQq94Zr9yqMBsu/H3xy7FsE4EuICGk9gxMq5+sDrAlcsvX5
	 K75/QyU4O2jfYQmop4/3MzA5xrEDtNZ87hLisDFCXxhqIAnbc88XJGRwT4Xh73V/Xz
	 N7WMVvZjfISuGZRjTlQekaSGb8Jp9X0oPumanPUrlW4a4uvD5GmDSodUFkIXtT0kmk
	 LyA6j1joumAxw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jinwang Li <jinwang.li@oss.qualcomm.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 421/752] Bluetooth: hci_qca: Cleanup on all setup failures
Date: Sat, 28 Feb 2026 12:42:12 -0500
Message-ID: <20260228174750.1542406-421-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jinwang Li <jinwang.li@oss.qualcomm.com>

[ Upstream commit 5c4e9a8b18457ad28b57069ef0f14661e3192b2e ]

The setup process previously combined error handling and retry gating
under one condition. As a result, the final failed attempt exited
without performing cleanup.

Update the failure path to always perform power and port cleanup on
setup failure, and reopen the port only when retrying.

Fixes: 9e80587aba4c ("Bluetooth: hci_qca: Enhance retry logic in qca_setup")
Signed-off-by: Jinwang Li <jinwang.li@oss.qualcomm.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_qca.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index a3c217571c3c4..c0cc04995fc2f 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -2045,19 +2045,23 @@ static int qca_setup(struct hci_uart *hu)
 	}
 
 out:
-	if (ret && retries < MAX_INIT_RETRIES) {
-		bt_dev_warn(hdev, "Retry BT power ON:%d", retries);
+	if (ret) {
 		qca_power_shutdown(hu);
-		if (hu->serdev) {
-			serdev_device_close(hu->serdev);
-			ret = serdev_device_open(hu->serdev);
-			if (ret) {
-				bt_dev_err(hdev, "failed to open port");
-				return ret;
+
+		if (retries < MAX_INIT_RETRIES) {
+			bt_dev_warn(hdev, "Retry BT power ON:%d", retries);
+			if (hu->serdev) {
+				serdev_device_close(hu->serdev);
+				ret = serdev_device_open(hu->serdev);
+				if (ret) {
+					bt_dev_err(hdev, "failed to open port");
+					return ret;
+				}
 			}
+			retries++;
+			goto retry;
 		}
-		retries++;
-		goto retry;
+		return ret;
 	}
 
 	/* Setup bdaddr */
-- 
2.51.0

