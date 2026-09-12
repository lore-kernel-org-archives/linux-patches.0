Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 499E3246BCD;
	Sat, 12 Sep 2026 10:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207386; cv=none; b=mzAielWo/4WccXSEGBNqsIlFHacfkrW9olQDc5lbYXg+lxJZCM3mA69WK1xDfs9gAlC0FMVb2LF2F3YGl3ENnLMnMtetCXSO1aa9YBpdnUySIxYYYgq9y26LuVkLVXV0VpcaqQbQStYCKLSoDKnEjDhuWtfydU4wj1ajxPFVP3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207386; c=relaxed/simple;
	bh=Am+GzHd9TTIv5gIG7f86IdVBaXgCQniyXqNwimZthtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aZg7dQa492246TvpJNi2v/Y/cXRJ14J8lk18jPK/dTALadAYB0wWtRVuN+hFpHa2/p74mYyXWdCRxz+6cnrPoSqFFjGCMUrIFcW9vIEEJoZKKbKYptPMJdXk/aX22tYthJeYK0zPPBSlTMozPu6YxmHv3w5/c01KTXZLmzyBfr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hXRal3xT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hXRal3xT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D852C1F000FF;
	Sat, 12 Sep 2026 10:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207385;
	bh=XrKQNQl6/Uz9VoZxKkzu1mnUSZFeINoNDqpHXgtk7ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hXRal3xTO4CsZagFOKUP+fe4GpDqh+Ni8mpcLCijULLHy9RCHlZ58fqHOhOo7webG
	 Kv1Jno74snPm7Nlb3DIfuxu1Pv1ARsKNXNAe3WGM6B+BCRAKZ3npjaos/9BBBPMtgu
	 7OlOnW1vJ7jj3AIjsTjuQComhuHhUbfKtEm+zYnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugen Hristev <ehristev@kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0401/1518] media: bcm2835-unicam: Fix asc leaked in error/remove path
Date: Sat, 12 Sep 2026 08:42:50 +0200
Message-ID: <20260912065632.527049668@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eugen Hristev <ehristev@kernel.org>

[ Upstream commit 253c9659e25131b0169f718e7d094ac1aa0d9279 ]

v4l2_async_nf_add_fwnode_remote() allocates the asc, which is freed when
v4l2_async_nf_cleanup() is called.

Call v4l2_async_nf_cleanup() properly in the driver paths.

Discovered with kmemleak after rmmod:

unreferenced object 0xffff000084526b80 (size 64):
  comm "modprobe", pid 185, jiffies 4295013512
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 e8 0d ff bf 00 00 ff ff  ................
    40 83 bc 84 00 00 ff ff 60 83 bc 84 00 00 ff ff  @.......`.......
  backtrace (crc ac584083):
    [<00000000ffb081a7>] kmemleak_alloc+0x38/0x44
    [<00000000d2fd9301>] __kmalloc+0x1b0/0x250
    [<000000004dd5354d>] __v4l2_async_nf_add_fwnode+0x28/0x9c
    [<0000000067587657>] __v4l2_async_nf_add_fwnode_remote+0x3c/0x64

Fixes: 392cd78d495f ("media: bcm2835-unicam: Add support for CCP2/CSI2 camera interface")
Signed-off-by: Eugen Hristev <ehristev@kernel.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/broadcom/bcm2835-unicam.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/broadcom/bcm2835-unicam.c b/drivers/media/platform/broadcom/bcm2835-unicam.c
index f10064107d543..fd862300e06f2 100644
--- a/drivers/media/platform/broadcom/bcm2835-unicam.c
+++ b/drivers/media/platform/broadcom/bcm2835-unicam.c
@@ -2594,6 +2594,7 @@ static int unicam_async_nf_init(struct unicam_device *unicam)
 	return 0;
 
 error:
+	v4l2_async_nf_cleanup(&unicam->notifier);
 	fwnode_handle_put(ep_handle);
 	return ret;
 }
@@ -2726,6 +2727,7 @@ static void unicam_remove(struct platform_device *pdev)
 	v4l2_device_unregister(&unicam->v4l2_dev);
 	media_device_unregister(&unicam->mdev);
 	v4l2_async_nf_unregister(&unicam->notifier);
+	v4l2_async_nf_cleanup(&unicam->notifier);
 
 	unicam_subdev_cleanup(unicam);
 
-- 
2.53.0



