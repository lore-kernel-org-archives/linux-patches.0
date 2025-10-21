Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB1A2773D4;
	Tue, 21 Oct 2025 20:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076814; cv=none; b=thZ+Ybcjwa7L1IogLjO5QG7bb4hZU9LWMPTPYPySHEuTRa168/c9y5lLta1gO9lbj9KLsngojIf2nlFch5SUeWUnOM/K3KgGGVyWXItiX8f1MLSX0vcGmLP81OpqVGf0/XX4rR2zUri8CIWjm1ki0EuDr05L5Ta268Zr0v66KhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076814; c=relaxed/simple;
	bh=OYGVOL2XNQ5P+FH53RT8PPJmP923uxewY2asD1NFPyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Av8GvsGzUhbFdQufkv+eRgwdmEaYXpynOejfehWugIVaK7O3fBo4SKaJpqTpgVmOu2IT3sEeBzrndmF9eRz1tUyVuXUur9QzqwNsn6xpCvuCGLT8qWD0jBUajCJ0b+Uhn+eojXHiMh6NyumdCGXta9/mgrF+lUNSE/tAe6hUnXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n1qwL5ZR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n1qwL5ZR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11EA5C4CEF7;
	Tue, 21 Oct 2025 20:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076814;
	bh=OYGVOL2XNQ5P+FH53RT8PPJmP923uxewY2asD1NFPyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n1qwL5ZRNw0AvQpO+90r4+5Zch7RLVcO2dOG4We3daY2wYY4O52XtpjZfrxieZ92Y
	 222e9/9DpDYvtRJjjEs0EU2cUz8gh1v05Lz8WzhsByj520TIEgIS8ogjnmjFDvQ41U
	 kT5oF4M+fblukVqCydVDGOc/LfoWKM2vRoGKV72s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Cong <yicong@kylinos.cn>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 005/136] r8152: add error handling in rtl8152_driver_init
Date: Tue, 21 Oct 2025 21:49:53 +0200
Message-ID: <20251021195036.088481275@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yi Cong <yicong@kylinos.cn>

commit 75527d61d60d493d1eb064f335071a20ca581f54 upstream.

rtl8152_driver_init() is missing the error handling.
When rtl8152_driver registration fails, rtl8152_cfgselector_driver
should be deregistered.

Fixes: ec51fbd1b8a2 ("r8152: add USB device driver for config selection")
Cc: stable@vger.kernel.org
Signed-off-by: Yi Cong <yicong@kylinos.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20251011082415.580740-1-yicongsrfy@163.com
[pabeni@redhat.com: clarified the commit message]
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/r8152.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -10151,7 +10151,12 @@ static int __init rtl8152_driver_init(vo
 	ret = usb_register_device_driver(&rtl8152_cfgselector_driver, THIS_MODULE);
 	if (ret)
 		return ret;
-	return usb_register(&rtl8152_driver);
+
+	ret = usb_register(&rtl8152_driver);
+	if (ret)
+		usb_deregister_device_driver(&rtl8152_cfgselector_driver);
+
+	return ret;
 }
 
 static void __exit rtl8152_driver_exit(void)


