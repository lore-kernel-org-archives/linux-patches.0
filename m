Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68773469E4;
	Tue, 26 Aug 2025 13:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214347; cv=none; b=pVrlWrFapEe6g7R+o5qzNUV0VxfpfhlHe5Ey/g4ZZFpG0GOMU7j1eqtrcF/BSmdPnwNcZT7dl7bRZ8v/4ql7EwNs6/qSjA7RHDSd5qj9rVCO4q3oEn8QOaDiF3YgVysUOHtV4DwJSB4tKEbtiBuNB0+wWkA3bnBeiWU3TGShI1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214347; c=relaxed/simple;
	bh=PCQ0XRaN7cTi8Fjdh1CGd5sd0QuvJ7Wr7NfLKLMXyXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T2kD06pS11kt3TCIqJ2Sb/nZuCniuZC/UwB6fdcQM9QpoTYe9GTCgLVlbc0BRLUdk9IrooxFqPmsdOJ4siDxWXdeuihaq9ZMqPnRtghFnklUQCbiZXuMS0EKfk+zDIXS025BrYuOA5wVoGPZ6Js3T0rOzVbHXmVmlH+xn7d35Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oj7reChl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oj7reChl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C482C4CEF1;
	Tue, 26 Aug 2025 13:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214347;
	bh=PCQ0XRaN7cTi8Fjdh1CGd5sd0QuvJ7Wr7NfLKLMXyXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oj7reChlNBZvdkrHhA7fNCK44oHHxotej/+207cPAljCaObycuTgYvgBBm3vpsZZQ
	 b2Emvukkul+ukTP5nH7nwypAUEX7cTPQfhKUp+K4A3JWj6FDU8gH+SnOUTHKFZKrlh
	 HurBr30bEYWRPT7vaeJlkIWgXjL5isBkyM45rXBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 104/482] usb: core: usb_submit_urb: downgrade type check
Date: Tue, 26 Aug 2025 13:05:57 +0200
Message-ID: <20250826110933.397616374@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit 503bbde34cc3dd2acd231f277ba70c3f9ed22e59 ]

Checking for the endpoint type is no reason for a WARN, as that can
cause a reboot. A driver not checking the endpoint type must not cause a
reboot, as there is just no point in this.  We cannot prevent a device
from doing something incorrect as a reaction to a transfer. Hence
warning for a mere assumption being wrong is not sensible.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20250612122149.2559724-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/core/urb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/core/urb.c b/drivers/usb/core/urb.c
index 9f3c54032556..64f6592b27ce 100644
--- a/drivers/usb/core/urb.c
+++ b/drivers/usb/core/urb.c
@@ -501,7 +501,7 @@ int usb_submit_urb(struct urb *urb, gfp_t mem_flags)
 
 	/* Check that the pipe's type matches the endpoint's type */
 	if (usb_pipe_type_check(urb->dev, urb->pipe))
-		dev_WARN(&dev->dev, "BOGUS urb xfer, pipe %x != type %x\n",
+		dev_warn_once(&dev->dev, "BOGUS urb xfer, pipe %x != type %x\n",
 			usb_pipetype(urb->pipe), pipetypes[xfertype]);
 
 	/* Check against a simple/standard policy */
-- 
2.39.5



