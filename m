Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1FF335BCD;
	Mon, 18 Aug 2025 13:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525232; cv=none; b=gsI8BAZkZywaq0Z3Yc3WVAQimFg0lKiFtLQmQhiN0XrmQ0rney84G5Doz4pMJ9OsqvQLxZ9nKgJE2aP4/c5WhyRtmnpq3qukiwfCjXoRaVR9GFVzGAF22ut6gu+7Ab9WJHvuRqHVqyXokuA9lxDHF4k53XXgaNJ9FEH4sSFZ4Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525232; c=relaxed/simple;
	bh=qVVmoO7rfDnpKWMgQsEVVv4q2xk/lfs99L1GgDC7smc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vx+tj6ZgmpH2IqWKG0lmuEKuuixSAJaspSOKgf3e7YmSv9eMUe/wYYE41ulF7xNtllo/YRsAifIAaY9mj/EKZ2cSYK966L82cPfyof0wU/S827HkBxquMOeoD/IjbnL5rm4KBQaGEbitrcP08mRicoqSDvw3wkVctT6/7hov9qA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TC7tZmpX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TC7tZmpX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82944C4CEEB;
	Mon, 18 Aug 2025 13:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525232;
	bh=qVVmoO7rfDnpKWMgQsEVVv4q2xk/lfs99L1GgDC7smc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TC7tZmpXpcXd7R2RWxVV3+4eqTyaDTcip77MAUSLlwcQ1ZeQcc9cMvnVO4OyWZEyN
	 54wPCGJNrfHT6IFFdRbNnJYK2BLWCoYamTDEXAZQdN2oGW/vCtdvvGT9ztQVKOKPVN
	 hK36JP163Wh0djs00vx/+Rs2swVBDbHjCThMR3ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomasz Michalec <tmichalec@google.com>,
	Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 198/570] platform/chrome: cros_ec_typec: Defer probe on missing EC parent
Date: Mon, 18 Aug 2025 14:43:05 +0200
Message-ID: <20250818124513.425280985@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 7678e3d05fd3..f437b594055c 100644
--- a/drivers/platform/chrome/cros_ec_typec.c
+++ b/drivers/platform/chrome/cros_ec_typec.c
@@ -1272,8 +1272,8 @@ static int cros_typec_probe(struct platform_device *pdev)
 
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



