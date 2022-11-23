Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 104591C26
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:10:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F48BC433C1;
	Wed, 23 Nov 2022 09:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669194642;
	bh=ZyIsjk83RiWDYobLCizAPcbpgtskiaSiiPgPFhWC6U8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lDsitFP0Il4W7F7osnWhVn/1l+2XzhQBgf1MoHmJ/l7WYCWT8ZtkGhBE8Cx8kw/iM
	 9uNvLm9MjVySsRy8xj7tQeUQTrFJqPbKIlsVJElKsexFhI30HDzFEpC2FfXKMuU2ZJ
	 7NO2Ub0+U99oq/D3+34F0IFdpQsfkv7hSsBBYMEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Maxime Ripard <maxime@cerno.tech>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 020/156] drm/vc4: Fix missing platform_unregister_drivers() call in vc4_drm_register()
Date: Wed, 23 Nov 2022 09:49:37 +0100
Message-Id: <20221123084558.657301431@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
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

[ Upstream commit cf53db768a8790fdaae2fa3a81322b080285f7e5 ]

A problem about modprobe vc4 failed is triggered with the following log
given:

 [  420.327987] Error: Driver 'vc4_hvs' is already registered, aborting...
 [  420.333904] failed to register platform driver vc4_hvs_driver [vc4]: -16
 modprobe: ERROR: could not insert 'vc4': Device or resource busy

The reason is that vc4_drm_register() returns platform_driver_register()
directly without checking its return value, if platform_driver_register()
fails, it returns without unregistering all the vc4 drivers, resulting the
vc4 can never be installed later.
A simple call graph is shown as below:

 vc4_drm_register()
   platform_register_drivers() # all vc4 drivers are registered
   platform_driver_register()
     driver_register()
       bus_add_driver()
         priv = kzalloc(...) # OOM happened
   # return without unregister drivers

Fixing this problem by checking the return value of
platform_driver_register() and do platform_unregister_drivers() if
error happened.

Fixes: c8b75bca92cb ("drm/vc4: Add KMS support for Raspberry Pi.")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20221103014705.109322-1-yuancan@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_drv.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vc4/vc4_drv.c b/drivers/gpu/drm/vc4/vc4_drv.c
index 0d78ba017a29..36688a56c91c 100644
--- a/drivers/gpu/drm/vc4/vc4_drv.c
+++ b/drivers/gpu/drm/vc4/vc4_drv.c
@@ -392,7 +392,12 @@ static int __init vc4_drm_register(void)
 	if (ret)
 		return ret;
 
-	return platform_driver_register(&vc4_platform_driver);
+	ret = platform_driver_register(&vc4_platform_driver);
+	if (ret)
+		platform_unregister_drivers(component_drivers,
+					    ARRAY_SIZE(component_drivers));
+
+	return ret;
 }
 
 static void __exit vc4_drm_unregister(void)
-- 
2.35.1



