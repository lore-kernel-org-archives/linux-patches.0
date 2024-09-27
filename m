Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7CA518BC32;
	Fri, 27 Sep 2024 12:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440008; cv=none; b=YkY1xdVQdCnQA4syXHPvQ0Wxs7/Jqb77Kb6/88bLBqU7RWIcLcin0i+AlWROlU9UmSF+5avO1j2OJMhuzZ5S58WGhwC2vP1q178FZi+XHop2qgB8+HW5ZjxanCGC3mkupnFsgc52LLqNuosZvkJjkZ5yCxMkxD5z+Tt2t4G6XBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440008; c=relaxed/simple;
	bh=Uur/8t/JdSDb7Cob6Kr3zw3Ka7qmpanM3X0MZ+tX9TE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tYVvT82khFra28sTiysADe3MmjmmTr3dRUvd6LsLZLF3WKmYoGViU/2Ubr1fXud0BfCurCBn1fv3OIChg6EyLKRj+tx+2z78nrZiKaxahaj5TKfVAml5qoHYQ/hu46d/kB8YOLKapFVuLujAJlvmLJbFeMu71Yb5FnGQLNfWOyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v6T/07er; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v6T/07er"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 644ABC4CEC4;
	Fri, 27 Sep 2024 12:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440008;
	bh=Uur/8t/JdSDb7Cob6Kr3zw3Ka7qmpanM3X0MZ+tX9TE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v6T/07er9mj7qQzPU/MyQdN3SA+JDAnERYfyvpzD+OQVpNkerYvTgyhx+fdf8T9LY
	 Ku+RwOfSjTQ+sr9G1Gx6hC5WID6f/7blWZo787TTNijdW2szn/CRaowNPefqWHNXYz
	 CNOJtHOtGOGa3WIp5GuTSEn1Ji6pXe2H73WGG6J0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	stable <stable@kernel.org>,
	syzbot+9d34f80f841e948c3fdb@syzkaller.appspotmail.com
Subject: [PATCH 6.6 54/54] USB: usbtmc: prevent kernel-usb-infoleak
Date: Fri, 27 Sep 2024 14:23:46 +0200
Message-ID: <20240927121721.975280866@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.714627278@linuxfoundation.org>
References: <20240927121719.714627278@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


