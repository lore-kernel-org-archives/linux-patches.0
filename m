Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA95274B46;
	Sat, 12 Sep 2026 18:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237716; cv=none; b=b7qszk+j+bx9iT9yzEpC7uGgu5pCx8SHrI/yDF4wAYWIgz04kDI6yT0UZPNWvIU3U1WOeu9YDGnd73GnF+FdLlEXR4R8i7a3KGlnb04x0MufGHeNQwmc126VHpUeU8SYCcRbNjtUoSuQbpy8BPnttmoV7y5SeU8uyl8r7zUtdBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237716; c=relaxed/simple;
	bh=vsUmGBuX6B9JwFB750a05yMej0AwygSu01dgXC3RuDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H5NI/k5bEI6ZG8DACwIwI8VVAQMYc6NUV16B3WLpWKWNLtr6exZVnTFtty0WsYUcUfA4oLWpUk2EAPm3zyZVhswfbhzceJ225e0RcCOrEtm4ALJ971sFpyeQrbPBKmH9zuOm2iI1Q3/z+tgUMHKXbSeLs7h37j/D3z3XkNnQ+2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ot+LJJPK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ot+LJJPK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B32751F000FF;
	Sat, 12 Sep 2026 18:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237715;
	bh=OGy5uaX5WUP7MW9s1c3diKU69q9CLBzdgwD8Qe+YKD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ot+LJJPKyEcsEiIZLpskVJc9+USCQQZ3da36yDA6OaZbbRovf+d8SSAF1QKu7GWRc
	 AnjodlOSctXLWki3xHN+X9Dmf9DcJ1h9QvR3otCxCpiHmxUo4x5B44Y3FSfHQCK5dH
	 P13g7+VUg6D8Yis8qv7TFehIkc1mj0BvAScLroCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+99d6c66dbbc484f50e1c@syzkaller.appspotmail.com,
	"Jiangong.Han" <jiangong.han@windriver.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.15 316/935] media: em28xx: fix use-after-free of dev_next->devlist on disconnect
Date: Sat, 12 Sep 2026 08:55:46 +0200
Message-ID: <20260912065534.054762943@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

From: Jiangong.Han <jiangong.han@windriver.com>

commit 826915b6b65e2d3251e7248ea54289a22d748c84 upstream.

When a device with has_dual_ts=1 is probed and the is_audio_only path
is taken, both dev and dev->dev_next are added to the global
em28xx_devlist via em28xx_init_extension(). However, during disconnect,
em28xx_close_extension(dev) only calls list_del(&dev->devlist), leaving
dev->dev_next->devlist still linked in the global list. When dev_next is
subsequently freed via kref_put(), its devlist entry becomes a dangling
pointer in em28xx_devlist. The next device probe that calls
em28xx_init_extension() triggers a list corruption BUG when list_add_tail
detects the freed node.

This bug was exposed by commit a368ecde8a50 ("USB: core: Fix duplicate
endpoint bug by clearing reserved bits in the descriptor") which clears
reserved bits in bEndpointAddress during endpoint parsing. This causes
fuzzed endpoint addresses like 0xf3 to be normalized to 0x83, which
em28xx interprets as a vendor audio endpoint, enabling the
is_audio_only + has_dual_ts code path that was previously unreachable
with such descriptors.

Fix this by removing dev->dev_next->devlist from the global list in
em28xx_close_extension() before the device is freed.

Fixes: f410b4093fdd ("media: em28xx: split up em28xx_dvb_init to reduce stack size")
Cc: stable@vger.kernel.org
Reported-by: syzbot+99d6c66dbbc484f50e1c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=99d6c66dbbc484f50e1c
Signed-off-by: Jiangong.Han <jiangong.han@windriver.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/em28xx/em28xx-core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -1143,6 +1143,8 @@ void em28xx_close_extension(struct em28x
 			ops->fini(dev);
 		}
 	}
+	if (dev->dev_next)
+		list_del(&dev->dev_next->devlist);
 	list_del(&dev->devlist);
 	mutex_unlock(&em28xx_devlist_mutex);
 }


