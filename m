Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F4B41F7CC;
	Thu, 16 Jul 2026 14:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210462; cv=none; b=la/SrVaiiEiie3o5jclXG8TI1UUWNtRzAC0BnTbiyc4RlCQLkCZ6Ky3cVCUwWs6U2AYqZ1khd1vjg90SP67KNXLtU124DDiFe5ULwfJ3pZGUSn29YeDt+vjY4Uj+AHQU9W3iciry0hOSRtLz4Ztp98tdmHDRxnGLNth+KmzxziE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210462; c=relaxed/simple;
	bh=VpuzV9ln3+zwtxAYj/YhtYcEoy8byrnFrMqXJq0pvII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XR7+lMkd77zX8+TIvREaBvz6XebXE91K4mXw9pv3QtGaiyLHjy4V3jnZ7QYsYTO5kKoYpSVC49P/3xveoczGOYvqjNkxKgrMH9Y0q0K00QUqrxKEsoP5mstMyV/K+iDAXddYjIpo4PhS3BPreog8Z1xqkhDElRuus0Uzqt+eHhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xTuYuEEh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xTuYuEEh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A45DA1F000E9;
	Thu, 16 Jul 2026 14:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210461;
	bh=mKRglfUve2HQ+kELQA/AKmOUP0GopwscP7/K+00wOt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xTuYuEEh7FBebY2xzFlW6K7Nv2K7mS14lP/HIFI0Ucrcl2RQyCkm78lJG2SJo2A9U
	 QlkqgKRH3/FAdJJeHCjkuiMniozai/aFccyN0m2LBv20GYhJ1B0ZIZOcqn3fIKwkJA
	 N4LKPkO+EW8CX24vnI++ZExYLb18BPnVgG+w4FQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.18 057/480] iio: adc: ti-ads1119: fix PM reference leak in buffer preenable
Date: Thu, 16 Jul 2026 15:26:44 +0200
Message-ID: <20260716133045.946076879@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit adf4bc07f814da8329278d32600147f5a150938c upstream.

ads1119_triggered_buffer_preenable() resumes the device with
pm_runtime_resume_and_get() before starting a conversion.

If i2c_smbus_write_byte() fails, the function returns the error directly
and leaves the runtime PM usage counter elevated. The matching
postdisable callback is not called when preenable fails, so the reference
is leaked and the device may remain runtime-active indefinitely.

Store the I2C transfer result in ret and drop the runtime PM reference on
failure before returning the error.

Fixes: a9306887eba41 ("iio: adc: ti-ads1119: Add driver")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ti-ads1119.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/iio/adc/ti-ads1119.c
+++ b/drivers/iio/adc/ti-ads1119.c
@@ -459,7 +459,11 @@ static int ads1119_triggered_buffer_pree
 	if (ret)
 		return ret;
 
-	return i2c_smbus_write_byte(st->client, ADS1119_CMD_START_SYNC);
+	ret = i2c_smbus_write_byte(st->client, ADS1119_CMD_START_SYNC);
+	if (ret)
+		pm_runtime_put_autosuspend(dev);
+
+	return ret;
 }
 
 static int ads1119_triggered_buffer_postdisable(struct iio_dev *indio_dev)


