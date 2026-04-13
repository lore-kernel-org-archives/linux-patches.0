Received: from mail115-69.sinamail.sina.com.cn (mail115-69.sinamail.sina.com.cn [218.30.115.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB991DE8AE
	for <patches@lists.linux.dev>; Mon, 13 Apr 2026 01:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=218.30.115.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776044022; cv=none; b=gXic6wg/+UMUMfDzFa24b0mrQ1LSKYKZZ5i1ulffIpunE1h2LzmPsLBAfi9+QBK6tpehnD+kqMrkyUikMWfzaG9KcBoVi7GdD2txHHQtj8n4ABoBWkEantkbYI2z8mbS3vdvnfWqJ2fuF+qpN3+vH/1Eww144wovaK9/d8TPRlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776044022; c=relaxed/simple;
	bh=fg8f6Jjir04dYy1MUu5cm/qWNdaGJEtBqGRWLfrK//U=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FAc4fN5WBQOV8zF+p9iV7yA6jHr+ZylWdpPqNFFO24cgrNayLKXRqXsYdeoea1SsvwSLXOsPh13JxmT79tWO714qz4Y5IHPWe0cCOKsCg/YjIi+TRNzjnJxL4CP527vApBIcZBurwVDRF++uQEB/OY29bp23aha8eDuj9aDobPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.cn; spf=pass smtp.mailfrom=sina.cn; dkim=pass (1024-bit key) header.d=sina.cn header.i=@sina.cn header.b=y0dPstk4; arc=none smtp.client-ip=218.30.115.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sina.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=sina.cn header.i=@sina.cn header.b="y0dPstk4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.cn; s=201208; t=1776044020;
	bh=5AiOv3OmSV1vAgdRKipxBvh8ToeMYXa8wksWt6WBwek=;
	h=From:Subject:Date:Message-Id;
	b=y0dPstk4pFWiOO/3fS5Q2wu+b9BWmUU9a+ZhvWo6IvQY5sG2293Zy1WvOLjHv2CIp
	 aWmbKmKZ9zbxV/QXiZw1t9I540Z7UO9w6KqZoxYwaUszAWpoPw2zktG/lLG6EUDwMc
	 naLyfdUGMqR38z1YwA1LwOHF5pebF8DNw+jM8u+g=
X-SMAIL-HELO: NTT-kernel-dev
Received: from unknown (HELO NTT-kernel-dev)([60.247.85.88])
	by sina.cn (10.185.250.22) with ESMTP
	id 69DC47E900000EAA; Mon, 13 Apr 2026 09:33:31 +0800 (CST)
X-Sender: jianqkang@sina.cn
X-Auth-ID: jianqkang@sina.cn
Authentication-Results: sina.cn;
	 spf=none smtp.mailfrom=jianqkang@sina.cn;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=jianqkang@sina.cn
X-SMAIL-MID: 2821247602310
X-SMAIL-UIID: EF915E9DFECA41D78B31B4BD59713C7D-20260413-093331-1
From: Jianqiang kang <jianqkang@sina.cn>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	ira.weiny@intel.com
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alexander.h.duyck@linux.intel.com,
	linux-nvdimm@lists.01.org,
	dingiso.kernel@gmail.com
Subject: [PATCH 5.10.y] nvdimm/bus: Fix potential use after free in asynchronous initialization
Date: Mon, 13 Apr 2026 09:33:29 +0800
Message-Id: <20260413013329.837358-1-jianqkang@sina.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ira Weiny <ira.weiny@intel.com>

[ Upstream commit a8aec14230322ed8f1e8042b6d656c1631d41163 ]

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
Signed-off-by: Jianqiang kang <jianqkang@sina.cn>
---
 drivers/nvdimm/bus.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 9ec59960f216..1aacc40ad09f 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -502,14 +502,15 @@ EXPORT_SYMBOL_GPL(nd_synchronize);
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
-- 
2.34.1

