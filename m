Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808B522094;
	Tue, 22 Jul 2025 14:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193071; cv=none; b=YQXu8UqsEp/ySz8KB57le1tSv7ZJfrTUNB5mreKydyFfkaTg4wdADVLkuqTn4SzO+ufi9wDRT3eHN6JZAzRXoYXnsTybrWhofYArnkJ4juGTlMoaQGlXyYg6E58d1o6y1MDy/HdbjIFn1vSIlYR8LpQkK8mBTX+8HvNI03S99Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193071; c=relaxed/simple;
	bh=QzyqIQ+arwDyaRc3rILFmIBVXEk/t/kA9/QDSRnTjdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BJfMV7KP8rX2eH6+fi4nDmigyqa0yJNGxSZc6hKCEAiEDsS4T74Zy41CXkT49HHtSkZdMI8uUiaTeln9B7dYPXr0YwihFXPKFi88/c/yEii7lPx8XOhqpiaoXFljFU1joYljPqon0VmBGafxIBf+q1pzCFRQMcMMRZp7bnnLo+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=guruPpS9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="guruPpS9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07A9FC4CEF6;
	Tue, 22 Jul 2025 14:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193071;
	bh=QzyqIQ+arwDyaRc3rILFmIBVXEk/t/kA9/QDSRnTjdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=guruPpS937BTewTGJMkYecSwEykEt3geeFF4hoXklTGs5IqS/pCo0Pizr51gmmI3T
	 VTzqnbqg6vbj6GvOvp07SXOoyU5A0HaKJ6/wnQlEIZSI6M0yIZSMDjaMaaLZBk0bv+
	 +yOKTqvCTQEtgLo7CSSv7aKnWrTGNwKyYHn4eOK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3f89ec3d1d0842e95d50@syzkaller.appspotmail.com,
	Oliver Neukum <oneukum@suse.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 109/158] usb: net: sierra: check for no status endpoint
Date: Tue, 22 Jul 2025 15:44:53 +0200
Message-ID: <20250722134344.818098553@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit 4c4ca3c46167518f8534ed70f6e3b4bf86c4d158 ]

The driver checks for having three endpoints and
having bulk in and out endpoints, but not that
the third endpoint is interrupt input.
Rectify the omission.

Reported-by: syzbot+3f89ec3d1d0842e95d50@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-usb/686d5a9f.050a0220.1ffab7.0017.GAE@google.com/
Tested-by: syzbot+3f89ec3d1d0842e95d50@syzkaller.appspotmail.com
Fixes: eb4fd8cd355c8 ("net/usb: add sierra_net.c driver")
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://patch.msgid.link/20250714111326.258378-1-oneukum@suse.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/sierra_net.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/usb/sierra_net.c b/drivers/net/usb/sierra_net.c
index 3d239b8d1a1bc..52e9fd8116f98 100644
--- a/drivers/net/usb/sierra_net.c
+++ b/drivers/net/usb/sierra_net.c
@@ -689,6 +689,10 @@ static int sierra_net_bind(struct usbnet *dev, struct usb_interface *intf)
 			status);
 		return -ENODEV;
 	}
+	if (!dev->status) {
+		dev_err(&dev->udev->dev, "No status endpoint found");
+		return -ENODEV;
+	}
 	/* Initialize sierra private data */
 	priv = kzalloc(sizeof *priv, GFP_KERNEL);
 	if (!priv)
-- 
2.39.5



