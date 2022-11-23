Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C0E1C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:57:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 826DAC433C1;
	Wed, 23 Nov 2022 09:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669197451;
	bh=n06H6EjI+t95X0e5Sdo7/cuOyKLiOKt5oByDt9aHc5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OvOD5Yzm7AsPwnTPFFyCkdmmD0le03lYYQmfsXI8WH1RaIMAOCCPGyUqCHKM52/LW
	 ogb/TLaYIacthtLIydv9XvwZIK4E1lWYKox/3xF9Br/ARiei0Xwsx7jdmjSa8ahpzx
	 fJ32kTQ8IisLi3DT9ERhkURY8nhKy2EshMy/yLkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Jun <chenjun102@huawei.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 297/314] Input: i8042 - fix leaking of platform device on module removal
Date: Wed, 23 Nov 2022 09:52:22 +0100
Message-Id: <20221123084638.996173018@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chen Jun <chenjun102@huawei.com>

[ Upstream commit 81cd7e8489278d28794e7b272950c3e00c344e44 ]

Avoid resetting the module-wide i8042_platform_device pointer in
i8042_probe() or i8042_remove(), so that the device can be properly
destroyed by i8042_exit() on module unload.

Fixes: 9222ba68c3f4 ("Input: i8042 - add deferred probe support")
Signed-off-by: Chen Jun <chenjun102@huawei.com>
Link: https://lore.kernel.org/r/20221109034148.23821-1-chenjun102@huawei.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/serio/i8042.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -1543,8 +1543,6 @@ static int i8042_probe(struct platform_d
 {
 	int error;
 
-	i8042_platform_device = dev;
-
 	if (i8042_reset == I8042_RESET_ALWAYS) {
 		error = i8042_controller_selftest();
 		if (error)
@@ -1582,7 +1580,6 @@ static int i8042_probe(struct platform_d
 	i8042_free_aux_ports();	/* in case KBD failed but AUX not */
 	i8042_free_irqs();
 	i8042_controller_reset(false);
-	i8042_platform_device = NULL;
 
 	return error;
 }
@@ -1592,7 +1589,6 @@ static int i8042_remove(struct platform_
 	i8042_unregister_ports();
 	i8042_free_irqs();
 	i8042_controller_reset(false);
-	i8042_platform_device = NULL;
 
 	return 0;
 }


