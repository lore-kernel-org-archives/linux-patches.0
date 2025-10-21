Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A16D270EC1;
	Tue, 21 Oct 2025 19:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076356; cv=none; b=jiZe/9L/PY/w1Shlg31VP/R+PBTpnTWYrPaa7zbBdzAnMtFg23ZnS7K59cgTkrxbza+zwuarlfp7CmUoVBZ1YCug+LJq6qec0fHAMHUzlJrXV3VBDfUM2oHMW5ty2oaTLo9FWylJJQ0ek1mmOg3H9+bbTHPuCxOpmjANDEeAuR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076356; c=relaxed/simple;
	bh=pfLrxdpJ8gN+syGKgLz7HlqpeMg3FImPk8OuGGMT+10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d++d1TpmVNWWZNOYCw6ogAg3UznUEoOL+gcK8UwwoBFnkoMWrbYv3bhXtkiBDvRN1/w4v6ZiQYlAuD9L3kEgLbkKlVifAqIA1gYAPLIccFmtXQmcPD/kB+13LfcbuIO/DcE4HQn6Sp2d1Dhn3J8zgx9Xb8BO3Ae5LopHb9ldlTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vHsaCH5q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vHsaCH5q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B639C4CEF1;
	Tue, 21 Oct 2025 19:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076356;
	bh=pfLrxdpJ8gN+syGKgLz7HlqpeMg3FImPk8OuGGMT+10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vHsaCH5qaSKacgZv6723znvBJkWoMkaA91e9qQTofUS8uoSdqGKUCHgAakll5gbJa
	 Q8O2Zn61qwpehThvnoHTL3TJLiPNCnVCR2jtakNbtnXnJ9utqW7kYtCZzoQw009Lav
	 LtntnMK1yV4AEo3qgnFECrDi/qm/A7USP63pQ2JU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Cong <yicong@kylinos.cn>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 002/105] r8152: add error handling in rtl8152_driver_init
Date: Tue, 21 Oct 2025 21:50:11 +0200
Message-ID: <20251021195021.553803037@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
References: <20251021195021.492915002@linuxfoundation.org>
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
@@ -10104,7 +10104,12 @@ static int __init rtl8152_driver_init(vo
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


