Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 433D6545284;
	Wed,  9 Sep 2026 14:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963111; cv=none; b=fVApco8M8Tg4Zb3ED347M2UvrPnX9TgYWO8pZjJzf0wfuW5DCNbGO8wj7STmEuLSc2Yd6LFe02cLabcr428mYlmqtt6yW8YtRFB0DT4nzGGSfbqRLLEdbwpe3aPl7twckr1+vXwQjZBI5zzzRZ8Q6RwjfIl+SdEvDYsaz06b3ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963111; c=relaxed/simple;
	bh=G64/Nj/MSrsGVRqTc4nZpD2i8ppuxYa0fiJuxMGgwls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ClK/uHrvxOptDwEaMHa1cEu+tpd+/o1BFbRS6Qw9p+4M3DFsAPmb3KkYMVwJqCpeAyGqoulGsFx6QK8QdqqrtX+paOT0nqoWbN3xC4pYpjFeZ1ArfJL/dWSkAVx+y12dlX8l/+iBX8vNpSpgGEq+PCj0xZ9jxY9Rpn/nNebupxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lq+ARPbc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lq+ARPbc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 499A31F00A3A;
	Wed,  9 Sep 2026 14:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963109;
	bh=D2KBQyeJVHsv+0PqMuX4Wg6VJ+2zucelCIDOVQ0B4iI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lq+ARPbcGA+h0i0CywB5rwC/2cyKS8pBnnNMj1+/gYJsUJGC5ikheU+a3eSFN/ebf
	 HVpTvOFV3W4DyyXzhNuK3pAfpB2RBq3P8/Yy+sooKNooKf+9A9H40c6HSLAIfoDKMB
	 PSnT86xOaTFMohCtmKdutsOUvzd1pAqWoOZfKY70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Johan Hovold <johan@kernel.org>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: [PATCH 7.2 477/556] drm/bridge: dw-hdmi: fix i2c adapter leak on probe failure
Date: Wed,  9 Sep 2026 15:42:37 +0200
Message-ID: <20260909134247.320260378@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3389,7 +3389,8 @@ struct dw_hdmi *dw_hdmi_probe(struct pla
 			break;
 		default:
 			dev_err(dev, "reg-io-width must be 1 or 4\n");
-			return ERR_PTR(-EINVAL);
+			ret = -EINVAL;
+			goto err_res;
 		}
 
 		iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);


