Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC3825335A;
	Thu, 17 Apr 2025 18:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914556; cv=none; b=MIGq8dRMdbnNaDG+MfrlrBnMhWOaDudziZtVyZ/DpAbI5TUzFydFNcEqBgzle8zJv7+peJU9Ij3imaYJxgum/u7BUg+Q9hfz61Vl83+zYZZG0FlL3Pxx9vWqNxTj5so/nr0ZK6kERRT2tZSD5pddZTQxSRT6hjr0PlM3nlD/T9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914556; c=relaxed/simple;
	bh=NyC0/M2cKmg/fV912xeVK2WJ/sNAWjs1VMcxacU8Y+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lHgY7iPHGgIgze1h2VzfUBfVMzOdkwmXAKifXdefPGq00kQJAU9OL4cNNyC9MVJh8iXPY6kuSL24ZFcA4tjEYQXLME7FaTVZhXFHT099ov/k5PNzekygB9TJOv9lCRsEv8tlKctAKt0ag+gvtvAg2MLBKuNZkEozZ/n5cmP/HXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HfAe1SeX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HfAe1SeX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10D05C4CEE4;
	Thu, 17 Apr 2025 18:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914556;
	bh=NyC0/M2cKmg/fV912xeVK2WJ/sNAWjs1VMcxacU8Y+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HfAe1SeXbsjTVM0UoidYdf/KjG0uPtCa08Y9ptUOdZ+sYe/da/6JYDqhKiF5jt0iy
	 Z3kupZZA8hMtH11R+dA876QoUfKCF5Hys8K3Siln9FgLFz9P7LdiSMIkQVesodALYc
	 kwSaN0EFuVObKXJK+NGIxhM2bxcnsD8f1WSzkZts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.13 255/414] wifi: mt76: Add check for devm_kstrdup()
Date: Thu, 17 Apr 2025 19:50:13 +0200
Message-ID: <20250417175121.677312449@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -95,6 +95,10 @@ int mt76_get_of_data_from_mtd(struct mt7
 
 #ifdef CONFIG_NL80211_TESTMODE
 	dev->test_mtd.name = devm_kstrdup(dev->dev, part, GFP_KERNEL);
+	if (!dev->test_mtd.name) {
+		ret = -ENOMEM;
+		goto out_put_node;
+	}
 	dev->test_mtd.offset = offset;
 #endif
 


