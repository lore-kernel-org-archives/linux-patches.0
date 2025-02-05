Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE12522A;
	Wed,  5 Feb 2025 14:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765655; cv=none; b=fU/QbwXuE8a6Ka8REyfOOW6dsZ6BVSZoVvG0EFmPOvoyS6sfyLYoAPyWv3SAmvonwEguMzLmxniMW/sdYEEldLZYQ1A5s+z4rZ4gNYfyO85PciSjH5/vhXD++PEvb6ks5/XIBJhzj0Gqgauq/DrRtDKcqeT30EdsCYnlMdraAiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765655; c=relaxed/simple;
	bh=WQw1xJw3mjdDJwzUYvuT+8NumQLHgjhCr6Ro9/3+KFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J9BT/FNTImtw645mlt7Nq1su6RDMgyrZZa73PIIkw6zCu7tjWDwfWp2hXQPrUkIHRANn1CPRw4px8wHMNbbosDBZ0rcNpMAVYlqSw6lPowOFVgHpT6pVWzs6SQfltzveP2tcsidC3M6LZVyHb9WsR2TTdz8OhWBBlLwuK0erWug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A0ebql9z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A0ebql9z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6C7FC4CED1;
	Wed,  5 Feb 2025 14:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765655;
	bh=WQw1xJw3mjdDJwzUYvuT+8NumQLHgjhCr6Ro9/3+KFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A0ebql9zYnBmizbs0rFynAfEoDnYLLsHDkqZDfjsRFOBPnOgQcWBL5kYK8WrwRsXH
	 zJJjA92cNX7Ctr7/DeQQPX6QAcDSYtgxAYOzYjk178gwgP9iWmWcOT5uw8djghIn3h
	 8ve/tNnqqyxHcnu/n4JH1CyaoucNpdrYRSHHdcBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Kieran Bingham <kieran.bingham@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 287/393] media: i2c: ov9282: Correct the exposure offset
Date: Wed,  5 Feb 2025 14:43:26 +0100
Message-ID: <20250205134431.294220603@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

[ Upstream commit feaf4154d69657af2bf96e6e66cca794f88b1a61 ]

The datasheet lists that "Maximum exposure time is frame
length -25 row periods, where frame length is set by
registers {0x380E, 0x380F}".
However this driver had OV9282_EXPOSURE_OFFSET set to 12
which allowed that restriction to be violated, and would
result in very under-exposed images.

Correct the offset.

Fixes: 14ea315bbeb7 ("media: i2c: Add ov9282 camera sensor driver")
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Reviewed-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov9282.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov9282.c b/drivers/media/i2c/ov9282.c
index 068c7449f50ed..7498f55b3ef2b 100644
--- a/drivers/media/i2c/ov9282.c
+++ b/drivers/media/i2c/ov9282.c
@@ -40,7 +40,7 @@
 /* Exposure control */
 #define OV9282_REG_EXPOSURE	0x3500
 #define OV9282_EXPOSURE_MIN	1
-#define OV9282_EXPOSURE_OFFSET	12
+#define OV9282_EXPOSURE_OFFSET	25
 #define OV9282_EXPOSURE_STEP	1
 #define OV9282_EXPOSURE_DEFAULT	0x0282
 
-- 
2.39.5



