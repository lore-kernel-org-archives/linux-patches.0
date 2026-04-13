Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24FD81D6DB5;
	Mon, 13 Apr 2026 16:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096236; cv=none; b=QIE0BKqhyYtnZfXMtNRinVR1eLOzwNthh+D1sUr3JaxV3+kEp2dC7K1O9gzRcuVndDk6T2JYY+7NaxMpIu8wBNT06opeHv3gF9Ry1/PvXSWg58UGDDtQ5etPg1MTkGyldKrhBaf8O4gVp2z3VVnlI322Ek8ilINpxdcU6s3tTOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096236; c=relaxed/simple;
	bh=GYOSkwfu5yLVNmMeTUmm+TdpwvY6tK0sTg8Amz9XneA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iWHzLSxidqGwNS+DpnwKIXqEaSeI8IuW+bQVEEALA4SET19CipPVAlg1cSSetacdz9EZyS4VFJrjKY5VvtD4K5ICQ5+CO0t0dU/1N0/TO6XlTKc1QyaL7ktqKSgSkDFWm0z2anqjTGoZRWFAqD+fr1R+w5LyKWRKC37uPT6HfDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZPWp/gUf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZPWp/gUf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C0EC2BCB4;
	Mon, 13 Apr 2026 16:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096235;
	bh=GYOSkwfu5yLVNmMeTUmm+TdpwvY6tK0sTg8Amz9XneA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZPWp/gUfabnMSHwHgs1GGy0nc9Z6jpwFAYaS9ifrIcj4osQgNoSP1xGlUE8l4XBYG
	 /iC+oeUBKvJvLZu60MNzDFI79caVM4H0ouclnD94h3+fJKEPmgPkv7nwpp8dW5hjiD
	 uIf5SBq9qBel4NWhU3IxGjpH2h9yvuK+nvUDywP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vishal Thanki <vishalthanki@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.19 02/86] wifi: rt2x00usb: fix devres lifetime
Date: Mon, 13 Apr 2026 17:59:09 +0200
Message-ID: <20260413155731.663169547@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.568515178@linuxfoundation.org>
References: <20260413155731.568515178@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 25369b22223d1c56e42a0cd4ac9137349d5a898e upstream.

USB drivers bind to USB interfaces and any device managed resources
should have their lifetime tied to the interface rather than parent USB
device. This avoids issues like memory leaks when drivers are unbound
without their devices being physically disconnected (e.g. on probe
deferral or configuration changes).

Fix the USB anchor lifetime so that it is released on driver unbind.

Fixes: 8b4c0009313f ("rt2x00usb: Use usb anchor to manage URB")
Cc: stable@vger.kernel.org	# 4.7
Cc: Vishal Thanki <vishalthanki@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/20260327113219.1313748-1-johan@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
@@ -828,7 +828,7 @@ int rt2x00usb_probe(struct usb_interface
 	if (retval)
 		goto exit_free_device;
 
-	rt2x00dev->anchor = devm_kmalloc(&usb_dev->dev,
+	rt2x00dev->anchor = devm_kmalloc(&usb_intf->dev,
 					sizeof(struct usb_anchor),
 					GFP_KERNEL);
 	if (!rt2x00dev->anchor) {


