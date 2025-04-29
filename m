Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32DF244664;
	Tue, 29 Apr 2025 17:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948689; cv=none; b=DWgoRL8yQn62OibKrayKHR0ecuxioJh5nMHWoMX/3WZaL1Qxx4laqR7XkUzwF6Xiy1pRiAIQkvl/xNKdVT2lH0el47Db11gBIl4G3FmY6Ubtw1zfk2D2d2xZS1xz+DnwbZJtq0dJB1JuBnTUtd3xzAy2ssPUjSueUA8bikouWv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948689; c=relaxed/simple;
	bh=CoXytnKz63mTNIH+gmNNO49AmOtlXr4kQrHxUfLwqxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O43RBifCFGMd0ZJylPTYrH8UitD/zza1cUhU+f3Q4jeQoiMH1sVl+4/9gUptjRRpo5JjrlYGoQYxlVQwmiEUh9mgEIoX/4tL/n5Vj9l4TO0vjRRaGYBJzFCdcWuDxmMj+YJDYxwLtUcUW7CFJPOxvUtAT16KIRFkaE1AJc+Ns64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=joa6qLmr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="joa6qLmr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF0B8C4CEE3;
	Tue, 29 Apr 2025 17:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948689;
	bh=CoXytnKz63mTNIH+gmNNO49AmOtlXr4kQrHxUfLwqxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=joa6qLmrZbblfKYSGiyr+rZ0tv9vRPDL9G0hrwU97272GHYRwQWsWptkmi2ELIBWm
	 Tjs+8mhnq47kyopFbEJJQxo2afQPba8enJKhtGfmOhTCI/Jn4ZyBqrJcv1XRF7XBzw
	 NaHHEY3hIg1DPdofBQxXdUkeP8qum899bblt5tpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 5.15 082/373] wifi: mt76: Add check for devm_kstrdup()
Date: Tue, 29 Apr 2025 18:39:19 +0200
Message-ID: <20250429161126.523505191@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -74,6 +74,10 @@ int mt76_get_of_eeprom(struct mt76_dev *
 
 #ifdef CONFIG_NL80211_TESTMODE
 	dev->test_mtd.name = devm_kstrdup(dev->dev, part, GFP_KERNEL);
+	if (!dev->test_mtd.name) {
+		ret = -ENOMEM;
+		goto out_put_node;
+	}
 	dev->test_mtd.offset = offset;
 #endif
 


