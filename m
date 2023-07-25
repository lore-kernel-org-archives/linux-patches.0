Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55951ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:22:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 683EFC433C9;
	Tue, 25 Jul 2023 11:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284137;
	bh=mf/xt/cNE7gpiOuscCxORewUPKa6bd+vlyKI/hcXJSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q3hyyBu8bZW7qkIYr5ondgGLTCiNvLYYTbUMIvumC3+wDpJc6ii6j79+3Rp7l0Hrp
	 guz/3MZqLs/J3Me2AClGNf6er5q6nQHEpmwxYV3aVB5J9feChP/miIjXlTzASLb+Lw
	 CNsGrsZ67Lj3GZ8X2Br20yOviRNdw59Yt4aqMEDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 219/509] w1: fix loop in w1_fini()
Date: Tue, 25 Jul 2023 12:42:38 +0200
Message-ID: <20230725104603.778367197@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 83f3fcf96fcc7e5405b37d9424c7ef26bfa203f8 ]

The __w1_remove_master_device() function calls:

	list_del(&dev->w1_master_entry);

So presumably this can cause an endless loop.

Fixes: 7785925dd8e0 ("[PATCH] w1: cleanups.")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/w1/w1.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 15842377c8d2c..1c1a9438f4b6b 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -1228,10 +1228,10 @@ static int __init w1_init(void)
 
 static void __exit w1_fini(void)
 {
-	struct w1_master *dev;
+	struct w1_master *dev, *n;
 
 	/* Set netlink removal messages and some cleanup */
-	list_for_each_entry(dev, &w1_masters, w1_master_entry)
+	list_for_each_entry_safe(dev, n, &w1_masters, w1_master_entry)
 		__w1_remove_master_device(dev);
 
 	w1_fini_netlink();
-- 
2.39.2



