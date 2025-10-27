Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E10632D43F;
	Mon, 27 Oct 2025 19:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591816; cv=none; b=nfTeFL+DC6ZrWiN7IXhAc/FQjuAUI79zm+mNkoU90Q2+2QUaVgsTjnCXm8dpf3ACmKIoe9NHOfkkSShpgUrnOWuhYFJXuBddmAcDDCuSNE46hRmjCbBSghKTkFErmURlFQld16at179caI7R0alnR9zz2qcLI2WK975+c2DhDco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591816; c=relaxed/simple;
	bh=d77xYxsRoSqroU54lIRlHvcf+GiTR+aOSt0ClgSz7gw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ciHt/r/QX3qM3V0pcXQO8zlesLu5r2/jMAdVhaWEeCpdGj4SV8l5IV2f1dYOnHHbrccUp/qOYJEaaDi8au7x1fEzq6Eig9jHUhV2Mff1iT656KNltip7OMw2dlSXYqeb3ZP0UzggFhOcaizzrSb2eWeSJEBuLVml/i9/R4pG6NI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F1hi53La; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F1hi53La"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9DB5C4CEFD;
	Mon, 27 Oct 2025 19:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591816;
	bh=d77xYxsRoSqroU54lIRlHvcf+GiTR+aOSt0ClgSz7gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F1hi53LalSg52ezjM0VOgxfvXA/tnLlMmn4jp3Bq8aXcdPoCvVNUSvqIFaP4vUH2A
	 FQJawAk0lL5e0GbO1Muq0g9QfuLQ8iTSC1cZdqLYMCRUnei7L2NG4/wTvbDVHg9Yux
	 iWVvwBV1dkhAeNFu/Ufkwo5m7iWuoS2gc6JAQNfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Cong <yicong@kylinos.cn>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 001/123] r8152: add error handling in rtl8152_driver_init
Date: Mon, 27 Oct 2025 19:34:41 +0100
Message-ID: <20251027183446.425369646@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
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
@@ -9925,7 +9925,12 @@ static int __init rtl8152_driver_init(vo
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


