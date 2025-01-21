Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA23E1F7086;
	Tue, 21 Jan 2025 18:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482927; cv=none; b=hTeorr4pp1RLVJXkWi207Zsy96PN11ZN61r/tcaWuH5e7jzYe3v6i2eWflAIxExy/4wt68dW1/rue3xBidca5fqsll/yddR/2IZ8y2Odm3/0V6H7v30yYa+MXfgKRREKdD9xiMRgmRWm46YaFoEaw35JXAlqpWEwAhP1FHP9KiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482927; c=relaxed/simple;
	bh=Bci5YagbuAt0ytqfzJ+MbbY0s5ijpMhtjedimFNlsu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XePGTrEDsRqhcpGUv9c0CSF+I9HKXjTM87tI0kyVdj4hoWh/z+dYxXTLg9p/8UBw4ht9fzxTDZ03036eOV1yWFojPX/7gpyTX5fi9dlmsGvWzonHvRV7zhIZrsp2GsduEtxmHWhciGiQXmcuLvU4l9vcwOC+HxgQmCh0SuunfTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MVuw0M7L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MVuw0M7L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDEDBC4CEDF;
	Tue, 21 Jan 2025 18:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482927;
	bh=Bci5YagbuAt0ytqfzJ+MbbY0s5ijpMhtjedimFNlsu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MVuw0M7LSmEP9AzSarWtpfma7GJavQbfkENEH60Is/MaQhZxZLlNEJf+c4EkPuCc4
	 4E4geki2IUKd2MV8stwdyatESlULgQhJabUiS/V3CYEaDDf4x1CdG33Kfvh/bc25Nv
	 xNwZ0lG/Den57gJr1c34x6XO6VsYVpqjVVQUin0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 056/127] iio: imu: kmx61: fix information leak in triggered buffer
Date: Tue, 21 Jan 2025 18:52:08 +0100
Message-ID: <20250121174531.827153750@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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


