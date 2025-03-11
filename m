Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 207561DF749;
	Tue, 11 Mar 2025 15:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706890; cv=none; b=lkphQ9w608uyNIia3dxISqD9bLa8cBYiIYlkpGITTYQftjBFUhXiyHn5SZei237AKfQutBmC2O2LNgEVxR3K7WAAhVfr3ao0ZB02P4pqjkTGivg2+48ew6/qltv+XtBr73f67gngoTqrGn38gWqeFW0+9zm3ZbIWAGOCrJrvgjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706890; c=relaxed/simple;
	bh=fmzE3MRLAgEHlF0NWpTLhmF6SQxWqC8w1AeBUlAQzaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PoJRUqSNkwHC/q9/AVeQYXKZEYYH2NzNx0iz9pWGA5QkpKypVYLAtXQ6lt9s7ywPIjMuuPzU7H4FluBRq3qZLBxOWAgcByX6dQMCbJIIehqoVT8ombz+9Hal/t/9u+nj0S74+bu4z+GhxXFjeQgnLUv5Gv0Pqxq0W+GmGWLzvrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gvrTIotV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gvrTIotV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF14C4CEE9;
	Tue, 11 Mar 2025 15:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706889;
	bh=fmzE3MRLAgEHlF0NWpTLhmF6SQxWqC8w1AeBUlAQzaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gvrTIotVjUTtq2BZFYWlRAchnuJqDWshsRphBZRj7NR1XWLOBAhfFIl9SCU0aqOrP
	 akEfE/6bnJD/i9jrr5vBEKEfkXba1V5w//LC0Qrd3I6q2OsukVg47OhNpVIQYG6p+L
	 VQ6DLpjoUSkBhTndbTI+BZSQMK4U94ra1M1hhHLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Eggers <ceggers@arri.de>,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 202/462] iio: light: as73211: fix channel handling in only-color triggered buffer
Date: Tue, 11 Mar 2025 15:57:48 +0100
Message-ID: <20250311145806.336107586@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit ab09c6cfe01b317f515bcd944668697241a54b9d upstream.

The channel index is off by one unit if AS73211_SCAN_MASK_ALL is not
set (optimized path for color channel readings), and it must be shifted
instead of leaving an empty channel for the temperature when it is off.

Once the channel index is fixed, the uninitialized channel must be set
to zero to avoid pushing uninitialized data.

Add available_scan_masks for all channels and only-color channels to let
the IIO core demux and repack the enabled channels.

Cc: stable@vger.kernel.org
Fixes: 403e5586b52e ("iio: light: as73211: New driver")
Tested-by: Christian Eggers <ceggers@arri.de>
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20241214-iio_memset_scan_holes-v4-1-260b395b8ed5@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/as73211.c |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

--- a/drivers/iio/light/as73211.c
+++ b/drivers/iio/light/as73211.c
@@ -155,6 +155,12 @@ struct as73211_data {
 	BIT(AS73211_SCAN_INDEX_TEMP) | \
 	AS73211_SCAN_MASK_COLOR)
 
+static const unsigned long as73211_scan_masks[] = {
+	AS73211_SCAN_MASK_COLOR,
+	AS73211_SCAN_MASK_ALL,
+	0
+};
+
 static const struct iio_chan_spec as73211_channels[] = {
 	{
 		.type = IIO_TEMP,
@@ -603,9 +609,12 @@ static irqreturn_t as73211_trigger_handl
 
 		/* AS73211 starts reading at address 2 */
 		ret = i2c_master_recv(data->client,
-				(char *)&scan.chan[1], 3 * sizeof(scan.chan[1]));
+				(char *)&scan.chan[0], 3 * sizeof(scan.chan[0]));
 		if (ret < 0)
 			goto done;
+
+		/* Avoid pushing uninitialized data */
+		scan.chan[3] = 0;
 	}
 
 	if (data_result) {
@@ -613,9 +622,15 @@ static irqreturn_t as73211_trigger_handl
 		 * Saturate all channels (in case of overflows). Temperature channel
 		 * is not affected by overflows.
 		 */
-		scan.chan[1] = cpu_to_le16(U16_MAX);
-		scan.chan[2] = cpu_to_le16(U16_MAX);
-		scan.chan[3] = cpu_to_le16(U16_MAX);
+		if (*indio_dev->active_scan_mask == AS73211_SCAN_MASK_ALL) {
+			scan.chan[1] = cpu_to_le16(U16_MAX);
+			scan.chan[2] = cpu_to_le16(U16_MAX);
+			scan.chan[3] = cpu_to_le16(U16_MAX);
+		} else {
+			scan.chan[0] = cpu_to_le16(U16_MAX);
+			scan.chan[1] = cpu_to_le16(U16_MAX);
+			scan.chan[2] = cpu_to_le16(U16_MAX);
+		}
 	}
 
 	iio_push_to_buffers_with_timestamp(indio_dev, &scan, iio_get_time_ns(indio_dev));
@@ -685,6 +700,7 @@ static int as73211_probe(struct i2c_clie
 	indio_dev->channels = as73211_channels;
 	indio_dev->num_channels = ARRAY_SIZE(as73211_channels);
 	indio_dev->modes = INDIO_DIRECT_MODE;
+	indio_dev->available_scan_masks = as73211_scan_masks;
 
 	ret = i2c_smbus_read_byte_data(data->client, AS73211_REG_OSR);
 	if (ret < 0)


