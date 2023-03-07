Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781D3BA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:11:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9B6FC433EF;
	Tue,  7 Mar 2023 18:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212699;
	bh=wHJfAO5LsXajI8osGTdcr2aeOgtdaGADNY7wZzWn0Uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bw0M/ekrs+VjvgIFZoL/1MfChSk/xYIXzG1WairX4vebw9NAurt5A3MmzW+mwDNUP
	 sPzNmm49QZ6jHuoUHl1cSDwcPFr5tQNQfBRvr1PaY0IrU09LRpXJRwXbquFRLjGDS5
	 W6McmNgzSBTeuuoTCm69ivzUdzSq8PWYkq9rSjKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Andrzej Hajda <andrzej.hajda@intel.com>,
	Ian Ray <ian.ray@ge.com>,
	Robert Foss <robert.foss@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 268/885] drm/bridge: megachips: Fix error handling in i2c_register_driver()
Date: Tue,  7 Mar 2023 17:53:22 +0100
Message-Id: <20230307170013.654554765@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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
index 97359f807bfc3..cbfa05a6767b5 100644
--- a/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c
+++ b/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c
@@ -440,7 +440,11 @@ static int __init stdpxxxx_ge_b850v3_init(void)
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



