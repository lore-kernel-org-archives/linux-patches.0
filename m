Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335DA4071DD;
	Sun,  7 Jun 2026 10:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829517; cv=none; b=bZ3zQqtC2j2PohzUnSBCfPODXcrIE+95qWkSbYu8j/9+3E6a2liMn17bKUVp+614xAUCM/tJBHBWHCtiDxc8V/co9LLSbzGC9GcCd6LcML9xdeS1WwKJNgMjh3RA/7m54sYt7cCa67kK4iN3XV4NsloBo1gsu2liuWxaMlBgdy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829517; c=relaxed/simple;
	bh=DQPIm5L4Sh6jCFeoVY9lTb/pp5j96hxzig04vrpTXUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B7MPWDGu/K+etmUy5d1QK7+LYvBgaMGW+Ta3Aw7ld7puZW42n6rCdnYy0TYqLy1J+AuFLxE5sSWpEX0vyucgFh95wkdl0+JJO1Mtrk8UK2Xg6VlhT1hqRXYYz+3t6XbD3UHWa16DX/6BnmWeUpzegiVggx1gcXWCNzHv9x8lx60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jGF/TIwI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jGF/TIwI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79B731F00893;
	Sun,  7 Jun 2026 10:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829516;
	bh=GmMpzDT9Bk0tzqAWwr0MHibQZZt01f5sNE5q/gwJUC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jGF/TIwIiZLzh3i6FUNAF5JcJxZBTogvyFlyhHUEt5co2NpklVLMNud+r8x2cITaa
	 RsWGIxdCZ7G1oAL27lJyjKzu1VfBxtHZe7Gn+T9bnSpuVqb0axM2OtoVWRb6R8CDiU
	 2ux9Cfxph64Hu5PrcxfPeyEw2iJexu1ZvgT7HR3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.12 231/307] usb: gadget: net2280: Fix double free in probe error path
Date: Sun,  7 Jun 2026 12:00:28 +0200
Message-ID: <20260607095736.188893808@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

commit c8547c74988e0b5f4cbb1b895e2a57aae084f070 upstream.

usb_initialize_gadget() installs gadget_release() as the release
callback for the embedded gadget device.  The struct net2280 instance is
therefore released through gadget_release() when the gadget device's last
reference is dropped.

The probe error path calls net2280_remove(), which tears down the
partially initialized device and drops the gadget reference with
usb_put_gadget().  Calling kfree(dev) afterwards can free the same object
again.

Drop the explicit kfree() and let the gadget device release callback
handle the final free.  This issue was found by a static analysis tool
I am developing.

Fixes: f770fbec4165 ("USB: UDC: net2280: Fix memory leaks")
Cc: stable <stable@kernel.org>
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20260427153651.337846-1-lgs201920130244@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/net2280.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/usb/gadget/udc/net2280.c
+++ b/drivers/usb/gadget/udc/net2280.c
@@ -3790,10 +3790,8 @@ static int net2280_probe(struct pci_dev
 	return 0;
 
 done:
-	if (dev) {
+	if (dev)
 		net2280_remove(pdev);
-		kfree(dev);
-	}
 	return retval;
 }
 


