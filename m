Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25523B1EE2;
	Tue, 12 May 2026 17:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607805; cv=none; b=f+Ufq+TwTb9w4KrAqTZZIKu5Kf7P//7dHlyN/tH2JpdJvKuVrSeF933qwXXaaqH9INOe0m2NleM5R3LhK7AGUDPeFgx8oH1LAfI4oJJ+5+TBxBzHSCwR434C/+Vbk14Itsrac7rTU8mfR5b8TzWZRoprT6/lzHjYRjGH5HrF/rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607805; c=relaxed/simple;
	bh=IwilgftpdgSXQMN4iDERFIdqsFf0Bw+GPGdcjhRq6Yc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e5xadsFVL6jTJZnQrH5smaysqe0pZrpg8DAItMOYJsXmtCoWJJVn57NIeb+pKlcAoYgNvNcjqtqVRuOFF8fqYHbta145eCt87JlrcHOF4BFQrnkWEvSxLfe6ffs79DQ9U7uCiEEfsaCTqq3ooiDu9/3rCcKHuyAp4jShHzsf3ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UvJDi5Ah; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UvJDi5Ah"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C07EC2BCB0;
	Tue, 12 May 2026 17:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778607805;
	bh=IwilgftpdgSXQMN4iDERFIdqsFf0Bw+GPGdcjhRq6Yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UvJDi5AhTxm8wN++3v3XoO6aQdVg0SkQryIUkiD3wE3MYzCE4qkhGapLTgCYxMIoZ
	 LyKIjLRiQ9Wq/xmujey1H5QqCeW3o9cnfVF1z+933XtwrzlsMFNhXAkI1EwVMqCi+4
	 LQj2Y98Bz9tBcgacl7os/kOqtGOZ1VA5Cs5fHN5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pete Zaitcev <zaitcev@redhat.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.12 041/206] usb: usblp: fix heap leak in IEEE 1284 device ID via short response
Date: Tue, 12 May 2026 19:38:13 +0200
Message-ID: <20260512173933.705639115@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 7a400c6fe3617e31e690e3f7ca37bb335e0498f3 upstream.

usblp_ctrl_msg() collapses the usb_control_msg() return value to
0/-errno, discarding the actual number of bytes transferred.  A broken
printer can complete the GET_DEVICE_ID control transfer short and the
driver has no way to know.

usblp_cache_device_id_string() reads the 2-byte big-endian length prefix
from the response and trusts it (clamped only to the buffer bounds).
The buffer is kmalloc(1024) at probe time. A device that sends exactly
two bytes (e.g. 0x03 0xFF, claiming a 1023-byte ID) leaves
device_id_string[2..1022] holding stale kmalloc heap.

That stale data is then exposed:
  - via the ieee1284_id sysfs attribute (sprintf("%s", buf+2), truncated
    at the first NUL in the stale heap), and
  - via the IOCNR_GET_DEVICE_ID ioctl, which copy_to_user()s the full
    claimed length regardless of NULs, up to 1021 bytes of uninitialized
    heap, with the leak size chosen by the device.

Fix this up by just zapping the buffer with zeros before each request
sent to the device.

Cc: Pete Zaitcev <zaitcev@redhat.com>
Assisted-by: gkh_clanker_t1000
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/2026042002-unicorn-greedily-3c63@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/usblp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/class/usblp.c
+++ b/drivers/usb/class/usblp.c
@@ -1365,6 +1365,7 @@ static int usblp_cache_device_id_string(
 {
 	int err, length;
 
+	memset(usblp->device_id_string, 0, USBLP_DEVICE_ID_SIZE);
 	err = usblp_get_id(usblp, 0, usblp->device_id_string, USBLP_DEVICE_ID_SIZE - 1);
 	if (err < 0) {
 		dev_dbg(&usblp->intf->dev,


