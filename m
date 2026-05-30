Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15632E92B3;
	Sat, 30 May 2026 16:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160305; cv=none; b=aISr0V9GBvU+HpvyqRET1ILWJuWFGBKO2QMerLA7J8itQTnePuwH6LhBNk62V3KMmZABeKc/h8FnnTut7QBnTxaMfLGVh600x20DIHk+dJi+SBekIib90Fd4nfPbPf37Kt3xKOG9DubI/z/PPPoGapkdqHH11Bfx7RB7/TaIA7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160305; c=relaxed/simple;
	bh=NIf7+V54M/i4hvFiIAPxnk7OrkInf9V6C7pcxPi5n/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uHu37B0EPtEnhUVMile3R5Y4wV6L+SAEym1et4xvCO7kJAGe7n/wkLxDmffDZVl2k1E4tKb6BMo/2t4SRt47pYU6d0nYXsZW/iwbOaEbk4+UBEgi/6ewHFJtMOIlXn7Ov6Dj6p7Dnm7o3BN1b7MWIS0CgJZDfFpMBG1bL2NFqTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hxQCWYh2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hxQCWYh2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 256811F00893;
	Sat, 30 May 2026 16:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160303;
	bh=jCTLugJUK47HrA3Nh+KMVmqtglDIwH3jw1j2vuvQAxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hxQCWYh2/WfInugu7MyG70Enr9fwPAQIc/jbJZAUrMuyWVO8CmZvlVT6YOw3GbX4f
	 oobs7aswrXfibkm5351IrA3knj02jk8g7JJkKk3sESPahJlIT+wv2OrYhgMZ0MVHf4
	 nomkmXN4/p4iSssL7h+F0DLYe4TQIiT2ZQ5BSptg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Yen <leon.yen@mediatek.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.1 300/969] wifi: mt76: mt7921: fix a potential clc buffer length underflow
Date: Sat, 30 May 2026 17:57:04 +0200
Message-ID: <20260530160308.720888713@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Yen <leon.yen@mediatek.com>

commit 5373f8b19e568b5c217832b9bbef165bd2b2df14 upstream.

The buf_len is used to limit the iterations for retrieving the country
power setting and may underflow under certain conditions due to changes
in the power table in CLC.

This underflow leads to an almost infinite loop or an invalid power
setting resulting in driver initialization failure.

Cc: stable@vger.kernel.org
Fixes: fa6ad88e023d ("wifi: mt76: mt7921: fix country count limitation for CLC")
Signed-off-by: Leon Yen <leon.yen@mediatek.com>
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Link: https://patch.msgid.link/20251009020158.1923429-1-mingyen.hsieh@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -1054,6 +1054,9 @@ int __mt7921_mcu_set_clc(struct mt7921_d
 		u16 len = le16_to_cpu(rule->len);
 		u16 offset = len + sizeof(*rule);
 
+		if (buf_len < offset)
+			break;
+
 		pos += offset;
 		buf_len -= offset;
 		if (rule->alpha2[0] != alpha2[0] ||


