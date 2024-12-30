Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DEF315E8B;
	Mon, 30 Dec 2024 15:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573706; cv=none; b=YJcap5OtGFjyfKxkxOQddRlf3LXj5siEOFaqSeEAb+bt906tYAjJdydeBTaSHb7a1IRTfQrj7iRzmJSCiFIL9cWq7b7eLexXTvtjt0y6l+CM1fVQi8GT5HF/q1Blls2fTrnwF7WdMHsyYkKeIhagnJ8TemYczH+7o4XkVOBYcBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573706; c=relaxed/simple;
	bh=gKBXy+l+cdIE3k3H3PAoX8W+oaT7PA3pwUca5b4FhvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aECzvlcWmvyZNcaEd1fOouaj2S9IFDQ3qGlemHYVi+jSNJBrLqOnD8zBrcXM45Dx+UhcfpSYoiN0k7T5imJ6XJCex1BSEEvBc3gkXHjzCXri7JQOgbVwE0yQPo1dJJUhdz0FbAPqmvEa4CTFBBVpZDbE4fKT46co90WlwrXT2MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wCssNbBE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wCssNbBE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0FD9C4CED0;
	Mon, 30 Dec 2024 15:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573706;
	bh=gKBXy+l+cdIE3k3H3PAoX8W+oaT7PA3pwUca5b4FhvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wCssNbBEjJn5E/M3+njSPTTdIe6U38/1YWxFbbBQEb5ckxv4vJbjyExKJHpELyo4K
	 vz36BFl5S+YWUwvk2ONo4xUcmhhT85iseWN9rbLOydDOHFrALW2RbkPuTBw/XltEx0
	 9CZurAFFa5XIpLkkb86z1SvGL+MkqFXMkNUiDmUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Andrzejewski <maciej.andrzejewski@m-works.net>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.6 12/86] mtd: rawnand: arasan: Fix double assertion of chip-select
Date: Mon, 30 Dec 2024 16:42:20 +0100
Message-ID: <20241230154212.183391979@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1410,8 +1410,8 @@ static int anfc_parse_cs(struct arasan_n
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


