Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322631CDFD4;
	Wed, 19 Feb 2025 08:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739953844; cv=none; b=rJ6MmJCq3i0Q90bTMYE8Gt5CAwPdfSlIYW1AVZmnktMMQpzGJcsYT/SLPXhpw0Nl8h1PsEyyN9jI10Rsk/9vY9DHVW13xRmIc70Gtv1XMIs+9vqXiRl6gKHLthZSSguHYDFndEtneDx+B+rQi82/6AqEQFKegMiJRbfntU+byYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739953844; c=relaxed/simple;
	bh=N9zTRuGdGij/sr7fwV5LYNiUwW7BeBc78gC5GP7khVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pEIZ+BEOyCpOOU0EnMCP53rqvhx1telMqg+EWSaS+3ncWFauOA2jvxvl1kYCI4Xvw5X38rPMzf8yBdYM6uJDVrl3byGpce86hKsf+RsO6+EA+EPYRRPFXTzidl014aOuRjuV9LYshbqe1Y+7As17YKz1doVHrB/xbthvAT2vxK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bf9PaIfB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bf9PaIfB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54022C4CEE7;
	Wed, 19 Feb 2025 08:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739953843;
	bh=N9zTRuGdGij/sr7fwV5LYNiUwW7BeBc78gC5GP7khVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bf9PaIfB3ECBKx83X0SRmi1wg+ChXH3+hjoUoOrHb1ju3q9EGZgkbQpnHg3lKhn0V
	 7oK7L4xY8v5xaNVZw6vcFUd/HePkihFpFiim6/mP3Dp8kkXxnQ/kukeX1Tkz32X9tK
	 9bBAHJ5nhrLwCAq1OSWoi4gGgqSQltjJhjfrzBSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9c9179ac46169c56c1ad@syzkaller.appspotmail.com,
	=?UTF-8?q?T=C3=BAlio=20Fernandes?= <tuliomf09@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 016/274] HID: hid-thrustmaster: fix stack-out-of-bounds read in usb_check_int_endpoints()
Date: Wed, 19 Feb 2025 09:24:30 +0100
Message-ID: <20250219082610.174548434@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tulio Fernandes <tuliomf09@gmail.com>

[ Upstream commit 0b43d98ff29be3144e86294486b1373b5df74c0e ]

Syzbot[1] has detected a stack-out-of-bounds read of the ep_addr array from
hid-thrustmaster driver. This array is passed to usb_check_int_endpoints
function from usb.c core driver, which executes a for loop that iterates
over the elements of the passed array. Not finding a null element at the end of
the array, it tries to read the next, non-existent element, crashing the kernel.

To fix this, a 0 element was added at the end of the array to break the for
loop.

[1] https://syzkaller.appspot.com/bug?extid=9c9179ac46169c56c1ad

Reported-by: syzbot+9c9179ac46169c56c1ad@syzkaller.appspotmail.com
Fixes: 50420d7c79c3 ("HID: hid-thrustmaster: Fix warning in thrustmaster_probe by adding endpoint check")
Signed-off-by: Túlio Fernandes <tuliomf09@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-thrustmaster.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-thrustmaster.c b/drivers/hid/hid-thrustmaster.c
index 6c3e758bbb09e..3b81468a1df29 100644
--- a/drivers/hid/hid-thrustmaster.c
+++ b/drivers/hid/hid-thrustmaster.c
@@ -171,7 +171,7 @@ static void thrustmaster_interrupts(struct hid_device *hdev)
 	b_ep = ep->desc.bEndpointAddress;
 
 	/* Are the expected endpoints present? */
-	u8 ep_addr[1] = {b_ep};
+	u8 ep_addr[2] = {b_ep, 0};
 
 	if (!usb_check_int_endpoints(usbif, ep_addr)) {
 		hid_err(hdev, "Unexpected non-int endpoint\n");
-- 
2.39.5



