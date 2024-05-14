Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C86142E6E;
	Tue, 14 May 2024 11:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686056; cv=none; b=FVaVRz3nTKvSCb2Pep3PXwcnF+/YJfHLix0uEMkaPSe47UuG1ReXGywxx8wI2hEAXoqKN3wBECA+RX8BZOgXHhoineF3IlC9YOvRTCndomLA9j535N4Hplqf4IneQHNRUSMyttIRjYZ2g/7bio0kUsmTTkbqkMvQtbdEleCVbKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686056; c=relaxed/simple;
	bh=9mBiWXR3DFyYZ2Q3UQY0cPdba0NbCL4rMpdBMZU238s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lMWE8OPDV9vnB1waxy4gbZyR12wak/Rn7+bsaaugrsyPTILkW7SylMEpvFucscC+j0o64snfkGJWgSeHatEraeJRHAKIIxl4Zm177vSw1HSBO28GBh8oO9dy6MbO8VqKIaqgneCo5NV+9QaTUFpgomHDSctxJHzl9wBKy3Ws2Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=etbZKSxY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="etbZKSxY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73B5FC2BD10;
	Tue, 14 May 2024 11:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686056;
	bh=9mBiWXR3DFyYZ2Q3UQY0cPdba0NbCL4rMpdBMZU238s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=etbZKSxYPs7TLZtcGPq0xaaCgsj4fosnZR11TwD9OirAnoDtR9akr316ZoxUwz7v1
	 ok48kHUtC4thfEQOcO7veerhOKOTnfSuuuQsK4RwoWZV6eLRMtFhcmWDlyVeWjqb8T
	 voU+YmexgpItXSEAXCz1hLm075GcFJs0q5rQu6Lo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 300/301] Bluetooth: qca: fix info leak when fetching fw build id
Date: Tue, 14 May 2024 12:19:31 +0200
Message-ID: <20240514101043.592657550@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit cda0d6a198e2a7ec6f176c36173a57bdd8af7af2 upstream.

Add the missing sanity checks and move the 255-byte build-id buffer off
the stack to avoid leaking stack data through debugfs in case the
build-info reply is malformed.

Fixes: c0187b0bd3e9 ("Bluetooth: btqca: Add support to read FW build version for WCN3991 BTSoC")
Cc: stable@vger.kernel.org	# 5.12
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btqca.c |   25 +++++++++++++++++++++----
 drivers/bluetooth/btqca.h |    1 -
 2 files changed, 21 insertions(+), 5 deletions(-)

--- a/drivers/bluetooth/btqca.c
+++ b/drivers/bluetooth/btqca.c
@@ -99,7 +99,8 @@ static int qca_read_fw_build_info(struct
 {
 	struct sk_buff *skb;
 	struct edl_event_hdr *edl;
-	char cmd, build_label[QCA_FW_BUILD_VER_LEN];
+	char *build_label;
+	char cmd;
 	int build_lbl_len, err = 0;
 
 	bt_dev_dbg(hdev, "QCA read fw build info");
@@ -114,6 +115,11 @@ static int qca_read_fw_build_info(struct
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
@@ -129,14 +135,25 @@ static int qca_read_fw_build_info(struct
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
--- a/drivers/bluetooth/btqca.h
+++ b/drivers/bluetooth/btqca.h
@@ -48,7 +48,6 @@
 #define get_soc_ver(soc_id, rom_ver)	\
 	((le32_to_cpu(soc_id) << 16) | (le16_to_cpu(rom_ver)))
 
-#define QCA_FW_BUILD_VER_LEN		255
 #define QCA_HSP_GF_SOC_ID			0x1200
 #define QCA_HSP_GF_SOC_MASK			0x0000ff00
 


