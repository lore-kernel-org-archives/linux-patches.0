Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D421368957;
	Fri,  4 Sep 2026 05:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500790; cv=none; b=iV6BOf7BLdpsdGsJ1BfQ11xhMWBlrqoccvdEXJ+gjEwMutXKBBwCz+pnOoaw6THrOOFwNI4Io+OuBrWNmwWIKAXmxtxuqhHIAI7ZJAW1O/4gMakzy4/XNNdum0GkxcXGsHGb3OnL9AQjAW3SRqBBkTj61kxIglDvE7BXcQnZqgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500790; c=relaxed/simple;
	bh=yzq9SVzv/Dxl14ZhWuuYzUjfo7e7fncMt4OT9DKLJmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dnpirDDDZ6qzbQSCTSmZF7nFg5pz75oOQkXkwa8G9RW3Gpvrg3c2j7oJ0Y1oxmOAamx5F3w61l608yhGiocfb4pwax8+MmSNIFLgmbCgyHcz2F18gRoqIPIKH6KGmDVO9jzNQRihkvghPYP0oLStskmqVcLGGSZzHUasItzPM+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qA1a8FBI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qA1a8FBI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 689161F00A3D;
	Fri,  4 Sep 2026 05:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500787;
	bh=vG4J2NMiDA3M7id+KKgzxIBPhW8kR7+Hv95dylHq5Io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qA1a8FBI2nyP6GTZrMCBFuJXuIgLYZ+lRl8D+g/Llwfp0lBzcsC/xREnd+YDgXfs8
	 WSq/HI+O2z2fM4VbFHBzY/RuN2xJNIL9wdGIJdf6KYIS/9TR6afG+m9bel6gDd9L4u
	 qZU7Z1bCqTvbu5Oe4rTkpv42ICbGVJkL7DzZWMRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.18 181/552] HID: mcp2221: stop device IO before hid_hw_stop
Date: Fri,  4 Sep 2026 06:55:38 +0200
Message-ID: <20260904045753.122581386@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiangshan Yi <yijiangshan@kylinos.cn>

commit dca151633c0fde90935311c60e7cfc064aa56134 upstream.

Quiesce device IO at the start of the devm cleanup callback
mcp2221_hid_unregister() so that incoming HID reports cannot race with
hardware teardown during probe failure or device removal, addressing a
potential use-after-free.

Guard the call to hid_device_io_stop() with io_started. On normal
removal hid_device_remove() has already cleared io_started before the
devres group is released, so an unconditional call would otherwise hit
the !io_started path and emit a spurious "io already stopped" warning
on every removal. The guard preserves the probe-failure balancing,
where io_started is still set after hid_device_io_start(), while
staying silent on the normal removal path.

Fixes: d4b50ac06ea6 ("HID: mcp2221: Allow IO to start during probe")
Cc: stable@vger.kernel.org
Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-mcp2221.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/hid/hid-mcp2221.c
+++ b/drivers/hid/hid-mcp2221.c
@@ -1035,6 +1035,8 @@ static void mcp2221_hid_unregister(void
 {
 	struct hid_device *hdev = ptr;
 
+	if (hdev->io_started)
+		hid_device_io_stop(hdev);
 	hid_hw_close(hdev);
 	hid_hw_stop(hdev);
 }


