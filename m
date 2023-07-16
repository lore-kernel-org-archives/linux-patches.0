Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E988F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:21:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C80CC433C7;
	Sun, 16 Jul 2023 20:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538873;
	bh=kHPX4Ov12ZRg1jPFlP8ipf2JA6+9RgVxmjQfkcDvdl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AkQV0XaCv2W2P9wEm9hWDZ3E+mBHRhRHBmHeMJl0j9DURROi4z9c796CLdkERt7Rk
	 BbcVlBRn53Jn37UW6TDWFerSa1fkC6X9eaO/Dci+6zRYub9XKsFHztteJ7rIVeRWiw
	 5Vwp+SuzOV2ObfresHNgbhXK2sfaaIqOA/ur2NbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 607/800] media: atomisp: gc0310: Fix double free in gc0310_remove()
Date: Sun, 16 Jul 2023 21:47:40 +0200
Message-ID: <20230716195003.206062187@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 2746a966f9f05fdb0727f4e1e8f2d51ec79e071d ]

gc0310_remove() must not call kfree(dev) since the gc0310_device struct
is devm managed so explicitly freeing it causes a double free.

While at it add a missing mutex_destroy() call for the input_lock.

Link: https://lore.kernel.org/r/20230518153214.194976-6-hdegoede@redhat.com

Fixes: 340b4dd6c183 ("media: atomisp: gc0310: Use devm_kzalloc() for data struct")
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/atomisp/i2c/atomisp-gc0310.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/i2c/atomisp-gc0310.c b/drivers/staging/media/atomisp/i2c/atomisp-gc0310.c
index 273155308fe36..eb6db1571dc0d 100644
--- a/drivers/staging/media/atomisp/i2c/atomisp-gc0310.c
+++ b/drivers/staging/media/atomisp/i2c/atomisp-gc0310.c
@@ -377,8 +377,8 @@ static void gc0310_remove(struct i2c_client *client)
 	v4l2_device_unregister_subdev(sd);
 	media_entity_cleanup(&dev->sd.entity);
 	v4l2_ctrl_handler_free(&dev->ctrls.handler);
+	mutex_destroy(&dev->input_lock);
 	pm_runtime_disable(&client->dev);
-	kfree(dev);
 }
 
 static int gc0310_probe(struct i2c_client *client)
-- 
2.39.2



