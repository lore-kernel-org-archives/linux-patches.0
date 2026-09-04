Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA5D4CCDC7;
	Fri,  4 Sep 2026 05:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500229; cv=none; b=LicoRbtw6cqt3y9Up/836FSqTleeyaeoSpC+ccThffsRcTYeCEjqOoN4i/mYyo18MOQvZ3BcFlQAO5satTiQGpCRy0Y+yUDg19YJeLyP57szUUmNbOJs+DlC0BU0uAZznEZDyP8PEuzuxGNWQcUFXs2lM9p8ILSfZyLqfwBasZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500229; c=relaxed/simple;
	bh=0v4A5T2v0bZdr5lVwlG6XyxSK3NsWkMe+j9wDp9hZ+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pYoxyKSU3uLC6WGRcwaIjGAFCPAtRAne7UOlB3lBOU2pl3IsWnIkHdAbfaCO2rd0QEHydxVNoA5qwdJua0VediGiDZ9T8ggStcAVUurjxSgLHr7IIgWaBHUzuvnC+C4eOC7imzk7SFQEM/u710eI6PkmXgHWOInHg1Ex2MVMpSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gxGWLkwE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gxGWLkwE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21131F00A3D;
	Fri,  4 Sep 2026 05:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500228;
	bh=6z9Z7UYmIJPEi1QxgeP4y4+htDCSOtQ0LBKqarzkpAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gxGWLkwEBoNwIpnyHL/DO2Vwyf9TPB+YcHwADL7FKYGBWFn1AdDBt8nLW2OIC/2Sn
	 awAXlsHdPRMYpRo6WMjIvEvcEBBRoz1dQ368e0a4AErfVrG6/6yiczStHBsPeNsVz/
	 r+mC8WVABnqgmrARq56PdR7yzr0VyrPyai2WcYro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 7.2 697/713] wifi: mt76: mt7996: validate default EEPROM firmware size
Date: Fri,  4 Sep 2026 07:01:05 +0200
Message-ID: <20260904045819.470000964@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>

commit 653c6e289b13cc6942f3e8f8e3c568e70fa42d1f upstream.

The default EEPROM firmware is parsed and copied as a full EEPROM
without checking its length. A truncated file can make the driver
read beyond the firmware buffer during variant validation or the
fallback copy.

Reject files shorter than MT7996_EEPROM_SIZE before parsing or
copying the firmware.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Cc: stable@vger.kernel.org
Signed-off-by: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
Link: https://patch.msgid.link/20260713115412.67095-1-acharyalaxman8848@gmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/eeprom.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/wireless/mediatek/mt76/mt7996/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/eeprom.c
@@ -150,6 +150,12 @@ mt7996_eeprom_check_or_use_default(struc
 		goto out;
 	}
 
+	if (fw->size < MT7996_EEPROM_SIZE) {
+		dev_err(dev->mt76.dev, "Invalid default bin size\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
 	if (!use_default && mt7996_eeprom_variant_valid(dev, fw->data))
 		goto out;
 


