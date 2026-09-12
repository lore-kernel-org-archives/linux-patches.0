Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE6E0CA6F;
	Sat, 12 Sep 2026 15:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225954; cv=none; b=PLp1NOl2HNnYgt6Ye4qdiwF3lWvw7t4uQP0z8R1ZQTDUCPfKA9hdw48hnHyBrhrNA4uCQHQxBViXn7UI13UReTW9MHr4JSsv4htuTPXXIyIUOjKDtG4k4FUb98Vpf9y8/ChCVlAloEIiaoDLHjz8sDUYJk4bwgwn3VEnygUjcG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225954; c=relaxed/simple;
	bh=qOPMUTP0IZPMdz6yQFcPYWXw5MstIdAJO1pUB2mG1bg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zqjp4iS3luqjBep4rBfvr6/jy2U3OxL3XUY0h6lz1eyh/NCv4syBLPcTbxsWKoJfaF85sHXcrj8aQCTEQ4PZcS3DYi7MFZtsEEWkKtz/i6V+8+0LxA3HrQVAvNdS+m0Bh+wr4/bZyHPovMT8EzYZsa+h6YZemOrF/ulnRF+DoVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HqvK5cil; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HqvK5cil"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C301F000FF;
	Sat, 12 Sep 2026 15:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225952;
	bh=Oyw1d/Q1OS0qmyc7h9lmu9Th+MVlojxwkw/3Sn6yQ7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HqvK5cilJ/ridn+A++cdKYRJgwa6nmkGEHex8lpsbzLxUxrnuq0Ual8V61+bjZMfZ
	 li5ytRJ+Na/pPZZCzx7Ttj3WcOAv/7TMHLj/MY5EXb7p2WYAroQCsvttYwXG2bESKP
	 3MB6n6pvmjOl6bNnR8sf1GHNhsh3/EP+2eecJtEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1302/1424] i3c: mipi-i3c-hci: Fix number of DAT/DCT entries for HCI versions < 1.1
Date: Sat, 12 Sep 2026 09:02:14 +0200
Message-ID: <20260912065636.423901550@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jarkko Nikula <jarkko.nikula@linux.intel.com>

[ Upstream commit be90ae1ba14a83962b33c4d4c854ef081186b0e4 ]

I was wrong about the TABLE_SIZE field description in the
commit 0676bfebf576 ("i3c: mipi-i3c-hci: Fix DAT/DCT entry sizes").

For the MIPI I3C HCI versions 1.0 and earlier the TABLE_SIZE field in
the registers DAT_SECTION_OFFSET and DCT_SECTION_OFFSET is indeed defined
in DWORDs and not number of entries like it is defined in later versions.

Where above fix allowed driver initialization to continue the wrongly
interpreted TABLE_SIZE field leads variables DAT_entries being twice and
DCT_entries four times as big as they really are.

That in turn leads clearing the DAT table over the boundary in the
dat_v1.c: hci_dat_v1_init().

So interprete the TABLE_SIZE field in DWORDs for HCI versions < 1.1 and
fix number of DAT/DCT entries accordingly.

Fixes: 0676bfebf576 ("i3c: mipi-i3c-hci: Fix DAT/DCT entry sizes")
Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 308ecb824db3 ("i3c: mipi-i3c-hci: Fix missing STAT_IBI_STATUS_THLD in PIO mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/mipi-i3c-hci/core.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/i3c/master/mipi-i3c-hci/core.c b/drivers/i3c/master/mipi-i3c-hci/core.c
index 63d5e869dc8ad..a4c57b518bee9 100644
--- a/drivers/i3c/master/mipi-i3c-hci/core.c
+++ b/drivers/i3c/master/mipi-i3c-hci/core.c
@@ -583,6 +583,7 @@ static irqreturn_t i3c_hci_irq_handler(int irq, void *dev_id)
 static int i3c_hci_init(struct i3c_hci *hci)
 {
 	u32 regval, offset;
+	bool size_in_dwords;
 	int ret;
 
 	/* Validate HCI hardware version */
@@ -606,11 +607,16 @@ static int i3c_hci_init(struct i3c_hci *hci)
 	hci->caps = reg_read(HC_CAPABILITIES);
 	DBG("caps = %#x", hci->caps);
 
+	size_in_dwords = hci->version_major < 1 ||
+			 (hci->version_major == 1 && hci->version_minor < 1);
+
 	regval = reg_read(DAT_SECTION);
 	offset = FIELD_GET(DAT_TABLE_OFFSET, regval);
 	hci->DAT_regs = offset ? hci->base_regs + offset : NULL;
 	hci->DAT_entries = FIELD_GET(DAT_TABLE_SIZE, regval);
 	hci->DAT_entry_size = FIELD_GET(DAT_ENTRY_SIZE, regval) ? 0 : 8;
+	if (size_in_dwords)
+		hci->DAT_entries = 4 * hci->DAT_entries / hci->DAT_entry_size;
 	dev_info(&hci->master.dev, "DAT: %u %u-bytes entries at offset %#x\n",
 		 hci->DAT_entries, hci->DAT_entry_size, offset);
 
@@ -619,6 +625,8 @@ static int i3c_hci_init(struct i3c_hci *hci)
 	hci->DCT_regs = offset ? hci->base_regs + offset : NULL;
 	hci->DCT_entries = FIELD_GET(DCT_TABLE_SIZE, regval);
 	hci->DCT_entry_size = FIELD_GET(DCT_ENTRY_SIZE, regval) ? 0 : 16;
+	if (size_in_dwords)
+		hci->DCT_entries = 4 * hci->DCT_entries / hci->DCT_entry_size;
 	dev_info(&hci->master.dev, "DCT: %u %u-bytes entries at offset %#x\n",
 		 hci->DCT_entries, hci->DCT_entry_size, offset);
 
-- 
2.53.0



