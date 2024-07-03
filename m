Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732EB17B51A;
	Wed,  3 Jul 2024 11:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005355; cv=none; b=Dy5Go4tRFFfch5/baGiGzRFiCINHU38HYcsvuFjb0zwF2qZcnim+f0E53ahPrgYXo4n0O+ZPa9AVgqBhBLY2eopeQl799HKgYUW+gWs/GMndPwGsxlFJ1JiQ8eov/YWYA5xt9A53lAbvTs2Qz/nWxGD9La729zahS6sNUyzmpD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005355; c=relaxed/simple;
	bh=mWWCT2D4WxnkCKgVff3ieu5Fkno2bPvn9M0w/F4+0Ts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YQN3ZQAqSUoqdqEvZDrrC8EhOBafB8zdOMb0qzxzcAKc7Dxr7mto6ACl5EPkZCYCPW7xwHIvKFXoUehj4lqCYx7zBSwUwJJ4CJLMXedKBrRkvoxyZN4+eZDRVn3j6cSb4ozGX7Mt+XBoZAKbsVldVmAE9JD1ZuXkoJmYI4rYJKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Of34cf6l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Of34cf6l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDC5CC2BD10;
	Wed,  3 Jul 2024 11:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005355;
	bh=mWWCT2D4WxnkCKgVff3ieu5Fkno2bPvn9M0w/F4+0Ts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Of34cf6lbkykbzO36r8upjqXWn8ha3y4hTBxRYTofD7JUw709cR4Psz8mFuQmAekl
	 xYX1ToLy7mXroUV9oOJwb7/9qgGouzu3/vObD6RyL79btpixe+dP3VbPL2DLtLBnur
	 XG+tUvlwBhAlzqJHPQ6EtuGefsx9cPcsNJJeKMMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 054/356] Bluetooth: qca: fix info leak when fetching fw build id
Date: Wed,  3 Jul 2024 12:36:30 +0200
Message-ID: <20240703102915.139298901@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit cda0d6a198e2a7ec6f176c36173a57bdd8af7af2 ]

Add the missing sanity checks and move the 255-byte build-id buffer off
the stack to avoid leaking stack data through debugfs in case the
build-info reply is malformed.

Fixes: c0187b0bd3e9 ("Bluetooth: btqca: Add support to read FW build version for WCN3991 BTSoC")
Cc: stable@vger.kernel.org	# 5.12
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btqca.c | 25 +++++++++++++++++++++----
 drivers/bluetooth/btqca.h |  1 -
 2 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/bluetooth/btqca.c b/drivers/bluetooth/btqca.c
index abd621d224667..7011151420e48 100644
--- a/drivers/bluetooth/btqca.c
+++ b/drivers/bluetooth/btqca.c
@@ -98,7 +98,8 @@ static int qca_read_fw_build_info(struct hci_dev *hdev)
 {
 	struct sk_buff *skb;
 	struct edl_event_hdr *edl;
-	char cmd, build_label[QCA_FW_BUILD_VER_LEN];
+	char *build_label;
+	char cmd;
 	int build_lbl_len, err = 0;
 
 	bt_dev_dbg(hdev, "QCA read fw build info");
@@ -113,6 +114,11 @@ static int qca_read_fw_build_info(struct hci_dev *hdev)
 		return err;
 	}
 
+	if (skb->len < sizeof(*edl)) {
+		err = -EILSEQ;
+		goto out;
+	}
+
 	edl = (struct edl_event_hdr *)(skb->data);
 	if (!edl) {
 		bt_dev_err(hdev, "QCA read fw build info with no header");
@@ -128,14 +134,25 @@ static int qca_read_fw_build_info(struct hci_dev *hdev)
 		goto out;
 	}
 
+	if (skb->len < sizeof(*edl) + 1) {
+		err = -EILSEQ;
+		goto out;
+	}
+
 	build_lbl_len = edl->data[0];
-	if (build_lbl_len <= QCA_FW_BUILD_VER_LEN - 1) {
-		memcpy(build_label, edl->data + 1, build_lbl_len);
-		*(build_label + build_lbl_len) = '\0';
+
+	if (skb->len < sizeof(*edl) + 1 + build_lbl_len) {
+		err = -EILSEQ;
+		goto out;
 	}
 
+	build_label = kstrndup(&edl->data[1], build_lbl_len, GFP_KERNEL);
+	if (!build_label)
+		goto out;
+
 	hci_set_fw_info(hdev, "%s", build_label);
 
+	kfree(build_label);
 out:
 	kfree_skb(skb);
 	return err;
diff --git a/drivers/bluetooth/btqca.h b/drivers/bluetooth/btqca.h
index d69ecfdef2a20..6a6a286bc8547 100644
--- a/drivers/bluetooth/btqca.h
+++ b/drivers/bluetooth/btqca.h
@@ -45,7 +45,6 @@
 #define get_soc_ver(soc_id, rom_ver)	\
 	((le32_to_cpu(soc_id) << 16) | (le16_to_cpu(rom_ver)))
 
-#define QCA_FW_BUILD_VER_LEN		255
 #define QCA_HSP_GF_SOC_ID			0x1200
 #define QCA_HSP_GF_SOC_MASK			0x0000ff00
 
-- 
2.43.0



