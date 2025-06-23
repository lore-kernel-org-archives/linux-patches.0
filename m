Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E8470838;
	Mon, 23 Jun 2025 21:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713032; cv=none; b=D1ONsUK+YlKX5IdxQMelugKh1cKYHBCq3wNsq3pWszxQw+rY6y/u4VR/8ewz3QSpa0geneEp9DsSAkrSghZXz2AVzolts6uXqVlHIm0GwzweLjkLo8H//2UQpS/XbTs9HBQU9ej9+Bm8EktviSzB6YlbtGNm5e1jEZ52+NUYhgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713032; c=relaxed/simple;
	bh=MtKtPTvuUWwmE248WXtRsK/3OsNsCO3wUDfvcvtz2E4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q4vO5O6upiTE5fh1eZR05T8IY8jDPgQZLGwrBOCBaLETf+0l62paccO+9A5LP+hhMVby33Qn2X1LRMDHIBQ3LgHZMLNqmy23xJJ41PNcxIdcQYpaVil5ebBpWVsmCyRi8HP2BcdDzgC/mcn69LWPWvftpToTEdH626fnRQ1y3js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VvfgJPoS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VvfgJPoS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C34A2C4CEEA;
	Mon, 23 Jun 2025 21:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713032;
	bh=MtKtPTvuUWwmE248WXtRsK/3OsNsCO3wUDfvcvtz2E4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VvfgJPoSoXdns18EZsDPehR0Lc1yBC6PgrLPJ2CV0/5QSyV3hEzcGqEG3x+31Fn20
	 lq+D3qFF7uNSeYP+yBv3+ImMMTzm3grbIIFhAt4d3ctdHS/8cVHCPYAOZzcWsHMcZM
	 +iNsb1PXpC4YqnXlJhPdJFIqcJwahLIVrr5qm6UI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 042/414] media: ov5675: suppress probe deferral errors
Date: Mon, 23 Jun 2025 15:02:59 +0200
Message-ID: <20250623130643.087681845@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit 8268da3c474a43a79a6540fb06c5d3b730a0d5a5 upstream.

Probe deferral should not be logged as an error:

	ov5675 24-0010: failed to get HW configuration: -517

Drop the (mostly) redundant dev_err() from sensor probe() to suppress
it.

Note that errors during clock and regulator lookup are already correctly
logged using dev_err_probe().

Fixes: 49d9ad719e89 ("media: ov5675: add device-tree support and support runtime PM")
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ov5675.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/media/i2c/ov5675.c
+++ b/drivers/media/i2c/ov5675.c
@@ -1295,11 +1295,8 @@ static int ov5675_probe(struct i2c_clien
 		return -ENOMEM;
 
 	ret = ov5675_get_hwcfg(ov5675, &client->dev);
-	if (ret) {
-		dev_err(&client->dev, "failed to get HW configuration: %d",
-			ret);
+	if (ret)
 		return ret;
-	}
 
 	v4l2_i2c_subdev_init(&ov5675->sd, client, &ov5675_subdev_ops);
 


