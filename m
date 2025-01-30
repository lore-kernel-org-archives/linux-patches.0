Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6CE1BDA95;
	Thu, 30 Jan 2025 14:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247007; cv=none; b=hFFxw9/sk2kEGHqjDxF6Lnz3di59K83z084gNFp/C6B/BKlzWngfYEzw/+gYET30ieuUHcfc+T1bgWQ54v7DM+DnddEARiC0p6B/pjIw04YE+iWP0n837Qijwd8FyKn8Xa/D77fhM5Nu9siAO6zdjJ6tNYKXntQIGh8lXBoPEnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247007; c=relaxed/simple;
	bh=l3DOeeA0MRUbh26Hlvry+uksawTGcfe9lNbMNvAta6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ePn+VIZvKrimbBrSod5pT+uXKoWkfK8O/YhL9Tg6tAqCiEzsmKpASwfbXMdMnW1GKqJy0MSBQ5mmCEquhlDBHqnuy2FCtF88hJxOugUF+K0i2vKLTEjmo6wvKtUEikQmFJNujVwz1zV8vsDrI85uw8kAf7COt5uo5520F+49fW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i9gO7Zw8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i9gO7Zw8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93EDFC4CED2;
	Thu, 30 Jan 2025 14:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247007;
	bh=l3DOeeA0MRUbh26Hlvry+uksawTGcfe9lNbMNvAta6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i9gO7Zw8l8LRiJ7BRNvv8d2znBh/wvYASiaGgtmHlqmxm1HQbBOvUecRKTyN5aDeJ
	 D+fj8Ufk3hyotvy7vYVbUKbpZ2iZQ5iVdgf687hFevZWnB9PZC3iafAoEMT6a3LnrE
	 ChuJUCaKHkDUcntXHSzxKotQ6JaArQsjd2ZcZX00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 050/133] iio: inkern: call iio_device_put() only on mapped devices
Date: Thu, 30 Jan 2025 15:00:39 +0100
Message-ID: <20250130140144.534974332@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -447,7 +447,7 @@ struct iio_channel *iio_channel_get_all(
 	return chans;
 
 error_free_chans:
-	for (i = 0; i < nummaps; i++)
+	for (i = 0; i < mapind; i++)
 		iio_device_put(chans[i].indio_dev);
 	kfree(chans);
 error_ret:


