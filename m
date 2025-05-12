Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C702D1519B8;
	Mon, 12 May 2025 18:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072882; cv=none; b=PpnHeiT2ajLYHvy8ymYlwn0XALl618z2GLM72KgRBMNnElFqtNHjhQujSoH+twd9h4tukE7WK2zsjhBXwMlCfBVuet7WWdll5Mf4dEzw9/u0d4VtxXSH/6OhRDisCQ7A8QpZwZ28GNeuZ5ov/05MqrOLMkJAomnIR9CrojREKy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072882; c=relaxed/simple;
	bh=392aqt7fZtcPJlZxZgXfWfHiGntu9x9YUjGYFjATlyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WvPdHkgg2PR2n7E1v63NmEsHVojbolcXG/dQj6P7Th7vVROBsNQcP4oHTczbrNvNsaaB1TYP7EtO+LQkK3a0LfJklUfCORPL3l8d15abKs9tR7mW0mlo/TTuESwFFwl+2xUyZG1Q19CmKa7dBjoy57ecCyUQeSE/Ahl3APSJlOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SjqeXw/P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SjqeXw/P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD82C4CEE7;
	Mon, 12 May 2025 18:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072882;
	bh=392aqt7fZtcPJlZxZgXfWfHiGntu9x9YUjGYFjATlyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SjqeXw/PtN2mBXlurLgItK4sNPecFZ/ffmN2+XtqcAg2XzLK92GQs1WNUuSRpM/kr
	 M3OIvUeIKDN1cWbNX4rLerJrGqPvFNv/YI9eqgamIUrtVguakt6548tCtZ6LBZtIXF
	 5eDT1Yi9dMwxDvWGU5VR4oJmuxMWBYNP8lM/rB2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 085/184] iio: imu: inv_mpu6050: align buffer for timestamp
Date: Mon, 12 May 2025 19:44:46 +0200
Message-ID: <20250512172045.285145461@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

commit 1d2d8524eaffc4d9a116213520d2c650e07c9cc6 upstream.

Align the buffer used with iio_push_to_buffers_with_timestamp() to
ensure the s64 timestamp is aligned to 8 bytes.

Fixes: 0829edc43e0a ("iio: imu: inv_mpu6050: read the full fifo when processing data")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20250417-iio-more-timestamp-alignment-v1-7-eafac1e22318@baylibre.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c
@@ -50,7 +50,7 @@ irqreturn_t inv_mpu6050_read_fifo(int ir
 	u16 fifo_count;
 	u32 fifo_period;
 	s64 timestamp;
-	u8 data[INV_MPU6050_OUTPUT_DATA_SIZE];
+	u8 data[INV_MPU6050_OUTPUT_DATA_SIZE] __aligned(8);
 	size_t i, nb;
 
 	mutex_lock(&st->lock);


