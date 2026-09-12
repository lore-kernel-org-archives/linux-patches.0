Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F102378C9C;
	Sat, 12 Sep 2026 19:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241186; cv=none; b=FRmuEcyD4rLvcYbn7RLFeTYJdL6gpNEh5atSv+zcaC2wf4RLYD8XcbDE5MMoIaD7+dIlOf6McvZT3xNuQgLi0IRyNfsPqi3G/x7kMXN6WGH9V3RX809te+Nj5dYkxe3uCgMZtHl8W+C0arK9Oy6jCqjLZSM15iIJ/cmvn+LCrE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241186; c=relaxed/simple;
	bh=zDbxE9Qo7TV4sSgUrYDPcyaWnlH7ILbjjlCEh8W3cDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ElzBelyWx/TNIq76u5HITzvAibUQCbtpkAkavmIqQfzBRwzdAZc08OZ/ypU8meMqvmhCPRxjZOjUSma9lBvYkPUk3XVjhoH/+DVVbVpmOyYOufM4UGLv8CV/bdJWWiPN3n7cRTsuMJaEfW3WQBYJEQEnGwx0b3GqmAhVpbqIZCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LfvI+cfB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LfvI+cfB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE17E1F000FF;
	Sat, 12 Sep 2026 19:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241184;
	bh=MtGRbg9Y82ij5iXtO68SltMqR7uT6FXws74hLP/VCTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LfvI+cfBJTrLRCwLrlfP4/N83X6YwTKHqfItJZb21gw97Q6fdn5q33oeW5u51FCGf
	 UkNA+2RUMrqW1Rx0uKyzLq2pK/U6D1YZXR+So5xs8B9KE5iw9hHB0NODMuhGMuYFQo
	 Er9goEy1StboZBX5lIaISkxg74z0Xx7aqfThHaGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gongwei Li <ligongwei@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.10 084/798] Bluetooth: hci_uart: Fix false success return in hci_uart_setup()
Date: Sat, 12 Sep 2026 08:55:12 +0200
Message-ID: <20260912065518.885084318@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


