Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79FE7248BA0;
	Wed, 15 Jan 2025 10:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937748; cv=none; b=nE775WTtBKXrhWjP5zM39BgZqsv5gyHQci5wj/eMZRV+2axcJdsjkaY3oVudqJ4lTrDxW3Yeg3o93NHc+NtQ9TNRoo5S/oDt8cprXQGgxwaxYG+luDhmf5C8nq1uIQpdwooLRzKJPxeb+fLasFg6v0kDiGeyA7xNEJW+PA9/2Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937748; c=relaxed/simple;
	bh=MJFbPvkke3DUEEvwyJcTQ/NdRqSRxrv+KagLJdFrGZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TKjPp/QFNhdtBkybRylwL9YknLaM3iD2qDM8xPtFX9izbI1VQKCGGUG7TvSZRXyt3KPEefy3BpztfZXliZEWm8g0rbBlp9RhjBNNxTOiojmWiQAHMB5RBJxJ5ekJHCirIMGZkHnNaguEAw6Y5DOflJJ2UJ/lrP0jfv6OOC0D+ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CgKjDaFO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CgKjDaFO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72BACC4CEDF;
	Wed, 15 Jan 2025 10:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937745;
	bh=MJFbPvkke3DUEEvwyJcTQ/NdRqSRxrv+KagLJdFrGZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CgKjDaFOg2BLiEnjhLud49gvcCMsd5EJJa6rBBxOp3xXfrDsUdz5sRn19/WCxui/r
	 9PPUPtw9weSwvAfbDraD6BlbYfSl8R1gw0xcId+k/A3CY/Jlhc6ENp00Xp/WhUzwZE
	 GP8bwY631ZLiNQCeyzRzfjC1lnrChKLGoIk37zbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 70/92] iio: dummy: iio_simply_dummy_buffer: fix information leak in triggered buffer
Date: Wed, 15 Jan 2025 11:37:28 +0100
Message-ID: <20250115103550.351165986@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


