Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1629250EA
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ViVPFpU4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E940C433C9;
	Mon,  6 Nov 2023 13:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699277641;
	bh=zTqA0ZeehZiBCzx0jxvV6QNCo6L8K0Mb1HbC3RWO67M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ViVPFpU4jclNqXGyiIoEBspZPGkPebWY1ih6wLEIHXMv6MW6Px9h2ZHDj/1T3kgb3
	 M127nsrPVPf6tGda3qLilOpxHgBX9hNlFsFrdCwUrqri09POWsoJYoOMMdxppZOxsv
	 8yAgFkCkC/FmSjoKg0xV5x4AALbAxbcMcyVRKtiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	lee@kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Hangyu Hua <hbh25y@gmail.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 5.10 59/95] rpmsg: Fix possible refcount leak in rpmsg_register_device_override()
Date: Mon,  6 Nov 2023 14:04:27 +0100
Message-ID: <20231106130306.862544567@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130304.678610325@linuxfoundation.org>
References: <20231106130304.678610325@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangyu Hua <hbh25y@gmail.com>

commit d7bd416d35121c95fe47330e09a5c04adbc5f928 upstream.

rpmsg_register_device_override need to call put_device to free vch when
driver_set_override fails.

Fix this by adding a put_device() to the error path.

Fixes: bb17d110cbf2 ("rpmsg: Fix calling device_lock() on non-initialized device")
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Link: https://lore.kernel.org/r/20220624024120.11576-1-hbh25y@gmail.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rpmsg/rpmsg_core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/rpmsg/rpmsg_core.c
+++ b/drivers/rpmsg/rpmsg_core.c
@@ -551,6 +551,7 @@ int rpmsg_register_device_override(struc
 					  strlen(driver_override));
 		if (ret) {
 			dev_err(dev, "device_set_override failed: %d\n", ret);
+			put_device(dev);
 			return ret;
 		}
 	}


