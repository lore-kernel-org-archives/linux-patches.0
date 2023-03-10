Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514DF846C
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:30:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA583C433EF;
	Fri, 10 Mar 2023 14:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458647;
	bh=HPD4wT44TXc6FJkK6bysETcJ69toq5QgoIfAwP/SNOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pGCdpiRjQRDZY6TFXuq8tF0Qw/lTHNV57YV/J63szMgoF3XNJv65OrOULy9bdZQ2/
	 rz3DRUO2rhjW0d7lbLr6YHVbCvM6eC0Gcsodg/hzfVvVXuj9+1tNm+Z+h6S/66J27q
	 iT6UsdROX3qM+Z+ag+WvlQgPEqiQ4fCxH3umaXmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Andrzej Hajda <andrzej.hajda@intel.com>,
	Ian Ray <ian.ray@ge.com>,
	Robert Foss <robert.foss@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 098/357] drm/bridge: megachips: Fix error handling in i2c_register_driver()
Date: Fri, 10 Mar 2023 14:36:27 +0100
Message-Id: <20230310133738.328326637@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
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

[ Upstream commit 4ecff954c370b82bce45bdca2846c5c5563e8a8a ]

A problem about insmod megachips-stdpxxxx-ge-b850v3-fw.ko failed is
triggered with the following log given:

[ 4497.981497] Error: Driver 'stdp4028-ge-b850v3-fw' is already registered, aborting...
insmod: ERROR: could not insert module megachips-stdpxxxx-ge-b850v3-fw.ko: Device or resource busy

The reason is that stdpxxxx_ge_b850v3_init() returns i2c_add_driver()
directly without checking its return value, if i2c_add_driver() failed,
it returns without calling i2c_del_driver() on the previous i2c driver,
resulting the megachips-stdpxxxx-ge-b850v3-fw can never be installed
later.
A simple call graph is shown as below:

 stdpxxxx_ge_b850v3_init()
   i2c_add_driver(&stdp4028_ge_b850v3_fw_driver)
   i2c_add_driver(&stdp2690_ge_b850v3_fw_driver)
     i2c_register_driver()
       driver_register()
         bus_add_driver()
           priv = kzalloc(...) # OOM happened
   # return without delete stdp4028_ge_b850v3_fw_driver

Fix by calling i2c_del_driver() on stdp4028_ge_b850v3_fw_driver when
i2c_add_driver() returns error.

Fixes: fcfa0ddc18ed ("drm/bridge: Drivers for megachips-stdpxxxx-ge-b850v3-fw (LVDS-DP++)")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
Tested-by: Ian Ray <ian.ray@ge.com>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20221108091226.114524-1-yuancan@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c b/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c
index b72f6f541d4ef..14d578fce09f9 100644
--- a/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c
+++ b/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c
@@ -426,7 +426,11 @@ static int __init stdpxxxx_ge_b850v3_init(void)
 	if (ret)
 		return ret;
 
-	return i2c_add_driver(&stdp2690_ge_b850v3_fw_driver);
+	ret = i2c_add_driver(&stdp2690_ge_b850v3_fw_driver);
+	if (ret)
+		i2c_del_driver(&stdp4028_ge_b850v3_fw_driver);
+
+	return ret;
 }
 module_init(stdpxxxx_ge_b850v3_init);
 
-- 
2.39.2



