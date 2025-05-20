Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE4F24290D;
	Tue, 20 May 2025 14:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750025; cv=none; b=eQyyendD/Kqu+n9oQ/Sm9DY8pNDhdsBcdbVT1f/KPU5ViVUpPk0PRrfySH8cRYMyYXD9GowH5BM/DRXBL1iOclnEJ7hnqkIMeyBJLYr2JB4NfK8dwApJCYXORDhVB+9V+EiWsGa7BdWoa21iww+j6aBS2xygg3oODIze4vapYyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750025; c=relaxed/simple;
	bh=rcjC7NNA6g2kNgoAo0/BPM835rE6zYa12yk5hwuAl0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O3ffs7vfDMWdsWI2S9snNCTVLLbbaTgdmHTNbmoN2Ft25OQFoRDHe5fTcruHvJex9L1zLwJtLVeHzwn3E9LMKaZlTJYCta6pZ5g8XovRKAFgwmO2plyIPbwxgR7JuuFDFT8i7xolNN3pLpslcWmCMUpBarMDEMNOBuZEBwW/7vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HOrVkvIe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HOrVkvIe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F06C9C4CEE9;
	Tue, 20 May 2025 14:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750024;
	bh=rcjC7NNA6g2kNgoAo0/BPM835rE6zYa12yk5hwuAl0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HOrVkvIeU4ire9grcw89Az+oxYJdPVdb+ujKDwZLiRKO5RhAgOphozCPGCIDOzLk8
	 jTLuICuW0sejbCVq6OWvyJu8VPqhe52vnqWwS9Kf1NIdzQpURxFVNfL5aoTYFPspnG
	 +QMmk3E+YF/M4dmu29nXpHLKcYylEWi4xgy8q5+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 018/143] iio: pressure: mprls0025pa: use aligned_s64 for timestamp
Date: Tue, 20 May 2025 15:49:33 +0200
Message-ID: <20250520125810.776013224@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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

[ Upstream commit ffcd19e9f4cca0c8f9e23e88f968711acefbb37b ]

Follow the pattern of other drivers and use aligned_s64 for the
timestamp. This will ensure the struct itself it also 8-byte aligned.

While touching this, convert struct mpr_chan to an anonymous struct
to consolidate the code a bit to make it easier for future readers.

Fixes: 713337d9143e ("iio: pressure: Honeywell mprls0025pa pressure sensor")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20250418-iio-more-timestamp-alignment-v2-2-d6a5d2b1c9fe@baylibre.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/pressure/mprls0025pa.h | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/iio/pressure/mprls0025pa.h b/drivers/iio/pressure/mprls0025pa.h
index 9d5c30afa9d69..d62a018eaff32 100644
--- a/drivers/iio/pressure/mprls0025pa.h
+++ b/drivers/iio/pressure/mprls0025pa.h
@@ -34,16 +34,6 @@ struct iio_dev;
 struct mpr_data;
 struct mpr_ops;
 
-/**
- * struct mpr_chan
- * @pres: pressure value
- * @ts: timestamp
- */
-struct mpr_chan {
-	s32 pres;
-	s64 ts;
-};
-
 enum mpr_func_id {
 	MPR_FUNCTION_A,
 	MPR_FUNCTION_B,
@@ -69,6 +59,8 @@ enum mpr_func_id {
  *       reading in a loop until data is ready
  * @completion: handshake from irq to read
  * @chan: channel values for buffered mode
+ * @chan.pres: pressure value
+ * @chan.ts: timestamp
  * @buffer: raw conversion data
  */
 struct mpr_data {
@@ -87,7 +79,10 @@ struct mpr_data {
 	struct gpio_desc	*gpiod_reset;
 	int			irq;
 	struct completion	completion;
-	struct mpr_chan		chan;
+	struct {
+		s32 pres;
+		aligned_s64 ts;
+	} chan;
 	u8	    buffer[MPR_MEASUREMENT_RD_SIZE] __aligned(IIO_DMA_MINALIGN);
 };
 
-- 
2.39.5



