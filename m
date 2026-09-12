Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162132E06E4;
	Sat, 12 Sep 2026 12:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215547; cv=none; b=Y8Yj3xijrqBacIEK7d1FuNurWs3lucBU8UGHfQxUpoBbVjNEG8fuleMjj/cSzdmVYryFH4MpFnpNi7z+6+0sLRb3Sa+MhP2S68MuMVoRvy2D7i20MZ+n3laoEhsWMb/wAwyWahu1St2Ar0CZ2jAe8/EGSOrXcR3uicuyCfJmBTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215547; c=relaxed/simple;
	bh=BKVX9wY+x502n7m+Ee5C1aVNHbDJmRW5eMyK0y3ZGwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f0IGh0pNHN7jhHWoq3DIafe/LYVST+yP16GSjz1CmAaLyQqIF+h1oXDO2jgHA1KDSdBWoXZnRE9Zw0yTkCS0cpJ5JttLgCFfJVEwZZHPJTZwpwzyvm/HhdSSLGBdp2mGFoGBXa3cuTHWot/tG4GAGnsesiaUnS21hafE8///rJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GmpX60YQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GmpX60YQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD4A51F000FF;
	Sat, 12 Sep 2026 12:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215546;
	bh=iHhEtu6yCztKqhATNfWbrtoN7ymA9WOKIhyjcAfw0m0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GmpX60YQcXOFbsz4ql+Ef9dyu5bWQindf3J1cHHMrsNaJ+DwtwRoJ4EufmjMwYBn8
	 pzV8f/Wr6EiswGXpS8SpfMp2kOM3B587MPr0OtIEVZsynqvv9046YIIsK89Mnp7kFQ
	 tdHqBY4GCBAIKUbuySTpg9iqwht+A9ED05nW9NbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugen Hristev <ehristev@kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0552/1376] media: bcm2835-unicam: Fix asc leaked in error/remove path
Date: Sat, 12 Sep 2026 08:49:38 +0200
Message-ID: <20260912065619.840158287@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9f81e1582a300..d94703ac1022a 100644
--- a/drivers/media/platform/broadcom/bcm2835-unicam.c
+++ b/drivers/media/platform/broadcom/bcm2835-unicam.c
@@ -2570,6 +2570,7 @@ static int unicam_async_nf_init(struct unicam_device *unicam)
 	return 0;
 
 error:
+	v4l2_async_nf_cleanup(&unicam->notifier);
 	fwnode_handle_put(ep_handle);
 	return ret;
 }
@@ -2702,6 +2703,7 @@ static void unicam_remove(struct platform_device *pdev)
 	v4l2_device_unregister(&unicam->v4l2_dev);
 	media_device_unregister(&unicam->mdev);
 	v4l2_async_nf_unregister(&unicam->notifier);
+	v4l2_async_nf_cleanup(&unicam->notifier);
 
 	unicam_subdev_cleanup(unicam);
 
-- 
2.53.0



