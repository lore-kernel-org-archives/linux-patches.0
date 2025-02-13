Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F3C26B091;
	Thu, 13 Feb 2025 15:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459876; cv=none; b=PRQlVCzD87QEWTl67Fr3noiEjaeERjWr729K13RA/4epPgn8J+gotB3aRWZWwdZgG537+0wr3OneQkW0Jg4O8ihzb7CQ1qCobzqxel/rP8odUi8r2Op9+6VqUvVfgUfd0VSxjVHsAoJeGWs2R4gK3uza2OjvLsgBNMkq4kxZgrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459876; c=relaxed/simple;
	bh=TM/FX8CNyaxsKQDe5Q9ZtyVmT4kOxsbkqcWdorK5iaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pea312Kc3W2TAZYoM4fuwA+eFXHjiTx1I8/XuOtymhXhA6im5T8W7l8Mi7wP/mkmlwKH3R//+VVk+ExnQMp/0BVGX+rTY1zGAO01c1nOih7EzYSXks9SglM1mTpPTx4yi/XNizIMYRgBKlM/WiOdMA8h+IeMcj7M6pdei5p4q2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aOiv3j6q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aOiv3j6q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C07E2C4CED1;
	Thu, 13 Feb 2025 15:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459876;
	bh=TM/FX8CNyaxsKQDe5Q9ZtyVmT4kOxsbkqcWdorK5iaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aOiv3j6qN0y/szmHLivU9o9Mwv54SW7Dv2S0xHicVIY0zmeVDcrrj0XYsqdKm7JGM
	 ATZ1opeTjIGClGiOjvsOwWbK8//GCCSDC4d7wsbvkUsP2Rld0IVh+ZXgzXYOQ0qqkt
	 ph0A1LF3tRjUD/VkNIAdT3wPaB92wpjL8T1wguDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Hauer <s.hauer@pengutronix.de>,
	stable <stable@kernel.org>,
	Peng Fan <peng.fan@nxp.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.13 390/443] nvmem: imx-ocotp-ele: simplify read beyond device check
Date: Thu, 13 Feb 2025 15:29:15 +0100
Message-ID: <20250213142455.658875938@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sascha Hauer <s.hauer@pengutronix.de>

commit 343aa1e289e8e3dba5e3d054c4eb27da7b4e1ecc upstream.

Do the read beyond device check on function entry in bytes instead of
32bit words which is easier to follow.

Fixes: 22e9e6fcfb50 ("nvmem: imx: support i.MX93 OCOTP")
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Cc: stable <stable@kernel.org>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20241230141901.263976-2-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/imx-ocotp-ele.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/nvmem/imx-ocotp-ele.c
+++ b/drivers/nvmem/imx-ocotp-ele.c
@@ -72,13 +72,13 @@ static int imx_ocotp_reg_read(void *cont
 	void *p;
 	int i;
 
+	if (offset + bytes > priv->data->size)
+		bytes = priv->data->size - offset;
+
 	index = offset;
 	num_bytes = round_up(bytes, 4);
 	count = num_bytes >> 2;
 
-	if (count > ((priv->data->size >> 2) - index))
-		count = (priv->data->size >> 2) - index;
-
 	p = kzalloc(num_bytes, GFP_KERNEL);
 	if (!p)
 		return -ENOMEM;


