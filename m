Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E2C221719;
	Tue, 29 Apr 2025 17:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948666; cv=none; b=m6HVP9PSAAWpLdZZ7d2dTTC9sKJMVtyRcGgk8uHn5/8gaPZ8yI2QXfwC5m+GYU9smeR0xRvb0cpUoKiNQ78W8adGcGxKP0o3h2E9Fa3ygLN9fNOivigVyVtJquaXt2NoVecmlgfFX5K0+tcaFfN7/66yf1cq8GZMaybtNjLQOh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948666; c=relaxed/simple;
	bh=BdaT+hvFSX+0+PZHSpV9WQpHsJKX4YphtuNFXJ+lnz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZWFnfJfm6nhN11hiTmP+y4OVCWhXn6cxbCrT0wocrb3hUdjv638J9weJDuGnfM81kIExzra4jbE/aGM4W37ki0Yw4TenE3j5s/ZB5KH5al/Dx4ZlEB6OIPYmrEiPOn0tW8QC2wdJiyzDidgKySvbeKkSpnY7GukRYmYXCylaP2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bozp8UHw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bozp8UHw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0569DC4CEE3;
	Tue, 29 Apr 2025 17:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948666;
	bh=BdaT+hvFSX+0+PZHSpV9WQpHsJKX4YphtuNFXJ+lnz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bozp8UHwj/n80fMWFeufC9wKi/flRv6AH2ExWZXtUh64VvZ/JgbBYyPUPSlJOd/u0
	 DXwYBY8FJuTd2ISyDyEawxqoVL/+ctd4GnAmWLVYOArX4JYvPMejccahDi/d+UTSeN
	 VGI7CJAW5zRYESUQ3QA7/3BerHJ5377nXoktq6gk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 5.15 075/373] media: i2c: ov7251: Introduce 1 ms delay between regulators and en GPIO
Date: Tue, 29 Apr 2025 18:39:12 +0200
Message-ID: <20250429161126.236786758@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


