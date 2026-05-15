Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C28563F927A;
	Fri, 15 May 2026 16:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861088; cv=none; b=bsfLG4Fe982I7c8CN1l9BlnmuBiSDOU10AZnYCC6UO/cqfXrUXey0DZrP7WPK7TUajvQ62YYRXLvf2dQ84+FhyuK2nr5/nvzNhi6dG0Uqm2/Fn7Vc/d9rQlHyufSIEIgslzYTI9WbPDAmoJ5CcmrqpxKQ2/pjNo/yDXaU8X0gRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861088; c=relaxed/simple;
	bh=CXu1pEON8BRtY/zyre2oXOYXWdIbyEZTelGi3A5GjNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SHW+vTLCMVJiIBWTI9Vb+olFNzWWJvKGmDdCtTpYj5/dD7FEA1SLN3I1UtIJ1d8TaCHy2n9fj4lzNU9lBbAeNVBhrBGHF2fs5X8Q4WbzCgqqb2rc6tlBE03xveot4O9SDb+EvFS2tmmmhdWD9NCZy0JefbvOoS6ZhtkrtCVJPHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AjSvm3Mg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AjSvm3Mg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D9FC2BCB3;
	Fri, 15 May 2026 16:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861088;
	bh=CXu1pEON8BRtY/zyre2oXOYXWdIbyEZTelGi3A5GjNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AjSvm3MgV4C9tShKWIhVetdft5HcvSsmF09zhv2zTGFxYqyLq5mV6eMnfynI9Jd2C
	 XUh8zOXO3O9OuKgaV4mSz+1wCV4+PMIboUf0LBnOmH9JNs0XO4s7Ekg//FoehCl1uc
	 E2S6pmn+puQm2pppmZv86s8pi+rBVULa+tXKyZ5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pete Zaitcev <zaitcev@redhat.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.6 193/474] usb: usblp: fix heap leak in IEEE 1284 device ID via short response
Date: Fri, 15 May 2026 17:45:02 +0200
Message-ID: <20260515154719.196863201@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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


