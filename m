Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2C6248BA0;
	Wed, 15 Jan 2025 10:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937772; cv=none; b=k2VOCRFWksT/d2g4RcQnS2aiYQSGmc+9ADKH8/1RVklhBZPR7q/oEnD9v54TWEF7AyY4yIzOrSOC5nAm/d5Z727ODX8rqaGyZxJ47TbF0va/WmxvVLRmNA02/VRYPyUTP+Fej+2Q1i7q/OvpB72jX1wg7ynBpgxnYUO3P/w/3+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937772; c=relaxed/simple;
	bh=YOolBxeA39V83ei1EzDAymUATSFoY6NTOVlxNnqi8XA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b+Qi7s90CfQRvYDCRj+KLwkavCAg2/DPXVZwY7Zn5veeUY0KMqifXnWygimIwls8x0aRf0I9FEK6XVy8b6bVwpu2zzUCze6gcDmBeD9A7EDebLE1ozUOzdFMUh/4XkLF4TD79EVSIGDwZL9+M4qfWvD1xNupI35G/eZCEZRqdsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dyr4Ivvc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dyr4Ivvc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D479C4CEE1;
	Wed, 15 Jan 2025 10:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937772;
	bh=YOolBxeA39V83ei1EzDAymUATSFoY6NTOVlxNnqi8XA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dyr4Ivvc7qexgBpvnPP7ggm4l7y3vN4CsBss917qmhhtXEGNq0p3VgtD1lHnwIUOK
	 UZDEVFwhcasSKv1OJkQ+9DqBGa6u7GsW+wQqGHwlYMtSBqSvn67pYcnMcudz9WArJp
	 aUcYwD7VyLbreSPfTvXE7P4JPp5r1BpW4FhSWQnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 77/92] iio: inkern: call iio_device_put() only on mapped devices
Date: Wed, 15 Jan 2025 11:37:35 +0100
Message-ID: <20250115103550.635600234@linuxfoundation.org>
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

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

commit 64f43895b4457532a3cc524ab250b7a30739a1b1 upstream.

In the error path of iio_channel_get_all(), iio_device_put() is called
on all IIO devices, which can cause a refcount imbalance. Fix this error
by calling iio_device_put() only on IIO devices whose refcounts were
previously incremented by iio_device_get().

Fixes: 314be14bb893 ("iio: Rename _st_ functions to loose the bit that meant the staging version.")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Link: https://patch.msgid.link/20241204111342.1246706-1-joe@pf.is.s.u-tokyo.ac.jp
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/inkern.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/inkern.c
+++ b/drivers/iio/inkern.c
@@ -513,7 +513,7 @@ struct iio_channel *iio_channel_get_all(
 	return chans;
 
 error_free_chans:
-	for (i = 0; i < nummaps; i++)
+	for (i = 0; i < mapind; i++)
 		iio_device_put(chans[i].indio_dev);
 	kfree(chans);
 error_ret:


