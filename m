Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13C0157466;
	Tue, 30 Jul 2024 17:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360781; cv=none; b=kvUs9TYrOiBQ58dEOXpZ0rNAAJk4RvLnrVrQTXCQCz/vwFUZhWqi0lIO/gu0Ie7giuyvsT6vo3o7H8btXHQXUiKwpAVvbCB6l4cqqORUbYcsLuLOmqSeanjPuu2FZAZuYGGjsnJjT93Xu9pvq4YFPxTc/DaVcbWfZbDXSi/xico=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360781; c=relaxed/simple;
	bh=1eq57+ZpSnXcqxqV0Ko2uFJKS/MUZxlUIVs6h+r8CGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T3ifNnxU6rfTJMP3wxLu2qRcDt/OFAn3MAVJhtK4BRamOpVdrfivh2Ujbsz5Amy1DwpeMe/PRuSQN7R7d0phyPcabil6yHqDBUq/7Eyep3y00qPgICII0MT9IXf5gDELXgQ5twcEa8CHOMN6UCOenCaIJwxMpqZ/lttCIxjQats=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xW7hJxcF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xW7hJxcF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29CA5C32782;
	Tue, 30 Jul 2024 17:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360781;
	bh=1eq57+ZpSnXcqxqV0Ko2uFJKS/MUZxlUIVs6h+r8CGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xW7hJxcFqx5+jx71xnoXd2JhEZ7yNQ70Zw9JFe6N5z8bNrzf/pTpNldQ2/q30+ubk
	 w0x9nRYzJuyzLDWDY90isLSlONEfJcOaBRBcK6EhD0oLC12/hHW+WPJq3wAOcFrz1Y
	 BGcIJlzjrjOch5R0GOknlICiF0vn/vVWBgi0LD34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 806/809] i3c: mipi-i3c-hci: Fix number of DAT/DCT entries for HCI versions < 1.1
Date: Tue, 30 Jul 2024 17:51:22 +0200
Message-ID: <20240730151756.816668235@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/mipi-i3c-hci/core.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/i3c/master/mipi-i3c-hci/core.c b/drivers/i3c/master/mipi-i3c-hci/core.c
index d7e966a255833..4e7d6a43ee9b3 100644
--- a/drivers/i3c/master/mipi-i3c-hci/core.c
+++ b/drivers/i3c/master/mipi-i3c-hci/core.c
@@ -631,6 +631,7 @@ static irqreturn_t i3c_hci_irq_handler(int irq, void *dev_id)
 static int i3c_hci_init(struct i3c_hci *hci)
 {
 	u32 regval, offset;
+	bool size_in_dwords;
 	int ret;
 
 	/* Validate HCI hardware version */
@@ -654,11 +655,16 @@ static int i3c_hci_init(struct i3c_hci *hci)
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
 
@@ -667,6 +673,8 @@ static int i3c_hci_init(struct i3c_hci *hci)
 	hci->DCT_regs = offset ? hci->base_regs + offset : NULL;
 	hci->DCT_entries = FIELD_GET(DCT_TABLE_SIZE, regval);
 	hci->DCT_entry_size = FIELD_GET(DCT_ENTRY_SIZE, regval) ? 0 : 16;
+	if (size_in_dwords)
+		hci->DCT_entries = 4 * hci->DCT_entries / hci->DCT_entry_size;
 	dev_info(&hci->master.dev, "DCT: %u %u-bytes entries at offset %#x\n",
 		 hci->DCT_entries, hci->DCT_entry_size, offset);
 
-- 
2.43.0



