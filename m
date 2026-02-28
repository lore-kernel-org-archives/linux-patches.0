Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E6147CC82;
	Sat, 28 Feb 2026 17:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301330; cv=none; b=R7zilNUMQiGyujCpvGUO1SUHqTKI2JXDD31IdYpuOhQaE5NAPQG/0mpftNSli5CGzHRThPnh1Pb7elRkdXSxXhlxj0a0SLxCRQn4f2A2loNBerdYCxJpMilrmhlRkV3PhEIFyz0KtVPzlAWKBNc5GLWtq3tYWVM26hwjNZSqyAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301330; c=relaxed/simple;
	bh=K8cH+cxgDcq/8J4Ln1pD0oHJgmCFDSwmvVWXHw6E38U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ipM3HkDD8vAmiVBD06NFUOT/YTmGxUqIRZAsxmImjErA1wIHhoW1mIlTMCGHPtpPd7mXsr1a7lnoWBWvLtntmFNl5oO90Sp47W0VAis+Y5Ar3c+RSGZbGuBsyiA8zPp74my91sPspYEShKAdm+2NznG06T+bYI1784rSPwdZlwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SQVtB55B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SQVtB55B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E640C116D0;
	Sat, 28 Feb 2026 17:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301330;
	bh=K8cH+cxgDcq/8J4Ln1pD0oHJgmCFDSwmvVWXHw6E38U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SQVtB55BJG5SuKcwo1YsA3VqVnAFj4n9MsaO6yJhrnGUAJRf69p9tDxL99hHjm6dI
	 8E41kAAog0vZkYBTEXngj+8gQKEfuT9u4YIVBex5I8ltniQ+fO+ZAN/hwdi+sLIWiu
	 ca/Xqse6cnu1tFvnCqd5tCs/kK+BRORKdYYPWQJX5srZWQblFZVIuELjhCyHisp9D7
	 LhTS8IWCWPCo34k8soxWyYMWzmPaWTzoGvOw3PIssCMjEXxB39K1CkD+Cm04XhHNEr
	 oCFaj6VnWNr3bCVNQzNJqXbkUR7I3NJP4u8dbm0GzFbPu/YTZz82kjdbQhbfNUdqwS
	 HRtO7zFfzqKjQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Hans de Goede <hansg@kernel.org>,
	stable@vger.kernel.org,
	Mehdi Djait <mehdi.djait@linux.intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 517/752] media: i2c: ov01a10: Fix reported pixel-rate value
Date: Sat, 28 Feb 2026 12:43:48 -0500
Message-ID: <20260228174750.1542406-517-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Hans de Goede <hansg@kernel.org>

[ Upstream commit 9c632eebf6af4cb7b0f85503fe1ebc5176ff0db1 ]

CSI lanes are double-clocked so with a single lane at 400MHZ the resulting
pixel-rate for 10-bits pixels is 400 MHz * 2 / 10 = 80 MHz, not 40 MHz.

This also matches with the observed frame-rate of 60 fps with the default
vblank setting: 80000000 / (1488 * 896) = 60.

Fixes: 0827b58dabff ("media: i2c: add ov01a10 image sensor driver")
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hansg@kernel.org>
Tested-by: Mehdi Djait <mehdi.djait@linux.intel.com> # Dell XPS 9315
Reviewed-by: Mehdi Djait <mehdi.djait@linux.intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov01a10.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov01a10.c b/drivers/media/i2c/ov01a10.c
index e5df01f979781..0b1a1ecfffd0e 100644
--- a/drivers/media/i2c/ov01a10.c
+++ b/drivers/media/i2c/ov01a10.c
@@ -16,7 +16,7 @@
 #include <media/v4l2-fwnode.h>
 
 #define OV01A10_LINK_FREQ_400MHZ	400000000ULL
-#define OV01A10_SCLK			40000000LL
+#define OV01A10_SCLK			80000000LL
 #define OV01A10_DATA_LANES		1
 
 #define OV01A10_REG_CHIP_ID		0x300a
-- 
2.51.0

