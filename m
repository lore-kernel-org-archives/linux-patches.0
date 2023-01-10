Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4353B6FBB
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:29:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98DEFC433D2;
	Tue, 10 Jan 2023 18:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673375380;
	bh=XEK883afEs0yvxpSuDYEQQaMBvXgPuMNRnAB24jTYSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NpdEJpFqRz7m0DgvEY2y0bJ+2MNAman3V38YMvBIk5V5MCdoJME+vcsm62rKiarC6
	 cyvmb+twjtyacyEXPD46Yuta5X2HHTv5L3khOv5wRgb31/bTrPofyWVZpXaNCaVt1d
	 Lzao0ogF9gSo8+Qo7iLsTT31ozRQvf9dk5/ieadc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Paul Cercueil <paul@crapouillou.net>
Subject: [PATCH 5.15 138/290] drm/ingenic: Fix missing platform_driver_unregister() call in ingenic_drm_init()
Date: Tue, 10 Jan 2023 19:03:50 +0100
Message-Id: <20230110180036.610000918@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yuan Can <yuancan@huawei.com>

commit 47078311b8efebdefd5b3b2f87e2b02b14f49c66 upstream.

A problem about modprobe ingenic-drm failed is triggered with the following
log given:

 [  303.561088] Error: Driver 'ingenic-ipu' is already registered, aborting...
 modprobe: ERROR: could not insert 'ingenic_drm': Device or resource busy

The reason is that ingenic_drm_init() returns platform_driver_register()
directly without checking its return value, if platform_driver_register()
failed, it returns without unregistering ingenic_ipu_driver_ptr, resulting
the ingenic-drm can never be installed later.
A simple call graph is shown as below:

 ingenic_drm_init()
   platform_driver_register() # ingenic_ipu_driver_ptr are registered
   platform_driver_register()
     driver_register()
       bus_add_driver()
         priv = kzalloc(...) # OOM happened
   # return without unregister ingenic_ipu_driver_ptr

Fixing this problem by checking the return value of
platform_driver_register() and do platform_unregister_drivers() if
error happened.

Fixes: fc1acf317b01 ("drm/ingenic: Add support for the IPU")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Link: https://patchwork.freedesktop.org/patch/msgid/20221104064512.8569-1-yuancan@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/ingenic/ingenic-drm-drv.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
+++ b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
@@ -1326,7 +1326,11 @@ static int ingenic_drm_init(void)
 			return err;
 	}
 
-	return platform_driver_register(&ingenic_drm_driver);
+	err = platform_driver_register(&ingenic_drm_driver);
+	if (IS_ENABLED(CONFIG_DRM_INGENIC_IPU) && err)
+		platform_driver_unregister(ingenic_ipu_driver_ptr);
+
+	return err;
 }
 module_init(ingenic_drm_init);
 


