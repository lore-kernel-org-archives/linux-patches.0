Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9D32E7379;
	Sat, 30 May 2026 17:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162806; cv=none; b=IofEaLdYXfO85eW7awli0J/X1g5F1DNKQwmldGMetq+xLlvvg3+8m/oyemftdov4wqg28qRcxmK6REMDkmEmlhQs16zbbbNGbS5CA57LJo9A0DQISr3cflfsmn82DRwgyZl2ejdnyl6q8xDn3sME8SKExOU380KtdkboF9VDM1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162806; c=relaxed/simple;
	bh=L3HU0kXXt0P18uDFzr43iwSf6SPDuLacKz6+fvB59Zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aPC7ARM8dKWndZSbGyuP2Ls5IhTICNZIIU4JaQJEKr9/Lhu1ydyfSDVTvuQz1a0muRssW9gGuOlgTIUGAV/u4/RILziN8Iyk/fEMDTBOBN8uptTkS2l8agG2/ZklMRDp/nPdK+C/2/WSOwhksMkIfShDcop3ihCtXDR/LxFBcr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LwScX8TI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LwScX8TI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90F3F1F00893;
	Sat, 30 May 2026 17:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162805;
	bh=OQNqwLTiSfnloXoSBuH2fXQQ06m0u3CRKk2HRw6cYBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LwScX8TI/Uw+ucwhjC3VLqAz3QQFKo3eeSJIr6ycrtc8/3RDCYmdhVdA9fI+gdLRY
	 fxBcfNlrHQkj9auePTbMU7KLHMWVCERpcNiqfWj6cTj0iquXtfNBSKH7P7jZbfcQzs
	 KnH1ZQbUSEKsDHpCG0jZ+t8P7ncFDjI+/8FmwZFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samasth Norway Ananda <samasth.norway.ananda@oracle.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 039/776] gpio: tegra: fix irq_release_resources calling enable instead of disable
Date: Sat, 30 May 2026 17:55:53 +0200
Message-ID: <20260530160241.303866213@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

From: Samasth Norway Ananda <samasth.norway.ananda@oracle.com>

[ Upstream commit 1561d96f5f55c1bca9ff047ace5813f4f244eea6 ]

tegra_gpio_irq_release_resources() erroneously calls tegra_gpio_enable()
instead of tegra_gpio_disable(). When IRQ resources are released, the
GPIO configuration bit (CNF) should be cleared to deconfigure the pin as
a GPIO. Leaving it enabled wastes power and can cause unexpected behavior
if the pin is later reused for an alternate function via pinctrl.

Fixes: 66fecef5bde0 ("gpio: tegra: Convert to gpio_irq_chip")
Signed-off-by: Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
Link: https://patch.msgid.link/20260407210247.1737938-1-samasth.norway.ananda@oracle.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-tegra.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-tegra.c b/drivers/gpio/gpio-tegra.c
index 7f5bc10a64792..ae769a29bf169 100644
--- a/drivers/gpio/gpio-tegra.c
+++ b/drivers/gpio/gpio-tegra.c
@@ -598,7 +598,7 @@ static void tegra_gpio_irq_release_resources(struct irq_data *d)
 	struct tegra_gpio_info *tgi = gpiochip_get_data(chip);
 
 	gpiochip_relres_irq(chip, d->hwirq);
-	tegra_gpio_enable(tgi, d->hwirq);
+	tegra_gpio_disable(tgi, d->hwirq);
 }
 
 #ifdef	CONFIG_DEBUG_FS
-- 
2.53.0



