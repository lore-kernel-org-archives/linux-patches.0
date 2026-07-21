Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC2BA19049B;
	Tue, 21 Jul 2026 17:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654681; cv=none; b=DTvImkBc/D/4ZhjLnVIHlULRa2cOVEcglkwSlK0dDlVF+8K3UqvGNaQIPruX6jyOV7geWFFriS2oYRTOzsQzM6ZGqX/7UOVuT5k9dvOKoTiH15+BMvoxNtASxRL4nREHP7UC2x+2ldlVT933NtcWkHPt6VLnipJXaFV52+Iu280=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654681; c=relaxed/simple;
	bh=6erEFk2BNG4QKXQWt7pveQ9S1MPaTE1bvsxsBqKgZ4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CZw397616amy7K2xkTRo6K2a6WSIcpBcDxOuPqtVTV8LaTRvxywfXhB6oRHt8i7z2OCI2S9M4M7VC7F39N1hk8xMO2yclY3m8xtekRs8w32my+Ne7pNMJxueG60j89Mto5EIzi8U+5HRkAZzAOK1GIbRhd+N/q/8NsSh9PUVRfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=euV849bE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="euV849bE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A3EB1F000E9;
	Tue, 21 Jul 2026 17:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654680;
	bh=nZrZ0QXONbzla8HHggs6LYhtvkPrj+FZqPbQfaxD1b0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=euV849bEktvTx67nK0PXhQX2zc+m4cW7EfR6XC8vh3FFZjIDEk1XaxXeZXFGnVCQc
	 pkN1/L6ssDpYoZF5TPSQYJ5sPqeoVfeYDNvuXoDrodBFShWw2VmDCf1gOjtYszJTFJ
	 LcA8NNg+27CrjShmM+ZqnS4N0KmJ+L2zebLny86o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Vivchar <rva333@protonmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 7.1 1795/2077] i2c: mediatek: fix WRRD for SoCs without auto_restart option
Date: Tue, 21 Jul 2026 17:24:28 +0200
Message-ID: <20260721152635.084156257@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Vivchar <rva333@protonmail.com>

commit deb35336b5bfed5db9231b5348bc1514db930797 upstream.

MediaTek mt65xx family SoCs have no auto restart, however, they still
support the WRRD mode in the hardware. Because auto_restart is set to 0,
the WRRD mode will be never enabled, leading to read errors.

Fix this by removing auto_restart check from the WRRD enable path.

Fixes: b49218365280 ("i2c: mediatek: fix potential incorrect use of I2C_MASTER_WRRD")
Signed-off-by: Roman Vivchar <rva333@protonmail.com>
Cc: <stable@vger.kernel.org> # v6.18+
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260709-6572-6595-i2c-v2-1-b2fb8510d1d3@protonmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-mt65xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-mt65xx.c
+++ b/drivers/i2c/busses/i2c-mt65xx.c
@@ -1258,7 +1258,7 @@ static int mtk_i2c_transfer(struct i2c_a
 	i2c->auto_restart = i2c->dev_comp->auto_restart;
 
 	/* checking if we can skip restart and optimize using WRRD mode */
-	if (i2c->auto_restart && num == 2) {
+	if (num == 2) {
 		if (!(msgs[0].flags & I2C_M_RD) && (msgs[1].flags & I2C_M_RD) &&
 		    msgs[0].addr == msgs[1].addr) {
 			i2c->auto_restart = 0;


