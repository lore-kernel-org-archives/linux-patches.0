Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3EF40DFB4;
	Thu, 12 Mar 2026 20:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346910; cv=none; b=NtsNBLnO2VQxmd4wBiZ3pwghxRPUDUkYkg/7zkFlrYwL3m/VcZoWR+dbYJ6vemswTCuD3HyCkItp8qhhvgXEePxNzJcVdb9YOJ3wlkdQSfdCyRvASdWC5/McnIMWTthsULDGL36i8fPObJt0+z7NTRXn5VdX330loF9bCmVOq9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346910; c=relaxed/simple;
	bh=CuHsTwVwI9CE464y71ofQN4MPuEVTCNUENmLNpqF5IM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DbqLbI9CeH/1EBT4zta/E1MHoWPh9z94LRxMrYxSrqsy4jsgYxGdk0BCZ/OFrXMKrWFsTeWI2n/bxOmkLBnR9ODQxbcCoVOWJbMDeiVTtcToH+gILl20gRsP89iRcjU4bb9OQuniooDmgE04bbkj9uiGm1tOV6Y6gA4vrWGDC/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KlZJPs3e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KlZJPs3e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31A31C4CEF7;
	Thu, 12 Mar 2026 20:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346909;
	bh=CuHsTwVwI9CE464y71ofQN4MPuEVTCNUENmLNpqF5IM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KlZJPs3eK34qCbw3xyWN9OTVqwrn4IHBF14S16xPzvU0W3YbwUarEh2VBIbYDekdW
	 pT0ibsR18Gla16JRKVrMtFDm8Yf2U+kVK0pjSl9EB5/XJQmx9yLDTQS8sGNUZ7f+MQ
	 M1rxDRbI/J4RVKwJwX/K91Rlh4BH+Iy8dPfNyzQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 125/265] net: arcnet: com20020-pci: fix support for 2.5Mbit cards
Date: Thu, 12 Mar 2026 21:08:32 +0100
Message-ID: <20260312201022.762851605@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

From: Ethan Nelson-Moore <enelsonmoore@gmail.com>

[ Upstream commit c7d9be66b71af490446127c6ffcb66d6bb71b8b9 ]

Commit 8c14f9c70327 ("ARCNET: add com20020 PCI IDs with metadata")
converted the com20020-pci driver to use a card info structure instead
of a single flag mask in driver_data. However, it failed to take into
account that in the original code, driver_data of 0 indicates a card
with no special flags, not a card that should not have any card info
structure. This introduced a null pointer dereference when cards with
no flags were probed.

Commit bd6f1fd5d33d ("net: arcnet: com20020: Fix null-ptr-deref in
com20020pci_probe()") then papered over this issue by rejecting cards
with no driver_data instead of resolving the problem at its source.

Fix the original issue by introducing a new card info structure for
2.5Mbit cards that does not set any flags and using it if no
driver_data is present.

Fixes: 8c14f9c70327 ("ARCNET: add com20020 PCI IDs with metadata")
Fixes: bd6f1fd5d33d ("net: arcnet: com20020: Fix null-ptr-deref in com20020pci_probe()")
Cc: stable@vger.kernel.org
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Link: https://patch.msgid.link/20260213045510.32368-1-enelsonmoore@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/arcnet/com20020-pci.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/arcnet/com20020-pci.c b/drivers/net/arcnet/com20020-pci.c
index 0472bcdff1307..b5729d6c0b47c 100644
--- a/drivers/net/arcnet/com20020-pci.c
+++ b/drivers/net/arcnet/com20020-pci.c
@@ -115,6 +115,8 @@ static const struct attribute_group com20020_state_group = {
 	.attrs = com20020_state_attrs,
 };
 
+static struct com20020_pci_card_info card_info_2p5mbit;
+
 static void com20020pci_remove(struct pci_dev *pdev);
 
 static int com20020pci_probe(struct pci_dev *pdev,
@@ -140,7 +142,7 @@ static int com20020pci_probe(struct pci_dev *pdev,
 
 	ci = (struct com20020_pci_card_info *)id->driver_data;
 	if (!ci)
-		return -EINVAL;
+		ci = &card_info_2p5mbit;
 
 	priv->ci = ci;
 	mm = &ci->misc_map;
@@ -347,6 +349,18 @@ static struct com20020_pci_card_info card_info_5mbit = {
 	.flags = ARC_IS_5MBIT,
 };
 
+static struct com20020_pci_card_info card_info_2p5mbit = {
+	.name = "ARC-PCI",
+	.devcount = 1,
+	.chan_map_tbl = {
+		{
+			.bar = 2,
+			.offset = 0x00,
+			.size = 0x08,
+		},
+	},
+};
+
 static struct com20020_pci_card_info card_info_sohard = {
 	.name = "SOHARD SH ARC-PCI",
 	.devcount = 1,
-- 
2.51.0



