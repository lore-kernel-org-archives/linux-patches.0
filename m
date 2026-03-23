Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69F82737EE;
	Mon, 23 Mar 2026 15:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278606; cv=none; b=ZHuLF9dR61GIyIBXNzkdFc9Pdqus1h5zPp2DqkW4U3r+e8FrlW7G1Ci2AKO3P0xq4UaB3pouNNsvPai3ysCCxW5Cra2Np+S+jp3cnjimS5jRV0aXECoV9uARyVkFg3TyyB4UM5hxBrNPpsohLAFeb7TEqVfzIg9d1x2Cfs3qpbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278606; c=relaxed/simple;
	bh=50UrZfLWSa3EROokJosWDTpasI6680TKddwuyDZ2TWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gTYJL+dmANT7YrVinVn/0WGemiUYN5PXP4Oxasa/WNHifQ0HbWpxyJfzdHz2z71ur73jrb8Aeadr1sqLOr8AOmpYUqpRhVxIvaSoBxuNTzoQgl44LKaASuABCHrtV8zRWeLHV/SmZ0WDgs4qN8pbQesVtOJKrlk3sLdhSvYtmTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t4zGBLkc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t4zGBLkc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A2D8C4CEF7;
	Mon, 23 Mar 2026 15:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278606;
	bh=50UrZfLWSa3EROokJosWDTpasI6680TKddwuyDZ2TWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t4zGBLkcnVe9hbVoZI9gR157vqO6m5k6IiobO7eoYCJI7Z6T38GsMgMQvtkAxsZqp
	 05Op92jq5dv+srb2r3DGh0qlG/KijwMUUIXOAa3MGXsHLSZT/9ALsQDIJRr07H8DQk
	 IyM7/ywdSm8dPusy20POTUTgEybs2C82J56FpibI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 360/567] iio: gyro: mpu3050-i2c: fix pm_runtime error handling
Date: Mon, 23 Mar 2026 14:44:40 +0100
Message-ID: <20260323134542.735924501@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antoniu Miclaus <antoniu.miclaus@analog.com>

commit 91f950b4cbb1aa9ea4eb3999f1463e8044b717fb upstream.

The return value of pm_runtime_get_sync() is not checked, and the
function always returns success. This allows I2C mux operations to
proceed even when the device fails to resume.

Use pm_runtime_resume_and_get() and propagate its return value to
properly handle resume failures.

Fixes: 3904b28efb2c ("iio: gyro: Add driver for the MPU-3050 gyroscope")
Signed-off-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/gyro/mpu3050-i2c.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/iio/gyro/mpu3050-i2c.c
+++ b/drivers/iio/gyro/mpu3050-i2c.c
@@ -19,8 +19,7 @@ static int mpu3050_i2c_bypass_select(str
 	struct mpu3050 *mpu3050 = i2c_mux_priv(mux);
 
 	/* Just power up the device, that is all that is needed */
-	pm_runtime_get_sync(mpu3050->dev);
-	return 0;
+	return pm_runtime_resume_and_get(mpu3050->dev);
 }
 
 static int mpu3050_i2c_bypass_deselect(struct i2c_mux_core *mux, u32 chan_id)


