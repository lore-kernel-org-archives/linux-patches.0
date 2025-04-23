Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3B4280A5F;
	Wed, 23 Apr 2025 15:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421163; cv=none; b=bsffvnKJ5oVl3CKvwszDA9PZi0y4htcqWA2XsA/Pk3rBJuyJShKLrqFBmhvTFZGkKumTiwQR1RlKy5sw08Aqp+TRNgOjWuT87GTDOq8G6oSZHux93+8rAQD9ZT5TkikrM9tWh5zo2tOWNmVEZpePcT2pdHRd8GxDkKJV8YzyYP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421163; c=relaxed/simple;
	bh=uvHzJB9nCLlLD713sHK2wLEXDgK9KjS8zjDrWIzo3l8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QuTa/ShP/2X0yEuw9VuA3qFSgg1REj13S42fSYaXPeZDJXOfQKMT8OUSNVAu7HNU1fpMm/UVVPUrMksNyMpir3iFIaw0gIaYYqzX6ETlrmnTz2L+Xbx005TLsj2bpCqv17+YaGQKjF0SoZFIs9uYlxlh3RTn4gURpOU4oTVwESM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YVRhNZ9b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YVRhNZ9b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99F0CC4CEE2;
	Wed, 23 Apr 2025 15:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421162;
	bh=uvHzJB9nCLlLD713sHK2wLEXDgK9KjS8zjDrWIzo3l8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YVRhNZ9bWXvY5u3V8xSREA0feDSJCgl24SbTR8xqrY8IDKTbwG0hTS6YWcYpGjPd+
	 NmU0zorQr1YOEtWQC+ZacIA75bA9fXGXCT3erBMVZD0Q85WxaC18gTefbJbb8uKKbO
	 JUmjirRCmEGphN9HItT/eq59hj+5PCql9sqCa0hs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.6 152/393] wifi: mt76: Add check for devm_kstrdup()
Date: Wed, 23 Apr 2025 16:40:48 +0200
Message-ID: <20250423142649.657716388@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -95,6 +95,10 @@ static int mt76_get_of_epprom_from_mtd(s
 
 #ifdef CONFIG_NL80211_TESTMODE
 	dev->test_mtd.name = devm_kstrdup(dev->dev, part, GFP_KERNEL);
+	if (!dev->test_mtd.name) {
+		ret = -ENOMEM;
+		goto out_put_node;
+	}
 	dev->test_mtd.offset = offset;
 #endif
 


