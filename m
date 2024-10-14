Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE4717C77;
	Mon, 14 Oct 2024 14:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916940; cv=none; b=DaR/TMiWLa1bBjCLT/8KyqW6O3SDWyMX1A2dycwyemj7EDTOkonQPyw/nq83JqulluY414L/xHOQs+j0XRfmBocx1Z7psLdNIZb4PL61EjGezou7OPq7i9NZGXwkIPJC9sovNvqxx5QFvU7wdJUz4i63u2nQ1KwdLu6Sn/3lR4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916940; c=relaxed/simple;
	bh=GjaasAFYCZ8JqFgbwO8Gd1u7I1ZPcHkR9FxJQIatLX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cc4VBZviCwspvAKif7A16yW3EyDlFdZ64/BK8hiZTeKbX84rUtMozKjtSR9iTYYixSZLiwADonuNnDOyZDr/YJWoa97NhqCwXX2rC9EB5purjn27MTlEHAHjv9aqh28OemIwL4DG4eLG0lQrO/BOGFYzIyKbENJ6kBl6whn7Vl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Re+4IR/e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Re+4IR/e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59EB9C4CEC3;
	Mon, 14 Oct 2024 14:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916939;
	bh=GjaasAFYCZ8JqFgbwO8Gd1u7I1ZPcHkR9FxJQIatLX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Re+4IR/ea492sduiv94tTAc93NTyEoGf5gabuFVgoc/7IDtp+K+wFaMGK4qIfOaEJ
	 xz3ggHX1A9X0K1d9V36B45uccJBVNoX8Xh6lPKMc0znp1Hto3tuTmmgjf85Ta3Dut3
	 04MMWURbN1F7HQQkH9FJvdoi3jxUe1Gg9o/Qbu8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaixin Wang <kxwang23@m.fudan.edu.cn>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 076/213] i3c: master: cdns: Fix use after free vulnerability in cdns_i3c_master Driver Due to Race Condition
Date: Mon, 14 Oct 2024 16:19:42 +0200
Message-ID: <20241014141045.948595019@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kaixin Wang <kxwang23@m.fudan.edu.cn>

[ Upstream commit 609366e7a06d035990df78f1562291c3bf0d4a12 ]

In the cdns_i3c_master_probe function, &master->hj_work is bound with
cdns_i3c_master_hj. And cdns_i3c_master_interrupt can call
cnds_i3c_master_demux_ibis function to start the work.

If we remove the module which will call cdns_i3c_master_remove to
make cleanup, it will free master->base through i3c_master_unregister
while the work mentioned above will be used. The sequence of operations
that may lead to a UAF bug is as follows:

CPU0                                      CPU1

                                     | cdns_i3c_master_hj
cdns_i3c_master_remove               |
i3c_master_unregister(&master->base) |
device_unregister(&master->dev)      |
device_release                       |
//free master->base                  |
                                     | i3c_master_do_daa(&master->base)
                                     | //use master->base

Fix it by ensuring that the work is canceled before proceeding with
the cleanup in cdns_i3c_master_remove.

Signed-off-by: Kaixin Wang <kxwang23@m.fudan.edu.cn>
Link: https://lore.kernel.org/r/20240911153544.848398-1-kxwang23@m.fudan.edu.cn
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/i3c-master-cdns.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i3c/master/i3c-master-cdns.c b/drivers/i3c/master/i3c-master-cdns.c
index fa5aaaf446181..d8426847c2837 100644
--- a/drivers/i3c/master/i3c-master-cdns.c
+++ b/drivers/i3c/master/i3c-master-cdns.c
@@ -1666,6 +1666,7 @@ static void cdns_i3c_master_remove(struct platform_device *pdev)
 {
 	struct cdns_i3c_master *master = platform_get_drvdata(pdev);
 
+	cancel_work_sync(&master->hj_work);
 	i3c_master_unregister(&master->base);
 
 	clk_disable_unprepare(master->sysclk);
-- 
2.43.0



