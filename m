Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5CB257982E;
	Wed,  9 Sep 2026 14:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962854; cv=none; b=DBwqo1h9d/kI+5OFeRTtqbGCgoz7c8NoDcrc1A1jQZF0L+T94U0P6AQNUUKjr7Mgm7Rgr7wpytvlDRsw57h0mlAlX6hIUl6OOlqzRaLner4tOSX2/ban0ZHVNpM/FLd4tWynKL+nh/saNVJexS2wYI0aJTcovacL4Y2havxVqbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962854; c=relaxed/simple;
	bh=CDHW0jrlsVgSE/v1Pv5j7V78l0PlMVhSDTj+6lWTIgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vv4bvpZdBxNmbQb0jyqgy0xXRBOfmcbV9Tx++bvBih1bMkhf8aMOrrcfZ7ZWKn9mXQDyaxCv63ZcuF3kuJ8ZyxzTRty014I5XV9FC1PgDs69BhrIZRE5WLRx4sJsNXzQsOPvFQ05ab8CnYi6axyJkrEMCaBR0nhRvBu1aze0g7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TxC9HEXc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TxC9HEXc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC8E1F00A3A;
	Wed,  9 Sep 2026 14:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962853;
	bh=Nsp0yhBjr6ytk+RBT26ic5NydB1L6XrByIQ/sdqaMYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TxC9HEXchoIO3SPWwq8sQ5puel2jgdoXsAleUMDNPFnE05LgObv7vTdnE1LY/LcMb
	 ezsmM8tocVu0pvUWNO9k0OpypgEzmH1OjyCD1BNfScveHXYObiFzxTyXBirndu89zA
	 YTBtyHSdv3/SJ80Ra1skeS1ZsIhVYXi/OpYluhBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Sean Young <sean@mess.org>
Subject: [PATCH 7.2 384/556] media: rc: sunxi-cir: Unregister rc device on probe failure
Date: Wed,  9 Sep 2026 15:41:04 +0200
Message-ID: <20260909134244.187212988@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
 


