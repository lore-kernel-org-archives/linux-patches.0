Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA2D7E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:44:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B50DC433C1;
	Wed,  2 Nov 2022 02:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667357052;
	bh=tyQT1sj7Hy8QkIbFt7toXAaiBygI6yFldUANFd5JroU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NQd0MPcD8PnW69RqO8rqaRDZLZ3PT5A/m4iWsHGzL3p4/iIuB3uDnsOn0xSq70w2s
	 dHdAw/QQAGpWOy1ucVfdxdr2AYnOLsQtkA1QUJig/9MYrafQop3j941Rtda1NOZfsX
	 za+XeqXj+v/XmTnU2wStPbRarjALIRHMEov7svoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
	Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 6.0 105/240] fbdev/core: Avoid uninitialized read in aperture_remove_conflicting_pci_device()
Date: Wed,  2 Nov 2022 03:31:20 +0100
Message-Id: <20221102022113.766208623@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michał Mirosław <mirq-linux@rere.qmqm.pl>

commit e0ba1a39b8dfe4f005bebdd85daa89e7382e26b7 upstream.

Return on error directly from the BAR-iterating loop instead of
break+return.

This is actually a cosmetic fix, since it would be highly unusual to
have this called for a PCI device without any memory BARs.

Fixes: 9d69ef183815 ("fbdev/core: Remove remove_conflicting_pci_framebuffers()")
Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/e75323732bedc46d613d72ecb40f97e3bc75eea8.1666829073.git.mirq-linux@rere.qmqm.pl
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/aperture.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/video/aperture.c
+++ b/drivers/video/aperture.c
@@ -351,12 +351,9 @@ int aperture_remove_conflicting_pci_devi
 		size = pci_resource_len(pdev, bar);
 		ret = aperture_remove_conflicting_devices(base, size, primary, name);
 		if (ret)
-			break;
+			return ret;
 	}
 
-	if (ret)
-		return ret;
-
 	/*
 	 * If a driver asked to unregister a platform device registered by
 	 * sysfb, then can be assumed that this is a driver for a display


