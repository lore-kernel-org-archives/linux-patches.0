Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A20CC1E990E;
	Wed, 15 Jan 2025 11:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938806; cv=none; b=klSYaeYz1Zux2tl/lMRWEyd4FVyi2i0ecRBu2WTS4v5a2ma4O9grWnNTfBaavf+ooOjUIh3NpyBBJ6S0/1KVOx7sp1VOAOeKD+64hYeDcDvd+kTFhampHMVZpqopRB98nugu9jsgC3xDyhZpvc52u1vl1FYFQQgjcleGsEGgDoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938806; c=relaxed/simple;
	bh=MUNOD1KJcBRgancNZOC+q2Y78U5XMZBYo1Mtg6pJY8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rq4Efw9eS8SOzeQsB8/X/uywgcaV5JKP7WGcz5WjIjHy1Z5yWx6Tr+JkSXxR/+JO8i2gjnEx8FIm2HbvLtiAexMlqZx5iqDaLmip60oq1Zb7tv1IHK8R07V9EtLLR4D0OrflXKrHnD5JfO7pQQRnHyoRIukEZwsuJyAHb+1I2ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P9CFebsX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P9CFebsX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF53C4CEDF;
	Wed, 15 Jan 2025 11:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938806;
	bh=MUNOD1KJcBRgancNZOC+q2Y78U5XMZBYo1Mtg6pJY8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P9CFebsXUmAYeaeG1g64hC7oYu6MPARusMbivzapgx97gG7nWVYNuXzP1pz2Hw7EX
	 19JEh1bq1mOyKo/Fhelp4KdD/jIDJlRpd5gG2GufT04LJTz9VuQy8lxKIBwM0fKrpm
	 QmIP8efZmh6XTkQZKPeb3SK0v6UUfQprIkg9lLWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 103/129] iio: dummy: iio_simply_dummy_buffer: fix information leak in triggered buffer
Date: Wed, 15 Jan 2025 11:37:58 +0100
Message-ID: <20250115103558.459119352@linuxfoundation.org>
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
 	int i = 0, j;
 	u16 *data;
 
-	data = kmalloc(indio_dev->scan_bytes, GFP_KERNEL);
+	data = kzalloc(indio_dev->scan_bytes, GFP_KERNEL);
 	if (!data)
 		goto done;
 


