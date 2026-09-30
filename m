Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59C24F472F;
	Wed, 30 Sep 2026 15:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783766; cv=none; b=aGXa27GtC8/8ReeEp+F/4AZQkt3jLnWun6DVC2+qHaCYdjfkIbpSOEl6L/QTjBBrYRXgXLGjiUEtIeL+3ExJDUoQoaBj5komuvbQT3xRydKxSHpr4buX2uvWGns8waHSrJYT3Sd2czr7gOiUfh8Sa8klZCi6rs5WQ25ueLoyGU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783766; c=relaxed/simple;
	bh=aAnhIYRZzELLuN61T493bjfyXOq5o6TqkCamPbGqtgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DYmf0kLp72geqyAMqk4Vvwqu1ZAgzA1Z2Q9/xLQNIPPqBQJl+J7vxI4QLn1yjyIrDH0TpnaR3IU9O0kXnnKyfVcxGNaJuxS3GJNQWDZ7655mee9KU0U2+cTL6Rj05yoxR8wzwUrwTUIGK3BZujYDw53t9kH0+djLbgMT91EPeWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GWbCbot2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GWbCbot2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FDBA1F00899;
	Wed, 30 Sep 2026 15:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783758;
	bh=uRjnj5dJGEkFgNDTrnkJu2YgVMTh1GCq9WTms7AJdy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GWbCbot27DLV6FRxDhoezYz6ebPXIi8Yjf/i4Exc4yfq1VF/MXE89gCPXBxC+uSUg
	 Z+0gdV4VpioIXi89CdIzz4bowprY+Fj5ZaH/5Ta8ZwH27jEtsOEuVOBjaf3pmsJKH8
	 YMM6pRZXv15B+GBuBq7q3dQzv/57nPhYGWMMcBqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 513/595] tg3: clean up PHYLIB resources on probe failure
Date: Wed, 30 Sep 2026 17:26:46 +0200
Message-ID: <20260930152358.736935144@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit a92e1a412c53dc0d9ad639e7abf8b3fc70a5b6ad ]

tg3_get_invariants() can register an MDIO bus and connect a PHY for
USE_PHYLIB devices. If tg3_init_one() later fails, its common error path
releases the mappings and netdev without undoing those PHYLIB resources.

Disconnect the PHY and unregister the MDIO bus before the remaining
teardown. Guard PHY cleanup with USE_PHYLIB to match tg3_phy_init(), and
call tg3_mdio_fini() unconditionally to match tg3_mdio_init(). The existing
IS_CONNECTED and MDIOBUS_INITED flags make both helpers safe when
initialization only completed partially.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: 158d7abdae85 ("tg3: Add mdio bus registration")
Assisted-by: OpenAI:GPT-5.6
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Link: https://patch.msgid.link/20260917183336.36239-1-mhun512@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/tg3.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 954a51fe0cd70..92425b387b54d 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -18028,6 +18028,10 @@ static int tg3_init_one(struct pci_dev *pdev,
 	return 0;
 
 err_out_apeunmap:
+	if (tg3_flag(tp, USE_PHYLIB))
+		tg3_phy_fini(tp);
+	tg3_mdio_fini(tp);
+
 	if (tp->aperegs) {
 		iounmap(tp->aperegs);
 		tp->aperegs = NULL;
-- 
2.53.0



