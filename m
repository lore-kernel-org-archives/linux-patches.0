Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6707A1A00CE;
	Tue, 21 Oct 2025 20:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077154; cv=none; b=WgoSOeUeGeHFLRPUnJXJtm4ta40RqwpF9QeXSAN5A+AnNb6brIhpuN07IxiSuhhr4aept5QIf/nikfu7ea+Hg/veAs1K3KXzJ8w09bJG/qjJMAdZjcUmrRDWFUj8gQX4Y703U101iSMgfy19bVeXIwKbloikD+BJVc/OpnWYEuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077154; c=relaxed/simple;
	bh=PQ65jLM35Svd4XCmCNqI7nqhmXspYC3iRk7e9WkDEZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PY3V4vqIhrvzjZK31O2WdHlyvU4PNzntoz0Zj9EQaMXn0NDRSyJYKBYDUrgGSeibBm++Lw3Qamx5+BjrSgbfDZV4obWKg0dehllbMoITRsWaIlNBHbJFOq/02KSbTsoLFZbym+V0+1QoamGMTdy2m7Uw5IeeMCjGGAwVZUGcnCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XiVoKQIv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XiVoKQIv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE86C4CEF1;
	Tue, 21 Oct 2025 20:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077154;
	bh=PQ65jLM35Svd4XCmCNqI7nqhmXspYC3iRk7e9WkDEZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XiVoKQIvEDI/u/jZrUrnkwFCubHHbpPP6w1MXJPlnQ26NI03v6kXRSSbzI0R580zm
	 DdkBj1ue6ub6kiI15S1dftpSdKgny3w7SUHrlkuAy5VlP8X04ITk0nUdxhHtB42UeQ
	 3QbKSjlP9UiliPnAGO4DMVZfQEsPVFDZKm1/Ofyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Cong <yicong@kylinos.cn>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.17 017/159] r8152: add error handling in rtl8152_driver_init
Date: Tue, 21 Oct 2025 21:49:54 +0200
Message-ID: <20251021195043.601173325@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -10122,7 +10122,12 @@ static int __init rtl8152_driver_init(vo
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


