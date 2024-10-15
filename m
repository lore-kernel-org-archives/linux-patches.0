Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D7F1C07C2;
	Tue, 15 Oct 2024 12:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728996999; cv=none; b=Gb4TQrfbY4OVLkK11oBeQEpGo4ZxuxFVs0cV40JKr+4+X/gCiIfwoD3XtwtRajuxG9nJeKAKmlxqz3g4CGD4giJMNr51pLycl6eiDnPfSt4sY4nPwO7KztNkjIpaMALPnpt+uRETPhtKZ+dwYe0SwuZubyECApn1KTQ6xtHHYG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728996999; c=relaxed/simple;
	bh=YK0Chov0HjAVKhhfXbzaC9egbtYn+EMwf29ThCkoXm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KGFQse6A5DOX8sdMGw8H5KG4jo9T4yZmwhHRudV1oeEJXkIk+yUG5vvCNc913J7n1Tssc2Z7E+QFRa2G5cDtAus5Bv0joc8U+ISrCkkyI8GN+pGzROcGpDsgYfbpkt1SBaxDNmdOUVoj47Xx8iMa99PWXzMgPZmD7vo+dz1G98Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2BKcQYZq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2BKcQYZq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D55E1C4CEC6;
	Tue, 15 Oct 2024 12:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728996999;
	bh=YK0Chov0HjAVKhhfXbzaC9egbtYn+EMwf29ThCkoXm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2BKcQYZqtRIxHLjIW5suCP78XVTmvyq+ukyV9ImO1FmuWAyDSbdHwTx6v8fw96g76
	 jBNUret3T0s283r6A8D5WB945kJku74MKft4zGQVphLGobncqOnMuwws1uoWbhcwCZ
	 RAeWEbMjwZBi1byuI1bcS55+fWCO4nDiWFBg5lHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	stable <stable@kernel.org>,
	syzbot+9d34f80f841e948c3fdb@syzkaller.appspotmail.com
Subject: [PATCH 5.10 058/518] USB: usbtmc: prevent kernel-usb-infoleak
Date: Tue, 15 Oct 2024 14:39:22 +0200
Message-ID: <20241015123919.249446643@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Adam Davis <eadavis@qq.com>

commit 625fa77151f00c1bd00d34d60d6f2e710b3f9aad upstream.

The syzbot reported a kernel-usb-infoleak in usbtmc_write,
we need to clear the structure before filling fields.

Fixes: 4ddc645f40e9 ("usb: usbtmc: Add ioctl for vendor specific write")
Reported-and-tested-by: syzbot+9d34f80f841e948c3fdb@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9d34f80f841e948c3fdb
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/tencent_9649AA6EC56EDECCA8A7D106C792D1C66B06@qq.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/usbtmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -724,7 +724,7 @@ static struct urb *usbtmc_create_urb(voi
 	if (!urb)
 		return NULL;
 
-	dmabuf = kmalloc(bufsize, GFP_KERNEL);
+	dmabuf = kzalloc(bufsize, GFP_KERNEL);
 	if (!dmabuf) {
 		usb_free_urb(urb);
 		return NULL;


