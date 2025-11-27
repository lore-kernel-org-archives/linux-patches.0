Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F21334697;
	Thu, 27 Nov 2025 14:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255291; cv=none; b=r87tFhQMuWIT+RmZ1FOYgjYWU+1zIwlbPhRVnvfnK7b7cFsSSdDTBEYOfv9Kvsr6xtQqR6kRqtDe3QdV4HNn/BuxvmD/gF5GhuEwwBTdyvcnpKEwyOGuRyt4JCheBe4mNikiNfqWnWwxqiAE6XDt9AV0rLIGOHptbFRGFm0SGrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255291; c=relaxed/simple;
	bh=yJbSNaa5aE3VVuhWilq542InJseenOYhIoh8sNQTZcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b/75ppfZmHBv1S7afPXCzeBbshEDC6ok3c8NiTvQPH7Yf9hM2shzxmtWrbEl2nm0IGtQ3iUU0aEaJZvPhkQ/Vwo8wgAZ9URnEBg5ayup/FKeFbRNtOxJje8VzYtgRrDp99g5bgbrC9igqIeTkbNVKUd7O2wVSzgZAbBtfGg6dlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TWb8faMs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TWb8faMs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C0E7C4CEF8;
	Thu, 27 Nov 2025 14:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255289;
	bh=yJbSNaa5aE3VVuhWilq542InJseenOYhIoh8sNQTZcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TWb8faMsgSMBqvif321ebVHKMpr9t1HetV09BH1Oq+ShN4fbnxksUgodjPg7Jaaya
	 MuPTVBiWjM/h2w/maI+hHhnezuE/I3P7Rd5W8D9EZH3aEplHtoux5Cu/dPJElX97og
	 YhPvR+VXSKFye5hChsYsxFYOq/Y54kZa24ZqQ3cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jared Kangas <jkangas@redhat.com>,
	"Jan Petrous (OSS)" <jan.petrous@oss.nxp.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 074/112] pinctrl: s32cc: fix uninitialized memory in s32_pinctrl_desc
Date: Thu, 27 Nov 2025 15:46:16 +0100
Message-ID: <20251127144035.550547955@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jared Kangas <jkangas@redhat.com>

[ Upstream commit 97ea34defbb57bfaf71ce487b1b0865ffd186e81 ]

s32_pinctrl_desc is allocated with devm_kmalloc(), but not all of its
fields are initialized. Notably, num_custom_params is used in
pinconf_generic_parse_dt_config(), resulting in intermittent allocation
errors, such as the following splat when probing i2c-imx:

        WARNING: CPU: 0 PID: 176 at mm/page_alloc.c:4795 __alloc_pages_noprof+0x290/0x300
        [...]
        Hardware name: NXP S32G3 Reference Design Board 3 (S32G-VNP-RDB3) (DT)
        [...]
        Call trace:
         __alloc_pages_noprof+0x290/0x300 (P)
         ___kmalloc_large_node+0x84/0x168
         __kmalloc_large_node_noprof+0x34/0x120
         __kmalloc_noprof+0x2ac/0x378
         pinconf_generic_parse_dt_config+0x68/0x1a0
         s32_dt_node_to_map+0x104/0x248
         dt_to_map_one_config+0x154/0x1d8
         pinctrl_dt_to_map+0x12c/0x280
         create_pinctrl+0x6c/0x270
         pinctrl_get+0xc0/0x170
         devm_pinctrl_get+0x50/0xa0
         pinctrl_bind_pins+0x60/0x2a0
         really_probe+0x60/0x3a0
        [...]
         __platform_driver_register+0x2c/0x40
         i2c_adap_imx_init+0x28/0xff8 [i2c_imx]
        [...]

This results in later parse failures that can cause issues in dependent
drivers:

        s32g-siul2-pinctrl 4009c240.pinctrl: /soc@0/pinctrl@4009c240/i2c0-pins/i2c0-grp0: could not parse node property
        s32g-siul2-pinctrl 4009c240.pinctrl: /soc@0/pinctrl@4009c240/i2c0-pins/i2c0-grp0: could not parse node property
        [...]
        pca953x 0-0022: failed writing register: -6
        i2c i2c-0: IMX I2C adapter registered
        s32g-siul2-pinctrl 4009c240.pinctrl: /soc@0/pinctrl@4009c240/i2c2-pins/i2c2-grp0: could not parse node property
        s32g-siul2-pinctrl 4009c240.pinctrl: /soc@0/pinctrl@4009c240/i2c2-pins/i2c2-grp0: could not parse node property
        i2c i2c-1: IMX I2C adapter registered
        s32g-siul2-pinctrl 4009c240.pinctrl: /soc@0/pinctrl@4009c240/i2c4-pins/i2c4-grp0: could not parse node property
        s32g-siul2-pinctrl 4009c240.pinctrl: /soc@0/pinctrl@4009c240/i2c4-pins/i2c4-grp0: could not parse node property
        i2c i2c-2: IMX I2C adapter registered

Fix this by initializing s32_pinctrl_desc with devm_kzalloc() instead of
devm_kmalloc() in s32_pinctrl_probe(), which sets the previously
uninitialized fields to zero.

Fixes: fd84aaa8173d ("pinctrl: add NXP S32 SoC family support")
Signed-off-by: Jared Kangas <jkangas@redhat.com>
Tested-by: Jan Petrous (OSS) <jan.petrous@oss.nxp.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/nxp/pinctrl-s32cc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/nxp/pinctrl-s32cc.c b/drivers/pinctrl/nxp/pinctrl-s32cc.c
index 501eb296c7605..51ecb8d0fb7e8 100644
--- a/drivers/pinctrl/nxp/pinctrl-s32cc.c
+++ b/drivers/pinctrl/nxp/pinctrl-s32cc.c
@@ -951,7 +951,7 @@ int s32_pinctrl_probe(struct platform_device *pdev,
 	spin_lock_init(&ipctl->gpio_configs_lock);
 
 	s32_pinctrl_desc =
-		devm_kmalloc(&pdev->dev, sizeof(*s32_pinctrl_desc), GFP_KERNEL);
+		devm_kzalloc(&pdev->dev, sizeof(*s32_pinctrl_desc), GFP_KERNEL);
 	if (!s32_pinctrl_desc)
 		return -ENOMEM;
 
-- 
2.51.0



