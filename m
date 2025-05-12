Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECBD91DC1A7;
	Mon, 12 May 2025 17:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071139; cv=none; b=rOX4W2fGuw02ZoYyJ2FFpNYyHy2gsoiaus7gWsSvoyuL6htK61jA2VlRUsWUqKsTd50/8WHqSDzUo46DxSIrWGkXK4xm0h3RYpxELqH9jxtj28GRbZ8YwvC000CKGCJjgyW4UMHgaj70RvU+7wM8arm+nDmkoFGKIDtTKTu2A+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071139; c=relaxed/simple;
	bh=6ZdXF/LgQhCM3y0YQNXGzR1AS7H95NKJOgPhvqzm1xU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H6IO7u5Q34ZY0OqVVlELzOvG0vi9HJQxnDg2/DYPa6HtjhZbXuALSKB821skP2KdhVfpuqrKdC/Kk+gPkiioNOSag1z9g+RRqC7WeKpcKUQhCnuCgCxt+ueA8s9035803WMOlopZ17/YG1qGS/ngHtfoDw2iW52FcItFGA20H9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hPSXdXwU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hPSXdXwU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF11C4CEE7;
	Mon, 12 May 2025 17:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071138;
	bh=6ZdXF/LgQhCM3y0YQNXGzR1AS7H95NKJOgPhvqzm1xU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hPSXdXwUD65M4oi/qcOtzHJ7PZv6OavTJo7L/2ROqshbLiaU/V6vK+/AvV+nsZlyB
	 HRsx7ixf+kt84R98epEn8GxpC4LG3bFWmkRKrQ898cfCjClE03CexbHGxubMNis9AL
	 4qJe35dmqZVgV+sXLls67ysrQS5d9CrBiLH4Kp7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Silvano Seva <s.seva@4sigma.it>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 26/54] iio: imu: st_lsm6dsx: fix possible lockup in st_lsm6dsx_read_fifo
Date: Mon, 12 May 2025 19:29:38 +0200
Message-ID: <20250512172016.701045146@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172015.643809034@linuxfoundation.org>
References: <20250512172015.643809034@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -369,6 +369,9 @@ int st_lsm6dsx_read_fifo(struct st_lsm6d
 	if (fifo_status & cpu_to_le16(ST_LSM6DSX_FIFO_EMPTY_MASK))
 		return 0;
 
+	if (!pattern_len)
+		pattern_len = ST_LSM6DSX_SAMPLE_SIZE;
+
 	fifo_len = (le16_to_cpu(fifo_status) & fifo_diff_mask) *
 		   ST_LSM6DSX_CHAN_SIZE;
 	fifo_len = (fifo_len / pattern_len) * pattern_len;


