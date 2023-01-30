Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE1728EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:16:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40056C433D2;
	Mon, 30 Jan 2023 14:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675088210;
	bh=9MLON69AHoR+q/K+zfaO2GiUr4oqO7b6QntrDhxsdpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qs5KIgTowgTmrQK7JtbDufcTMJpNLqk0mapI17SB4xm0jV28wKh7iJ6HG64ijGydZ
	 X2myRMFUCHZuPLQOlFe3ERCouOTlF/jE19PP889SP+cjFH5hKfPNphLxYjr+bkfWIu
	 voUJGcoj54uFYg3ADa4LVpQDbsltfexnWpOJDfzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Morgan <macromorgan@hotmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Wolfram Sang <wsa@kernel.org>,
	Tong Zhang <ztong0001@gmail.com>
Subject: [PATCH 5.15 152/204] i2c: mv64xxx: Remove shutdown method from driver
Date: Mon, 30 Jan 2023 14:51:57 +0100
Message-Id: <20230130134323.236051412@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chris Morgan <macromorgan@hotmail.com>

commit 09b343038e3470e4d0da45f0ee09fb42107e5314 upstream.

When I attempt to shut down (or reboot) my R8 based NTC CHIP with this
i2c driver I get the following error: "i2c i2c-0: mv64xxx: I2C bus
locked, block: 1, time_left: 0". Reboots are successful but shutdowns
freeze. If I comment out the shutdown routine the device both reboots
and shuts down successfully without receiving this error (however it
does receive a warning of missing atomic_xfer).

It appears that very few i2c drivers have a shutdown method, I assume
because these devices are often used to communicate with PMICs (such
as in my case with the R8 based NTC CHIP). I'm proposing we simply
remove this method so long as it doesn't cause trouble for others
downstream. I'll work on an atomic_xfer method and submit that in
a different patch.

Signed-off-by: Chris Morgan <macromorgan@hotmail.com>
Acked-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Cc: Tong Zhang <ztong0001@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-mv64xxx.c |    9 ---------
 1 file changed, 9 deletions(-)

--- a/drivers/i2c/busses/i2c-mv64xxx.c
+++ b/drivers/i2c/busses/i2c-mv64xxx.c
@@ -1047,14 +1047,6 @@ mv64xxx_i2c_remove(struct platform_devic
 	return 0;
 }
 
-static void
-mv64xxx_i2c_shutdown(struct platform_device *pd)
-{
-	pm_runtime_disable(&pd->dev);
-	if (!pm_runtime_status_suspended(&pd->dev))
-		mv64xxx_i2c_runtime_suspend(&pd->dev);
-}
-
 static const struct dev_pm_ops mv64xxx_i2c_pm_ops = {
 	SET_RUNTIME_PM_OPS(mv64xxx_i2c_runtime_suspend,
 			   mv64xxx_i2c_runtime_resume, NULL)
@@ -1065,7 +1057,6 @@ static const struct dev_pm_ops mv64xxx_i
 static struct platform_driver mv64xxx_i2c_driver = {
 	.probe	= mv64xxx_i2c_probe,
 	.remove	= mv64xxx_i2c_remove,
-	.shutdown = mv64xxx_i2c_shutdown,
 	.driver	= {
 		.name	= MV64XXX_I2C_CTLR_NAME,
 		.pm     = &mv64xxx_i2c_pm_ops,


