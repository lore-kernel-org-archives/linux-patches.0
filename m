Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8482A2E06E4;
	Sat, 12 Sep 2026 12:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216824; cv=none; b=dBFMo04t1b7K2tCiQTmcvpl7zID5MifCjHUzZycEu0fRqP43W1rzhHhY1giZKhjN4Tlap37TqGmWqNJLOKeiGb/ejkTRMwXO/d4cgO8ZTjWjp5pgpPxExa9/oLqgmBAReW4MymmwzoqSoCCMLvudqi92VlzQ4pORojveWmH0UXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216824; c=relaxed/simple;
	bh=IjQz7SOv/MWRtVMPt75QIEijxeVQXzDT266n9g15gKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kp7f7XWxxsu5bXDCem7U6FfSvhnT+ulXjlLHtfG/nJMk4TktlNGuch/IQXFE8lMlt3uOERqltvWrlkhUjrZnz4RY/myTUKrq1VTaIcw2hc93wvxEi/cOa5tGNcalek3VLSuDoq80uVMHEkPnr1D2CdqV/ouIMy0C/NBUMFlD5eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bk1pOc2J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bk1pOc2J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D25F1F000FF;
	Sat, 12 Sep 2026 12:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216823;
	bh=NQsNX/+/nWDvdvtM9hXxoy5sYpEGJNrBAznnBzDDqwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bk1pOc2JAHWrxObkyclMWmC+J4mZ3XLmI43l1M5OHlKphYgr35L5xp49EZHT2X9+I
	 Vu3zEctcEzq1YDS2jD1TTqLnQyagxMJ4QqwCtLZ5cVbfY8I93nDZXB6ukAqQ0qOPxS
	 0AEJF90fzf2sZiA9yCzMiJZPE0Rhhmcq1yoWfczM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0815/1376] wifi: mt76: mt7915: poll the correct SLP CTRL register for the second adie
Date: Sat, 12 Sep 2026 08:54:01 +0200
Message-ID: <20260912065625.706849401@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit dd59a6126a8f1bd52bf6bd057bf0c8307f76a74b ]

The clock enable path for the second adie sets MT_ADIE_SLP_CTRL_CK0(1)
but polled the busy bit of MT_ADIE_SLP_CTRL_CK0(0), so dual-adie
bring-up could proceed before the adie1 clock was stable.

Fixes: 99ad32a4ca3a ("mt76: mt7915: add support for MT7986")
Link: https://patch.msgid.link/20260722082610.2699628-18-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/soc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/soc.c b/drivers/net/wireless/mediatek/mt76/mt7915/soc.c
index 90a6f61d10892..c0372f693cd49 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/soc.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/soc.c
@@ -913,7 +913,7 @@ static void mt7986_wmac_clock_enable(struct mt7915_dev *dev, u32 adie_type)
 
 		read_poll_timeout(mt76_rr, cur, !(cur & MT_SLP_CTRL_BSY_MASK),
 				  USEC_PER_MSEC, 50 * USEC_PER_MSEC, false,
-				  dev, MT_ADIE_SLP_CTRL_CK0(0));
+				  dev, MT_ADIE_SLP_CTRL_CK0(1));
 	}
 	mt76_wmac_spi_unlock(dev);
 
-- 
2.53.0



