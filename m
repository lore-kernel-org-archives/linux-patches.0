Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7523ACA5A;
	Tue, 16 Jun 2026 18:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633772; cv=none; b=h/XEKPD5Qd7u77A1P3qaPf7wxCjHF21qMSjCI+49L9jEo9t8yxHfs4X4SfDt2ZaQnCnACeTbPpBGkf1rCRrn9l+zTfFAMEPlLPKmMUY1csehM6Iar034/Esl2iQlcQaH6ZGmxC4Dqs0TNv0F7VIkpVqne+u/r5uxUUNyPVXvjaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633772; c=relaxed/simple;
	bh=vWB8tRt0YGbtLA1o2rJqKKVzjHVkwj5t7Q20zYbucxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E9DK1wyeCmFizX/6+MkhUQlfK85SXmeG7ZevjOCkuA4iZ5uytcaM8kFopnxr62rjMkztFr2KGhb7v7s1pqz7eNINMfLM+OZrpDa+g44eYgZ+Z5gbOcJmPytfezM1/KzXmk9xWEUZZJ1BdmVYvBhqhQP4acLy4L2f0ilCAGETuPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XrfbWxv8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XrfbWxv8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD9EE1F000E9;
	Tue, 16 Jun 2026 18:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633770;
	bh=Nl1DeXPviodyxZA1U0JwB+9jZ8sCp7Dk5AC4/A+54JY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XrfbWxv8uMMyx9f+GfbCza34GuijbZxm8mmQa10UsqtRT5DduGW7RDXjyzrzn09Xu
	 HwfRhKBxJLQGZdRB+DwBuMv8FZyyVbXEFsOQdiN5sdN/A0PEg1KpfhUf+WLvi/ski4
	 seCb2U/jqyIGHRaYx6BwfASXe+ZGpGl2m8ZVWoOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Michal Pecio <michal.pecio@gmail.com>
Subject: [PATCH 5.15 142/411] usb: core: Fix SuperSpeed root hub wMaxPacketSize
Date: Tue, 16 Jun 2026 20:26:20 +0530
Message-ID: <20260616145107.926607139@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


