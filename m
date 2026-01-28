Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE4C288C22;
	Wed, 28 Jan 2026 15:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615407; cv=none; b=FXiCP35ULuMXIYv3PoBhNh9VElmxgFL/HCyWbTkhx6vedhdDRtrHsilv48xk9NSbGLdHlJ1m1aNrC8R+XW2NQo14/uXIzuFo7IdehgJYSBJMPmjqgZ65J585L+PLonl9RL3F6GhncJaa87TZ2bpJYkat79x+icfvrwVUOBhtmJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615407; c=relaxed/simple;
	bh=XP7iCW/fFtecCpQAoo011EIJc0uVNDNz5KgGXu2SuZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y946f0m8/ps3jmbcvRGEcX+tkuLVarrqkSZxFxaIo046gElc5LDbD0TREmz3sTZiAQ2BS6/VJNGS3qkLg1oQx46Zxs1nw32TDHIihUk9koZwDgT4yk14+T/ZvyQ4G1CDpMPOgsR4hzvYlPhTEKx01vtYxm4nO+MttCoTFcAk7HU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zm1oUnal; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zm1oUnal"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E00BBC4CEF1;
	Wed, 28 Jan 2026 15:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615407;
	bh=XP7iCW/fFtecCpQAoo011EIJc0uVNDNz5KgGXu2SuZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zm1oUnalVOY7P1PIgQ0wCJEd1J49Mxmr/gxRErnsPl721N/LM7VVcXSqeeeenoFE5
	 XornW4Sa/DqWHhVWgmioTlEBIFtwlxwLsG5LkWKyUWHGvhjVtZYPmVI3D+ogVPoPdm
	 2Y8u1+gyCXIo0TKWefFTlSXceM1iwpA88sh8bg8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 152/169] iio: core: add missing mutex_destroy in iio_dev_release()
Date: Wed, 28 Jan 2026 16:23:55 +0100
Message-ID: <20260128145339.475910119@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit f5d203467a31798191365efeb16cd619d2c8f23a ]

Add missing mutex_destroy() call in iio_dev_release() to properly
clean up the mutex initialized in iio_device_alloc(). Ensure proper
resource cleanup and follows kernel practices.

Found by code review.

While at it, create a lockdep key before mutex initialisation.
This will help with converting it to the better API in the future.

Fixes: 847ec80bbaa7 ("Staging: IIO: core support for device registration and management")
Fixes: ac917a81117c ("staging:iio:core set the iio_dev.info pointer to null on unregister under lock.")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 9910159f0659 ("iio: core: add separate lockdep class for info_exist_lock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-core.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -1628,6 +1628,9 @@ static void iio_dev_release(struct devic
 
 	iio_device_detach_buffers(indio_dev);
 
+	mutex_destroy(&iio_dev_opaque->info_exist_lock);
+	mutex_destroy(&iio_dev_opaque->mlock);
+
 	lockdep_unregister_key(&iio_dev_opaque->mlock_key);
 
 	ida_free(&iio_ida, iio_dev_opaque->id);
@@ -1672,8 +1675,7 @@ struct iio_dev *iio_device_alloc(struct
 	indio_dev->dev.type = &iio_device_type;
 	indio_dev->dev.bus = &iio_bus_type;
 	device_initialize(&indio_dev->dev);
-	mutex_init(&iio_dev_opaque->mlock);
-	mutex_init(&iio_dev_opaque->info_exist_lock);
+
 	INIT_LIST_HEAD(&iio_dev_opaque->channel_attr_list);
 
 	iio_dev_opaque->id = ida_alloc(&iio_ida, GFP_KERNEL);
@@ -1696,6 +1698,9 @@ struct iio_dev *iio_device_alloc(struct
 	lockdep_register_key(&iio_dev_opaque->mlock_key);
 	lockdep_set_class(&iio_dev_opaque->mlock, &iio_dev_opaque->mlock_key);
 
+	mutex_init(&iio_dev_opaque->mlock);
+	mutex_init(&iio_dev_opaque->info_exist_lock);
+
 	return indio_dev;
 }
 EXPORT_SYMBOL(iio_device_alloc);


