Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A5123C1FD7;
	Thu, 15 Jan 2026 17:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498044; cv=none; b=quVM5SQKQwPpkPa1XiomDcH4R5ZtJsfRXyc6XbXUO8byaqW1N1QBOpjSkDjSP+LlqsrxA9a6ERi5FMzJl1N8AOQ24VAQ5nOLLJs5TxT2zypeWlPI9t3KkUPkDq+YHxtYNNJHZoQ25scHtq+ZuqleT/wc5klINttbw4jvsrZvacU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498044; c=relaxed/simple;
	bh=jbaWy38s+zqQFDumk5gFP8ymIKKVw2SyVdzigAgpNWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ws1Y4qiEhCykQq6gQg8+46mH/r6uE519eupbR6r0Gp+eXHbLiEcHVeU/15oztu2mvXJreBRr6M4pNP+nan9RXUvi+c4HnC0Yis+yQ39BOYziNuITbMTMc1kjs0M2UdvakM/GcyEJdYyN6Jha0m27v1nR7GfbDcx5RINdoNSHf8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ndfpexeb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ndfpexeb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA7DEC116D0;
	Thu, 15 Jan 2026 17:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498044;
	bh=jbaWy38s+zqQFDumk5gFP8ymIKKVw2SyVdzigAgpNWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ndfpexeb/oFykBwWAVbTWGoBg0kVb6LRy/os+vJ3Ns7mOz5NI1ml2ZuS4sefB+7oT
	 UzwamfSoZaKifAoZT4/MU4waXmlHpguSrjq3XR7aGaLr0MphWOZ7FAoYGgmezrG6VE
	 H9X2QTBr0v/C6GvrhkA5/eRjdCzaXy7TRQkqkJGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH 5.15 294/554] usb: phy: fsl-usb: Fix use-after-free in delayed work during device removal
Date: Thu, 15 Jan 2026 17:46:00 +0100
Message-ID: <20260115164256.869605605@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Duoming Zhou <duoming@zju.edu.cn>

commit 41ca62e3e21e48c2903b3b45e232cf4f2ff7434f upstream.

The delayed work item otg_event is initialized in fsl_otg_conf() and
scheduled under two conditions:
1. When a host controller binds to the OTG controller.
2. When the USB ID pin state changes (cable insertion/removal).

A race condition occurs when the device is removed via fsl_otg_remove():
the fsl_otg instance may be freed while the delayed work is still pending
or executing. This leads to use-after-free when the work function
fsl_otg_event() accesses the already freed memory.

The problematic scenario:

(detach thread)            | (delayed work)
fsl_otg_remove()           |
  kfree(fsl_otg_dev) //FREE| fsl_otg_event()
                           |   og = container_of(...) //USE
                           |   og-> //USE

Fix this by calling disable_delayed_work_sync() in fsl_otg_remove()
before deallocating the fsl_otg structure. This ensures the delayed work
is properly canceled and completes execution prior to memory deallocation.

This bug was identified through static analysis.

Fixes: 0807c500a1a6 ("USB: add Freescale USB OTG Transceiver driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Link: https://patch.msgid.link/20251205034831.12846-1-duoming@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/phy/phy-fsl-usb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/phy/phy-fsl-usb.c
+++ b/drivers/usb/phy/phy-fsl-usb.c
@@ -987,6 +987,7 @@ static int fsl_otg_remove(struct platfor
 {
 	struct fsl_usb2_platform_data *pdata = dev_get_platdata(&pdev->dev);
 
+	disable_delayed_work_sync(&fsl_otg_dev->otg_event);
 	usb_remove_phy(&fsl_otg_dev->phy);
 	free_irq(fsl_otg_dev->irq, fsl_otg_dev);
 


