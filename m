Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2868A217723;
	Thu, 30 Jul 2026 15:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424579; cv=none; b=ILV3WeocPVhd0VjrCd1TA5qt5VOtIU3pwjYM9rknNi0qE/xV4d8sqglegdKHlgwxS7wnqe2gryS/ijDSrft06eNRCaBfFP6Bl8L72qFkrkbjBCyR+IdBy8XEZuXYyiQ7ORgtoUxSaV/71QT/vmCM2PUJ31o4eY4AeOgJeTMZRt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424579; c=relaxed/simple;
	bh=rh5jgfRU2JZnUy0/QsNlYsOk6P8BPgyfQVlTk0+8fXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hGJ/b+9nxvA0aC5JFKLsHshcLa6gfJSJhXD0uu6yz4hqN/gj6tjkHvf/GWnH4S+xblcr5YU7O/vgMJlAJQZMVy6SNyT03Z9IPHny6+xJgxW8bCsLcWo3Ui9y/EpHw+6tOgbBL77OZ8A+E8cEle/yhXyUjqZxPnrMi3JH9Mrz18g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HoL7x6H7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HoL7x6H7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7982C1F000E9;
	Thu, 30 Jul 2026 15:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424578;
	bh=uu2Hn3xzRclPQXkj2qJb0FwA1UT2ej6erXbrOiyQRKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HoL7x6H7M1tOjrwpnFNo+za2FrN5Lc3qgiPAe2arU6utnBJTiO/2sXkTiXAWNOmA9
	 vCr4I/Q8o1955zgvh1638MlZN8wmyT7eAD2L55yYqyRF2CR+0UwqwaljGei/26fMzG
	 g+yIAgPBd0Y3p8/hZtomUqjpiYYr+Jc+f93Ga4m8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 442/675] media: vimc: fix reference leak on failed device registration
Date: Thu, 30 Jul 2026 16:12:52 +0200
Message-ID: <20260730141454.535221689@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 33e2b833c66b890a0d71c4fa82d4c97143f7f75f upstream.

When platform_device_register() fails in vimc_init(), the embedded
struct device in vimc_pdev has already been initialized by
device_initialize(), but the failure path returns the error without
dropping the device reference for the current platform device:

  vimc_init()
    -> platform_device_register(&vimc_pdev)
       -> device_initialize(&vimc_pdev.dev)
       -> setup_pdev_dma_masks(&vimc_pdev)
       -> platform_device_add(&vimc_pdev)

This leads to a reference leak when platform_device_register() fails.
Fix this by calling platform_device_put() before returning the error.

The issue was identified by a static analysis tool I developed and
confirmed by manual review.

Fixes: 4babf057c143f ("media: vimc: allocate vimc_device dynamically")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/test-drivers/vimc/vimc-core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/test-drivers/vimc/vimc-core.c
+++ b/drivers/media/test-drivers/vimc/vimc-core.c
@@ -422,6 +422,7 @@ static int __init vimc_init(void)
 	if (ret) {
 		dev_err(&vimc_pdev.dev,
 			"platform device registration failed (err=%d)\n", ret);
+		platform_device_put(&vimc_pdev);
 		return ret;
 	}
 


