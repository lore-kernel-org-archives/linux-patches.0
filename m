Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3400D253F23;
	Thu, 17 Apr 2025 18:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913187; cv=none; b=g1L5AzPBZ5QuQ6hrQuHLhbTJqp67eqS9ePqSz4evxfRwUmDZNQg81GmODu5yZW9K1oQuB4zlF2Xlwk8MWYn/FowSUH/NuFa+xWwUDfV7ddaOxz/zMN3+/Rg68DrhwDjzhpDEk25s1TePQxh23KxfnCRbrog2W1KYj6NrJtBBXuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913187; c=relaxed/simple;
	bh=g6jFFIIPPJ2ZfsYq4rGZrKk+9e/kppYuqrCqCVsL7B4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C4fKMAO0yi/nd2GRwwYnJ3Z0msZgdrcFwiYxu9xw+cXd2Vd7qNWuroNmfFIakHAlc3p8qi76NnMa1561OpO+DF2MfyJZQsaxsMmCK/NsKDbkLy+OkXbj66QKu5bLYDyHS4jYRKB81EANJJ6CHuQZHgANVVfCRfAnM54AnLkD//A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KZ6lZtPJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KZ6lZtPJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1186C4CEE4;
	Thu, 17 Apr 2025 18:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913187;
	bh=g6jFFIIPPJ2ZfsYq4rGZrKk+9e/kppYuqrCqCVsL7B4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KZ6lZtPJqc1RZSCKvBDdUKUoGdDdvyh6yDZubynOQCBjWo7fBdCOl7/H05pUghxjn
	 McLdptiKtB2dTnz5y1R1FKwcBawhOMkAMCPROG9z0gdmljVsBOhRK0nBKF8FigA81c
	 OGk5mTynExbk5a8PdS5AQZ3x3Ha7Zg10ur6RCz0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.14 255/449] media: i2c: ov7251: Introduce 1 ms delay between regulators and en GPIO
Date: Thu, 17 Apr 2025 19:49:03 +0200
Message-ID: <20250417175128.258912427@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -922,6 +922,8 @@ static int ov7251_set_power_on(struct de
 		return ret;
 	}
 
+	usleep_range(1000, 1100);
+
 	gpiod_set_value_cansleep(ov7251->enable_gpio, 1);
 
 	/* wait at least 65536 external clock cycles */


