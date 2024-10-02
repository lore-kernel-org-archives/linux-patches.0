Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A987B18DF60;
	Wed,  2 Oct 2024 13:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876980; cv=none; b=h2ENHcIaJFMYNsu4t2XsLeJZydWbcBg4AaW+8BTklgN2umwVn2x9goB3+QvKDXmE+4/JmzG0HXzzSV0hvci4LjP0UcvkoWYP0cr7eQ4SfqfbKV0QmjEY78ue8rgfKLU1xft6IicMqmJYlWll3Gn7LuH2SUDKpDM/l14yVj1KngE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876980; c=relaxed/simple;
	bh=BAsXiuvc2w7vvsJIWJXFMuG7L+Eb57X3G9hmz3zq04U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gQEWShOWFyR15BWI2vMg+7WhhAhQH1T0CwfgJGfYHRmLvCv6U0FRZAX+K9Gy8wN27TkrEfUY541nrBossGz+iby4A7dPKhIfkpc/PEpxvwxLMSHzUoZX7HFn8+ov312DNmGMgsFXIb7FRqBq04g/eXjl1wYGFRFDMpoQRnzd6JU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cr3rDEB6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cr3rDEB6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDA5EC4CEC2;
	Wed,  2 Oct 2024 13:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876980;
	bh=BAsXiuvc2w7vvsJIWJXFMuG7L+Eb57X3G9hmz3zq04U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cr3rDEB6OMOm4LtDQpB19+7ZxFFcei43txT17UTQV+x4lzaWdWd19Sv93ojxuvITJ
	 ZYWWS45jjmd9vQudXXz5rwGRPomCt0Mzv7DeeCvfvLrfcUwx7rmVwvSNjRBI+SF0iA
	 wABMQG/hBJ6XO6zpOACCatLKAX08QMa+5eMhCp0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.11 622/695] wifi: mt76: mt7615: check devm_kasprintf() returned value
Date: Wed,  2 Oct 2024 15:00:20 +0200
Message-ID: <20241002125847.340396981@linuxfoundation.org>
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


