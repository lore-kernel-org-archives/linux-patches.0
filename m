Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E276147CA60;
	Sat, 12 Sep 2026 18:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238150; cv=none; b=OGtIHpdvfyIwqLckITF++OdtmC4Shs+bjAT3GrbjUCPfUHfVZjFAKYnlYQp409vVuk2dyLXDhPv3DVIRhQqVaFtGBjMWxBbbWE+r0S75FoVEBWF6R8Zugj9tCuobpVlzVCFrxQLW6mySHPocPOH0BhIxjQYWVZLsDYpVOTKWKrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238150; c=relaxed/simple;
	bh=+cL4fcKgpIvvv+pU+OEtLNdroeJcU8/7sHEFCglwaSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MVnc+cfMhJUFALkIqv9svyV0yPywHm5F1OVsxfP1WzVa42s8Da7wT1akjwu+YIyOuJnsgKUxVDGCEzdpApbPlgOIMgHs6Q7DJvv+4SrMv18K2GbSzeOQNVcea6vWLxbu5bKnmm+0IO2D1UaM83Vo4zc0kj6pLbYRla2JCifYUag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s+27JRkB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s+27JRkB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFBEF1F00893;
	Sat, 12 Sep 2026 18:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238143;
	bh=x+XTNUtqxL2Dm04RnJH25gQKUybd2zU1c/zEDCqxS6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s+27JRkBRH4aCHG25xmSvW4vkPJfD8NLqAXCLjguJFU2dKm8kurTur9ys00/Q/KyG
	 PTtMuw8WQEAttcP0Ap+NVzar4xdYDPB8OZvhkDTprHQpDf2CjyrBvs0ST7wEIY7TEV
	 x0R9Ms9Kt7PvWg7ikP7sLioIbeK34+YbWeI015NA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Johan Hovold <johan@kernel.org>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: [PATCH 5.15 359/935] drm/bridge: dw-hdmi: fix i2c adapter leak on probe failure
Date: Sat, 12 Sep 2026 08:56:29 +0200
Message-ID: <20260912065535.040897342@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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
@@ -3287,7 +3287,8 @@ struct dw_hdmi *dw_hdmi_probe(struct pla
 			break;
 		default:
 			dev_err(dev, "reg-io-width must be 1 or 4\n");
-			return ERR_PTR(-EINVAL);
+			ret = -EINVAL;
+			goto err_res;
 		}
 
 		iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);


