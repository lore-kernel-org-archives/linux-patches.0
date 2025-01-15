Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA2C1E98E7;
	Wed, 15 Jan 2025 11:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938819; cv=none; b=V3K25dkd9q0+3iftBLIsqMQ4M8WGA74Cz8L3+DpvKOP1vve+5dEO37wxzwoOKiemuVfg1mXkffKY0NqIP44ogRbxmFlG6YVW3HPAiPRvi1f1D1NFhyCTOx1M0SlArdm91o84HoyHFcYzyAlke3OtZL0yoTzMNngHtZHZYWWf280=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938819; c=relaxed/simple;
	bh=Ql+ZREUpsvE5xcaXPqrCJNZuNw2Mg+Q+6+xa6ZqGAKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VLuxvMduHW/7bCNiyOZUhpYs1fA7xpn6V18Zp5Sjms3Q+k4TT7jko0o2OiNY3ADVYHuadoRc5yaRlCtgFbcbRxduqL2peOWHgzsIwpQlnVjgR3iXyCa2OYjE4Xp4nD9xHcdXbEp1P9i5dxICEYcOmk71P/XzjVDGxqa/25JlKWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YKbvi3L7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YKbvi3L7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F8B4C4CEDF;
	Wed, 15 Jan 2025 11:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938817;
	bh=Ql+ZREUpsvE5xcaXPqrCJNZuNw2Mg+Q+6+xa6ZqGAKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YKbvi3L7mkU4Wv2ssX0cvfzEaU8Ij03r8Ec6kp3qyBBvfIm3emRXS3Rxz8GtCPxd+
	 hqAAqhcbd7xyKlz8MM74bHTb6aKT2M+0sgSy3PAmYfLSdz2MHHI45a3xb4rPm0fMBT
	 CZNThP0iyiXKeMHqB60utevXX8Npd5iaEjLh5yCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 105/129] iio: imu: kmx61: fix information leak in triggered buffer
Date: Wed, 15 Jan 2025 11:38:00 +0100
Message-ID: <20250115103558.541410529@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit 6ae053113f6a226a2303caa4936a4c37f3bfff7b upstream.

The 'buffer' local array is used to push data to user space from a
triggered buffer, but it does not set values for inactive channels, as
it only uses iio_for_each_active_channel() to assign new values.

Initialize the array to zero before using it to avoid pushing
uninitialized information to userspace.

Cc: stable@vger.kernel.org
Fixes: c3a23ecc0901 ("iio: imu: kmx61: Add support for data ready triggers")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20241125-iio_memset_scan_holes-v1-5-0cb6e98d895c@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/kmx61.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/imu/kmx61.c
+++ b/drivers/iio/imu/kmx61.c
@@ -1192,7 +1192,7 @@ static irqreturn_t kmx61_trigger_handler
 	struct kmx61_data *data = kmx61_get_data(indio_dev);
 	int bit, ret, i = 0;
 	u8 base;
-	s16 buffer[8];
+	s16 buffer[8] = { };
 
 	if (indio_dev == data->acc_indio_dev)
 		base = KMX61_ACC_XOUT_L;


