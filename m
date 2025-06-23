Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A34E221FDC;
	Mon, 23 Jun 2025 21:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713381; cv=none; b=L05oQvJKRpk0i95TaApZEJj9dyS6l0Nmlp23Tt7OCgH9w9349ntrTczdBzyuboCkB3ydmcD3fUVG1+yb5DuKkuIuJFE4BwB7aqdXeu7ZJFCXFuTz16h+wGgmnPZRBvEoAZ6aMCKVyM2Yx1Jth++M9ZhPdpt78h0Q+NNMKatbQXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713381; c=relaxed/simple;
	bh=8E4qmek7ywOqqb9t/HRUs8fxndbYJsU0d+qBnnx34F0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jQlfM1Ny05LYnXGtuo4NkYgtDfbpbp9QR0Au70E2Tagb0uPpEURXg2c5FHip6x3Th/cMM5ulLlVAOrsyKF/lRAYP4TaS0Wl/8xg3a1OFFENCZo92C8idbSATBERC/b92EXNc2GG197gqpbQH/twsyr6STn+cTCJzilEGaPcKbgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w7Z9IcNL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w7Z9IcNL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AF5CC4CEF0;
	Mon, 23 Jun 2025 21:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713377;
	bh=8E4qmek7ywOqqb9t/HRUs8fxndbYJsU0d+qBnnx34F0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w7Z9IcNLl3c/j6oO08m99GtKC4JDRzsYo8dYYt+QqHOH7M96SQN6D1URB3UlMfuri
	 1gKGzKZSy0sTo0JcLkOdrgH6B5S9mwerXaemriSwGtGuUqExZKnVM1ZHkDS6F35feO
	 APRZxM490wn07Bhsnm/KSffPgFWdDVK6NXYbJKVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 041/414] media: ov8856: suppress probe deferral errors
Date: Mon, 23 Jun 2025 15:02:58 +0200
Message-ID: <20250623130643.062667687@linuxfoundation.org>
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
@@ -2276,8 +2276,8 @@ static int ov8856_get_hwcfg(struct ov885
 	if (!is_acpi_node(fwnode)) {
 		ov8856->xvclk = devm_clk_get(dev, "xvclk");
 		if (IS_ERR(ov8856->xvclk)) {
-			dev_err(dev, "could not get xvclk clock (%pe)\n",
-				ov8856->xvclk);
+			dev_err_probe(dev, PTR_ERR(ov8856->xvclk),
+				      "could not get xvclk clock\n");
 			return PTR_ERR(ov8856->xvclk);
 		}
 
@@ -2382,11 +2382,8 @@ static int ov8856_probe(struct i2c_clien
 		return -ENOMEM;
 
 	ret = ov8856_get_hwcfg(ov8856, &client->dev);
-	if (ret) {
-		dev_err(&client->dev, "failed to get HW configuration: %d",
-			ret);
+	if (ret)
 		return ret;
-	}
 
 	v4l2_i2c_subdev_init(&ov8856->sd, client, &ov8856_subdev_ops);
 


