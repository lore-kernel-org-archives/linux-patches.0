Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA7537C10F;
	Wed,  8 Apr 2026 18:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672152; cv=none; b=NvUD+Wmt5+Az1Y9yiO31U9nL8HTNeSP7AS4+Vbh1sbhavdgpKB3hI5cZb6L1QPQngDGEwOCpNZ4RltXlDE/05VJtPCAhzSm8z+SLhg7dCibfNBmXCK8fSHPDuwUmphh9PK7j4amic07E7BC7x8yy26FfHRzlJxszRNkhA2+UmPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672152; c=relaxed/simple;
	bh=769dEdSdeUAf9bic1/HaKQBzDu4tcfsTK8I2xp/t67o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t9dLJwzxhWhk69cy3663717ICudCKDkIWWjYLVHJsTghZ1OFatTI7RTsRRmqKYn0Y+HHuCDGc4YtzHti5UeLzXKJp4YDNzvb+S71eqsaBspAoRVxImaGbitqN4J7LXj4op+rjwSWjgexr3gxoDPVx/scR7VmsvDWzEAbk7kIL7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hsLHQIQG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hsLHQIQG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C125C19421;
	Wed,  8 Apr 2026 18:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672152;
	bh=769dEdSdeUAf9bic1/HaKQBzDu4tcfsTK8I2xp/t67o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hsLHQIQG9KdvLQqYEXjR/YX7CJXYlucD8oJJnRCGaMwt0nfS29oQu5MVzK47X5dGS
	 vZE3lpQjtQCpgEkr+JyvaBq0f4Fmg92b60NhwKT+alH8o3vz01QPkDnK/q4UCJPnHV
	 9BAP1F5ulFDGjMpM0djZe7F7bqMzlTrIYDnyRgfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 192/312] iio: imu: bno055: fix BNO055_SCAN_CH_COUNT off by one
Date: Wed,  8 Apr 2026 20:01:49 +0200
Message-ID: <20260408175940.930205563@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



