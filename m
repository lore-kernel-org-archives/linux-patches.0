Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37DD5377ABA;
	Sat, 12 Sep 2026 19:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242179; cv=none; b=eLQHMX4+NPyDPYejKpS1kCPRkH2QGObPKuqDE71SUaZ3llzvXPQ++JqR4c6grbOoXb2MymDBnhywSq1U0/xyO5nelYYcRN0wqIgjINnBsVKZ2eA/SYBI74Lh9NKa82Vu9VDn7BQunePA5pUDiVxTBxOngVcC8YjUd1wBTRteX6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242179; c=relaxed/simple;
	bh=MZ+Sv5dTVyUC1LvWxlhh12OSFadduyKfCoejnieHReg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J+ZrYRJVzB/z4Lmva2Sht889X259cuR1hc2zMGdPwAyLPBasvcM5uoRQfR/U2iBXJBqJOqmUk820fiEaBIxgAmti60gt0mIufdUqSM6WjUtM2fUV7t3oORt0ZpMKIau41iTxdwIiRDWqP9jcS4xf0gI75BEQ31GuqeQX2eedpYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=asplyE0D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="asplyE0D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93EB31F000FF;
	Sat, 12 Sep 2026 19:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242178;
	bh=54kBi3T9KI8jjPyfdTJTVXafl5edXiPIti1NEZenbVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=asplyE0DT171gRjWZ+8DH0ouWWbl7zeCGpHazAiaxgXxbfWLM6Qqvx4jpICSKcT3J
	 1G2xbype2jW9zr8qKn/WsooQjlw8nmFZihJ5WVZuuMWsu1a+z9NKTHxe+OCoUPcQez
	 ZPeDtMEU46h7gjElGFpX5IQydZGXdTSHQG6WPJv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Johan Hovold <johan@kernel.org>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: [PATCH 5.10 313/798] drm/bridge: dw-hdmi: fix i2c adapter leak on probe failure
Date: Sat, 12 Sep 2026 08:59:01 +0200
Message-ID: <20260912065524.332686780@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3251,7 +3251,8 @@ struct dw_hdmi *dw_hdmi_probe(struct pla
 			break;
 		default:
 			dev_err(dev, "reg-io-width must be 1 or 4\n");
-			return ERR_PTR(-EINVAL);
+			ret = -EINVAL;
+			goto err_res;
 		}
 
 		iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);


