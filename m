Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33993FD956;
	Sat, 12 Sep 2026 15:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228517; cv=none; b=fI84fmf+0IF7bChg0Czqhx0CwqbaCbzWwI1Ofr5OiYanYZT7POxPnnq2tY+nUnv2j4VplGwZiGjw7YdU26sgrcyuuxIwokF/VJvmZCeltfsV3aSTUjEe6ODKhCqoFdxO78oU6DfUMhdpyCOqozsaDXEdv6M5nWIhqHTiGmoML8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228517; c=relaxed/simple;
	bh=4idWUnsEEbEfONd+tUDZMku3f6Y5p2sjuLXz7f8/gVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rfc7qMUYYD20tEr9TuuQm7vsqdaz+VlyJI3shLrvpbue/BXyON0fJcvB4HxLkG1BobljU1yEHMCCigs6eQrC2WS5NTMRGBphcMTLtfY0+GD15uBFfOPYLGgGIr0HnsdOO0fkj+oNB89wkb+Vab69/IYiF5Tll8olJ0zEep/x8Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DwwC9y7q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DwwC9y7q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CF1C1F000FF;
	Sat, 12 Sep 2026 15:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228516;
	bh=Vn2h9cHQ5ywgkhlS55SkF3NjymBAo6ZvOUTy8XoLYAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DwwC9y7q6fv/FC3dzlUSBeVwTVQmhU45rbTSLBr0FEo3+J8JLKFE7g0mVvsUIsOqF
	 +PIwKmiw0mp7Emu+eNqVRxQIK4XLPrA9zdkf4lfhQg4sL0A0FR2/jxSXaDk97ZKmPe
	 MG89m2uSr0EnSXqFCJoJ/13YoCpIp8lyjEeioi0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Sean Young <sean@mess.org>
Subject: [PATCH 6.1 0374/1191] media: rc: sunxi-cir: Unregister rc device on probe failure
Date: Sat, 12 Sep 2026 08:51:42 +0200
Message-ID: <20260912065556.632861214@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -342,22 +342,25 @@ static int sunxi_ir_probe(struct platfor
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
 


