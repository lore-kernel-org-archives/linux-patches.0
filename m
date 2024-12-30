Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0932594B6;
	Mon, 30 Dec 2024 15:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573531; cv=none; b=cxA9NJFh4iTeJ/g6TlRXOgVLm7kxUR1olpF+3pgtZKj/5CTJVrhzJmHtG+Q3GhggrsGKE8QHfwZUYxGLhWjLKHb3wQfL8rma2Qrctl6WL2nEeEJ7MgH8xGCNH8x4Ymq4rF1HlJLJp/AdoXgI7RxTcC9WS4cihOp13fVOdeNsRNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573531; c=relaxed/simple;
	bh=CFrn99IaPG2YHbw3GGafegaybtZwNWd+gpSXhgwbz38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f1HcCzC8/cc1xJ4gUE2NEo3Bfs8OjWWdmMH8Ma2kx5V9kCtpOK6PsU4sA1wdyQfR1aE18Udsc78LD7MncQ6WdFCkzNA4S9NF/Qu6s/n7y0YeQMeuiW6VtppQ9dALmGxZ6M5+0nurDZvz6PzN5SSb/jVs5v9N+yWZvDdos/izKGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tCpj1442; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tCpj1442"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7979C4CED0;
	Mon, 30 Dec 2024 15:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573531;
	bh=CFrn99IaPG2YHbw3GGafegaybtZwNWd+gpSXhgwbz38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tCpj14424W42nzR/rHg7SzdrnwzRK8egcXc/AZTUJ8GYa4omzQKObbMqg6qrUhosX
	 Jj61ii+jpvTNSbQVsaytLYUpp1iSCx1KSOxdMPZPL8x9Tlk0Ry6QiUVFREfZA+dPTU
	 EUz1qN6hiIkgujE013pAeZPOYh6euP625nP+h1js=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Andrzejewski <maciej.andrzejewski@m-works.net>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.1 08/60] mtd: rawnand: arasan: Fix double assertion of chip-select
Date: Mon, 30 Dec 2024 16:42:18 +0100
Message-ID: <20241230154207.601229038@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154207.276570972@linuxfoundation.org>
References: <20241230154207.276570972@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Maciej Andrzejewski <maciej.andrzejewski@m-works.net>

commit b086a46dae48829e11c0c02580e30d920b76743c upstream.

When two chip-selects are configured in the device tree, and the second is
a non-native GPIO, both the GPIO-based chip-select and the first native
chip-select may be asserted simultaneously. This double assertion causes
incorrect read and write operations.

The issue occurs because when nfc->ncs <= 2, nfc->spare_cs is always
initialized to 0 due to static initialization. Consequently, when the
second chip-select (GPIO-based) is selected in anfc_assert_cs(), it is
detected by anfc_is_gpio_cs(), and nfc->native_cs is assigned the value 0.
This results in both the GPIO-based chip-select being asserted and the
NAND controller register receiving 0, erroneously selecting the native
chip-select.

This patch resolves the issue, as confirmed by oscilloscope testing with
configurations involving two or more chip-selects in the device tree.

Fixes: acbd3d0945f9 ("mtd: rawnand: arasan: Leverage additional GPIO CS")
Cc: stable@vger.kernel.org
Signed-off-by: Maciej Andrzejewski <maciej.andrzejewski@m-works.net>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/arasan-nand-controller.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mtd/nand/raw/arasan-nand-controller.c
+++ b/drivers/mtd/nand/raw/arasan-nand-controller.c
@@ -1425,8 +1425,8 @@ static int anfc_parse_cs(struct arasan_n
 	 * case, the "not" chosen CS is assigned to nfc->spare_cs and selected
 	 * whenever a GPIO CS must be asserted.
 	 */
-	if (nfc->cs_array && nfc->ncs > 2) {
-		if (!nfc->cs_array[0] && !nfc->cs_array[1]) {
+	if (nfc->cs_array) {
+		if (nfc->ncs > 2 && !nfc->cs_array[0] && !nfc->cs_array[1]) {
 			dev_err(nfc->dev,
 				"Assign a single native CS when using GPIOs\n");
 			return -EINVAL;


