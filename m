Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19D53B38A9;
	Mon, 23 Mar 2026 15:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278905; cv=none; b=iB4qjD5MHF4ZQLNQFb7HWVqUxkyPY3OiSWap0lmap2GsQ4cTU/2b0NDk3aCYLCu7bA0L/8Cp57AgIdYUuT9u9zWMxh3G/LUkstynlCBirNfU8sWFPnrU/6+v91ZLmhqWbLwwVVmktCj5tv+j+rVb2SywjAjGLfeyJeUP3kiFIds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278905; c=relaxed/simple;
	bh=iC/duIzbwiW5e4dBs1PqhxnbBocpcQbsRg/B1gf1xQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IZELRyVRAGLD0vfpBSbB3enIvVQi2IKu8aB0iE5BIGrfODOjwlIx+6xxayWaORfg5ImrvB0+EL/n8VmXH+EVGiLHusKijgSi+LXILYPbDyH8uXGMyToMvXmVKJ5QQiwwGKAm6DNIaW4NmFA6oPFKz+OQ4v9uJgibb+AaiDnlLAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pel5pbn6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pel5pbn6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63AC1C2BC9E;
	Mon, 23 Mar 2026 15:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278904;
	bh=iC/duIzbwiW5e4dBs1PqhxnbBocpcQbsRg/B1gf1xQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pel5pbn6D8B5FwmA7ihCtR/gz6OAaShscjDUGJz0lzL41H0ZmC5x09ARqt7WR8EPo
	 D/fO4ySaTf1nUiyKYkU/8d1jLHS41/3Mh2+aAJ48slIacqhoDZaKhAnt6FZWhAVt31
	 uCHoN7uGGHCOIWizsFuhipx+GpHFjWPqA0IDQ5uY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dingisoul <dingiso.kernel@gmail.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>
Subject: [PATCH 6.6 454/567] nvdimm/bus: Fix potential use after free in asynchronous initialization
Date: Mon, 23 Mar 2026 14:46:14 +0100
Message-ID: <20260323134545.215238740@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Ira Weiny <ira.weiny@intel.com>

commit a8aec14230322ed8f1e8042b6d656c1631d41163 upstream.

Dingisoul with KASAN reports a use after free if device_add() fails in
nd_async_device_register().

Commit b6eae0f61db2 ("libnvdimm: Hold reference on parent while
scheduling async init") correctly added a reference on the parent device
to be held until asynchronous initialization was complete.  However, if
device_add() results in an allocation failure the ref count of the
device drops to 0 prior to the parent pointer being accessed.  Thus
resulting in use after free.

The bug bot AI correctly identified the fix.  Save a reference to the
parent pointer to be used to drop the parent reference regardless of the
outcome of device_add().

Reported-by: Dingisoul <dingiso.kernel@gmail.com>
Closes: http://lore.kernel.org/8855544b-be9e-4153-aa55-0bc328b13733@gmail.com
Fixes: b6eae0f61db2 ("libnvdimm: Hold reference on parent while scheduling async init")
Cc: stable@vger.kernel.org
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20260306-fix-uaf-async-init-v1-1-a28fd7526723@intel.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvdimm/bus.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -486,14 +486,15 @@ EXPORT_SYMBOL_GPL(nd_synchronize);
 static void nd_async_device_register(void *d, async_cookie_t cookie)
 {
 	struct device *dev = d;
+	struct device *parent = dev->parent;
 
 	if (device_add(dev) != 0) {
 		dev_err(dev, "%s: failed\n", __func__);
 		put_device(dev);
 	}
 	put_device(dev);
-	if (dev->parent)
-		put_device(dev->parent);
+	if (parent)
+		put_device(parent);
 }
 
 static void nd_async_device_unregister(void *d, async_cookie_t cookie)


