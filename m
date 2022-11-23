Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B1D1C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:31:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74192C433D6;
	Wed, 23 Nov 2022 09:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669195916;
	bh=XpwRcAo2jfwOpMnSgLEF1oXMai8/FPRyv23ruHXnGqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZIf4JLfOBewM18GGTaR0qbqWDMJeJ3Q7smgMOt1c6M8FTO15Ry4r/d1sPpU/NaxzL
	 JbS71omyArvQ9zKHAAH1jpeHMq3e+4spg+1Qlf/R1xTOD12MpoNmYY9v/kdo3J6o4a
	 5+rLD1TJJI6EF6zbJcZY+CMP2NU44a4PD3SVrOnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 061/181] siox: fix possible memory leak in siox_device_add()
Date: Wed, 23 Nov 2022 09:50:24 +0100
Message-Id: <20221123084605.006524154@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
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

[ Upstream commit 6e63153db50059fb78b8a8447b132664887d24e3 ]

If device_register() returns error in siox_device_add(),
the name allocated by dev_set_name() need be freed. As
comment of device_register() says, it should use put_device()
to give up the reference in the error path. So fix this
by calling put_device(), then the name can be freed in
kobject_cleanup(), and sdevice is freed in siox_device_release(),
set it to null in error path.

Fixes: bbecb07fa0af ("siox: new driver framework for eckelmann SIOX")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20221104021334.618189-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/siox/siox-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/siox/siox-core.c b/drivers/siox/siox-core.c
index 7c4f32d76966..561408583b2b 100644
--- a/drivers/siox/siox-core.c
+++ b/drivers/siox/siox-core.c
@@ -839,6 +839,8 @@ static struct siox_device *siox_device_add(struct siox_master *smaster,
 
 err_device_register:
 	/* don't care to make the buffer smaller again */
+	put_device(&sdevice->dev);
+	sdevice = NULL;
 
 err_buf_alloc:
 	siox_master_unlock(smaster);
-- 
2.35.1



