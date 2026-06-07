Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4D0327204;
	Sun,  7 Jun 2026 10:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827835; cv=none; b=BBYCWGbFfGiOhLAj5N6cBlA5NvaQoO9y/6+WHc+hNW3hAPeVBdr7pRAnhZM7USXp56z4REEu/l6UO/sKk/KIyzltLMFLZMKsS4tznSqESeA6XbgKX4xyq2DrHyPtI3w96pjmHt6wcdGLBKddNXiFSJqZRoGZzkgsEQpMHHeAPZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827835; c=relaxed/simple;
	bh=KbPjsHP8481LMbvM7BEoaPMU6KmV7EOLW+PD//I0hmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eRsEF1XpO/lVIZEZRjAqkAXFyvanzx+Tk1XT3toTFZIHVzdHFGyFVH1Ff+mxyBLxgLP+DYjEwxbwlf9AoEwr3Hov1SMe/y/zK9nLtCa/ys1UpAe2FNz16D1QD/DJO3fPJAv7+WibuC3iZQohBYEX0/tnEJ9+86uWxPKXTO4mlGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YBlpA7A7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YBlpA7A7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD3471F00893;
	Sun,  7 Jun 2026 10:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827833;
	bh=+hNm0TFvhTWQEqQn2Yzhs5wBstx2mVlq5ztSpxFbtJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YBlpA7A7wYksEvVHVo+ZWuVpgR8Ii5G90BOPvkmpY8YuOBsn7sfAUbsOEhmm3/NYQ
	 87IhEubrLCHDOHH1azyZK6Mxdj0ewtEVzrpu31m9oRFBcQ2BmdwagvlQlqb/iaqmm+
	 JF1XSIiXMD9VD/xvj9OqjBKP0onAUugjUsq/ErU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jonathan Cameron <jic23@kernel.org>,
	David Lechner <dlechner@baylibre.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Andy Shevchenko <andy@kernel.org>,
	stable <stable@kernel.org>
Subject: [PATCH 6.18 104/315] iio: imu: st_lsm6dsx: fix stack leak in tagged FIFO buffer
Date: Sun,  7 Jun 2026 11:58:11 +0200
Message-ID: <20260607095731.465292206@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit c9d8e9adaa63150ef7e833480b799d0bab83a276 upstream.

The tagged FIFO path declares iio_buff on the stack with __aligned(8)
but no initializer, but there is a hole in the structure, which will
then leak to userspace as ST_LSM6DSX_SAMPLE_SIZE bytes (6) will be
copied, but the space between that and the timestamp are not
initialized.

Commit c14edb4d0bdc ("iio:imu:st_lsm6dsx Fix alignment and data leak
issues") moved the untagged FIFO path to a kzalloc'd buffer in hw->scan,
but for the tagged path it only added the alignment qualifier and not
the initializer :(

Fix this by just zero-initializing the structure on the stack.

Cc: Lorenzo Bianconi <lorenzo@kernel.org>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: David Lechner <dlechner@baylibre.com>
Cc: "Nuno Sá" <nuno.sa@analog.com>
Cc: Andy Shevchenko <andy@kernel.org>
Fixes: c14edb4d0bdc ("iio:imu:st_lsm6dsx Fix alignment and data leak issues")
Cc: stable <stable@kernel.org>
Assisted-by: gregkh_clanker_t1000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
@@ -608,7 +608,7 @@ int st_lsm6dsx_read_tagged_fifo(struct s
 	 * must be passed a buffer that is aligned to 8 bytes so
 	 * as to allow insertion of a naturally aligned timestamp.
 	 */
-	u8 iio_buff[ST_LSM6DSX_IIO_BUFF_SIZE] __aligned(8);
+	u8 iio_buff[ST_LSM6DSX_IIO_BUFF_SIZE] __aligned(8) = { };
 	u8 tag;
 	bool reset_ts = false;
 	int i, err, read_len;


