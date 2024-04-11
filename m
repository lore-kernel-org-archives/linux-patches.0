Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E18140E3D;
	Thu, 11 Apr 2024 10:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831064; cv=none; b=g/IXJnbETT/osTTM6SB6RUTEYZWStUGrgsByqsgviOFyxH1A6XrUIKX6YWfYdQbUNBY0ScDiBm1H2cTqoJDFPwuT6cenhO7D+jSb8KdIhdBhPFpG33VZQXqbqHErFgNOUhylH5DvKoNv6qka9GcEiQgTrfMkHTAVjegrMEcY5EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831064; c=relaxed/simple;
	bh=wquyjN4gNriRAXvJ9bcI0sXHTlSBlGvp6y2d417aw28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hCXgLgfEvkUyGJXLkO6Si0KXKKQfvWFyuPZ45jCjtTfMdGZcN/xqWROz1MOndPFndx6ee4PH0k/9hmn4pQee02Z2A8Hzd/NXX85LtBGxibOomNY2N7MpV1FECJ9OJ+Felb3OifqPj/9+kDxeyDlZyvUbCZCY97ZMQvbTyGnNka4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=niyU85IA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="niyU85IA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DA51C433F1;
	Thu, 11 Apr 2024 10:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831063;
	bh=wquyjN4gNriRAXvJ9bcI0sXHTlSBlGvp6y2d417aw28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=niyU85IArp5NRqsc113q9dbAwqfx1LZsopaZcu2cPGvxZRbIqOhDFAY9UgYLKmf6V
	 lqOahjyUqJ7oaQmT+3fWKSEGW1FmSNoXyUCKuMjBLhs/s+/K9MIsArMqkyr1enj0uo
	 I9pDQ2pYIgCNnRJUkynvsbFETe5wFkQDHeDYEvTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.4 211/215] Bluetooth: btintel: Fixe build regression
Date: Thu, 11 Apr 2024 11:57:00 +0200
Message-ID: <20240411095431.205534958@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit 6e62ebfb49eb65bdcbfc5797db55e0ce7f79c3dd upstream.

This fixes the following build regression:

drivers-bluetooth-btintel.c-btintel_read_version()-warn:
passing-zero-to-PTR_ERR

Fixes: b79e04091010 ("Bluetooth: btintel: Fix null ptr deref in btintel_read_version")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btintel.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -340,13 +340,13 @@ int btintel_read_version(struct hci_dev
 	struct sk_buff *skb;
 
 	skb = __hci_cmd_sync(hdev, 0xfc05, 0, NULL, HCI_CMD_TIMEOUT);
-	if (IS_ERR_OR_NULL(skb)) {
+	if (IS_ERR(skb)) {
 		bt_dev_err(hdev, "Reading Intel version information failed (%ld)",
 			   PTR_ERR(skb));
 		return PTR_ERR(skb);
 	}
 
-	if (skb->len != sizeof(*ver)) {
+	if (!skb || skb->len != sizeof(*ver)) {
 		bt_dev_err(hdev, "Intel version event size mismatch");
 		kfree_skb(skb);
 		return -EILSEQ;


