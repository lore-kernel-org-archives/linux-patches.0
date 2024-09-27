Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7ABA1E507;
	Fri, 27 Sep 2024 12:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440206; cv=none; b=D9mnbdjtDhSsFzIR93xahYUI5rJB+LO/5eU9ML6vveKklAPHK8et493kk85jwejq/pT23hNB2H3rpt333X1VeNFOsuQvguoRYcRbs/DX1MnuqyWWoqaPbQlmEk+ZtukoxWDD8Yy1D91g/wXaVGmiJCYcn82xcPCD9daaK/1fFlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440206; c=relaxed/simple;
	bh=awioz8hkqkzHLo2orXBBPwx1SQKxd6l3/qerDiQNFVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B1UZvCgXzjogTPrH78bEE+LaMYN7V4P1KFDYlX484eU4fRKmwhY5dph/nBaovo2JmarANK6gNh2gZdnnhgGn4Y/HW0stgC8IVQGoD/CFbmL4ZeDXz4YKMf5OnIEvJXWxJ1A//BSOIrJlNkvngE0nqzYdVVnk5x7E90wX74sX7/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DAaz2s8e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DAaz2s8e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE5B4C4CECE;
	Fri, 27 Sep 2024 12:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440206;
	bh=awioz8hkqkzHLo2orXBBPwx1SQKxd6l3/qerDiQNFVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DAaz2s8ei5DtfYRGCTQXQyzcTejApJPoiXsW5M5frCn/nckMfV4BAtJtG9YUgS7rG
	 aQ7+HGvkRj2LUWZf0JUDil8RQsMgOzLTewJzYqnkf6wDvE3zlkaT4Hy8+cSu3MATAN
	 WZpQRnnK8fSYOdLhHLRJ/0YzU/i/vnQBaD7sE9bQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	stable <stable@kernel.org>,
	syzbot+9d34f80f841e948c3fdb@syzkaller.appspotmail.com
Subject: [PATCH 6.11 12/12] USB: usbtmc: prevent kernel-usb-infoleak
Date: Fri, 27 Sep 2024 14:24:15 +0200
Message-ID: <20240927121715.757754022@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121715.213013166@linuxfoundation.org>
References: <20240927121715.213013166@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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


