Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02AA66FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:08:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D6EAC433D2;
	Mon, 16 Jan 2023 17:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888911;
	bh=yBul7LKb13qRrMGXqUeTDx2fmV9/t3F5Nxut59jbji8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mxwrz2gS6lwpuISShHY39zHJb2MAtHJFCdUwiMJBpDpcLy04q1ln0hX829r6t8qPi
	 8vIUUYTg4psTln6TmKV3PQHSczJiEQiB4JAs8xkkKdaC1uPBZUSzn03fm7Nyd99/jI
	 9b+f20TRm7zFRTwFtgiX/QExo3NAMycDrUnpl6rk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 187/338] HSI: omap_ssi_core: fix possible memory leak in ssi_probe()
Date: Mon, 16 Jan 2023 16:51:00 +0100
Message-Id: <20230116154829.090509290@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
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

[ Upstream commit 1aff514e1d2bd47854dbbdf867970b9d463d4c57 ]

If ssi_add_controller() returns error, it should call hsi_put_controller()
to give up the reference that was set in hsi_alloc_controller(), so that
it can call hsi_controller_release() to free controller and ports that
allocated in hsi_alloc_controller().

Fixes: b209e047bc74 ("HSI: Introduce OMAP SSI driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hsi/controllers/omap_ssi_core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hsi/controllers/omap_ssi_core.c b/drivers/hsi/controllers/omap_ssi_core.c
index 281fb9b1f219..fa3835ec5104 100644
--- a/drivers/hsi/controllers/omap_ssi_core.c
+++ b/drivers/hsi/controllers/omap_ssi_core.c
@@ -538,8 +538,10 @@ static int ssi_probe(struct platform_device *pd)
 	platform_set_drvdata(pd, ssi);
 
 	err = ssi_add_controller(ssi, pd);
-	if (err < 0)
+	if (err < 0) {
+		hsi_put_controller(ssi);
 		goto out1;
+	}
 
 	pm_runtime_enable(&pd->dev);
 
-- 
2.35.1



