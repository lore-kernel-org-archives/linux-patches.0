Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9180D29403;
	Tue, 23 Jan 2024 01:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974743; cv=none; b=nNPGfCm7VICOx66xC/vt7zQCLvNLhZlx1NlmZXsRvVdC8JuWzBnyReVoeliKyEQJBXRJ/VcJ5uH9wxcElGDP09QCJUqFCdX1Pu0NVSbmfJoMIKebmWzDdULBqC48+YzK0g/sEoGAuOxI9PCrYtPNcaXvNZmT8mT/zbhGG6C1lNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974743; c=relaxed/simple;
	bh=9FM7nUtMvOFJL6SAOaNPIlVnayCib4mHyMv856YPcC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OvapK8RsQUCQKZcZWo8SCE4ljFf7oxKt7GCbx+U3vD7JHuVv9/5PB+BOIyPRo3jSFGPESzkGLuu5ts5IJWZ604Rj0hEfjwHtrmkE0AXcPPCvW3PqHcFipenIT7KkYXP7qDvZruUavI1RWa6jde+mYnsOHM8Dbj7Eci3vCYGCbAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JY5Qmhj4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JY5Qmhj4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 575A9C43390;
	Tue, 23 Jan 2024 01:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974743;
	bh=9FM7nUtMvOFJL6SAOaNPIlVnayCib4mHyMv856YPcC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JY5Qmhj4gROipPuQCer6j0ZLOys05358Ddh92YuMtdA9DTA+nrU5llor14iE3ZrJz
	 djip6RIecYJ6XFUmPNjchKr7BmpKTAg18PY/xh7qU51gZ0M5DDxeq6WS1BBn6MFev/
	 P5hO6+WZbgwbIFnmHrZTBtxqEJYJNWzV4WJq2bHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 5.15 277/374] wifi: mt76: fix broken precal loading from MTD for mt7915
Date: Mon, 22 Jan 2024 15:58:53 -0800
Message-ID: <20240122235754.405816872@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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
@@ -51,7 +51,7 @@ int mt76_get_of_eeprom(struct mt76_dev *
 		goto out_put_node;
 	}
 
-	offset = be32_to_cpup(list);
+	offset += be32_to_cpup(list);
 	ret = mtd_read(mtd, offset, len, &retlen, eep);
 	put_mtd_device(mtd);
 	if (ret)


