Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB9B2D60A;
	Tue, 14 May 2024 10:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684171; cv=none; b=jAI6BUFf0LQtRu2Y7zyttwoLnMXuPfVBwX4FvuWAUwghDzgn3T3YEO6rjwnG5CH23p3KNwHA3MjsRjfkX+DgzyOoiViwk+38krfgVJs47lv8mfcEELtJlRCtn+OU+BvS1M/AJdhkEKKqWjbXl8zppaOhUDiDK6J5TzQf0UPlFnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684171; c=relaxed/simple;
	bh=OPKjKdbwFZe6KhhmI0n8kWJRp/qK2ay+Cmk1A5AKbJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cROC7QtwyXbDUfhwlQFN2K1y4ef8UGP4djIRoSn5exKUhZ7AA8sgmpLT3MvvxcpA5Iq56+8XnN9T4FQeHb4cMGbn+N9fh2wkBHxr0J+1IyzypIa1xfqGPkis68jV9qZBJujKFUfxHR9lkPXiFG8hZYHGqKuCem05GasXJPYtqIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OnzXJT77; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OnzXJT77"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0A25C2BD10;
	Tue, 14 May 2024 10:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684171;
	bh=OPKjKdbwFZe6KhhmI0n8kWJRp/qK2ay+Cmk1A5AKbJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OnzXJT77QbldJsDJAVOmV/tT1cTL2ikBBbr1Q4N+KQeiZ5e0fWP39vYSidz7JULMh
	 DFqwzpHRLPdzkzGTni28RPMakNRGe7Jvsfs9BkRyADTG/o06He52TSGZT3RD/AeG63
	 HuaMQQW0XWHa4I6BfVwjFjaGiYdBgl/V/Wnk/+9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.8 335/336] Bluetooth: qca: fix info leak when fetching fw build id
Date: Tue, 14 May 2024 12:18:59 +0200
Message-ID: <20240514101051.275788909@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
 


