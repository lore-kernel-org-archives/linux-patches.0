Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C873A346E4A;
	Tue, 16 Dec 2025 12:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887660; cv=none; b=AXUqqRD1QPWCON5+h/7cyp9fZpad6KUdaNSt4i6kD9bawr5sz5EcIZHDRWysbDP7q91dy2rSXvsHpDKmJb+GBd0/LJCZ0jVHZsnPTuZFnZy7eWsX6EZs1CKIjMHKJ5qAE1HIFSYpHyRSthyLX0uDTOsqFaxg/g3Q9Pw3lZTs5P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887660; c=relaxed/simple;
	bh=qMHe1Dl4WHDMxkTd7B9rgVIZMZx5kshdxN6p7MvzfS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Emk9Ggc3DIDHxzO0269BRPguKJYi2ZkXiy+kQ7ArfJiM9FQ4k3hJRjzuwH5VJqcMvY0wEtMMufK9BZRFXLYS4oYFGlmmVyhUdC/V4JuEVmy36iMSLLT6bhCGLSP/NvJsF+Uoc8/QBjnbGo+aHR6MTmsRzQpzuwY8sxGLMH0UVAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0cGw59Oy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0cGw59Oy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05D4BC4CEF1;
	Tue, 16 Dec 2025 12:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887660;
	bh=qMHe1Dl4WHDMxkTd7B9rgVIZMZx5kshdxN6p7MvzfS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0cGw59OypLF5Dq1VzIK5389eQAlPeJ5PQmidrSZKQ/PAbToGLpo6jm+aqsW4ESn3R
	 OK0IJPMPt6w7kgvynhWfNMEGY/qTk8GhjMddk1Ike80+L6ZSDiK12TbJ69ZvfPhxCT
	 3+B7kZ1iS33CJSLzsg/P4tFYwGzVpu+BXrUXLVs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 299/614] iio: core: add missing mutex_destroy in iio_dev_release()
Date: Tue, 16 Dec 2025 12:11:06 +0100
Message-ID: <20251216111412.203350711@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/industrialio-core.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
index 88c3d585a1bd0..93d6e5b101cf1 100644
--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -1654,6 +1654,9 @@ static void iio_dev_release(struct device *device)
 
 	iio_device_detach_buffers(indio_dev);
 
+	mutex_destroy(&iio_dev_opaque->info_exist_lock);
+	mutex_destroy(&iio_dev_opaque->mlock);
+
 	lockdep_unregister_key(&iio_dev_opaque->mlock_key);
 
 	ida_free(&iio_ida, iio_dev_opaque->id);
@@ -1698,8 +1701,7 @@ struct iio_dev *iio_device_alloc(struct device *parent, int sizeof_priv)
 	indio_dev->dev.type = &iio_device_type;
 	indio_dev->dev.bus = &iio_bus_type;
 	device_initialize(&indio_dev->dev);
-	mutex_init(&iio_dev_opaque->mlock);
-	mutex_init(&iio_dev_opaque->info_exist_lock);
+
 	INIT_LIST_HEAD(&iio_dev_opaque->channel_attr_list);
 
 	iio_dev_opaque->id = ida_alloc(&iio_ida, GFP_KERNEL);
@@ -1722,6 +1724,9 @@ struct iio_dev *iio_device_alloc(struct device *parent, int sizeof_priv)
 	lockdep_register_key(&iio_dev_opaque->mlock_key);
 	lockdep_set_class(&iio_dev_opaque->mlock, &iio_dev_opaque->mlock_key);
 
+	mutex_init(&iio_dev_opaque->mlock);
+	mutex_init(&iio_dev_opaque->info_exist_lock);
+
 	return indio_dev;
 }
 EXPORT_SYMBOL(iio_device_alloc);
-- 
2.51.0



