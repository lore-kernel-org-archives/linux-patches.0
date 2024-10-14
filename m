Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F63045C1C;
	Mon, 14 Oct 2024 15:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918468; cv=none; b=eIoHizAmo7FF79arRj1IAYJ88AlliGLnTFSAfnKxetec8Bd6VOq9ckbSHElWL+/74NXIhoUfOxlkb8XiKnbSN2/XYveZSqbqj3IXryGKCro3Erys8AQ+V7HZOD6trsBdWpy/QOxpQX6t4me95qi//wiIYvFfSM71zcT4nd8a1G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918468; c=relaxed/simple;
	bh=rKhUx44nKGqb8zNdVSX6GU+3S3AevWy4PFhgr7jE4mc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e3ZhAITVWRrmDry9CFHUh2HvQRbqN5oQw9RXsbBi4ycNLP+vqUTuYObYUZQASKY2nak5oPCBzxnWGsxNDiUwi5xBa2wktQ3499YSjFTQediyLYBfDQAcrSd62t7KQx/w0KxxN4ZqHhJbXCbO5d47CJKwPG/+UT52vqyuLp29Z2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=juhoCCdv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="juhoCCdv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCF2FC4CEC3;
	Mon, 14 Oct 2024 15:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918468;
	bh=rKhUx44nKGqb8zNdVSX6GU+3S3AevWy4PFhgr7jE4mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=juhoCCdvgDPFTvgM1KSZpfQQ8/F7jNSDvmSGys0zYlPJgcyyfOWFH5jDeMuS99RJu
	 refgcOPpm53qa4iJsLvWaM2Il1UIAsEXNtLlzUWkITmslGw2ojRMX7FOZVYz6a8wN1
	 gr0A5k/xFBN3GIGe8d8JuIslvFSOEoGKJisF0TcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.1 325/798] wifi: mt76: mt7615: check devm_kasprintf() returned value
Date: Mon, 14 Oct 2024 16:14:39 +0200
Message-ID: <20241014141230.720508728@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


