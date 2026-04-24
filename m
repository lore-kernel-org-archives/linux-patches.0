Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 690333D5236;
	Fri, 24 Apr 2026 13:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038009; cv=none; b=Qo+/OlITdAIppgTfpratahnMNkH7/5deUf9U7d6vZI7FR5FwpXSJL3Tkx/uRg40iaMw3cMdTcztPX9eIT6pvckoF4IXprlnNur9rj68xe4lefxGBG6FT1Yn0GCLkQSb2ui0t4fvStqTATrhnBwvUG6exWqdSTGVmxM5nQJnX0k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038009; c=relaxed/simple;
	bh=eqHJXHiR4HY96dxa3kaoBnwwXNimPhP7ryD1NZWe8lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kt5ijPBVx40OYMjxOQPeB+jWAcDFKwMPCsvj23HAgNov5ToQNE+U4dSy2aXSXTnDMD+DjobMO/vycyBG0Ty/uiPTzFIQfOdqPoYMu3IDFbiG/5r1Ez8B8Z5DuVyW/PLQDjbZ3S0R4+RhTXrA76GNe4MdAOpxq1uuhzx4vO3FmPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DNlVW00J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DNlVW00J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F28A1C19425;
	Fri, 24 Apr 2026 13:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777038009;
	bh=eqHJXHiR4HY96dxa3kaoBnwwXNimPhP7ryD1NZWe8lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DNlVW00Jqe3zuwJ26Rb+30RuFJWNrzB4AQBybVeqk1joRnVwCBlrZ42nrowvTCAbm
	 ZnHK62F37pHOP83aDv6UkTpYvbutYb1aWsZp/oas3YrdLHIMPbsqz8fhu5mZ/d9XOS
	 PlW5pKN3BvxZ347WRv/MRQ3JS1reBBF3m1bYAP0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+47321e8fd5a4c84088db@syzkaller.appspotmail.com,
	Jeongjun Park <aha310510@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 122/166] media: as102: fix to not free memory after the device is registered in as102_usb_probe()
Date: Fri, 24 Apr 2026 15:30:36 +0200
Message-ID: <20260424132558.379230934@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

From: Jeongjun Park <aha310510@gmail.com>

commit 8bd29dbe03fc5b0f039ab2395ff37b64236d2f0c upstream.

In as102_usb driver, the following race condition occurs:
```
		CPU0						CPU1
as102_usb_probe()
  kzalloc(); // alloc as102_dev_t
  ....
  usb_register_dev();
						fd = sys_open("/path/to/dev"); // open as102 fd
						....
  usb_deregister_dev();
  ....
  kfree(); // free as102_dev_t
  ....
						sys_close(fd);
						  as102_release() // UAF!!
						    as102_usb_release()
						      kfree(); // DFB!!
```

When a USB character device registered with usb_register_dev() is later
unregistered (via usb_deregister_dev() or disconnect), the device node is
removed so new open() calls fail. However, file descriptors that are
already open do not go away immediately: they remain valid until the last
reference is dropped and the driver's .release() is invoked.

In as102, as102_usb_probe() calls usb_register_dev() and then, on an
error path, does usb_deregister_dev() and frees as102_dev_t right away.
If userspace raced a successful open() before the deregistration, that
open FD will later hit as102_release() --> as102_usb_release() and access
or free as102_dev_t again, occur a race to use-after-free and
double-free vuln.

The fix is to never kfree(as102_dev_t) directly once usb_register_dev()
has succeeded. After deregistration, defer freeing memory to .release().

In other words, let release() perform the last kfree when the final open
FD is closed.

Cc: <stable@vger.kernel.org>
Reported-by: syzbot+47321e8fd5a4c84088db@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=47321e8fd5a4c84088db
Fixes: cd19f7d3e39b ("[media] as102: fix leaks at failure paths in as102_usb_probe()")
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/as102/as102_usb_drv.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/usb/as102/as102_usb_drv.c
+++ b/drivers/media/usb/as102/as102_usb_drv.c
@@ -403,7 +403,9 @@ static int as102_usb_probe(struct usb_in
 failed_dvb:
 	as102_free_usb_stream_buffer(as102_dev);
 failed_stream:
+	usb_set_intfdata(intf, NULL);
 	usb_deregister_dev(intf, &as102_usb_class_driver);
+	return ret;
 failed:
 	usb_put_dev(as102_dev->bus_adap.usb_dev);
 	usb_set_intfdata(intf, NULL);


