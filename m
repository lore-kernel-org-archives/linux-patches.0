Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7BE837A84A;
	Fri,  4 Sep 2026 06:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501856; cv=none; b=CelEXkdNzDr4nk91AFpCpAusjqA1Dk+sRwYFi3UXHY2TVZJYhxhBGhJ6pAXPZjEboVgXNzxJ5zUKkAnX45zpYY6980llsTw/OKKYCOcuwQVsU2wjpng4PGPUgerJSvwR90g+b5bVzWB0FJYr8+5qSATAnwK0M9RYFvtUnLTJ16Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501856; c=relaxed/simple;
	bh=rW5tJh11CYc3Pk8DMwU5phzJizoHRsDDQwVsiIdBTIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mTwFkzspJ8X8DTwXjzy2rv7j0qEd5+b4UC7t+Uqj5PVX2BpTppkBT9+ICzOX9mKHL96lBEoZBoFeaZQ+pg0VR1COesWasJksiRC5Q5iJznRtXDdiXQNiN26YivYMXdvEfNByCQ2gwlj2ujEQN/7T/+cdh/hCIog7k2VuCNDQZak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SjvO/RyQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SjvO/RyQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40CA61F00A3D;
	Fri,  4 Sep 2026 06:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501854;
	bh=Phec8ZjK+4Vy8QRxdfZOkW0Fhz99At920ps2MmU+QwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SjvO/RyQ+4X1AVhqZoV53j2573WyrkNIx4uGru3rrgOxzTAUTnBaJbWizcV/q107c
	 bfDNZyOzEd0+9nuk27cNq1ANHF6L16zZ0RsQB60vof0R5bqB+h/9n3w85DNGqycRif
	 J1JTpIEZTJ44WwMm4GuSokdASHMxFT8Vl//RZ9pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.18 537/552] wifi: mt76: mt7996: validate default EEPROM firmware size
Date: Fri,  4 Sep 2026 07:01:34 +0200
Message-ID: <20260904045802.789895635@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -148,6 +148,12 @@ mt7996_eeprom_check_or_use_default(struc
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
 


