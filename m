Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388042ECE80;
	Tue, 17 Jun 2025 15:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175620; cv=none; b=OC2b9sG/Lmb3d+zfKIPrefH2+iEnouMRlVr3SxuUX1YnRpzG0eXbeoixGp9FKq0OLlcFGNXb/PVc6pa4+B9nUJ5PE3Nb/Zg9zIc60m/Mco4OItj9wSKG59XidRpqXn+fEWAyIVycVyj0fgkob2JESo700qls5OvabmzNG6d9L8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175620; c=relaxed/simple;
	bh=ZN1Pc7u58Jl/j8M6/mVQY49AxB/KlWEw39KZ6MKaLSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LRsEhu6zweOQbCiElYmTbzJUnqy3b0VVkKdpXvALghXiEOpAzaEE8nDUfcPhc2w4HeN6x4kAwaH0hOQEjQODTkpBsjvA6LLdNOvOlwg6CIYvwCvnIUqvixnLvZO1p53i0AC6U9vwiBXAbvGVovubRh8vudpZ4zx4CYevLc7Jo/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Efls3XrJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Efls3XrJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C48C4CEE3;
	Tue, 17 Jun 2025 15:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175620;
	bh=ZN1Pc7u58Jl/j8M6/mVQY49AxB/KlWEw39KZ6MKaLSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Efls3XrJbV4ZSM4vF3KzfcUs1BfXbM6+KfCe5bSI8+vkUexo7xcvD3aETN6EJdS2+
	 dWqkw62+p6gL+w1InPeWsvXDoo2rxQ94InkRsniZo1h4l3GiQ8vBj7Paeg48Pvbnxg
	 tf5ytctfa2+0c/WD8iGbOknW4zSzRm1XDRoGC4lU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 194/356] soc: aspeed: Add NULL check in aspeed_lpc_enable_snoop()
Date: Tue, 17 Jun 2025 17:25:09 +0200
Message-ID: <20250617152346.027747015@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

From: Henry Martin <bsdhenrymartin@gmail.com>

[ Upstream commit f1706e0e1a74b095cbc60375b9b1e6205f5f4c98 ]

devm_kasprintf() returns NULL when memory allocation fails. Currently,
aspeed_lpc_enable_snoop() does not check for this case, which results in a
NULL pointer dereference.

Add NULL check after devm_kasprintf() to prevent this issue.

Fixes: 3772e5da4454 ("drivers/misc: Aspeed LPC snoop output using misc chardev")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Link: https://patch.msgid.link/20250401074647.21300-1-bsdhenrymartin@gmail.com
[arj: Fix Fixes: tag to use subject from 3772e5da4454]
Signed-off-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/aspeed/aspeed-lpc-snoop.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/aspeed/aspeed-lpc-snoop.c b/drivers/soc/aspeed/aspeed-lpc-snoop.c
index 8cb3a0b4692cf..0f2ffee321dd9 100644
--- a/drivers/soc/aspeed/aspeed-lpc-snoop.c
+++ b/drivers/soc/aspeed/aspeed-lpc-snoop.c
@@ -200,11 +200,15 @@ static int aspeed_lpc_enable_snoop(struct aspeed_lpc_snoop *lpc_snoop,
 	lpc_snoop->chan[channel].miscdev.minor = MISC_DYNAMIC_MINOR;
 	lpc_snoop->chan[channel].miscdev.name =
 		devm_kasprintf(dev, GFP_KERNEL, "%s%d", DEVICE_NAME, channel);
+	if (!lpc_snoop->chan[channel].miscdev.name) {
+		rc = -ENOMEM;
+		goto err_free_fifo;
+	}
 	lpc_snoop->chan[channel].miscdev.fops = &snoop_fops;
 	lpc_snoop->chan[channel].miscdev.parent = dev;
 	rc = misc_register(&lpc_snoop->chan[channel].miscdev);
 	if (rc)
-		return rc;
+		goto err_free_fifo;
 
 	/* Enable LPC snoop channel at requested port */
 	switch (channel) {
@@ -221,7 +225,8 @@ static int aspeed_lpc_enable_snoop(struct aspeed_lpc_snoop *lpc_snoop,
 		hicrb_en = HICRB_ENSNP1D;
 		break;
 	default:
-		return -EINVAL;
+		rc = -EINVAL;
+		goto err_misc_deregister;
 	}
 
 	regmap_update_bits(lpc_snoop->regmap, HICR5, hicr5_en, hicr5_en);
@@ -231,6 +236,12 @@ static int aspeed_lpc_enable_snoop(struct aspeed_lpc_snoop *lpc_snoop,
 		regmap_update_bits(lpc_snoop->regmap, HICRB,
 				hicrb_en, hicrb_en);
 
+	return 0;
+
+err_misc_deregister:
+	misc_deregister(&lpc_snoop->chan[channel].miscdev);
+err_free_fifo:
+	kfifo_free(&lpc_snoop->chan[channel].fifo);
 	return rc;
 }
 
-- 
2.39.5



