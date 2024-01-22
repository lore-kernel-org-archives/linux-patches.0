Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8374768EC;
	Tue, 23 Jan 2024 02:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975482; cv=none; b=Jubx9EIlDZP22AR5EEoT4FOKd8m67DZJXqCmWRIjXl29uY9Frstce6xtiTzrIP9lx2Kf83FxIgIgZVAraTcZ/984MNqMKMxvXjbV5wv+5E0s3sIB2Ov8xUIGRfFS2ZdHaWhbh1D1HtQIs7C1soM6e4ILQVfskKLQoqJMRJ548bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975482; c=relaxed/simple;
	bh=tDpEDVPfpApsiArWeOS6JoRZI3/T4SzPeE1ui/+lZHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qhzuQdgtL9QIaTbGAbMXTcEGLPY4S4hVwPqY1GnS8he2ON80aWwOONawTzN1BB5vs+PaqLsfd0qgY/NAY/atIsU829KBH5F6JNZgF2G3aWY4bxIKmUdRAek43SPMd7io/Uyk3hvTEC3yHxrzhIgOuxS6YUrrOcWVWHPZcmT1dd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ejj654K0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ejj654K0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7957BC43399;
	Tue, 23 Jan 2024 02:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975482;
	bh=tDpEDVPfpApsiArWeOS6JoRZI3/T4SzPeE1ui/+lZHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ejj654K0IfMpMgcYBtaJeeN4yAW6g2khQYbJ9PKwFsPndX546jMhJ7XMk20fUnRNZ
	 qAiEryOOz8ir3dsg6c+g//l+IZpXoQaREqZ9a6NQkbbbTkZzjvu7FxknFv8dYMRfEg
	 alUbGbymbh7cUJyW5Vze7DVCR/IWXeZ//QvPyY88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.6 413/583] wifi: mt76: fix broken precal loading from MTD for mt7915
Date: Mon, 22 Jan 2024 15:57:44 -0800
Message-ID: <20240122235824.608296928@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Marangi <ansuelsmth@gmail.com>

commit e874a79250b39447765ac13272b67ac36ccf2a75 upstream.

Commit 495184ac91bb ("mt76: mt7915: add support for applying
pre-calibration data") was fundamentally broken and never worked.

The idea (before NVMEM support) was to expand the MTD function and pass
an additional offset. For normal EEPROM load the offset would always be
0. For the purpose of precal loading, an offset was passed that was
internally the size of EEPROM, since precal data is right after the
EEPROM.

Problem is that the offset value passed is never handled and is actually
overwrite by

	offset = be32_to_cpup(list);
	ret = mtd_read(mtd, offset, len, &retlen, eep);

resulting in the passed offset value always ingnored. (and even passing
garbage data as precal as the start of the EEPROM is getting read)

Fix this by adding to the current offset value, the offset from DT to
correctly read the piece of data at the requested location.

Cc: stable@vger.kernel.org
Fixes: 495184ac91bb ("mt76: mt7915: add support for applying pre-calibration data")
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/eeprom.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/mediatek/mt76/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/eeprom.c
@@ -67,7 +67,7 @@ static int mt76_get_of_epprom_from_mtd(s
 		goto out_put_node;
 	}
 
-	offset = be32_to_cpup(list);
+	offset += be32_to_cpup(list);
 	ret = mtd_read(mtd, offset, len, &retlen, eep);
 	put_mtd_device(mtd);
 	if (mtd_is_bitflip(ret))


