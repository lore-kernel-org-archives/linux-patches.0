Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74DBE9443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:32:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A903BC433C8;
	Sun, 13 Aug 2023 21:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962347;
	bh=fE48/0UsUrllRDfbt97Jx6zTEXya9sANIdyZCWDOEkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TZc8KxrrSCnqWVTG0sQBK5xm0QXIvOGawSwNT0HAYzR59nqMDDR66JQUdjEaoosJ0
	 pnwpSOYkyQA33GMtdF3Xevj0U08iSGWiyEv5ZRhKG7Y/OJBwfApRPKTSxsU26kL5CF
	 G8AujkasnJtQN2rify6JMaobkm2IoXQr2BIuDL1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Pasternak <vadimp@nvidia.com>,
	Michael Shych <michaelsh@nvidia.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.4 203/206] platform: mellanox: Fix order in exit flow
Date: Sun, 13 Aug 2023 23:19:33 +0200
Message-ID: <20230813211730.813556600@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vadim Pasternak <vadimp@nvidia.com>

commit 8e3938cff0191c810b2abd827313c090fe09d166 upstream.

Fix exit flow order: call mlxplat_post_exit() after
mlxplat_i2c_main_exit() in order to unregister main i2c driver before
to "mlxplat" driver.

Fixes: 0170f616f496 ("platform: mellanox: Split initialization procedure")
Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Reviewed-by: Michael Shych <michaelsh@nvidia.com>
Link: https://lore.kernel.org/r/20230813083735.39090-2-vadimp@nvidia.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/mlx-platform.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/platform/x86/mlx-platform.c
+++ b/drivers/platform/x86/mlx-platform.c
@@ -6238,8 +6238,6 @@ static void mlxplat_i2c_mux_topolgy_exit
 		if (priv->pdev_mux[i])
 			platform_device_unregister(priv->pdev_mux[i]);
 	}
-
-	mlxplat_post_exit();
 }
 
 static int mlxplat_i2c_main_complition_notify(void *handle, int id)
@@ -6369,6 +6367,7 @@ static void __exit mlxplat_exit(void)
 		pm_power_off = NULL;
 	mlxplat_pre_exit(priv);
 	mlxplat_i2c_main_exit(priv);
+	mlxplat_post_exit();
 }
 module_exit(mlxplat_exit);
 


