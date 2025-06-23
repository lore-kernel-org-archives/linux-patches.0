Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7241A4F12;
	Mon, 23 Jun 2025 22:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716188; cv=none; b=iRQkQin/7OZC4zBkIHKMEYmgnbsv9RgPDYsvcMmD+GHSl4NKUy+ViQp2rqM44pcwCtzJO67bxk8H8w0CxIlMsquHYZuCmqh0LevmtwHiUDujXQ7ptqjKiK+fPbU50AWE4rWXQcH09IdBsdx0jXEAypavYL+My/tIq/5rq2HcHBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716188; c=relaxed/simple;
	bh=e8jVjt99ubrvLiJsukak/yarfRfbrbn+bH8wrrr/nho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eD840rDLEMogoUA5Q2/tgSHXCqPWfN+EHTmeckpdmEXr/i6czwZGYpLptYlAEWS6E45kep5KfL80fKe39kx+fEX7iD5sw3O2c74CfAPxI+PIiyLMn0yaLS94iKyX3zVUK8Emh3YM/jTIvyzs8I5+w7fMvMVTyuhs8amOyKiFMHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RVrp2hY0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RVrp2hY0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67EFFC4CEEA;
	Mon, 23 Jun 2025 22:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716188;
	bh=e8jVjt99ubrvLiJsukak/yarfRfbrbn+bH8wrrr/nho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RVrp2hY02Bb15h012V7EO/aQ236Lwoe/14328XX/Iz9RJ0+xuHmIDpnYDeXwiFOb4
	 Gn5dTVJZdJ9PJLJ7gy1hZEiL1OIlVC8gpWoosuuJxv01GXF0H3DggqgwmAcr4tiocZ
	 rzBQAL4/NFVNhRnnNFi+xeUpxoTyDfpiMRkYlIRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.1 307/508] media: ov8856: suppress probe deferral errors
Date: Mon, 23 Jun 2025 15:05:52 +0200
Message-ID: <20250623130652.866011173@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit e3d86847fba58cf71f66e81b6a2515e07039ae17 upstream.

Probe deferral should not be logged as an error:

	ov8856 24-0010: failed to get HW configuration: -517

Use dev_err_probe() for the clock lookup and drop the (mostly) redundant
dev_err() from sensor probe() to suppress it.

Note that errors during regulator lookup is already correctly logged
using dev_err_probe().

Fixes: 0c2c7a1e0d69 ("media: ov8856: Add devicetree support")
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ov8856.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/media/i2c/ov8856.c
+++ b/drivers/media/i2c/ov8856.c
@@ -2319,8 +2319,8 @@ static int ov8856_get_hwcfg(struct ov885
 	if (!is_acpi_node(fwnode)) {
 		ov8856->xvclk = devm_clk_get(dev, "xvclk");
 		if (IS_ERR(ov8856->xvclk)) {
-			dev_err(dev, "could not get xvclk clock (%pe)\n",
-				ov8856->xvclk);
+			dev_err_probe(dev, PTR_ERR(ov8856->xvclk),
+				      "could not get xvclk clock\n");
 			return PTR_ERR(ov8856->xvclk);
 		}
 
@@ -2425,11 +2425,8 @@ static int ov8856_probe(struct i2c_clien
 		return -ENOMEM;
 
 	ret = ov8856_get_hwcfg(ov8856, &client->dev);
-	if (ret) {
-		dev_err(&client->dev, "failed to get HW configuration: %d",
-			ret);
+	if (ret)
 		return ret;
-	}
 
 	v4l2_i2c_subdev_init(&ov8856->sd, client, &ov8856_subdev_ops);
 


