Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482861DEFD9;
	Wed, 19 Feb 2025 09:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956480; cv=none; b=BJqGQET2z/1H/YzBR7LLn2wYS1NaVE0OHrjc8S6vGT23QqO6pSaKzsAuRh1de30Nh60/HgWjoaPQfzAXyn12M8lnsK8V0fp7dhiCwrhAPz2m13+pfn/aacHv0RqKFMOGV6l5JHOoa+NQf9AzOezvU6pEDH48sSIN5QHfwGQ3OOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956480; c=relaxed/simple;
	bh=Zx5hRYVOM9uLT/4EJEVBbkA06oeBL7TemACmkyy+2Us=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FRbo5au+o+JLUNehd/Yu7dWTh5PvrRq0EgfeIIY55DkNJjxvstqypP3YTDLVg1DF0WthIVjeQXBwVm3eW+C4cgxBleHK+0RJOFFxn8GsICnqGinKn10MMiKP3MqGT1LOcdZnYEZ+qb5Z2hPdea3lX+tBREuVemaVGDinhkFMmIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YHBSfmu0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YHBSfmu0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B84B9C4CEE7;
	Wed, 19 Feb 2025 09:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956480;
	bh=Zx5hRYVOM9uLT/4EJEVBbkA06oeBL7TemACmkyy+2Us=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YHBSfmu0QSpzbjuWchad/R0ewbbkBs4iziP07CA6h/SkYLF5h91BUJ4yApj4oCzIr
	 DQzMU/icu3SiWH3AHTV7z+O5yuQU9WgC/yeq0mQOK6hTO9372eNuAwMBLtOR4E9yf7
	 nkRg1TLfe8sjKlshyfgq5UWQ1rwMIEqOCFbeHCf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Kieran Bingham <kieran.bingham@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 193/578] media: i2c: ov9282: Correct the exposure offset
Date: Wed, 19 Feb 2025 09:23:17 +0100
Message-ID: <20250219082700.554196276@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index df144a2f6eda3..0ba4edd24d64b 100644
--- a/drivers/media/i2c/ov9282.c
+++ b/drivers/media/i2c/ov9282.c
@@ -31,7 +31,7 @@
 /* Exposure control */
 #define OV9282_REG_EXPOSURE	0x3500
 #define OV9282_EXPOSURE_MIN	1
-#define OV9282_EXPOSURE_OFFSET	12
+#define OV9282_EXPOSURE_OFFSET	25
 #define OV9282_EXPOSURE_STEP	1
 #define OV9282_EXPOSURE_DEFAULT	0x0282
 
-- 
2.39.5



