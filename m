Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1FF1875
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:58:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C7A6C433F0;
	Wed, 28 Dec 2022 15:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243100;
	bh=yLnkhlB9BbEslHaTL3lBF4JqC+SwK2YNaimLsP7VrDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CyHxLuu0zmFdOOVeUQS97phmGctyYjsdMDvXFX9OahJtOa8CE+4TaUtxpud8xk3NH
	 Jrjij+4WCZ7oEzksWP12tfM6ALmHWnblOTKkQGXp7uIqcF24FJSVU8XHixXwsXCAOd
	 FitDUOPo+EFtx9uC6RPEiQVG0q7Sb8Vmt+blj9vs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0490/1073] mmc: meson-gx: fix return value check of mmc_add_host()
Date: Wed, 28 Dec 2022 15:34:38 +0100
Message-Id: <20221228144341.344980099@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

[ Upstream commit 90935f16f2650ab7416fa2ffbe5c28cb39cf3f1e ]

mmc_add_host() may return error, if we ignore its return value,
it will lead two issues:
1. The memory that allocated in mmc_alloc_host() is leaked.
2. In the remove() path, mmc_remove_host() will be called to
   delete device, but it's not added yet, it will lead a kernel
   crash because of null-ptr-deref in device_del().

Fix this by checking the return value and goto error path which
will call mmc_free_host().

Fixes: 51c5d8447bd7 ("MMC: meson: initial support for GX platforms")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20221108123417.479045-1-yangyingliang@huawei.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/meson-gx-mmc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/meson-gx-mmc.c b/drivers/mmc/host/meson-gx-mmc.c
index fc462995cf94..4fd3d545e408 100644
--- a/drivers/mmc/host/meson-gx-mmc.c
+++ b/drivers/mmc/host/meson-gx-mmc.c
@@ -1291,7 +1291,9 @@ static int meson_mmc_probe(struct platform_device *pdev)
 	}
 
 	mmc->ops = &meson_mmc_ops;
-	mmc_add_host(mmc);
+	ret = mmc_add_host(mmc);
+	if (ret)
+		goto err_free_irq;
 
 	return 0;
 
-- 
2.35.1



