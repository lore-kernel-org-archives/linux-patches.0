Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1370C309F09;
	Mon, 13 Apr 2026 16:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097574; cv=none; b=RCmXdE9nkjv5xzBe/VCIhTzBb0gBlclUMUezrLgg6E4CXkiVDeY4OHBwtt2HI9GSFDIdqmgOpXKaqmRjeEhbkxb5StnHiVdwrFyIgsCUJG6psdHedVSYarHTpIQ1KM9xwN6UhqccKG7e3/hS8K0NTiNTTM9/aZrYr7mKEGZxKuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097574; c=relaxed/simple;
	bh=slQLGL6cOu4fcuhefxU1VLh3HblUdtatjlpSdk/Cc/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WaEZ0Yj7OoZ6zSROzeDX0TsTPTM/R9n3Zf6rvt3PKgyFW7WbC6oS3yPkYTWYsG8SwKVCZSW77FLl7N73OTI6/3r98f2c9zta8ONL+EO0oUsyiIP5osokCmMsOvgO3lIn7xfaXcFSyKLAyAmUHIHl7lzliwAL0ieTM9kUHBtm2/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ko9vn11E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ko9vn11E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A50AC2BCB0;
	Mon, 13 Apr 2026 16:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097574;
	bh=slQLGL6cOu4fcuhefxU1VLh3HblUdtatjlpSdk/Cc/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ko9vn11E4X7GSL+2McnRepSA2dRtCMgMINBGhE3Hoh6CxZTRnMn2rXwhWgfiOJ0Dz
	 z+kHi/z8JJdQCdwe8BOtL2rjTPT2dcx96omZgkRvwz/yguEEVzfnMJfF4IjGWtjpgW
	 rKR9PkP9hDgv4Uvx+GDTyfBQtR1PVAdA8HulCIXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 188/570] iio: gyro: mpu3050-i2c: fix pm_runtime error handling
Date: Mon, 13 Apr 2026 17:55:19 +0200
Message-ID: <20260413155837.502392040@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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


