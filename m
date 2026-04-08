Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CF035CB6F;
	Wed,  8 Apr 2026 18:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673238; cv=none; b=FrBhu61tkWkzPDz/q1wduPtthlZwgz6AlijJZTqfk9IvIMU6J3gQ5OOYjpw1X5sDPTt8dpZX6tjLL1Lk+2P2ZMctmHfrpbHtbA/VzjdCwyrP8Bui4c2yntcTxPgJBvbGubN+6qG9With90gHVMUFdIFLJkMb363wXv17kBJsoV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673238; c=relaxed/simple;
	bh=MqfBAu12hiMLTn7kZ3NtdtbUEq+ym8qBhqDndslrVA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rVAs8l55/hbFHw/slB21GypPLmapSYqjoHJbZ2+QZ0TnFDBTjfdBaCNX/fUjLGO2phvwuOeI/8OkJfSgvenecIrJrpF8wDT31pmUc6f6X6B3d5QB/fbP0ULIYJZxh1qRSTZCvKfarumx52ohJsiOBxRKipYxbSTNZMogMx+jbuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S4Qecp9u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S4Qecp9u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F01C5C19421;
	Wed,  8 Apr 2026 18:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673238;
	bh=MqfBAu12hiMLTn7kZ3NtdtbUEq+ym8qBhqDndslrVA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S4Qecp9uFkiQEMJLZ8v249aGqy0kRpvwAWgH4b1wHptwZTY4SpQmD8db5vqVuj+Pc
	 ydei6UFR8OXCyEMVOlAlCXqRsOjGgEFJm6zeSv5UN6Ru5f5Gt6uXcEl7X4RwUHOLvp
	 Vst90/ITIgaLhQ5Tj1g7mbDuKbpOCv5uk2hJ1CmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <jic23@kernel.org>,
	David Lechner <dlechner@baylibre.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.18 155/277] iio: orientation: hid-sensor-rotation: add timestamp hack to not break userspace
Date: Wed,  8 Apr 2026 20:02:20 +0200
Message-ID: <20260408175939.658743562@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

commit 79a86a6cc3669416a21fef32d0767d39ba84b3aa upstream.

Add a hack to push two timestamps in the hid-sensor-rotation scan data
to avoid breaking userspace applications that depend on the timestamp
being at the incorrect location in the scan data due to unintentional
misalignment in older kernels.

When this driver was written, the timestamp was in the correct location
because of the way iio_compute_scan_bytes() was implemented at the time.
(Samples were 24 bytes each.) Then commit 883f61653069 ("iio: buffer:
align the size of scan bytes to size of the largest element") changed
the computed scan_bytes to be a different size (32 bytes), which caused
iio_push_to_buffers_with_timestamp() to place the timestamp at an
incorrect offset.

There have been long periods of time (6 years each) where the timestamp
was in either location, so to not break either case, we open-code the
timestamps to be pushed to both locations in the scan data.

Reported-by: Jonathan Cameron <jic23@kernel.org>
Closes: https://lore.kernel.org/linux-iio/20260215162351.79f40b32@jic23-huawei/
Fixes: 883f61653069 ("iio: buffer: align the size of scan bytes to size of the largest element")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/orientation/hid-sensor-rotation.c |   22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

--- a/drivers/iio/orientation/hid-sensor-rotation.c
+++ b/drivers/iio/orientation/hid-sensor-rotation.c
@@ -20,7 +20,12 @@ struct dev_rot_state {
 	struct hid_sensor_hub_attribute_info quaternion;
 	struct {
 		IIO_DECLARE_QUATERNION(s32, sampled_vals);
-		aligned_s64 timestamp;
+		/*
+		 * ABI regression avoidance: There are two copies of the same
+		 * timestamp in case of userspace depending on broken alignment
+		 * from older kernels.
+		 */
+		aligned_s64 timestamp[2];
 	} scan;
 	int scale_pre_decml;
 	int scale_post_decml;
@@ -154,8 +159,19 @@ static int dev_rot_proc_event(struct hid
 		if (!rot_state->timestamp)
 			rot_state->timestamp = iio_get_time_ns(indio_dev);
 
-		iio_push_to_buffers_with_timestamp(indio_dev, &rot_state->scan,
-						   rot_state->timestamp);
+		/*
+		 * ABI regression avoidance: IIO previously had an incorrect
+		 * implementation of iio_push_to_buffers_with_timestamp() that
+		 * put the timestamp in the last 8 bytes of the buffer, which
+		 * was incorrect according to the IIO ABI. To avoid breaking
+		 * userspace that may be depending on this broken behavior, we
+		 * put the timestamp in both the correct place [0] and the old
+		 * incorrect place [1].
+		 */
+		rot_state->scan.timestamp[0] = rot_state->timestamp;
+		rot_state->scan.timestamp[1] = rot_state->timestamp;
+
+		iio_push_to_buffers(indio_dev, &rot_state->scan);
 
 		rot_state->timestamp = 0;
 	}


