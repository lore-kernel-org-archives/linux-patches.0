Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77242258EF3;
	Mon, 18 Aug 2025 13:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524627; cv=none; b=LQ4of4o9OKK1QGLMpk3VhRH4eOEoR2TVzGmofUXbHztStR7sSfawvAJvXnb2drWij0hbd+A/Dfy5SX1tVlAEH8L2Mzr5U/oObyklnCSu3r0g/vImazHSEqxAR94i2AdjpcS7ImWvu0AFen6UeLUX5XqzcSIh24B7Pb7p2H40GSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524627; c=relaxed/simple;
	bh=UeYjVeFX7Hvecu0D5ZBOzxQWzPPg8h2lCVSYfY0Oa/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YUMIRq8QoQCZkPMfHdstu3epIQm9wxctO9QmkskWoOHGHA/NCX5ztYELMPyQQyzJC80U6A3VvhAiFJLYh/NS8pRPpH3RXAx7tV2D7xmlU0gRiPOlDxO7XYHTSCOiXHpJNCR9y+E8Twdx/BA/95YUJdsOSejJWw6i4K4krloHQ08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=puJnN1w2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="puJnN1w2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B237BC4CEEB;
	Mon, 18 Aug 2025 13:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524627;
	bh=UeYjVeFX7Hvecu0D5ZBOzxQWzPPg8h2lCVSYfY0Oa/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=puJnN1w2CCKd2FGQnn3iWmfSk/C33mBuuVmgoMyJPx9OR8dsLIeeujhjsTI5Si3M0
	 HbSZwm83Pnj4M9Kd/omsSHu3i2ABnz39734uPmk5HqTcHcGs6V/vfwe9uBwG5V22bt
	 0YIT0QlVS/I3CBuID56CPohNWe3bPxVjIYQIC0cY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dongcheng Yan <dongcheng.yan@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.16 014/570] media: i2c: set lt6911uxes reset_gpio to GPIOD_OUT_LOW
Date: Mon, 18 Aug 2025 14:40:01 +0200
Message-ID: <20250818124506.335087080@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dongcheng Yan <dongcheng.yan@intel.com>

commit 3c607baf68639d6bfe1a336523c4c9597f4b512a upstream.

reset_gpio needs to be an output and set to GPIOD_OUT_LOW, to ensure
lt6911uxe is in reset state during probe.

This issue was found on the onboard lt6911uxe, where the reset_pin was
not reset, causing the lt6911uxe to fail to probe.

Fixes: e49563c3be09d4 ("media: i2c: add lt6911uxe hdmi bridge driver")
Cc: stable@vger.kernel.org
Signed-off-by: Dongcheng Yan <dongcheng.yan@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/lt6911uxe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/i2c/lt6911uxe.c
+++ b/drivers/media/i2c/lt6911uxe.c
@@ -600,7 +600,7 @@ static int lt6911uxe_probe(struct i2c_cl
 
 	v4l2_i2c_subdev_init(&lt6911uxe->sd, client, &lt6911uxe_subdev_ops);
 
-	lt6911uxe->reset_gpio = devm_gpiod_get(dev, "reset", GPIOD_IN);
+	lt6911uxe->reset_gpio = devm_gpiod_get(dev, "reset", GPIOD_OUT_LOW);
 	if (IS_ERR(lt6911uxe->reset_gpio))
 		return dev_err_probe(dev, PTR_ERR(lt6911uxe->reset_gpio),
 				     "failed to get reset gpio\n");


