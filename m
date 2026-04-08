Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A688B67E;
	Wed,  8 Apr 2026 18:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672675; cv=none; b=DsbuHuQLpZMH6vdX9FohJXsOuWCvCp2/P67PQ84hlchK5V1jBaAy+btgcBU1mK/5BHDOimjVLpjDo1n7/bhx74LIilqF6RFiYkMcLdGjr/SoilsBMVLrFT6wfbNpjknjy/myLhQ0AdDkmc4Y5BjGsksXpBPKxE6ex3yEujgzPtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672675; c=relaxed/simple;
	bh=mBCEGNLsyrmQKzzNsMBBefdnIb9jutOxw0yacxAo1xY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nF7ZZT8ROqJa6o/h6pwRpA9QvJpkcUHC1LHdX1p/OOUFzr3O4Qit77xbzZ5b8dNA2jkw6Cx5TpQMKyDXmxJXXyQ7/95egEcGvJ1zjfpQpO31qnic5MpLJba6iGEseoyAQVeoATk6Zepj3YCMmY1iMc4G9NlEBMAIgfgSRLvG2k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t3YANRCQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t3YANRCQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94F8AC19421;
	Wed,  8 Apr 2026 18:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672674;
	bh=mBCEGNLsyrmQKzzNsMBBefdnIb9jutOxw0yacxAo1xY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t3YANRCQQ6XILRfe+QIeN0VjZBxt3KBjxplV70YCt1W0tGW14bDGkNOoMCnTd5liK
	 jm6Heneifb2N3rMsKk73yA//ZAHkjpwh4t7SxBSYtOnyg/NaWnMY90r8hO1/ZuFCN6
	 PfncEltL21XpEDYXmpqChc9mmhytp+emYJAiSJoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 065/160] iio: imu: bno055: fix BNO055_SCAN_CH_COUNT off by one
Date: Wed,  8 Apr 2026 20:02:32 +0200
Message-ID: <20260408175915.632207212@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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

From: David Lechner <dlechner@baylibre.com>

[ Upstream commit 773ef9f95385bae52dcb7fd129fefba3a71a04db ]

Fix an off-by-one error in the BNO055_SCAN_CH_COUNT macro. The count
is derived by taking the difference of the last and first register
addresses, dividing by the size of each channel (2 bytes). It needs to
also add 1 to account for the fact that the count is inclusive of both
the first and last channels.

Thanks to the aligned_s64 timestamp field, there was already extra
padding in the buffer, so there were no runtime issues caused by this
bug.

Fixes: 4aefe1c2bd0c ("iio: imu: add Bosch Sensortec BNO055 core driver")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/bno055/bno055.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/imu/bno055/bno055.c b/drivers/iio/imu/bno055/bno055.c
index 98f17c29da69b..7b58b418b8a8b 100644
--- a/drivers/iio/imu/bno055/bno055.c
+++ b/drivers/iio/imu/bno055/bno055.c
@@ -64,7 +64,7 @@
 #define BNO055_GRAVITY_DATA_X_LSB_REG	0x2E
 #define BNO055_GRAVITY_DATA_Y_LSB_REG	0x30
 #define BNO055_GRAVITY_DATA_Z_LSB_REG	0x32
-#define BNO055_SCAN_CH_COUNT ((BNO055_GRAVITY_DATA_Z_LSB_REG - BNO055_ACC_DATA_X_LSB_REG) / 2)
+#define BNO055_SCAN_CH_COUNT ((BNO055_GRAVITY_DATA_Z_LSB_REG - BNO055_ACC_DATA_X_LSB_REG) / 2 + 1)
 #define BNO055_TEMP_REG			0x34
 #define BNO055_CALIB_STAT_REG		0x35
 #define BNO055_CALIB_STAT_MAGN_SHIFT 0
-- 
2.53.0



