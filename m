Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4257284B37;
	Sat, 12 Sep 2026 15:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227300; cv=none; b=g8jbTqVsA2rXrmRe//4BHvC08vE3Lp9gEn1KI4B0YdwbOSjrSOxhOYPtJdY1VL3g/hDQzq2OCRiWaGjLG+cQ2NpRSXOAVfIuSyatDZ2RvGGiuYbBF5PrBZ5M3qpnSC+HkZBylrucuPKoZp+BruI0H6DzHUc/m3zDnMa4RCK1E8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227300; c=relaxed/simple;
	bh=2c/aWXws8Tkmd8II8l1s4ySkHWqb3s4p/7Y9PmJpbEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TcCKvt/+FQQqXKaDNUQLJMpHkAN4F+R2xTOdLGYJGdPMJPoOYrOgqZgNUPhUzUyXr68Wh/SX+HAQCKDnu9tPWvJLUksLvDKtjwcMrH7HxBP0RYt7xzh4AaZhIaDDMD9HUPgNHybNavgOriXlQ88k9GxvsAzEcmSrRqPhmNg0ipQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xWjrehQu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xWjrehQu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B8041F000FF;
	Sat, 12 Sep 2026 15:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227298;
	bh=Nc68hVGjQx5tId2P+md4wVFolrI9G+e18IameoPBUe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xWjrehQuM9OUk/k0ds8ZPQ3ynOcLQ46dfhqHzEmwtkbHG1pOOpDO2G+OLzHnsW/zH
	 vanOpcvQWdhfO3gEt++lOYkl9Kzu6NQwvkWN6Yb4GFO9wSldner7BHOAWjfzq43pjB
	 da5/ZHKXnq+RmCC+TlnGGIK874gCAMUNFtCH5mu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gongwei Li <ligongwei@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 0110/1191] Bluetooth: hci_uart: Fix false success return in hci_uart_setup()
Date: Sat, 12 Sep 2026 08:47:18 +0200
Message-ID: <20260912065550.656797332@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gongwei Li <ligongwei@kylinos.cn>

commit a9355799343e10014f2acfd4b6844d2335ecafea upstream.

When reading the local version information for vendor detection
fails, the error is only printed and 0 is returned, which masks the
setup failure from the HCI core.

Return PTR_ERR(skb) instead.

Fixes: fb2ce8d11f039 ("Bluetooth: hci_uart: Add support for vendor detection flag")
Fixes: 82f5169bf3d3b ("Bluetooth: hci_uart: add serdev driver support library")
Cc: stable@vger.kernel.org
Signed-off-by: Gongwei Li <ligongwei@kylinos.cn>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/hci_ldisc.c  |    2 +-
 drivers/bluetooth/hci_serdev.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -445,7 +445,7 @@ static int hci_uart_setup(struct hci_dev
 	if (IS_ERR(skb)) {
 		BT_ERR("%s: Reading local version information failed (%ld)",
 		       hdev->name, PTR_ERR(skb));
-		return 0;
+		return PTR_ERR(skb);
 	}
 
 	if (skb->len != sizeof(*ver)) {
--- a/drivers/bluetooth/hci_serdev.c
+++ b/drivers/bluetooth/hci_serdev.c
@@ -221,7 +221,7 @@ static int hci_uart_setup(struct hci_dev
 	if (IS_ERR(skb)) {
 		bt_dev_err(hdev, "Reading local version info failed (%ld)",
 			   PTR_ERR(skb));
-		return 0;
+		return PTR_ERR(skb);
 	}
 
 	if (skb->len != sizeof(*ver))


