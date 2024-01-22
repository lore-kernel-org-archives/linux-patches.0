Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1061F12DDB0;
	Tue, 23 Jan 2024 01:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971728; cv=none; b=KRLN7MGfKobssFsBQG2+FTws2F+JW4JBJGfXxU/9JojA2ok4sVpbtdXvWxCXvGrB/R/6eSFSuhhUPQsudwrno99A1R01T4ZsslgQwwiT04xIkH1FsNWox8xd8DCJj9WdI06tY2flCnL4Sx5/kZiPZXbk7/qSCSkePiRctZBEO5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971728; c=relaxed/simple;
	bh=R/ddnG+c1aT8Bn/RPb9GgB2h1WwMncdmu1c565jGtLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U2e1E86pHybevMDyWfMWlHfgHhrx7uVh+056vBCKLfxCYlMjSODU5GXBbVEap2CmcAnlgsEKDoRxbwl6IVLpTdbgJ7YW95LsRkaCUy02LvFSBGehuEGZ4lyyfM4GrTfRoRRLWxzp70mfZMmz06dJ8ZM91JlAIFe/8HvqHq+hLRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BxbqXtPq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BxbqXtPq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E18C433F1;
	Tue, 23 Jan 2024 01:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971727;
	bh=R/ddnG+c1aT8Bn/RPb9GgB2h1WwMncdmu1c565jGtLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BxbqXtPqCELQBA5OI+FjwyE4NpLXLH1icaBNsv3jDUwuvv89dFuhWRLHnA9lc5zae
	 4t2MzPSHFC/c4BDCJzItz55426CyGKBvDRsFVEpNf2tgZ+NV8O/nTybUhlR1NEYcv2
	 2Y528ut6rOCPh+P0+InD7Srd7Uc/LXf/3+T5VMYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.1 307/417] wifi: mt76: fix broken precal loading from MTD for mt7915
Date: Mon, 22 Jan 2024 15:57:55 -0800
Message-ID: <20240122235802.460042745@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -62,7 +62,7 @@ int mt76_get_of_eeprom(struct mt76_dev *
 		goto out_put_node;
 	}
 
-	offset = be32_to_cpup(list);
+	offset += be32_to_cpup(list);
 	ret = mtd_read(mtd, offset, len, &retlen, eep);
 	put_mtd_device(mtd);
 	if (mtd_is_bitflip(ret))


