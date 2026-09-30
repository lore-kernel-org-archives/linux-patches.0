Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C29918C332;
	Wed, 30 Sep 2026 16:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787318; cv=none; b=KIJ7BmZJsHlmtjenHc9ijKy9Jdi3V8xsBqxyyg5n+Cs1aNac3+LTUh4RTORjdqAy32i0nWJukpzGOgeaM6HQNg+NawIdxpTKzP+ExRiaqJweLWuPRuHRRG0H8k2+ZwWqu6ttr/PBj5+XbJ3cJrRF62WsE49BcaFihl8slt9j5uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787318; c=relaxed/simple;
	bh=6YQRTvqmkHmiUHoct1ah7MK43wkmXjzxfir/DdjbJjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QW3OAuZw7kvLhY6OA8wlvPVj5fWhdIXGjR0LP/ZyFAwGetL8pqJ5MzOtIPRERkqeRxLy3oF2EuRSAvTNl9uMF/5pXY3vBatsSiaEuAsMh0BaMzGD88o1RgHJ0DDgU+a7AzdHH76kGwqtnB6J7mQ9a+ZuIov4puSZq4d4aUqoQdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LGEM3C32; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LGEM3C32"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7598D1F000FF;
	Wed, 30 Sep 2026 16:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787317;
	bh=dPtG1XGUYgG8OmWzDcDv6YhQ09rOOKuIg/0ayFqy1cc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LGEM3C32RnFIXoE9FQk8SSroskOcxs479QWA4V6WfocBDYE2MLNVBYmVijwGUTBQ1
	 agHcATqOfng3VSf91MBj7pEUlPAUq3j+4E3iG2NEE4GGvwJfiZrSuOmg7i19aTsxXa
	 KeFRpT28cUwXrVcudd/0qjxLVOEG9BhCu/qhLE38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Jelonek <jonas@jonasjelonek.de>,
	Markus Stockhausen <markus.stockhausen@gmx.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 187/457] net: mdio: realtek-rtl9300: fix RTL931x C22 extended page selection
Date: Wed, 30 Sep 2026 17:24:52 +0200
Message-ID: <20260930152350.086879477@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Jelonek <jonas@jonasjelonek.de>

[ Upstream commit 89a8a1eef2d441b7825a6c0116ce817235a7ffe6 ]

The RTL931x indirect access engine has a separate nine-bit extended page
field. The driver leaves it at zero, and otto_emdio_run_cmd() therefore
programs extended page zero for every Clause 22 transaction. This
overrides page selection made through PHY register 30, causing accesses
to private PHY pages to hit extended page zero instead.

Set the field to its 0x1ff "do not change" value for RTL931x Clause 22
reads and writes. This preserves extended page selection made through
PHY register 30 and restores access to its private register pages.

Fixes: 5ebdcac59aff ("net: mdio: realtek-rtl9300: Add support for RTL931x")
Signed-off-by: Jonas Jelonek <jonas@jonasjelonek.de>
Acked-by: Markus Stockhausen <markus.stockhausen@gmx.de>
Link: https://patch.msgid.link/20260918211955.3955777-1-jonas@jonasjelonek.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mdio/mdio-realtek-rtl9300.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/mdio/mdio-realtek-rtl9300.c b/drivers/net/mdio/mdio-realtek-rtl9300.c
index afd52a1cd7f83..9ce2b78075320 100644
--- a/drivers/net/mdio/mdio-realtek-rtl9300.c
+++ b/drivers/net/mdio/mdio-realtek-rtl9300.c
@@ -88,6 +88,8 @@
 #define RTL9310_SMI_INDRT_ACCESS_BC_PHYID_CTRL	0x0c14
 #define   RTL9310_BC_PORT_ID			GENMASK(10, 5)
 #define RTL9310_SMI_INDRT_ACCESS_CTRL_1		0x0c04
+#define   RTL9310_SMI_INDRT_EXT_PAGE		GENMASK(8, 0)
+#define   RTL9310_SMI_INDRT_EXT_PAGE_NO_CHANGE	0x1ff
 #define RTL9310_SMI_INDRT_ACCESS_CTRL_2_LOW	0x0c08
 #define RTL9310_SMI_INDRT_ACCESS_CTRL_2_HIGH	0x0c0c
 #define RTL9310_SMI_INDRT_ACCESS_CTRL_3		0x0c10 /* I/O fields flipped */
@@ -325,6 +327,8 @@ static int otto_emdio_9310_read_c22(struct mii_bus *bus, int port, int regnum, u
 		.broadcast	= FIELD_PREP(RTL9310_BC_PORT_ID, port),
 		.c22_data	= FIELD_PREP(RTL9310_PHY_CTRL_REG_ADDR, regnum) |
 				  FIELD_PREP(RTL9310_PHY_CTRL_MAIN_PAGE, RAW_PAGE(priv)),
+		.ext_page	= FIELD_PREP(RTL9310_SMI_INDRT_EXT_PAGE,
+					     RTL9310_SMI_INDRT_EXT_PAGE_NO_CHANGE),
 	};
 
 	return otto_emdio_read_cmd(bus, RTL9310_PHY_CTRL_TYPE_C22, &cmd_data,
@@ -337,6 +341,8 @@ static int otto_emdio_9310_write_c22(struct mii_bus *bus, int port, int regnum,
 	struct otto_emdio_cmd_regs cmd_data = {
 		.c22_data	= FIELD_PREP(RTL9310_PHY_CTRL_REG_ADDR, regnum) |
 				  FIELD_PREP(RTL9310_PHY_CTRL_MAIN_PAGE, RAW_PAGE(priv)),
+		.ext_page	= FIELD_PREP(RTL9310_SMI_INDRT_EXT_PAGE,
+					     RTL9310_SMI_INDRT_EXT_PAGE_NO_CHANGE),
 		.io_data	= FIELD_PREP(RTL9310_PHY_CTRL_INDATA, value),
 		.port_mask_high	= (u32)(BIT_ULL(port) >> 32),
 		.port_mask_low	= (u32)(BIT_ULL(port)),
-- 
2.53.0



