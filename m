Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840D115C85
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:38:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 038AAC433D7;
	Mon,  5 Dec 2022 19:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670269136;
	bh=xs0T1emr/3XAO3nTm0l68ESnq+xGYfP5UNbiI0vCEcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xR2JjQQLFBo7s8zImKYKddpW3mE4Ih6AE8/Py6z4/bcXnHfpuFI0bglD0TOC52ZZa
	 Agpt2HE9RLIEx9JFuh3fb6+Y5FFebgM9eVo1Ja2P/mUdmooxIl+UJi/J8TItVyEAnG
	 Y26dFbjHlh6vJY6tXXzbYxvtohaVkY/sWJQLGAMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Sumit Garg <sumit.garg@linaro.org>,
	Jens Wiklander <jens.wiklander@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 017/153] tee: optee: fix possible memory leak in optee_register_device()
Date: Mon,  5 Dec 2022 20:09:01 +0100
Message-Id: <20221205190809.243522204@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit cce616e012c215d65c15e5d1afa73182dea49389 ]

If device_register() returns error in optee_register_device(),
the name allocated by dev_set_name() need be freed. As comment
of device_register() says, it should use put_device() to give
up the reference in the error path. So fix this by calling
put_device(), then the name can be freed in kobject_cleanup(),
and optee_device is freed in optee_release_device().

Fixes: c3fa24af9244 ("tee: optee: add TEE bus device enumeration support")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Sumit Garg <sumit.garg@linaro.org>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tee/optee/device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tee/optee/device.c b/drivers/tee/optee/device.c
index acff7dd677d6..71c491cbb0c5 100644
--- a/drivers/tee/optee/device.c
+++ b/drivers/tee/optee/device.c
@@ -89,7 +89,7 @@ static int optee_register_device(const uuid_t *device_uuid, u32 device_id)
 	rc = device_register(&optee_device->dev);
 	if (rc) {
 		pr_err("device registration failed, err: %d\n", rc);
-		kfree(optee_device);
+		put_device(&optee_device->dev);
 	}
 
 	return rc;
-- 
2.35.1



