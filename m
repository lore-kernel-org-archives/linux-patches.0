Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75033145A03;
	Mon,  6 Jan 2025 15:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178708; cv=none; b=UJ0lPNioaVUTwkQMVPBJwC8PRTsOKSbfr2daCZ1A4aO1Az//A9Q/+mprwtDSB8Tg3gA+q5RumA9qC0sZmiVZyZOufyc+Y+4V/DArqoTkoFHZoaRtRdNZW9/peFcWyNHRNXIlkn7m97y1a/c4/wyb4GFzHOkhmfbkoQ0GrsC3Y3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178708; c=relaxed/simple;
	bh=Lbf4q2qVfagWCT7U61ydO8PI+KnrEoQy2plyO7jBNzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AuagAqsBqtaErYCDKRqmt9ufD6I9DKyAtAG/cUL4ZCau/MwtUpez87sCWd4zSgIFLvegjdEjBzgaM/nK3JK1TtTJ9HbIsgLTkFhrqLSPb+d/3UR91qxU/2V4nvbD0VYqNDB+cnHU3ppN3jk6c05r1uq1hZT5/7ZeZ3IFvcZmcsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aQMs5h1x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aQMs5h1x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7B91C4CED2;
	Mon,  6 Jan 2025 15:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178708;
	bh=Lbf4q2qVfagWCT7U61ydO8PI+KnrEoQy2plyO7jBNzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aQMs5h1xq2pVpneO0SnyfYuJHL82pxerpn9OH+FC9B8e6w/+GKp85+uhBRU05g2Lz
	 GqrcglPBNLEsN0eFw8mGtyviC2niF1uk9j9wqJmrIcC8f2kAYIlUWRofEVwNT3KfhH
	 id72ojyh/2x5CDk9kXh82q9EV7iw/Mz95iGbc5DI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Andrzejewski <maciej.andrzejewski@m-works.net>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.15 064/168] mtd: rawnand: arasan: Fix double assertion of chip-select
Date: Mon,  6 Jan 2025 16:16:12 +0100
Message-ID: <20250106151140.878027155@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


