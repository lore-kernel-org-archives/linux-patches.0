Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE939222D55;
	Thu, 12 Dec 2024 15:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018375; cv=none; b=uTnIUCtljFdcXkLqXvcroDAJyozHiFnpGASh8+J76gC5KnKUiB/7HtvGgczz6JZmQNp93xiQCo8MsSgkECXAZ+swknwLkMQnQcd42tmyli5ltg0h/C+qRsUWCNWfuP8UZI1wBcJ08rQ16NU8vEo0/PejmTLAnMxsWWOHR9OHmZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018375; c=relaxed/simple;
	bh=8Yk2WLh8bAdrWqnmG/x1b95ncHlQf1vY/6yI8cN8x80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b+ufC6CvCC6EqyUjLZEb2TSGuKaD5L+blyXeAwSiUMdzT+ZjjGjiNYF6zXINGI2BSJN2xTRL+i09e0QUdNUN1TcOlfBETeTrPr/jXcIEnNJ4sZQP5H8VY7zChoxrpgu2ZM8gHzsav/Ni52A7TfklynKtqIiMVJHsyn4OyAYvt/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lv6ks11T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lv6ks11T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 296D0C4CECE;
	Thu, 12 Dec 2024 15:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018375;
	bh=8Yk2WLh8bAdrWqnmG/x1b95ncHlQf1vY/6yI8cN8x80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lv6ks11T5jkRNQ5oBr+BAwC8LpyzZjJHVnjy1FZW/sShQzT1z1oAQaSHmtPnyQBNf
	 KiITlGrA6oQHW1ZJX1zX2fys0Vy8WyKH/pKpzMlGU1tRmUWb0pJWfX68NYOT0XEmBA
	 hRm6Au2N41Sz7iYYHHETwwo/1uY1cCcEuGfM5isE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danil Pylaev <danstiv404@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 258/356] Bluetooth: Add new quirks for ATS2851
Date: Thu, 12 Dec 2024 15:59:37 +0100
Message-ID: <20241212144254.793510105@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

From: Danil Pylaev <danstiv404@gmail.com>

[ Upstream commit 94464a7b71634037b13d54021e0dfd0fb0d8c1f0 ]

This adds quirks for broken extended create connection,
and write auth payload timeout.

Signed-off-by: Danil Pylaev <danstiv404@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci.h      | 14 ++++++++++++++
 include/net/bluetooth/hci_core.h | 10 ++++++----
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 2129d071c3725..77a3040a3f29d 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -297,6 +297,20 @@ enum {
 	 */
 	HCI_QUIRK_BROKEN_SET_RPA_TIMEOUT,
 
+	/*
+	 * When this quirk is set, the HCI_OP_LE_EXT_CREATE_CONN command is
+	 * disabled. This is required for the Actions Semiconductor ATS2851
+	 * based controllers, which erroneously claims to support it.
+	 */
+	HCI_QUIRK_BROKEN_EXT_CREATE_CONN,
+
+	/*
+	 * When this quirk is set, the command WRITE_AUTH_PAYLOAD_TIMEOUT is
+	 * skipped. This is required for the Actions Semiconductor ATS2851
+	 * based controllers, due to a race condition in pairing process.
+	 */
+	HCI_QUIRK_BROKEN_WRITE_AUTH_PAYLOAD_TIMEOUT,
+
 	/* When this quirk is set, MSFT extension monitor tracking by
 	 * address filter is supported. Since tracking quantity of each
 	 * pattern is limited, this feature supports tracking multiple
diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 0f50c0cefcb7d..4185eb679180d 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1852,8 +1852,8 @@ void hci_conn_del_sysfs(struct hci_conn *conn);
 			   !test_bit(HCI_QUIRK_BROKEN_EXT_SCAN, &(dev)->quirks))
 
 /* Use ext create connection if command is supported */
-#define use_ext_conn(dev) ((dev)->commands[37] & 0x80)
-
+#define use_ext_conn(dev) (((dev)->commands[37] & 0x80) && \
+	!test_bit(HCI_QUIRK_BROKEN_EXT_CREATE_CONN, &(dev)->quirks))
 /* Extended advertising support */
 #define ext_adv_capable(dev) (((dev)->le_features[1] & HCI_LE_EXT_ADV))
 
@@ -1866,8 +1866,10 @@ void hci_conn_del_sysfs(struct hci_conn *conn);
  * C24: Mandatory if the LE Controller supports Connection State and either
  * LE Feature (LL Privacy) or LE Feature (Extended Advertising) is supported
  */
-#define use_enhanced_conn_complete(dev) (ll_privacy_capable(dev) || \
-					 ext_adv_capable(dev))
+#define use_enhanced_conn_complete(dev) ((ll_privacy_capable(dev) || \
+					 ext_adv_capable(dev)) && \
+					 !test_bit(HCI_QUIRK_BROKEN_EXT_CREATE_CONN, \
+						 &(dev)->quirks))
 
 /* Periodic advertising support */
 #define per_adv_capable(dev) (((dev)->le_features[1] & HCI_LE_PERIODIC_ADV))
-- 
2.43.0



