Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20BC21F78FB;
	Tue, 21 Jan 2025 18:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482919; cv=none; b=rhh5jsXf6hMKFNE7zsNvqNVa0MqM7GWllmkRORiADOZ/okYATsSBCt2lRdGoUg3DzmTmVvtbCU+QEmQc8pRJgQ51xdRziX5aA5S1dWRLuPa6u7pfSdSi/hqJeKDYShtV2uzmZYV8i4SyZ8kYMghPYv9ubnMZ+aOV9lv0fXlURl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482919; c=relaxed/simple;
	bh=13TJD0rIgOgjPpZm5Ps7848WmcbbutDcmoWZ9t3m+/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o4Mini9FmiRL7J7Nm2C2ixb5FGrYWBNhVYqNAIx/bCx1FZ7Nat4OZGM2vjBiB2UkD1MSDF1x4DMMPoko4+W310Uxy5R5gRpfSmKoVZRdZwAR0LxWQYgpqat109MRAKH8mJ/tJRLzxes2y0VYUYvf99RlRq2sh3w17PYM47STXWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nkepP/jo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nkepP/jo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21980C4CEE1;
	Tue, 21 Jan 2025 18:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482918;
	bh=13TJD0rIgOgjPpZm5Ps7848WmcbbutDcmoWZ9t3m+/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nkepP/joDow3LckIqrwbT1kh/Jowr8gfnyvAmQGMIIxDN4/r8HK2gx1BNHo5KPgBn
	 kkmGdQyIPttIGP/2b7OtEqpO8GQi9pzCtKtORzWPBELVmQ7s2nIBvUzC0COE3/tjnr
	 HZdOwK3qh6RfzvdnMN2xJdsScFtt5qAc7/HUEoW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 054/127] iio: dummy: iio_simply_dummy_buffer: fix information leak in triggered buffer
Date: Tue, 21 Jan 2025 18:52:06 +0100
Message-ID: <20250121174531.751592429@linuxfoundation.org>
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

commit 333be433ee908a53f283beb95585dfc14c8ffb46 upstream.

The 'data' array is allocated via kmalloc() and it is used to push data
to user space from a triggered buffer, but it does not set values for
inactive channels, as it only uses iio_for_each_active_channel()
to assign new values.

Use kzalloc for the memory allocation to avoid pushing uninitialized
information to userspace.

Cc: stable@vger.kernel.org
Fixes: 415f79244757 ("iio: Move IIO Dummy Driver out of staging")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20241125-iio_memset_scan_holes-v1-9-0cb6e98d895c@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dummy/iio_simple_dummy_buffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/dummy/iio_simple_dummy_buffer.c
+++ b/drivers/iio/dummy/iio_simple_dummy_buffer.c
@@ -48,7 +48,7 @@ static irqreturn_t iio_simple_dummy_trig
 	int len = 0;
 	u16 *data;
 
-	data = kmalloc(indio_dev->scan_bytes, GFP_KERNEL);
+	data = kzalloc(indio_dev->scan_bytes, GFP_KERNEL);
 	if (!data)
 		goto done;
 


