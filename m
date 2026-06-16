Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D963B4611CF;
	Tue, 16 Jun 2026 17:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631267; cv=none; b=UQS7xSbdt0+Uy9dvcu/t4ivR+9uAY/zs+N/iZaDz6Ckc1ZYCj3ibfip4ZzxE3Z6BWgJSFbmxUet/WJ4CcsXse2R58xvLkIEqf3v7GhrSOqs/p3a+cpgpKOiYNZ2r5qtM2GW7S13JaHy/WcKabRTtbRSMbM06DcciiOr5QZkMRWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631267; c=relaxed/simple;
	bh=R0xaVbaJf1SylFtvoJpOBWTD6A21zk7xd0tuHq+Jh9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UpVXcGk6Hpm0zSAqx+vpvQOxmGw26bojK//w8EdHLXjfuZGhlRVI1WP5h09gyvpYsNBY43BCwk3VpukjqJcjmpNWE+65MaYh5bFL1BQaAJao+WdfXdiiRu5B3DxdFL/TvcYve1cpj+hCbekhSeVn1XoCDAe0Uaf+47o8SR3eeCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y65anoPu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y65anoPu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B55CE1F000E9;
	Tue, 16 Jun 2026 17:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631266;
	bh=oXWNEQRFKilFao9yXk2aLK6UQTMz+4oe3DpjeszXtqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y65anoPunGBSJwy1og5Go/zUYuKZfFdnOZMuVCWAngio3CFLnbDm8uDOaVgT1RWt1
	 T34LQcVExiC5AwlX0lB3qvGbKZralzj7VxYOpPrIj9NtfHEOmNCJp9iRsd0022wFa0
	 6BJmDyXf++M4sDM4PB5AkY4hIG0LvZIWKnAlo17U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Michal Pecio <michal.pecio@gmail.com>
Subject: [PATCH 6.1 189/522] usb: core: Fix SuperSpeed root hub wMaxPacketSize
Date: Tue, 16 Jun 2026 20:25:36 +0530
Message-ID: <20260616145134.954204987@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Pecio <michal.pecio@gmail.com>

commit d1e280334b7f0a1df441e08bd1f6a1bcc36b3bbb upstream.

There is no good reason to have wBytesPerInterval < wMaxPacketSize -
either one is too low or the other too high, and we may want to warn
about such descriptors. Start with cleaning up our own root hubs.

USB 3.2 section 10.15.1 sets wMaxPacketSize and wBytesPerInterval of
SuperSpeed hub status endpoints at 2 bytes, so reduce wMaxPacketSize
from its former value of 4, which was derived from USB 2.0 spec and
the kernel's USB_MAXCHILDREN limit. They don't apply because USB 3.2
10.15.2.1 specifies SuperSpeed hubs to have up to 15 ports.

Suggested-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Michal Pecio <michal.pecio@gmail.com>
Link: https://patch.msgid.link/20260518073121.7bc1da0f.michal.pecio@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hcd.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -353,9 +353,7 @@ static const u8 ss_rh_config_descriptor[
 	USB_DT_ENDPOINT, /* __u8 ep_bDescriptorType; Endpoint */
 	0x81,       /*  __u8  ep_bEndpointAddress; IN Endpoint 1 */
 	0x03,       /*  __u8  ep_bmAttributes; Interrupt */
-		    /* __le16 ep_wMaxPacketSize; 1 + (MAX_ROOT_PORTS / 8)
-		     * see hub.c:hub_configure() for details. */
-	(USB_MAXCHILDREN + 1 + 7) / 8, 0x00,
+	0x02, 0x00, /* __le16 ep_wMaxPacketSize; 2 bytes per USB3 10.15.1 */
 	0x0c,       /*  __u8  ep_bInterval; (256ms -- usb 2.0 spec) */
 
 	/* one SuperSpeed endpoint companion descriptor */


