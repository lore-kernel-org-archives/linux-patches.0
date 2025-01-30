Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71B31E7C27;
	Thu, 30 Jan 2025 14:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246680; cv=none; b=khrN0guF2tgQLmi1ZYGFhb6p4NPoQ5BG9xMmTuGXukS4Kd0vyypTZK1ck/RxyoVu2AvGMvtLxgYZO0tYdwhzVe5nFeXBp9dqxA/W4KB5QKyuGCa/PqRhB0rMYdUj8L88aTiRI7g7VTqG9x40+4V+CdsDDTtVR3fg+wgWe+9EKPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246680; c=relaxed/simple;
	bh=nIXf1e/VnWlpN+na/3NO/tjyQQAMPwjIlnQ5Bbd9Mbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SbqyPhqcz58rtPSnbBNAnYodkBJuFDUFgzd2L5c54BSuGIALfe1JwB/Yein1N5HlWCP12oA70PS68lTIcrVBQyoHBoFV5nWOegphWb8kg1l2ecmY3RyXHqfEaP7GquAjsIXdLQoP/0BYuzMiXngVoU29/ukJs30mDWRQ9DOBI/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d3hSaGxr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d3hSaGxr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D956C4CED2;
	Thu, 30 Jan 2025 14:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246679;
	bh=nIXf1e/VnWlpN+na/3NO/tjyQQAMPwjIlnQ5Bbd9Mbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d3hSaGxrQdxRjg13cGUcmc7PbQaFfWH47vOSGls9R60d3wowzK06eEJPPSiiXyhCH
	 f6ajwAwUdYQbjd61zbfv73VWM/COK5ZdzF/w6MQ4yLtOb27K13PqMV5R0sWBgPMHrJ
	 dQ7zemZLFbkBj9d5EFLEcOBpV9hsKvHi03G0exPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 30/91] iio: dummy: iio_simply_dummy_buffer: fix information leak in triggered buffer
Date: Thu, 30 Jan 2025 15:00:49 +0100
Message-ID: <20250130140134.875856318@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
 


