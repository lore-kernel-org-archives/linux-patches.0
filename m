Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2FB32ED43;
	Mon, 27 Oct 2025 19:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592143; cv=none; b=rL/DyQigd4EGM7LfGpQ66GLWrskYJPKz+QLnk6YdZIMR+bPE4+41HTQIYOIP3KpdTdu2/2f93ecMf+yJZzTR29x8RbFSTTEgA9Ij5aJ4Alg/Z5/V7WoeUujMsKEKB3p9bcZJ2FErFEPfh16MlD71dcro0S/G4lA4FIBimkT8/3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592143; c=relaxed/simple;
	bh=Lsi1CPVmEiLkcpmlUDqZkkZEtjxoyPbMdcW4YTMXNYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hV5HYqpitZzHgGOuk435XTxFnPmcrkQ0kkBKmhfFfcVD1c/ApzV4/2ktBMN4+f3DC1udp2i+YApXG/zlKJr2GcY/RC3KldB5XSyJR2IoyCoOjbRjog5YwBOPhLb3rtzrFiarRui1fSAUjqfX9zMS5xJOTy5G/W51L8duqoR/GXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HOJqxq6A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HOJqxq6A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F41EC4CEFD;
	Mon, 27 Oct 2025 19:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592143;
	bh=Lsi1CPVmEiLkcpmlUDqZkkZEtjxoyPbMdcW4YTMXNYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HOJqxq6ALh53ZEKl9CSgzrOeo72ox7fY17qqIXZ7f33ZrF10wezDqOzdzYtL8yxQL
	 lKzjN7E5sxhVHpbtgY37QTr6HxON5AHg6lxI6EkSY5JMCFkoI/RKZMnPLGgR5mhaz/
	 FWWeKkm3NtKrUXNl4IwI8PwRiqIa6V8t7DwNhpm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Cong <yicong@kylinos.cn>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 002/157] r8152: add error handling in rtl8152_driver_init
Date: Mon, 27 Oct 2025 19:34:23 +0100
Message-ID: <20251027183501.299078278@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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
@@ -9952,7 +9952,12 @@ static int __init rtl8152_driver_init(vo
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


