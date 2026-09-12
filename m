Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13BE12D9792;
	Sat, 12 Sep 2026 15:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228590; cv=none; b=t9hrRQBZGQJVJJKXHkscZK3qe0pHP+JQMd4DCCRZaNgzBRNtRKcPv5OYbj6G7hne7u76Vh8f8H2AJVjKpmPXinrgSYMoo5vjZlXoJ45N0OhZf0ZqeVBq0gj1Od/DV2SmH5oMCh88DZ8Zkxffb1s/GsDwN57N2mSQOV/cpeC2uns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228590; c=relaxed/simple;
	bh=s0CV86u1UViEvVidOuedXvBvhWKBPkKBGl1IQkggsEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cJvIIFsKNAdGquAyPe/w8Qkud0zAPSswsILTMxBHg6iqDwpP5/S5paW+pkwGi6KOj+rNSuxzjSBGMMXg6a6ZmsIIeYlWqriZtIAtfH0U+wqVsdombq+lWv0ryVEoXYBr9ow/KlWutp/e0NX8UbSumtcuQYBiyEbaYZBO40FNsFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uTl/uOBr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uTl/uOBr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 131D21F000FF;
	Sat, 12 Sep 2026 15:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228588;
	bh=HAtLissdAo6AYPKP9AmRr+kK1+xxksxxFiwNKDKKrVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uTl/uOBrxLfqlLVjX0r1QHJebUZAykcQBc8mLtSuSoYqEx8F7Uc33YsFdD87Jacqh
	 v9JA/vlvH9UUEL1XPHF0rpSMjdIPLPTpUQpOwlKTkp+17bb+6kIuW2gG8ou9Kd/xvA
	 3nbX/4nHktw0pp3PIvny515qCRoXn+M/B2mOBo+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Johan Hovold <johan@kernel.org>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: [PATCH 6.1 0414/1191] drm/bridge: dw-hdmi: fix i2c adapter leak on probe failure
Date: Sat, 12 Sep 2026 08:52:22 +0200
Message-ID: <20260912065557.536718563@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3414,7 +3414,8 @@ struct dw_hdmi *dw_hdmi_probe(struct pla
 			break;
 		default:
 			dev_err(dev, "reg-io-width must be 1 or 4\n");
-			return ERR_PTR(-EINVAL);
+			ret = -EINVAL;
+			goto err_res;
 		}
 
 		iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);


