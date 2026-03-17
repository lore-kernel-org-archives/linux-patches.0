Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2485B3F54A5;
	Tue, 17 Mar 2026 17:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767268; cv=none; b=tE6cA4qkStNIh5+eIpu23q9Qa7eiJs/+6VoCnoC8wjkLNJoPefSfJvOIDVIK3+jLvOamNBlyWlZvt40jLacnyorF/feRLiZBEJNIGjqT4Co6IUy/X6ngxn3KSIH6ICYPi/kZrxVmyaSrs3o2zql7Z/IcHbDZjhpMzapD5wO6s2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767268; c=relaxed/simple;
	bh=tCWzpL/rNKiS5s3ywg7/1RG6YZqL0Csrgh42g8Jdam8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SgCXkDb/Wmaa6BdTar5Ui9QopJai4xvgPQZfC6vcn1VhozgFjggpHGiFSic/NG3C+6DcTnzmP4H1qkQgbQ8cmgLxoHT4aAKsUjKoarWjiGCqjL8avtrrjkLJm3IS0WZi002Zm7/fWFQnZIh6ONxCIDpTlcp+5GMqWZv4njX3XZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aIZBymbI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aIZBymbI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56404C4CEF7;
	Tue, 17 Mar 2026 17:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767267;
	bh=tCWzpL/rNKiS5s3ywg7/1RG6YZqL0Csrgh42g8Jdam8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aIZBymbI1cvAbflYIYm0tGP8Q6Vep3IXKMftyFl9iwtXhUkdViqlYrRlVHL7SuWxh
	 EnwbWq4fKDGxvTVynNDAZOCrDtOX2XH6arXEG3FDKI9uEfLtba0IOI16dY79MUBeu4
	 sUkQDcUiNxhJaGVSPq+ODC7mipLf0doT/R3LG9RY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 051/333] spi: rockchip-sfc: Fix double-free in remove() callback
Date: Tue, 17 Mar 2026 17:31:20 +0100
Message-ID: <20260317163001.258740758@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 111e2863372c322e836e0c896f6dd9cf4ee08c71 ]

The driver uses devm_spi_register_controller() for registration, which
automatically unregisters the controller via devm cleanup when the
device is removed. The manual call to spi_unregister_controller() in
the remove() callback can lead to a double-free.

And to make sure controller is unregistered before DMA buffer is
unmapped, switch to use spi_register_controller() in probe().

Fixes: 8011709906d0 ("spi: rockchip-sfc: Support pm ops")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Link: https://patch.msgid.link/20260310-sfc-v2-1-67fab04b097f@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-rockchip-sfc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-rockchip-sfc.c b/drivers/spi/spi-rockchip-sfc.c
index b3c2b03b11535..8acf955636977 100644
--- a/drivers/spi/spi-rockchip-sfc.c
+++ b/drivers/spi/spi-rockchip-sfc.c
@@ -712,7 +712,7 @@ static int rockchip_sfc_probe(struct platform_device *pdev)
 		}
 	}
 
-	ret = devm_spi_register_controller(dev, host);
+	ret = spi_register_controller(host);
 	if (ret)
 		goto err_register;
 
-- 
2.51.0



