Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FEEA7B
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 08:57:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2752C433D6;
	Wed, 23 Nov 2022 08:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669193853;
	bh=TsvuJmuF2ccnUEtUAK/NNJtzXMVYSAIcVyKvGB6zSB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ILTb8E7pdpCw5lBlJ5PIZCMDWIj2l+m3VhSNMn0f5EeaZFYriFdzHjrkhzO98l0RL
	 4pUZezdaL/2rSVQnNQu+LxliW8iQFNY+TJGqPU8F8MOvUwqTQoariEQ8i/6ASD9PJc
	 fPvEDKNGLG0CeW9s5T3UxrZSqnIRnhzetxootJoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.9 58/76] iio: trigger: sysfs: fix possible memory leak in iio_sysfs_trig_init()
Date: Wed, 23 Nov 2022 09:50:57 +0100
Message-Id: <20221123084548.658718439@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084546.742331901@linuxfoundation.org>
References: <20221123084546.742331901@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

commit efa17e90e1711bdb084e3954fa44afb6647331c0 upstream.

dev_set_name() allocates memory for name, it need be freed
when device_add() fails, call put_device() to give up the
reference that hold in device_initialize(), so that it can
be freed in kobject_cleanup() when the refcount hit to 0.

Fault injection test can trigger this:

unreferenced object 0xffff8e8340a7b4c0 (size 32):
  comm "modprobe", pid 243, jiffies 4294678145 (age 48.845s)
  hex dump (first 32 bytes):
    69 69 6f 5f 73 79 73 66 73 5f 74 72 69 67 67 65  iio_sysfs_trigge
    72 00 a7 40 83 8e ff ff 00 86 13 c4 f6 ee ff ff  r..@............
  backtrace:
    [<0000000074999de8>] __kmem_cache_alloc_node+0x1e9/0x360
    [<00000000497fd30b>] __kmalloc_node_track_caller+0x44/0x1a0
    [<000000003636c520>] kstrdup+0x2d/0x60
    [<0000000032f84da2>] kobject_set_name_vargs+0x1e/0x90
    [<0000000092efe493>] dev_set_name+0x4e/0x70

Fixes: 1f785681a870 ("staging:iio:trigger sysfs userspace trigger rework.")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20221022074212.1386424-1-yangyingliang@huawei.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/trigger/iio-trig-sysfs.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/iio/trigger/iio-trig-sysfs.c
+++ b/drivers/iio/trigger/iio-trig-sysfs.c
@@ -212,9 +212,13 @@ static int iio_sysfs_trigger_remove(int
 
 static int __init iio_sysfs_trig_init(void)
 {
+	int ret;
 	device_initialize(&iio_sysfs_trig_dev);
 	dev_set_name(&iio_sysfs_trig_dev, "iio_sysfs_trigger");
-	return device_add(&iio_sysfs_trig_dev);
+	ret = device_add(&iio_sysfs_trig_dev);
+	if (ret)
+		put_device(&iio_sysfs_trig_dev);
+	return ret;
 }
 module_init(iio_sysfs_trig_init);
 


