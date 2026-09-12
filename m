Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 497083B0ACC;
	Sat, 12 Sep 2026 18:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237743; cv=none; b=dsIUCGcY8gSvKi6UAxHxMXGvl2rnMwXxHgkmuD5JogBRw6MrX0nKieyawESOAH/ubejjt0qmGE2jwYh7T694uRkG5BLuicE6/T/hA+treP9ZCXRySdGe4ERKAXxWJyUrjp8L9MbcNNmPdSNHKAX0mWaU58vHd1AtOsnmxhijLqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237743; c=relaxed/simple;
	bh=5zHqHw9+lEf2GDthE9hgzWkGwv52dqLC+v0LkyO3+RE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IRRiIASA6TueiKSPZhNsRImyjIKBxenBniYQjG88OeaC12ND31JvCctE8xEF8FHdWFvHjhipTBoaAWjfMHwqX3UUuaxExqcxy72+ijeEUNUS0tQzgfOVsIILD0YJQk7SEiL57M0Q9mc6Ei3OGgonoJBafs6GHrZp8sawsgiL7ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a0vFSzti; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a0vFSzti"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 983651F000FF;
	Sat, 12 Sep 2026 18:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237740;
	bh=z1x9hnShUraFJ7/Jjv3DbGh7jhHZEkzB2hAVOKKyKIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a0vFSztiCsinQNZXg3iZf/6JByYJs3PqXPT4qIdtluKOgVKgTSA+nLHwEQ7jk6rOz
	 NFSluTC6hS8B0OxFtu/AKajWyOthZiuvRAafFStKLssuJgsxU5oe7mH2aT7izeVOVy
	 p0fpoQKwC26iSXhQ8VZpsMlDsSm/iPDd0jIH3Rhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Sean Young <sean@mess.org>
Subject: [PATCH 5.15 321/935] media: rc: sunxi-cir: Unregister rc device on probe failure
Date: Sat, 12 Sep 2026 08:55:51 +0200
Message-ID: <20260912065534.168038027@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

commit 479aa6fa8c50f1052f1451326ef7d4d586d340c3 upstream.

After rc_register_device() succeeds, later probe failures must undo the
registration with rc_unregister_device(). The current error path jumps to
the allocation cleanup label and only calls rc_free_device(), leaving the
rc device registration and resources created by rc_register_device()
behind.

Add a registered-device unwind label for the IRQ lookup, IRQ request, and
hardware initialization failure paths. Keep rc_free_device() for failures
before rc_register_device() succeeds.

Fixes: b4e3e59fb59c ("[media] rc: add sunxi-ir driver")
Cc: stable@vger.kernel.org
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/sunxi-cir.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/media/rc/sunxi-cir.c
+++ b/drivers/media/rc/sunxi-cir.c
@@ -344,22 +344,25 @@ static int sunxi_ir_probe(struct platfor
 	ir->irq = platform_get_irq(pdev, 0);
 	if (ir->irq < 0) {
 		ret = ir->irq;
-		goto exit_free_dev;
+		goto exit_unregister_dev;
 	}
 
 	ret = devm_request_irq(dev, ir->irq, sunxi_ir_irq, 0, SUNXI_IR_DEV, ir);
 	if (ret) {
 		dev_err(dev, "failed request irq\n");
-		goto exit_free_dev;
+		goto exit_unregister_dev;
 	}
 
 	ret = sunxi_ir_hw_init(dev);
 	if (ret)
-		goto exit_free_dev;
+		goto exit_unregister_dev;
 
 	dev_info(dev, "initialized sunXi IR driver\n");
 	return 0;
 
+exit_unregister_dev:
+	rc_unregister_device(ir->rc);
+
 exit_free_dev:
 	rc_free_device(ir->rc);
 


