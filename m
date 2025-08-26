Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A254D35A281;
	Tue, 26 Aug 2025 14:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217725; cv=none; b=T/SfJWMqpyv6P0m2ZNACupr/SHtyV71Pfh9DyCcjV5XWWQMVg6d3YDJ+3aGHWQcYg21z9A4omytGdIP8ikNYOBJ9o+bKDLV5Rz56q/f9N5j9lOXPN/Gkx8Cz66HapEvg6CGHc8U69LewflMscow/MwgxdXcCv+64G0ZaWjv4XQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217725; c=relaxed/simple;
	bh=3/He20O2z8i4qpvy0zJjnWMo1zAYf/qkuFrhXlFEby0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sZQdUr7Pn2nNgmh7c9jxZWNQ8+vOO+j4FmzFXhfShNpjmSoOuG927vkFh4DTkp0WvWts2Zsj1m4K+k3pwlLpsGVUUB/x8wBl7cpSbs4daziSZe3o6tNFUTzxRJpP4YiH/Xqbdjl19a7MvhAUxLZLmM/IABH8DphGLJvcQv+/4yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wn50gpQg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wn50gpQg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F5EC113D0;
	Tue, 26 Aug 2025 14:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217725;
	bh=3/He20O2z8i4qpvy0zJjnWMo1zAYf/qkuFrhXlFEby0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wn50gpQgwtHTWismjeLwt1yydV99UyP9l1Q839su9UdoOwunsykNvBPuiTch6aeyL
	 UM5clkiVWncsG9dYSmANGf3vJ7Tn2feKI4ADBapEMxDfBKGoTQFDskpC5zHMr9sQGs
	 ri8zc8z/6mc5wfKDVU8kEhwtiCJmMchQGZG7nF/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomasz Michalec <tmichalec@google.com>,
	Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 252/523] platform/chrome: cros_ec_typec: Defer probe on missing EC parent
Date: Tue, 26 Aug 2025 13:07:42 +0200
Message-ID: <20250826110930.648490761@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Michalec <tmichalec@google.com>

[ Upstream commit 8866f4e557eba43e991f99711515217a95f62d2e ]

If cros_typec_probe is called before EC device is registered,
cros_typec_probe will fail. It may happen when cros-ec-typec.ko is
loaded before EC bus layer module (e.g. cros_ec_lpcs.ko,
cros_ec_spi.ko).

Return -EPROBE_DEFER when cros_typec_probe doesn't get EC device, so
the probe function can be called again after EC device is registered.

Signed-off-by: Tomasz Michalec <tmichalec@google.com>
Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Link: https://lore.kernel.org/r/20250610153748.1858519-1-tmichalec@google.com
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_ec_typec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/chrome/cros_ec_typec.c b/drivers/platform/chrome/cros_ec_typec.c
index 983daa220ee3..137f99c1848e 100644
--- a/drivers/platform/chrome/cros_ec_typec.c
+++ b/drivers/platform/chrome/cros_ec_typec.c
@@ -716,8 +716,8 @@ static int cros_typec_probe(struct platform_device *pdev)
 
 	typec->ec = dev_get_drvdata(pdev->dev.parent);
 	if (!typec->ec) {
-		dev_err(dev, "couldn't find parent EC device\n");
-		return -ENODEV;
+		dev_warn(dev, "couldn't find parent EC device\n");
+		return -EPROBE_DEFER;
 	}
 
 	platform_set_drvdata(pdev, typec);
-- 
2.39.5



