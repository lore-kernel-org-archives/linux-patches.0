Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5009C24113C;
	Tue, 29 Apr 2025 16:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945316; cv=none; b=dNBQ82rMJpZFIVoWa7hXefaulZY0yBWlWd6YU6OuqbHJIC/w2bLeYbYK/8VqmbYqy7iSEAg6vil9PR6rkSdTHggmNlsTmINCvf2OOpGK1uaB66L0E+UTuwKSrcJA+IcRM+keqYpJOTyKN9axHkIm8RaJgD0N1nwsMlw2U1+8auU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945316; c=relaxed/simple;
	bh=KyGmg8+6APYLqAlQRowjJsAFhv2tn3lxSk+7vct7xQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bVVawTcuJ30C6wTsT7xmFUgPhFPQ/EWV1qYhTXmgGpMRlfuxrJbAvFJPGlE5Syve5EefurI5R4IcD5qWH3c6uzxizJ4KgpcyidoQVPgkbbkFdQw0cIsVJjg6UEEesqB5LvBDzUqFu2LKix86+FdypYmBy6cofwN3qQIcGkyyD2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0N6ukxW9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0N6ukxW9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CC46C4CEE3;
	Tue, 29 Apr 2025 16:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945315;
	bh=KyGmg8+6APYLqAlQRowjJsAFhv2tn3lxSk+7vct7xQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0N6ukxW9cEI+1LkMbCy960MC+Daf7aJxevkHt6nrAYn59iMDRJlQWsjhog32xkMPh
	 Fw6VH+HQ65D5yEXqd6o8sL3OGs+la95Dy3LjLV7MU99kXQUqjDK8e0zWEyrkII0zFL
	 mDb28n+vqH2/wSKuN+nGNofVicUUaUVvXDdBpqrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 5.4 054/179] media: i2c: ov7251: Introduce 1 ms delay between regulators and en GPIO
Date: Tue, 29 Apr 2025 18:39:55 +0200
Message-ID: <20250429161051.583572585@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit 3d391292cdd53984ec1b9a1f6182a62a62751e03 upstream.

Lift the xshutdown (enable) GPIO 1 ms after enabling the regulators, as
required by the sensor's power-up sequence.

Fixes: d30bb512da3d ("media: Add a driver for the ov7251 camera sensor")
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ov7251.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/i2c/ov7251.c
+++ b/drivers/media/i2c/ov7251.c
@@ -748,6 +748,8 @@ static int ov7251_set_power_on(struct ov
 		return ret;
 	}
 
+	usleep_range(1000, 1100);
+
 	gpiod_set_value_cansleep(ov7251->enable_gpio, 1);
 
 	/* wait at least 65536 external clock cycles */


