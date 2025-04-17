Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D538185920;
	Thu, 17 Apr 2025 18:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915789; cv=none; b=S58DH0C+WLfMNoJYksfyO9nJDgIu96Apm55p1KmD3gGPk9wR7ThZfO4NSQ/fjzHUrk4h4clw1DiGeFJw5tO96SIrlkQz+s+Wruduz7/rq97RJsJ9ddbg4j/s32o+YrggyI3qRpa0ODEFzVrJSz+nxp8zBJGg4rhASGU7QleeL+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915789; c=relaxed/simple;
	bh=dsU0U1RubQV+AjTjHelxXnhubCeV64R7vM3EeY1jr1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EYU7WqFDaiTqR8lgxIz+PzEhyRBlbCw2D18RBdS4gfZaC68LTJEJtthGPD1sO4l6ZzjmPw7jqi+RkvfOe7VC9d4Np60anqfAoZu+O3KepMf79Fi97JGjPAHbVDRRIx+dI9b+QF4kbLGTPXTyb5XDWVZtiG7sQfGYLTeZyzCCZqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=op2t8FJ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="op2t8FJ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B38FC4CEE7;
	Thu, 17 Apr 2025 18:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915789;
	bh=dsU0U1RubQV+AjTjHelxXnhubCeV64R7vM3EeY1jr1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=op2t8FJ5LzrKpsvk4Stpij3/cd79qQK26uhvtpj7TM7qY0rnFOpXABpMNY8D3jcmg
	 sQW5JMmjjor2HmarA1BYvjPNSejkMPmlYjBfvskzwn7Q7EgRyvkFrYAee3epjnySBS
	 Gr6MNhXwoezNPb/tIsiB5d4mrJ0L1mmQw/IhIwF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.12 240/393] wifi: mt76: Add check for devm_kstrdup()
Date: Thu, 17 Apr 2025 19:50:49 +0200
Message-ID: <20250417175117.253098781@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


