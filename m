Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CAEF325726;
	Sat, 12 Sep 2026 17:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232843; cv=none; b=HJBaskjVpcpbJ+7VBVHfO4G2hOrZGExnWXfdaDsGi3L0yZamD4cWaZVK9O6O3Ci8ym54QQlofBCyG7m9HSjWX7JUlZ1EaMNDnu1ATzLZOaqyv+5kZEdTKvAbgVL5aPHUpZ6wf6WakFdysav+J06ilMvTjzAD01pRP0bKjbugeGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232843; c=relaxed/simple;
	bh=p9+EvyJ8LrEtHQ/nQfnCoFbjdC9ztUlY6NMtRLxmbPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kbjzpy5A+txPa16SIPIY5uYsc/g91nv3oaUIneakvO1GcvVwvjdSdSMreiQT+Cbi5nj9XHjEkezWcPW+HxJnnxAykdLVM4wbZrdt87jbaRYiu9D5voFRuc73MKvubWIxdIrmCfnf4XRr5Q2hVU1U6Dl4y+ms4zEviNcdhX8b1cQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zfwhFLkC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zfwhFLkC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D9E1F000FF;
	Sat, 12 Sep 2026 17:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232842;
	bh=tdEpamvjLtzoBMSUICe+Eq9eUXwIwt7heDFkifDMkZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zfwhFLkCRkZwMtooT/+pEjV0IYSzqHiOoSrfGq9CM8SFaqlShET0nq7NiLIylCINO
	 nb2RwlyerphbirVrLgLAVxOett4NmrFHvrjaHlCI0/fZY8qjjTQ5mhXkbJxKPWtpE6
	 n+HFv6WY5gzkD5YsoU1evMn2lF6oHzLVHl76raZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gongwei Li <ligongwei@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.15 094/935] Bluetooth: hci_uart: Fix false success return in hci_uart_setup()
Date: Sat, 12 Sep 2026 08:52:04 +0200
Message-ID: <20260912065528.980721746@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


