Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9D11E52C;
	Wed,  2 Oct 2024 14:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878832; cv=none; b=KDECYj2nbr0EyG0wua9WIq5PKKkJhxmY4+zpJFegBGkqysiQdO/0rmmNN6bnQw94ycp4sswODrwPUJboXtf9eWECCSPvIU5Y0rxulipJk1NoM2ZrHMD0gFHWLhi6KzEGhNrNWfkf4tDLd7zNLxEEAVbuacbgr3N9rqpe+6BIlI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878832; c=relaxed/simple;
	bh=61MS7Ciugh1Oas7AsRGqRgSj3kgTR5rUutIBA2/G1Bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sifOFtEcFzg7gUcCpy80/FtQhK+4yeNJJR0gedelgUgOb4PrmQuj9mkJdmin17Ir7cvVyoXg3xoCDtZxth6huEmWa8pJsUz3HyYydkjemLRu9YJ+TRtLteufVekiTW/ssXvMlubGCPFEM0udh7kbQipyO6QZ90jVEgYsmWVgkEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yfn46vct; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yfn46vct"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F81C4CEC2;
	Wed,  2 Oct 2024 14:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878832;
	bh=61MS7Ciugh1Oas7AsRGqRgSj3kgTR5rUutIBA2/G1Bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yfn46vctjRVb4ZGGQgu0J0w5V2kgj5lm0fkIQ6KAHdPJFxtetI6EUrVv8WrSfHIxP
	 lcRXGbTHadttyJJ5M8lOYr1CthIky5EYvyml3mGmo7fHAOiLKBuMXOm53NvHWOXOPU
	 kUufDDon+zzwZCi7Vpl9OQqdul4pp3ss1PsCKjek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Felix Fietkau <nbd@nbd.name>,
	Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH 6.10 548/634] wifi: mt76: mt7921: Check devm_kasprintf() returned value
Date: Wed,  2 Oct 2024 15:00:48 +0200
Message-ID: <20241002125832.742005141@linuxfoundation.org>
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


