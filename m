Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356E22D0C75;
	Sat, 12 Sep 2026 11:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214262; cv=none; b=pZcFFB4XkigGavZrFgm4AbNGouTsfOJYEonMtOfD+eKMmgxRfFFYHyHRH/brYlZM3ATBuTQa0C6KoPO25HRCyaYdmYsSPfLD9JYM5kQahMr2X1ObAVfoRD75o6IpN0YcvBi+WCxy63fWwbmVq0/RluRD9mvnZuySdfJuHTnCsyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214262; c=relaxed/simple;
	bh=fYqRKuKw7EC8PcF+007/yN8XSPERi3ZWK81ySAuV104=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Clu2ESgXiSqGXvEmFON9nwPa1Uq30bS/ETi4wopcL+kNigIq8cffrrlSbK4BX0WhaSYZr7zzPplD92VUdCpFoppxV3XgxqrOmXyySAwEpkGx5eyePNzazh29BRi2rvHW+lEvbrklDJS++7R6w7o4lKbCnhyg2vWkigX9ljBA20U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zbXjOVZF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zbXjOVZF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D481F000FF;
	Sat, 12 Sep 2026 11:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214261;
	bh=VhTAFBxWGEqMh9QB2fYkCV9kmIqrOAmtWX73KiOf8ek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zbXjOVZFJeMcvw/Xf2Gkh2VWrLUHcPkqGE1j/mXHhPQkU5YQEiGYuHNnLpSKNq6TE
	 Pj5kP1x+iEwIcxafn7BHDQI7skCvJKU1R+Imem2MMuYhn9BZS1T20AmSSu3s78a9Bb
	 zlMJg6MdxmNqZIYfRe8dU6AqH/EpaTK7JrHt3grs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Johan Hovold <johan@kernel.org>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: [PATCH 6.12 0259/1376] drm/bridge: dw-hdmi: fix i2c adapter leak on probe failure
Date: Sat, 12 Sep 2026 08:44:45 +0200
Message-ID: <20260912065613.311080032@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
@@ -3383,7 +3383,8 @@ struct dw_hdmi *dw_hdmi_probe(struct pla
 			break;
 		default:
 			dev_err(dev, "reg-io-width must be 1 or 4\n");
-			return ERR_PTR(-EINVAL);
+			ret = -EINVAL;
+			goto err_res;
 		}
 
 		iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);


