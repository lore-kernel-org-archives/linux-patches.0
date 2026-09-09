Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE4A550DCA;
	Wed,  9 Sep 2026 14:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964291; cv=none; b=hzsB29MKyPv051dnsuYrLsZuTEewuyyMnQSdRwPkHjgsVe+u8Cf6fLnLRY0+e+C7iZHwyRIAk2OVMgIlH0ki7coIuz4T+gbOnxb0yYi2gDf1qL2h7kqhtOInrpT9baduxtKqMn659eealknlyY/rcKXWVipAUKpb2yMnsESkJCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964291; c=relaxed/simple;
	bh=vNrXJ68sBc/JA5HRcgB5NaBmLIeXLvNVstBn5rMXYIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GBfm0vrUt6VPIeevGW3D9wHoaRAMj47EqsR6f0/o5RAijXGtUIsNJ6sfPxm6M9bZuk67O3lzoSk2G/B5YPu4OZFGSE/bkNyD9UYIngAw2A2UpL5+osk4NHysM1rt1QlftLmhAJ6ys89w8UWvFGRd0Ixg+2x7pGwnntMSZRQiH0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JXS96OtH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JXS96OtH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A5681F00A3A;
	Wed,  9 Sep 2026 14:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964289;
	bh=5grpkthjspGhWz0/osDo2XK39IUHc387MJ+TBENUpMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JXS96OtHNzBLt5uhLYHly/iy/0diK9aBLip6+ruzft4TzmzMr7YD31qYHJFBapaQ1
	 yZwq6RWQ7cYHvaoQB58/pzoFMqU6hb+Brr7/EfkfzpIOHRnqpn8gDE8zE745xpSN8F
	 8VxZaRgOmi/pOt/erfRRI73UfuxPKfkP/hG/BL9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Johan Hovold <johan@kernel.org>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: [PATCH 6.18 373/583] drm/bridge: dw-hdmi: fix i2c adapter leak on probe failure
Date: Wed,  9 Sep 2026 15:40:58 +0200
Message-ID: <20260909134250.955225380@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 09b195a7bb23df56269cd2a95d01ba3a5533af13 upstream.

Make sure to drop the i2c adapter device and module references before
returning when detecting a malformed devicetree during probe.

Fixes: 80e2f97968b5 ("drm: bridge: dw-hdmi: Switch to regmap for register access")
Cc: stable@vger.kernel.org	# 4.12
Cc: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Link: https://patch.msgid.link/20260717090819.1630965-1-johan@kernel.org
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
+++ b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
@@ -3385,7 +3385,8 @@ struct dw_hdmi *dw_hdmi_probe(struct pla
 			break;
 		default:
 			dev_err(dev, "reg-io-width must be 1 or 4\n");
-			return ERR_PTR(-EINVAL);
+			ret = -EINVAL;
+			goto err_res;
 		}
 
 		iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);


