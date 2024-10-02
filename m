Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8CFD29CE7;
	Wed,  2 Oct 2024 13:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876948; cv=none; b=Zt9Zjo62z3l0PpaglnFXoj358Dq6ucyKw36BZ5t3u6jL0LOkLppazIPo9fSMCt/xDppBrfBT+L/yN38eBt8V+mYEoMrKN3dn1WqxUmOBfmnYmV7MHyxJbqFZzlsEdNFruzdAcbf/tkSra8cfb0utb0CILWd2Rp3cJ1iVTgk/kjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876948; c=relaxed/simple;
	bh=ix8eF7oA5gg8CX38ZOqWEGBRt88C953bNmMXF1VFQLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bwHSrQjDrxZ0PJXnFKaMwCHCfaOUb7RNLwvzZJhYVYCzdVzD919Nuy3GJI0Htt06aoaSUYWrqkSWwxf9aSeWCfizmNrxVJ9RAa18RV/dxKP8dw2C6axGWHRmN88483o0T6N4G1VNVw3cQvgdp4MOyvZ4L4tNUu0qU8EuN1D4olU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bjJwJMX2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bjJwJMX2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE50C4CEC2;
	Wed,  2 Oct 2024 13:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876948;
	bh=ix8eF7oA5gg8CX38ZOqWEGBRt88C953bNmMXF1VFQLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bjJwJMX2wlCl30jnXcwoku1kOvqtXWuN4rjp3T39KaYZzuUVZ0ru+b/aTm03d2fw7
	 9x/86pZhwYIQdZSMiUtMgG8Sj3ro8EZiBqFPH9C+mWrBYSPR4QhxpCpvDWh54KHnUn
	 uLvHJ2HvTVzjrr1iJNNcF2yQY8J3l44n2/4rwnew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Felix Fietkau <nbd@nbd.name>,
	Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH 6.11 614/695] wifi: mt76: mt7921: Check devm_kasprintf() returned value
Date: Wed,  2 Oct 2024 15:00:12 +0200
Message-ID: <20241002125847.023048674@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit 1ccc9e476ce76e8577ba4fdbd1f63cb3e3499d38 upstream.

devm_kasprintf() can return a NULL pointer on failure but this returned
value is not checked. Fix this lack and check the returned value.

Found by code review.

Cc: stable@vger.kernel.org
Fixes: 6ae39b7c7ed4 ("wifi: mt76: mt7921: Support temp sensor")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Reviwed-by: Matthias Brugger <matthias.bgg@gmail.com>
Link: https://patch.msgid.link/20240903014455.4144536-1-make24@iscas.ac.cn
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/init.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/wireless/mediatek/mt76/mt7921/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
@@ -52,6 +52,8 @@ static int mt7921_thermal_init(struct mt
 
 	name = devm_kasprintf(&wiphy->dev, GFP_KERNEL, "mt7921_%s",
 			      wiphy_name(wiphy));
+	if (!name)
+		return -ENOMEM;
 
 	hwmon = devm_hwmon_device_register_with_groups(&wiphy->dev, name, phy,
 						       mt7921_hwmon_groups);


