Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9602279DA;
	Wed, 10 Dec 2025 07:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765351866; cv=none; b=o42+PgiFqhJaJo6sGCjYUkf/TTmxRPrqfyPJoCJUPyqIqr1pWfLoezmp0SZmhFjpNN41Ul3+T0NJCZiTTgp1SStnzdlCYgYIfZKpI05ouEY0YJKM62h50c1gvpHM7h//Pi32PpiPu29H+9LL6i/MPO98P9EQxkgaige5/goCjQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765351866; c=relaxed/simple;
	bh=L595N5ZxRojycExYNf6cNvB3tHfZRkxszETKKpC5peo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=auHi3ayOQEoLQv35DvnAXtpf6cf2TcnVbkdmgjNEtLWVio+xUW2NhNJRcbe08bQrwpuUjn3gCAP+CBIr0ADco7aU7P1Bz5dhmVHHu9dsJSu+DYn72j/EQZFxSyEDts4nNC3xeCdr8EV3n/SIADIfxou5jc/xTs3YDmJYEIo12yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eOzAhzgs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eOzAhzgs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F5D4C4CEF1;
	Wed, 10 Dec 2025 07:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765351866;
	bh=L595N5ZxRojycExYNf6cNvB3tHfZRkxszETKKpC5peo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eOzAhzgsrpnLBmbfRAVUawoaU4KVJEltB7eR/zAIKh9f5hF9frjxS4QFDqIblffko
	 9iMgL8SaM4KmOkEUJXgDWX/ibcTn7PbfJZLJSZzCLsOStrE1BQ5NY2KJlxTHI29gYV
	 F0pIlpzoH85lXjYNthzBn4VNtFsJpp44eJtNq19o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+fce5d9d5bd067d6fbe9b@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 6.12 11/49] comedi: pcl818: fix null-ptr-deref in pcl818_ai_cancel()
Date: Wed, 10 Dec 2025 16:29:41 +0900
Message-ID: <20251210072948.406530574@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072948.125620687@linuxfoundation.org>
References: <20251210072948.125620687@linuxfoundation.org>
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

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

commit a51f025b5038abd3d22eed2ede4cd46793d89565 upstream.

Syzbot identified an issue [1] in pcl818_ai_cancel(), which stems from
the fact that in case of early device detach via pcl818_detach(),
subdevice dev->read_subdev may not have initialized its pointer to
&struct comedi_async as intended. Thus, any such dereferencing of
&s->async->cmd will lead to general protection fault and kernel crash.

Mitigate this problem by removing a call to pcl818_ai_cancel() from
pcl818_detach() altogether. This way, if the subdevice setups its
support for async commands, everything async-related will be
handled via subdevice's own ->cancel() function in
comedi_device_detach_locked() even before pcl818_detach(). If no
support for asynchronous commands is provided, there is no need
to cancel anything either.

[1] Syzbot crash:
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000005: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000028-0x000000000000002f]
CPU: 1 UID: 0 PID: 6050 Comm: syz.0.18 Not tainted syzkaller #0 PREEMPT(full)
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/18/2025
RIP: 0010:pcl818_ai_cancel+0x69/0x3f0 drivers/comedi/drivers/pcl818.c:762
...
Call Trace:
 <TASK>
 pcl818_detach+0x66/0xd0 drivers/comedi/drivers/pcl818.c:1115
 comedi_device_detach_locked+0x178/0x750 drivers/comedi/drivers.c:207
 do_devconfig_ioctl drivers/comedi/comedi_fops.c:848 [inline]
 comedi_unlocked_ioctl+0xcde/0x1020 drivers/comedi/comedi_fops.c:2178
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
...

Reported-by: syzbot+fce5d9d5bd067d6fbe9b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=fce5d9d5bd067d6fbe9b
Fixes: 00aba6e7b565 ("staging: comedi: pcl818: remove 'neverending_ai' from private data")
Cc: stable <stable@kernel.org>
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://patch.msgid.link/20251023141457.398685-1-n.zhandarovich@fintech.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/comedi/drivers/pcl818.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/comedi/drivers/pcl818.c
+++ b/drivers/comedi/drivers/pcl818.c
@@ -1111,10 +1111,9 @@ static void pcl818_detach(struct comedi_
 {
 	struct pcl818_private *devpriv = dev->private;
 
-	if (devpriv) {
-		pcl818_ai_cancel(dev, dev->read_subdev);
+	if (devpriv)
 		pcl818_reset(dev);
-	}
+
 	pcl818_free_dma(dev);
 	comedi_legacy_detach(dev);
 }


