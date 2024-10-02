Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452A81D1F54;
	Wed,  2 Oct 2024 14:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878853; cv=none; b=dMWEp/4polQKfRBkV68wXYW7BZr51yJZrEtIy5WPtW4sfN9LH0IUcqyFTv6cXnEfIM+1TEo4KWNyXBJdV2Np0X9Sw4MMBegEB3p8CDz2XaSBzcv2gcmw44kvp8qCt7oaScLkyrjXYSqDL1HGsHGQ1sYnv9hyTsnTACsToI5MPlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878853; c=relaxed/simple;
	bh=4HtmzEn0srA4tPt9FIxf4MRMZYqDhZhfjjgOd/ouujc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FHvpyI5EqMKd/Vd1HapcJONCe6AOVTBzXCXfg0NJhfElBgQptJSNCwEJnxp9z5GQYLgf/71swNlUxmtYxa/9hqub6Ip4F+BfigAHppgsGJP+N264vHsgXmnaj9op7uOMyVWRDrbTT5BQgecU3K9n1j9C+ORGohPjXE+trhUQbPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fy0kbaqr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fy0kbaqr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5914DC4CEC5;
	Wed,  2 Oct 2024 14:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878852;
	bh=4HtmzEn0srA4tPt9FIxf4MRMZYqDhZhfjjgOd/ouujc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fy0kbaqriu+PtO7DgMJpGID1+u7ahyjB6mMfBhkhY83iCncAuJBKj1TXq44jylXpZ
	 2v4vt5w3fP7+fKxTSqZynxO/YDcjqP9IVg5ggi3+tEIkRsSTX3+NQO1HnE6+1Kv1YU
	 6C5f4WxGLINx+cJRS93Af/Pe6Cz9KkUNdiW/dQQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.10 555/634] wifi: mt76: mt7615: check devm_kasprintf() returned value
Date: Wed,  2 Oct 2024 15:00:55 +0200
Message-ID: <20241002125833.017870674@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
 	return PTR_ERR_OR_ZERO(hwmon);


