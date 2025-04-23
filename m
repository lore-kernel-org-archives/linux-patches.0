Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5C51A317A;
	Wed, 23 Apr 2025 15:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421077; cv=none; b=WBpMsAMZZ9dtT76UbGCL99Rmktyfz0cV5IIpedzxTAhSiF2tSmOkP+g40VI5crgM+gUJPWmF4jXAY+6FbYbKaW6+Rk9udkEK3fjmVsuJ8ixeKrgL0MOb31m6Tcftfe2E0cZV8E2qrvI99W2yTDLC2x2lsx7lOSOdlp9b8HUIklo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421077; c=relaxed/simple;
	bh=N0egCELzaCbTSdaQ+IcSDyEQ6FfYS9d8anRd0lDI2iA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QMKj0KgjSMABTSShG3evjTcmzMDtvP00jD4fEXezkV6E4dIkh144XGpU9YW6AJsJrqwIxv3mz426gACnkhZemfQ578yux4RZlrBNy2+AJzc2GZ4rM0NasqH/8gLog2SPgs9PNsdB5zwZLz8aMPqy9AlEcJBYa2pDTTRyihHi7OI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v4bvMtH7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v4bvMtH7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A753AC4CEE2;
	Wed, 23 Apr 2025 15:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421076;
	bh=N0egCELzaCbTSdaQ+IcSDyEQ6FfYS9d8anRd0lDI2iA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v4bvMtH7hvVSt/EAdTFNePMpuDXysjUwBQfcdALvLnSaEQMy7tq4B1ToCN/lts1lH
	 m+UoDpARu0Nl4P9fXTbLQT1KbO3zQrsDOXVAceqjEtrmIB9YJ0a7ittDE2Uzxk8Syi
	 6p45F0HmVM2pF9D9/Kr1KDJ5hHLe3D19zbj57RZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.1 106/291] wifi: mt76: Add check for devm_kstrdup()
Date: Wed, 23 Apr 2025 16:41:35 +0200
Message-ID: <20250423142628.697142962@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Haoxiang Li <haoxiang_li2024@163.com>

commit 4bc1da524b502999da28d287de4286c986a1af57 upstream.

Add check for the return value of devm_kstrdup() in
mt76_get_of_data_from_mtd() to catch potential exception.

Fixes: e7a6a044f9b9 ("mt76: testmode: move mtd part to mt76_dev")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Link: https://patch.msgid.link/20250219033645.2594753-1-haoxiang_li2024@163.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/eeprom.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/wireless/mediatek/mt76/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/eeprom.c
@@ -90,6 +90,10 @@ int mt76_get_of_eeprom(struct mt76_dev *
 
 #ifdef CONFIG_NL80211_TESTMODE
 	dev->test_mtd.name = devm_kstrdup(dev->dev, part, GFP_KERNEL);
+	if (!dev->test_mtd.name) {
+		ret = -ENOMEM;
+		goto out_put_node;
+	}
 	dev->test_mtd.offset = offset;
 #endif
 


