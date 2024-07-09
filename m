Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817D8153812;
	Tue,  9 Jul 2024 11:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523906; cv=none; b=OhLmggKqAl9P8R1sIuY9/LEHq5h3ygGKKz1rDJS8ggMXrSKSNoLtWOkhkMvL+40dcwWw6rFoT+hDZONQ4w6R6VM7Ahy62Pl7MBtUB81IA0bhqK1mFJHHaIctf7VaTpWxa6YQftDHJx4CvNcA7vn0fl46YH2IHrHOkpy0tLQU0jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523906; c=relaxed/simple;
	bh=U2tIqoFvD8w4rIxD5x9Intqsh89DzxC7yrHcRLM7pZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MPY33VMxm6IcAeq3v8HLtHRDe8iEmHhg2I+d2uyB4Yv6jHDPZaF/GeIgJphS68Blw1bvPddOGO+rOKsCc2HCxU0BxR16OSeIZwVGRJ2MWyagmJjDvApF1fH8sF0v46ggUIXQ8K99mYqJdc+8eMJ+E9ZtpROXSAx9xZbtwywPPis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dmmShrJd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dmmShrJd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 099D1C32786;
	Tue,  9 Jul 2024 11:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523906;
	bh=U2tIqoFvD8w4rIxD5x9Intqsh89DzxC7yrHcRLM7pZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dmmShrJd1vIhXLE4+wYYYKVVS2twT+T2qgElXnxfPoP/+RO0Nssf0aPlZ1d2E0VuW
	 p9CLc5eN+zaH/TAPey/PpFqVNCcUPoIKMWMRwkPsBUiKOk6RJ/Hl62N+DXIAab5x1p
	 wK9RoJLpf5q1m55hqo6OClmskuMT0t57nshWiVQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@packett.cool>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.6 112/139] mtd: rawnand: rockchip: ensure NVDDR timings are rejected
Date: Tue,  9 Jul 2024 13:10:12 +0200
Message-ID: <20240709110702.503267764@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

From: Val Packett <val@packett.cool>

commit b27d8946b5edd9827ee3c2f9ea1dd30022fb1ebe upstream.

.setup_interface first gets called with a "target" value of
NAND_DATA_IFACE_CHECK_ONLY, in which case an error is expected
if the controller driver does not support the timing mode (NVDDR).

Fixes: a9ecc8c814e9 ("mtd: rawnand: Choose the best timings, NV-DDR included")
Signed-off-by: Val Packett <val@packett.cool>
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20240519031409.26464-1-val@packett.cool
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/rockchip-nand-controller.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/mtd/nand/raw/rockchip-nand-controller.c
+++ b/drivers/mtd/nand/raw/rockchip-nand-controller.c
@@ -420,13 +420,13 @@ static int rk_nfc_setup_interface(struct
 	u32 rate, tc2rw, trwpw, trw2c;
 	u32 temp;
 
-	if (target < 0)
-		return 0;
-
 	timings = nand_get_sdr_timings(conf);
 	if (IS_ERR(timings))
 		return -EOPNOTSUPP;
 
+	if (target < 0)
+		return 0;
+
 	if (IS_ERR(nfc->nfc_clk))
 		rate = clk_get_rate(nfc->ahb_clk);
 	else


