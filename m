Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061164;
	b=ONT6gqsM9UzYGC+MGswBw/DAp/oU4uer5yKIC9esF0+4qYEzsOGQLcOLSzTzr2CJRHwi
	 +amr6NLiqeIVCMyEw5zupP3z+3DeJsFJu/GPhflU9I/7cbNJlphQz7J6qqHxtC6qu7MXV
	 9HM4eXqs+zn38/u4c0MDXxfyuItW/lL+N7EWS8Z/9JRsVqv+XxvsdBdhng9S8qoB0ZCfx
	 AToFB0XwzjdS3GG5i6eGQRySZhtzDWMNn28bdEEcWrcKddzrgyG88cN3XcBZfxf282emr
	 hw4K1DK3yAAPEn6akZm33pYF2NCDxMdyg10vaz9xJcQc6cs/Dd4wL4UTkrsQg6aqZMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061164;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u4792zslu3Oy79EV1P6aPQU0yyaZ9Mba7cTsSGeRf7g=;
	b=xRDGVicjiqMriuCB2BsKMXmVIw7HX5DXp42bhTGFmaT6+BlQ34Cg0LNIhIt/H6V4gZG/
	 jptaeUHnnAEoyAh8ahiOjGCGMlj8cRNNbnFjE6a+O6cHQWA7Ue/2jJgnbE0kBP/Akl5Pg
	 ZrC4tKBNbGzjGv2mqfkFGUGs94TDZEP5mX2Q97/6Sq1jVetTNboraEC0hPBSHPlPvlWre
	 3jcmk0MbTcqijgNFxPOOmmQ+ACiYPGQNyh66teSup3sdqZTfVAS5ARhNcLKiZZWfxKfep
	 kHZuKr1P442S/YdBbfkKbvp/LXi3KQ+bYaRaIRFqPxXsmdGPXRuLM1OakDuO12g1c5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FAg2upgE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9260606A325;
	Thu, 19 Nov 2026 04:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FAg2upgE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32DC11F000C4;
	Thu, 19 Nov 2026 04:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061164;
	bh=u4792zslu3Oy79EV1P6aPQU0yyaZ9Mba7cTsSGeRf7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FAg2upgEBWEW+jrd2+L/7BPV9qU0Vme9QNjXkeH/UsYbzy8Y0DOxdVN8XQMKxLKJM
	 hcb5RXVQT6jv2iiAgREus0a3ANS2RdJKLYxwCyO1m00mfXm++pmYUT5AcySTeTBcem
	 m/z9bB2LHJn9WxzRxGB8Y/rkOw6gAYl8tlGsqZRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tian Tao <tiantao6@hisilicon.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1454/1848] power: supply: Fix missing IRQF_ONESHOT as only threaded handler
Date: Wed, 18 Nov 2026 15:58:12 +0100
Message-ID: <20261118150020.265092290@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tian Tao <tiantao6@hisilicon.com>

[ Upstream commit df12470ce775cd126f26c96d240959b0c1929e23 ]

Coccinelle noticed:
drivers/power/supply/ab8500_btemp.c:1107:8-28: ERROR: Threaded IRQ with
no primary handler requested without IRQF_ONESHOT.

Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Stable-dep-of: 1098c619ce75 ("power: supply: ab8500_charger: Handle detection errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ab8500_btemp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/ab8500_btemp.c b/drivers/power/supply/ab8500_btemp.c
index a191effd5d63b..2fce437f04547 100644
--- a/drivers/power/supply/ab8500_btemp.c
+++ b/drivers/power/supply/ab8500_btemp.c
@@ -1093,7 +1093,7 @@ static int ab8500_btemp_probe(struct platform_device *pdev)
 		}
 
 		ret = request_threaded_irq(irq, NULL, ab8500_btemp_irq[i].isr,
-			IRQF_SHARED | IRQF_NO_SUSPEND,
+			IRQF_SHARED | IRQF_NO_SUSPEND | IRQF_ONESHOT,
 			ab8500_btemp_irq[i].name, di);
 
 		if (ret) {
-- 
2.53.0



