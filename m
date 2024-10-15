Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334D51D4154;
	Tue, 15 Oct 2024 11:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993185; cv=none; b=IEn03I9LgVjtidmlyT6002wy5J3cfcnIMacwfPNfNJFM9xCE/2DF/eXvOC8XPuf5HZp2Bh95wfWPamdValCEe0HUjwvQdLLi+Z0KshneoSO/ea+ICgX+EyrkYGFoOse7ZvtgS8dP2xBUTJrN4b+cozEG8HPz0NuUz0gOdi2CJ1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993185; c=relaxed/simple;
	bh=W75oMlwS0mlsZS5PuRgpxhGvWbkN+232kz7cAGee2ck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R+dNYrEt+FiuY+CRWVm/N/jq57oJnkgl1LiIMr2J8aSEhN96CLr0iOkgP1GNcZ1sbq3CBmEq+4Vyd7ghYSAyMRoqQ7tXF3XvCHBCRLOzyV93lyl78r+yrdJLGu8mgMZG6RGZH/G+u62qR0V3pyByk/U/Ixy7ES0LfTRN8fRtX+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mi5qrE02; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mi5qrE02"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A041C4CEC6;
	Tue, 15 Oct 2024 11:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993185;
	bh=W75oMlwS0mlsZS5PuRgpxhGvWbkN+232kz7cAGee2ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mi5qrE02rRi15jEFEltqUdHvxBNrgZ7UKnp+Cz54cdnedQI2CBXs5S0HRT/0twnBc
	 jaEgQED2JfimcnlfvzhKRW1XCTYTT2Jf/RMTgg4eja6FQQcJ5jjqfU5i4s6D1BSAxx
	 r2xll/s9tq4P42rcZEXjWDQhTP3OwO5JQ7OOsEj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 5.15 336/691] wifi: mt76: mt7615: check devm_kasprintf() returned value
Date: Tue, 15 Oct 2024 13:24:44 +0200
Message-ID: <20241015112453.678754843@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


