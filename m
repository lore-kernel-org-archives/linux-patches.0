Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4F81DF72E;
	Mon, 12 May 2025 17:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072030; cv=none; b=dVM4KuObrVALJriroZNWZB1pwTsbcpNJTSCPi9R2A7dlwzrcvWXJBN1m1HKOV+R01bw6ZNv2LfXwyOSDphcsF3L4Sf8HakOsUSzqQNMJNPKAo0++cfN8N9jsVavh87h4NJ0teKy0w9+nOU8nC97tbYDru1emDpC9RbG7Knoa9pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072030; c=relaxed/simple;
	bh=+mACTxlWBxU3IECAl2kg3xeDNAu4exN/3DwU76KiDNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hHM0yXlm9dibwTmvkj9uHDxQV2mpfqqFJIeS1F7Xu2zqdKdWNR0FP+5DHP9NQw2b/nVG4z8mUULzNxMECmAIPreZam+h9kawUrkWw2r+XBkmWkiXwYA2kPrFDvt9LqHtJNKpcJuME4P6r4jv4DUgja8cvjEwARxr6TrlCY9+Qd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IvVklzzG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IvVklzzG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA185C4CEE7;
	Mon, 12 May 2025 17:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072030;
	bh=+mACTxlWBxU3IECAl2kg3xeDNAu4exN/3DwU76KiDNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IvVklzzGByILLD355a9CSJyZUnKDIkv7tqo+0QiozWLQnA1Vh2jeOZgK8eXrd1fS3
	 FSkAgAQk8gZiubXOE+1c0jOPYHb3rG0gNXdRQwOdvYRtJzelmmFS68u2Yk+4l/6lxj
	 cj1n30tLFMe4N4xDWvJByeulVvU8rNMpNkSp9vl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Silvano Seva <s.seva@4sigma.it>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.14 097/197] iio: imu: st_lsm6dsx: fix possible lockup in st_lsm6dsx_read_fifo
Date: Mon, 12 May 2025 19:39:07 +0200
Message-ID: <20250512172048.332665042@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -392,6 +392,9 @@ int st_lsm6dsx_read_fifo(struct st_lsm6d
 	if (fifo_status & cpu_to_le16(ST_LSM6DSX_FIFO_EMPTY_MASK))
 		return 0;
 
+	if (!pattern_len)
+		pattern_len = ST_LSM6DSX_SAMPLE_SIZE;
+
 	fifo_len = (le16_to_cpu(fifo_status) & fifo_diff_mask) *
 		   ST_LSM6DSX_CHAN_SIZE;
 	fifo_len = (fifo_len / pattern_len) * pattern_len;


