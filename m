Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C993D994;
	Wed,  2 Oct 2024 14:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880434; cv=none; b=n0eZeJoU+OwDuVZOcmQs8tOiuAT3n5gsGjZJIbhbjr7b5aR6UdG/mt7zeKQea7kKCSjrBLwXgMGQ0zUDeQoYOcSTTO0i642atkGgkZQsHTU1CKbulUfRxDblEG0M+SMWAoRn7lSxn6klJYlp4xfhyOtn9MFcpvSdus//WruUEqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880434; c=relaxed/simple;
	bh=E6HvBbB4JsDAiHR+gry7J2JsrZdsb9VKS/0xJ2XBFBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uKEti7g2EK1KmwsckRc8CpkLook5gvbBluf6A9GCp8iMk3dusHjTq9zl4s8Wl8nXUY5B7YoZ5MHAxaKxdaOeD1Ov6aYN/q46ncKK2qLuRsIWAqLdJULngVhmGqLeal83eaZijb8t4NLjoOzXpHySkv7cFpKoJfF8qrurs0eVp7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HtT/fnag; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HtT/fnag"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8020FC4CEC2;
	Wed,  2 Oct 2024 14:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880433;
	bh=E6HvBbB4JsDAiHR+gry7J2JsrZdsb9VKS/0xJ2XBFBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HtT/fnagbfupKtgnz6fLkBZJbIhC1HxUZMO6neNBmAuee3oLXjL1dvyVKsNvnigEt
	 iiTkoYF4ZnxFGA+uOp4xacltGwNHVQ0jQ+L0pv/IKsfXliEpKI/Et6mbtTCKderd7y
	 zDYoH7RgrW6Wm2RcWQ18mLphZAkN7DPaGUzWh/ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.6 457/538] wifi: mt76: mt7615: check devm_kasprintf() returned value
Date: Wed,  2 Oct 2024 15:01:36 +0200
Message-ID: <20241002125810.482849738@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Ma Ke <make24@iscas.ac.cn>

commit 5acdc432f832d810e0d638164c393b877291d9b4 upstream.

devm_kasprintf() can return a NULL pointer on failure but this returned
value is not checked. Fix this lack and check the returned value.

Found by code review.

Cc: stable@vger.kernel.org
Fixes: 0bb4e9187ea4 ("mt76: mt7615: fix hwmon temp sensor mem use-after-free")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Link: https://patch.msgid.link/20240905014753.353271-1-make24@iscas.ac.cn
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/init.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/wireless/mediatek/mt76/mt7615/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
@@ -56,6 +56,9 @@ int mt7615_thermal_init(struct mt7615_de
 
 	name = devm_kasprintf(&wiphy->dev, GFP_KERNEL, "mt7615_%s",
 			      wiphy_name(wiphy));
+	if (!name)
+		return -ENOMEM;
+
 	hwmon = devm_hwmon_device_register_with_groups(&wiphy->dev, name, dev,
 						       mt7615_hwmon_groups);
 	if (IS_ERR(hwmon))


