Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57FE31E9910;
	Wed, 15 Jan 2025 10:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938423; cv=none; b=SbdRqIrgNCros3XlV6NYt/P5caIfESris8PRC2xETtSlnNwBkT0VtACxc4WtRghA5uthMel/hhwEGCgxjJUCPKzPQZGjUw0sVtHIJ2aoA9rFXetn0k9GHShONXSNnkvCFLf4+UxLebyhbgxwINzIjbfRzvTc3qZEnpSad8z6pyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938423; c=relaxed/simple;
	bh=EI4rV79SRpnwSQZoKuypFgXEMi1HTdn5k1YdzPCeEes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CJu6NiYv6PcvJSbVxZkAFmv1szOJ17prsdu/7/k9BU/qHzzDbRuZMR5B4MpthcXg4A+p8R5Ac4BvKF+EH0ArKhE0UNpETvNYh+tvZhZOY29fVPZJWZDCtBhbuL1RphgHBwX7Hv48fkhCInXsavBxMrzJpLoRP/yEZvhIn9i9DkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SHHpjfuq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SHHpjfuq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2A32C4CEDF;
	Wed, 15 Jan 2025 10:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938423;
	bh=EI4rV79SRpnwSQZoKuypFgXEMi1HTdn5k1YdzPCeEes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SHHpjfuq2kyuEBPkqoEk9JA1XtCgMjwcHy+NqxDsbCbEBClTZjeLK5mhxf6sbsuDM
	 HTKOvpu+0lSBrlqsWuDiq/p1tGo40n4U0AG9FL6r/KgLAQiYcYBERv5eTVFPEuLvzd
	 s2ARviEMFR57J+ZnJzTGz4fatoWQP+6JQv7Y9QAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 161/189] iio: imu: kmx61: fix information leak in triggered buffer
Date: Wed, 15 Jan 2025 11:37:37 +0100
Message-ID: <20250115103612.826644791@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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


