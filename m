Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B242D2C2FB2;
	Mon, 12 May 2025 18:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073347; cv=none; b=lAdtKcl6YFZNF8odfP+kpYw5sz1x61mhQRtf+1DihxQqvQogzZT/98dkz1DCUDDr6NQOzbS98m+dwHhLYOPpaQ4A5EWnxwHtndSLwDNJzGft4Hw0mMBpUJvaH3O0AaZ4xxihsMEi3hSWO8EcsUs6MArpQ/a7L/4ZEhDrdPbgcw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073347; c=relaxed/simple;
	bh=wvZk/b0K9dvf6+k+ahUOSZKKp8HF+8LFQxsEgovm8xY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RJBEUGep1ul81HEaaYwthfr7ajzxDgF7T9UT0oHMbxtTfmBDa0P9+Q+odAen/ht9FOxjHq08tDlG8wpHxG29aCvwhE+58cd5eCtedSHSUi6MM8fdF8dtuD8jdr9Va8mfjQ9gDHRC8pSQvz3u2vc4ukpVL/sh6JkP6Bbxva0AHL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uNwPKCY6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uNwPKCY6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B648AC4CEE9;
	Mon, 12 May 2025 18:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073347;
	bh=wvZk/b0K9dvf6+k+ahUOSZKKp8HF+8LFQxsEgovm8xY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uNwPKCY6IsLj+8QSMXzf9vUYT07frI5evI5CTjorawWceNzgmPFz7/czzcxBVYuOK
	 +Uqw6xiytlvq3DtVDiaJM13rDcSEml52vWVqWm0oFIiBQWEcGR8dziNexD/9Tu4BGp
	 Dqqb4J/Qnomn5nmzBZWqT21ONP1L3395bmgPHcaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Silvano Seva <s.seva@4sigma.it>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 045/113] iio: imu: st_lsm6dsx: fix possible lockup in st_lsm6dsx_read_fifo
Date: Mon, 12 May 2025 19:45:34 +0200
Message-ID: <20250512172029.499887132@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
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

From: Silvano Seva <s.seva@4sigma.it>

commit 159ca7f18129834b6f4c7eae67de48e96c752fc9 upstream.

Prevent st_lsm6dsx_read_fifo from falling in an infinite loop in case
pattern_len is equal to zero and the device FIFO is not empty.

Fixes: 290a6ce11d93 ("iio: imu: add support to lsm6dsx driver")
Signed-off-by: Silvano Seva <s.seva@4sigma.it>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20250311085030.3593-2-s.seva@4sigma.it
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
@@ -370,6 +370,9 @@ int st_lsm6dsx_read_fifo(struct st_lsm6d
 	if (fifo_status & cpu_to_le16(ST_LSM6DSX_FIFO_EMPTY_MASK))
 		return 0;
 
+	if (!pattern_len)
+		pattern_len = ST_LSM6DSX_SAMPLE_SIZE;
+
 	fifo_len = (le16_to_cpu(fifo_status) & fifo_diff_mask) *
 		   ST_LSM6DSX_CHAN_SIZE;
 	fifo_len = (fifo_len / pattern_len) * pattern_len;


