Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64CEC40F726;
	Wed, 30 Sep 2026 19:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796953; cv=none; b=EzoMC0HxF6II+ug9FitIVySdUGcUEceTsWju2P/1HimAGMIqOPw4GMHj61UwGoDzJOAaxbX9PHv1QZAzXr8WhOeDZytoJsezKr88vY++6EhxuHtlYBbi48c9/vHy5YwP0/ScHw+peHk+WJiOMU/Mx04iSkoGfZkUx34f6MKgZfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796953; c=relaxed/simple;
	bh=TqvIZCxE8xtRzUZ07B1/MVBP1k0E/pXZt6sXS+g83eg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b8kOs0K2Elq+kbi+o8x+2N38iSVSRI+Qq79uk8JRBj2EOdDhpRytZsqFdMchJsOhbDMSXn/9E2SAyz0Ycz4cUQjQ8PTACnXbFzJbx1EhFQWMLkP+Gu9Q6lW/s7hzlGMZpS5c9pzO8aOC+aX/JIfZJT+BfMB/KfkjpHACAGyESh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TZucPcVo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TZucPcVo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3FF41F00898;
	Wed, 30 Sep 2026 19:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796952;
	bh=U/FDoMverwkPYyI6Ec13AJz8HQsWs71b9yTjWF5bnlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TZucPcVo/yeulqIWR9qalGK7CfDvnLnEvzbM07edN01E9RqkQW6BYbvjSXiA/Lvpw
	 2U3oQxswIBA8a3/o1q8LkoasoD3KKni9Lz09We/hcRYoKMUa19mWqFlsLbj7NJ5vJY
	 RKOU5bsc6+VTWKEBQ5gvMFen6nBqVzlEz+joJdC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1853daab1a47603d4678@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1050/1193] nfc: pn533: fix OOB read in pn533_acr122_is_rx_frame_valid()
Date: Wed, 30 Sep 2026 17:28:54 +0200
Message-ID: <20260930152457.552198301@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Deepanshu Kartikey <kartikey406@gmail.com>

[ Upstream commit b61732f47316d45f27706db7812950145d3327b5 ]

frame->ccid.datalen is read directly from the USB response frame
and used, unchecked, as an index into frame->data[]. A malicious or
malfunctioning device can set this field to an arbitrary value,
causing the driver to read far outside the received buffer.

Bound ccid.datalen against the maximum possible ACR122 frame size
before using it. This replaces the existing datalen == 0 check,
since datalen < 2 already covers that case and additionally
rejects datalen == 1, which would still underflow the
"datalen - 2" offset used below.

Fixes: 9815c7cf22da ("NFC: pn533: Separate physical layer from the core implementation")
Reported-by: syzbot+1853daab1a47603d4678@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1853daab1a47603d4678
Tested-by: syzbot+1853daab1a47603d4678@syzkaller.appspotmail.com
Assisted-by: LLM
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Link: https://patch.msgid.link/20260923035627.6210-1-kartikey406@gmail.com
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/pn533/usb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nfc/pn533/usb.c b/drivers/nfc/pn533/usb.c
index 0b7e3b118dfd4..986d5bae2177f 100644
--- a/drivers/nfc/pn533/usb.c
+++ b/drivers/nfc/pn533/usb.c
@@ -320,7 +320,9 @@ static bool pn533_acr122_is_rx_frame_valid(void *_frame, struct pn533 *dev)
 	if (frame->ccid.type != 0x83)
 		return false;
 
-	if (!frame->ccid.datalen)
+	if (frame->ccid.datalen < 2 ||
+	    frame->ccid.datalen > PN533_ACR122_FRAME_MAX_PAYLOAD_LEN +
+	    PN533_ACR122_RX_FRAME_TAIL_LEN)
 		return false;
 
 	if (frame->data[frame->ccid.datalen - 2] == 0x63)
-- 
2.53.0



