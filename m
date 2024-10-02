Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB92E1D04A2;
	Wed,  2 Oct 2024 13:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876951; cv=none; b=AefbpNzPIEIOTZQDTk0hGfUWttcvuqxhpPUWnf5UjWwHbWt5vv+XG8KCJhIZfQ8EwtnhOUEzcBUcT0P+J5FoMAl0ocVHLWJpJ/Dr9ypujIlgCivb/vWUMQSiDoqbj2x7P0f5BrqiMphAz4iL1PGQgwz7j12hIFjv9iEyjiHQRK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876951; c=relaxed/simple;
	bh=sZxy0XyWmYPfDtFmIQUxC+lUth+aTvSF0eG06ASK7As=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bGMsExu+XC8lCZMff0mYKk+sAkRG113J1FTGtGz6WG9dJzHJkdaIGrPztQIuPiGwvNzJLqDLlE6Er3h+jrKvQ4sMEdeypNbVQxoX4H/CDhGr7yUa1DsjFS0iwXe/CDaxrpmqbgD0qpnRSPEWPz34DL7k9LY1S20KsP4msE3AWss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cXn1gcbm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cXn1gcbm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B727C4CEC2;
	Wed,  2 Oct 2024 13:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876951;
	bh=sZxy0XyWmYPfDtFmIQUxC+lUth+aTvSF0eG06ASK7As=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cXn1gcbms6nr0Ko592S6Aq0CAs5DXdxg1a0Abmp/oHYVAcAU6ba/DxxOv9rGIt16b
	 RxeSHJ1A9rQDuT458bHJFodC6lTmxG8+iSHvS4vQgKzyw/+j7ZedbJiSXubHxSwj0B
	 +/XYIVTXrntgEde5Qp7JPqe762a131fTyPFayGWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.11 615/695] wifi: mt76: mt7915: check devm_kasprintf() returned value
Date: Wed,  2 Oct 2024 15:00:13 +0200
Message-ID: <20241002125847.062609400@linuxfoundation.org>
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

commit 267efeda8c55f30e0e7c5b7fd03dea4efec6916c upstream.

devm_kasprintf() can return a NULL pointer on failure but this returned
value is not checked. Fix this lack and check the returned value.

Found by code review.

Cc: stable@vger.kernel.org
Fixes: 6ae39b7c7ed4 ("wifi: mt76: mt7921: Support temp sensor")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Link: https://patch.msgid.link/20240903014955.4145423-1-make24@iscas.ac.cn
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/init.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -194,6 +194,8 @@ static int mt7915_thermal_init(struct mt
 
 	name = devm_kasprintf(&wiphy->dev, GFP_KERNEL, "mt7915_%s",
 			      wiphy_name(wiphy));
+	if (!name)
+		return -ENOMEM;
 
 	cdev = thermal_cooling_device_register(name, phy, &mt7915_thermal_ops);
 	if (!IS_ERR(cdev)) {


