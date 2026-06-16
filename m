Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E3C47A0A1;
	Tue, 16 Jun 2026 16:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629007; cv=none; b=OYFnK1CTBjtRAFBPalynJWHVWdsr91BGXZvWRgztRiS0xdgCAsekSJJI9kHlBkAaFgITD21pLyLLYqsnQT1/6ILWbJxljB+Z6RK1vtR5jgWBirjR+F06TGoqHoOXiAKVqnpw3gX0ExuYOnrz7rfbJfhlt/8I4msjwwQ3GMoK5MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629007; c=relaxed/simple;
	bh=924sc21yquRlPi9qkeytnk7wtecxz+B5128B9fJd0fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jRL3vwo2pGlQztvyllcn2vzWUAQuq/eIL9OYurzXoA7F5z32r0k9WGlld3wdBJ2NjglTtGob6ByRF1vS2nmKSEHFd61Rp9l9Y04hFLNN86MpQYLi8gbX0VUVMLMLQDxUv0r5DZzOKudALbpHGwAFNHmeitVg6/WGf69hSSypFqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OWSIomVQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OWSIomVQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CDE11F000E9;
	Tue, 16 Jun 2026 16:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629006;
	bh=ruLZWzuLnNyVG6nFU+h6ZjBmVgiInd/I8EYL1qKnqNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OWSIomVQaOvMc7vvDghNcMI7BsuyjvqXcu3XrXwi7OSZ2ACKs8AEWKzbXiAPSJf8y
	 zD+Yr60rSAkt9HgcARv9ccdgdV3y+vpMqUP14WK8761+HctzL6JXoJ0pjyYHSR9vmy
	 rPGWoVvJBPwhI+LJZS3mnQaejINJvWpr2NEAC3OQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Michal Pecio <michal.pecio@gmail.com>
Subject: [PATCH 6.6 203/452] usb: core: Fix SuperSpeed root hub wMaxPacketSize
Date: Tue, 16 Jun 2026 20:27:10 +0530
Message-ID: <20260616145128.479260896@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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
@@ -332,9 +332,7 @@ static const u8 ss_rh_config_descriptor[
 	USB_DT_ENDPOINT, /* __u8 ep_bDescriptorType; Endpoint */
 	0x81,       /*  __u8  ep_bEndpointAddress; IN Endpoint 1 */
 	0x03,       /*  __u8  ep_bmAttributes; Interrupt */
-		    /* __le16 ep_wMaxPacketSize; 1 + (MAX_ROOT_PORTS / 8)
-		     * see hub.c:hub_configure() for details. */
-	(USB_MAXCHILDREN + 1 + 7) / 8, 0x00,
+	0x02, 0x00, /* __le16 ep_wMaxPacketSize; 2 bytes per USB3 10.15.1 */
 	0x0c,       /*  __u8  ep_bInterval; (256ms -- usb 2.0 spec) */
 
 	/* one SuperSpeed endpoint companion descriptor */


