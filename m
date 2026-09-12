Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AFEB427F91;
	Sat, 12 Sep 2026 16:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231965; cv=none; b=k30ZVdNzyYUOQGwUgOa0f9q5o7L9/+jat3jZMeXnownIYSQk4+u36d4aqmRFzWsMAPLpYdKyDIPv9Mq1Gi6DgEtDcBCeuzRh29LTTc/Ak83vEJVpWUyrCBf+nTCxu4KI92beOOLiG+jFq7jTtL+0RUcYlo8lRJDAz3VDFuJ4EPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231965; c=relaxed/simple;
	bh=ggYE2bwJh2Dh8kHzjKKUjWGunBTP5ZVVjfDwAJWYiP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CqQfYZcJFlOTD5VCsqZmCr64xlHxH4gmRpn+c60H6z9uPFXQdehuP9mgDYjAr6CWERqkd+HAoFHQqettWJss5UwEKmqtkwH4o188TD0QfRURFw17UW1Qan8NuUg6xaEx39LNLXm8+SRRnI9/24rXDYOQlTrwnm9Kblb5LhAzG1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S09wW9Bf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S09wW9Bf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D933D1F000FF;
	Sat, 12 Sep 2026 16:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231964;
	bh=LL9Z0jYPn0XEs3AmPcnOxD2RdDbzrYPN4OnWiGW6wJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S09wW9Bf5YfjiE32GFxOWPgEctuPmQRrLT3d+1wfP8QSbcfm0DSeUOZJY5WkTrC/H
	 tWZ3CIIU7V7+/rSRlQohmvYFbpGgzqGw2/Qt9PVMfFVvBt5gKmCL31CobVvOeyyPdm
	 GfO04XweV1HRUKVVLVA/zbgoi4vcg1wD2WbDzsS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1063/1191] i3c: mipi-i3c-hci: Fix DAT/DCT entry sizes
Date: Sat, 12 Sep 2026 09:03:11 +0200
Message-ID: <20260912065612.049439453@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Jarkko Nikula <jarkko.nikula@linux.intel.com>

[ Upstream commit 0676bfebf5766f0a60549f74ba597115028fa39c ]

MIPI I3C HCI specification v1.1 describes the ENTRY_SIZE field for the
Device Address Table (DAT) and the Device Characteristics Table (DCT)
section offset registers (DAT_SECTION_OFFSET and DCT_SECTION_OFFSET).
That field is not documented in earlier version.

ENTRY_SIZE value 0 is meant to be backward compatible. For the DAT entry
size it is interpreted as 2 DWORDs (8-bytes) and for the DCT entry size
as 4 DWORDs (16-bytes). Values 1-15 are reserved for future use.

New version I believe fixes also the TABLE_SIZE field description.
Before it was defined in DWORDs which I believe is incorrect since the
DAT/DCT table entry structures, and sizes, are described having
8-bytes/16-bytes entries.

This is more clear in the specification v1.1 which states the TABLE_SIZE
fields are interpreted as number of entries in the DAT/DCT tables. I
believe this same holds also in earlier version, at least it makes more
sense.

Fix code accordingly and let the DAT_entry_size and the DCT_entry_size
variables carry the size as bytes. Which is how it is already
interpreted in the dat_v1.c: hci_dat_v1_init().

Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Link: https://lore.kernel.org/r/20230921055704.1087277-4-jarkko.nikula@linux.intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 308ecb824db3 ("i3c: mipi-i3c-hci: Fix missing STAT_IBI_STATUS_THLD in PIO mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/mipi-i3c-hci/core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/i3c/master/mipi-i3c-hci/core.c b/drivers/i3c/master/mipi-i3c-hci/core.c
index d3f9d14c32f33..8622125ad3e4e 100644
--- a/drivers/i3c/master/mipi-i3c-hci/core.c
+++ b/drivers/i3c/master/mipi-i3c-hci/core.c
@@ -610,17 +610,17 @@ static int i3c_hci_init(struct i3c_hci *hci)
 	offset = FIELD_GET(DAT_TABLE_OFFSET, regval);
 	hci->DAT_regs = offset ? hci->base_regs + offset : NULL;
 	hci->DAT_entries = FIELD_GET(DAT_TABLE_SIZE, regval);
-	hci->DAT_entry_size = FIELD_GET(DAT_ENTRY_SIZE, regval);
+	hci->DAT_entry_size = FIELD_GET(DAT_ENTRY_SIZE, regval) ? 0 : 8;
 	dev_info(&hci->master.dev, "DAT: %u %u-bytes entries at offset %#x\n",
-		 hci->DAT_entries, hci->DAT_entry_size * 4, offset);
+		 hci->DAT_entries, hci->DAT_entry_size, offset);
 
 	regval = reg_read(DCT_SECTION);
 	offset = FIELD_GET(DCT_TABLE_OFFSET, regval);
 	hci->DCT_regs = offset ? hci->base_regs + offset : NULL;
 	hci->DCT_entries = FIELD_GET(DCT_TABLE_SIZE, regval);
-	hci->DCT_entry_size = FIELD_GET(DCT_ENTRY_SIZE, regval);
+	hci->DCT_entry_size = FIELD_GET(DCT_ENTRY_SIZE, regval) ? 0 : 16;
 	dev_info(&hci->master.dev, "DCT: %u %u-bytes entries at offset %#x\n",
-		 hci->DCT_entries, hci->DCT_entry_size * 4, offset);
+		 hci->DCT_entries, hci->DCT_entry_size, offset);
 
 	regval = reg_read(RING_HEADERS_SECTION);
 	offset = FIELD_GET(RING_HEADERS_OFFSET, regval);
-- 
2.53.0



