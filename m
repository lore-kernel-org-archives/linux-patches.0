Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C4618453A;
	Fri, 27 Sep 2024 12:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440411; cv=none; b=p68Zlk5JNiknOcVURN3r4Jnqx/2rNdNz8JbaC7+fVhBalHXmZlpfpdbf/gWTudbRZzYC3IiX0hdBCa0jvK7d9/3xxzvzH3bKCD0EZkv7IdythEtBTTenBbT88WnJoI+x+O1vHUVKq8p/UAWaxBXKp/IPR/HlWo/kKEc6nbt84Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440411; c=relaxed/simple;
	bh=n3QWQXbyJDxVEdaoyxXcfs2c6x5zjZl6rqfV44xJz60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cmECuBNMZPUpPrhu2Q2ywbO+CDaaslTDvjX3//wxAWdQW3HFRRKW+xe+cQMDrTbAT1dG3srAR62u5vSHnBRnQm6BUIDb4I2mF7G4K2NzeYC1uGNwf7G5HZ8NDrQ7gWLAtlt4VbZ6bGMyvk1jIlx0fIq8SoXGRYdd5gc/oVsL+78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eBbREi3l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eBbREi3l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3CCAC4CEC4;
	Fri, 27 Sep 2024 12:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440411;
	bh=n3QWQXbyJDxVEdaoyxXcfs2c6x5zjZl6rqfV44xJz60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eBbREi3l9c3J/4foBrte1FpEzGB0UL0jSqB0osc6IQagm/o11/R41NHTHmmKaTBzE
	 MD9j0tCMNE3bSAc6bco3QR6vhgmOjc7E3lgB8pUSXulc5GV+JRE/fhuLTPzO6tUHww
	 +woG5TDnOLVGFu6GiOmukNT+W7EoZLiN4tptQM0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	stable <stable@kernel.org>,
	syzbot+9d34f80f841e948c3fdb@syzkaller.appspotmail.com
Subject: [PATCH 6.1 73/73] USB: usbtmc: prevent kernel-usb-infoleak
Date: Fri, 27 Sep 2024 14:24:24 +0200
Message-ID: <20240927121722.780157952@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.897851549@linuxfoundation.org>
References: <20240927121719.897851549@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -754,7 +754,7 @@ static struct urb *usbtmc_create_urb(voi
 	if (!urb)
 		return NULL;
 
-	dmabuf = kmalloc(bufsize, GFP_KERNEL);
+	dmabuf = kzalloc(bufsize, GFP_KERNEL);
 	if (!dmabuf) {
 		usb_free_urb(urb);
 		return NULL;


