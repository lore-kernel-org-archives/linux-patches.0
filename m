Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A712E7631;
	Sat, 12 Sep 2026 14:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221806; cv=none; b=HCjIa6Fifm8nZaD/ue8ETtfNHhmUCKAoOOW9Ol3APfwYFq8AFf+1thEayjC1BmcP25NQBCHCJrVlCkfhqNNalt1n0T8suKp8iiHQYHW6J0oRJYe6AHzlRAv3IMD8+CzPoT9jVZYVLNU04hGV/Yv3kEbWNFzud8NghpLI0ZUQDJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221806; c=relaxed/simple;
	bh=aPb8i0KECXk92FNKQX/IFAVwGKfXbTM+WzK67YU04oE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ni2PJkzu5nZmeNONjOLB0zGw/hh3lhDk5ffj5uWigo2S1za7zQlpTQ9jKLsO/zwGHTVaAyaGU97QTbHiYQeD2qi+JFfEx7mcKB4HEa9+NUhY0gr3ateClKigMxvKsnfKkG6lXsb4C6DzvCE6SWIUs4NM1cxFK/YXlaTyaTLjE5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ARJ4MxJD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ARJ4MxJD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA16A1F000FF;
	Sat, 12 Sep 2026 14:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221805;
	bh=IVF5nQcdNs7w+dYKRCo+mjsKEyUm24wSxf9/dbQOHaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ARJ4MxJDYliL6Zu88MEUTzw7JGzlV475ERnQhENY8cOUWQv6DQAk+lUv9eStBI4RY
	 MK+5q3PnDpQAeK7CzwVy5AX9qsSYTDYqDbCxz4rQII1jwAKhLkM2vpElwhlPhjHN1K
	 3oJMQ8Jdeu+Ce4xYPCaB6TC7+MKmmu1fDRLLlLNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Sean Young <sean@mess.org>
Subject: [PATCH 6.6 0458/1424] media: rc: sunxi-cir: Unregister rc device on probe failure
Date: Sat, 12 Sep 2026 08:48:10 +0200
Message-ID: <20260912065617.543806148@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -343,22 +343,25 @@ static int sunxi_ir_probe(struct platfor
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
 


