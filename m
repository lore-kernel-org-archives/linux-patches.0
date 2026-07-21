Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D9545A2B3;
	Tue, 21 Jul 2026 22:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672585; cv=none; b=mFL2WlKdnqDhcP8pepQLU+FakjuuIEQPq/G9ItC69mktNZWqIKtnQquo8cQwurDIA8DimllC/APUci4PQ3Su5EKUIZBjCuJLFDSIOrcdEdo0143ZKiiX6ql04xKP4by8e3aDyafr/ZDEeC1/YOzyRHxCnUMOmqP1crZ4wzuFPB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672585; c=relaxed/simple;
	bh=KTJGVnTg2xCMRTBDnyGHvqNMORNv+ylf5u+O6Xwly/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j8yekGqitkazTcRN5G9Dn5BsaQ4TCRJKm17q15x/QpJJEz5hPIEcsbsgJWCw1AAqz0FJLKIl0QmbccqFQOeNNL1+k6N0Tqy8GqUkOmYj2zTmAleIyTvXgtrzmJX5qFy+OqmPhYKm+k6I4pabIVkhFHM9nLACyNYUCY9TS8lBB7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yBJ4EERF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yBJ4EERF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D73EA1F000E9;
	Tue, 21 Jul 2026 22:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672584;
	bh=jepfW6DdTKZxJGcsVJotWGZenctdL+T4530S2IZjdCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yBJ4EERFkVdvYjlaIX6n9xxyNDDYh26xzcWXqp922P2R/7M97HgbEsvl/wNR33HWF
	 E2Ds5vpN2y/E/C+eFnt7ljiqmeCSnjX6uI2FnPoQs2e/nE1qE6GJ0m2ksu2eWfCarr
	 DKUao42K1huWifQxGZ1BXOAYpWtjloL862DYUkoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Vivchar <rva333@protonmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 5.15 636/843] i2c: mediatek: fix WRRD for SoCs without auto_restart option
Date: Tue, 21 Jul 2026 17:24:31 +0200
Message-ID: <20260721152420.372247662@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1077,7 +1077,7 @@ static int mtk_i2c_transfer(struct i2c_a
 	i2c->auto_restart = i2c->dev_comp->auto_restart;
 
 	/* checking if we can skip restart and optimize using WRRD mode */
-	if (i2c->auto_restart && num == 2) {
+	if (num == 2) {
 		if (!(msgs[0].flags & I2C_M_RD) && (msgs[1].flags & I2C_M_RD) &&
 		    msgs[0].addr == msgs[1].addr) {
 			i2c->auto_restart = 0;


