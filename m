Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D53061509AC;
	Tue, 20 Feb 2024 21:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463805; cv=none; b=ZvBFFf9NzUQ4Oczw5WdkRDjWKpVXGjuUASjqCOLLnoP4R/V3nCmSUg67+rKFJbm3A85hNZCePA3CgZC80Dp4hPqSiy4yMHhZpBZIZ5uqG+uosNDQUjmnC0IkFEIJk7uc/kerUGHNKeuQ/xIA7YOObDJ+yQoHBY40FKnuYy6E+ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463805; c=relaxed/simple;
	bh=NE2bKY2rE4DTotVscZx4KYGyNTw+IgvOpgEFJIlv0DQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gOj61THUR4WM/2acd5ts99dpFFXr+D8V5nHjy0pPS1tJWfRbCwL9NcQfjB0IeEKyGu4Iuar9CzSexEunyTUM7c40QZknIQ2X/fcRprWJ9rDU+kUwDKuxxkoawZQQxShsrD4EAJYa0NyMQoJS1epg8KUX6TvUkEnR4/6CS6OIp7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yvFOiF8Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yvFOiF8Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CA9EC43394;
	Tue, 20 Feb 2024 21:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463805;
	bh=NE2bKY2rE4DTotVscZx4KYGyNTw+IgvOpgEFJIlv0DQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yvFOiF8ZiDqBJLoOqLDxCFljtsxemFVxRsHMj1KTNmyv7ljbrTzPSBplGKHa56kQx
	 AgKH1ZmcK/gIsKTQxJEbRAtjjGkKh58yLu4c8fiN5kp6MAbrefd9//sPZfoJ3NtvyF
	 DAIyPEdY2g3CTykpJGYpXt0VZwiz1HOJz6favJ1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 159/331] iio: accel: bma400: Fix a compilation problem
Date: Tue, 20 Feb 2024 21:54:35 +0100
Message-ID: <20240220205642.535710195@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Mario Limonciello <mario.limonciello@amd.com>

commit 4cb81840d8f29b66d9d05c6d7f360c9560f7e2f4 upstream.

The kernel fails when compiling without `CONFIG_REGMAP_I2C` but with
`CONFIG_BMA400`.
```
ld: drivers/iio/accel/bma400_i2c.o: in function `bma400_i2c_probe':
bma400_i2c.c:(.text+0x23): undefined reference to `__devm_regmap_init_i2c'
```

Link: https://download.01.org/0day-ci/archive/20240131/202401311634.FE5CBVwe-lkp@intel.com/config
Fixes: 465c811f1f20 ("iio: accel: Add driver for the BMA400")
Fixes: 9bea10642396 ("iio: accel: bma400: add support for bma400 spi")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20240131225246.14169-1-mario.limonciello@amd.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/accel/Kconfig
+++ b/drivers/iio/accel/Kconfig
@@ -219,10 +219,12 @@ config BMA400
 
 config BMA400_I2C
 	tristate
+	select REGMAP_I2C
 	depends on BMA400
 
 config BMA400_SPI
 	tristate
+	select REGMAP_SPI
 	depends on BMA400
 
 config BMC150_ACCEL


