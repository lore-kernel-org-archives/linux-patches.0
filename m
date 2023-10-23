Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC5A623C5
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 10:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XOuXBSjF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D680EC433C9;
	Mon, 23 Oct 2023 10:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698058762;
	bh=SWG+7rs0cu9OSQgSKnREGuzL5SvzhHGNZSHrLCJY7Uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XOuXBSjFLblbd/ykd0iyVvUTQwJXFHhKB0WCHLkh27uko/RySQY78p1nTFmu9Rv2p
	 D463WAJiD36WCYuMSZEokQU66Gdqvexe34xS87TOUAiEblkOPIg+BzHxBkzGMFwfmz
	 hPw8aTH1yG4h3d5B0+lbWaFzZWNtI6ITt0a4mFHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	syzbot+0434ac83f907a1dbdd1e@syzkaller.appspotmail.com,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.14 18/66] Input: powermate - fix use-after-free in powermate_config_complete
Date: Mon, 23 Oct 2023 12:56:08 +0200
Message-ID: <20231023104811.474402774@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104810.781270702@linuxfoundation.org>
References: <20231023104810.781270702@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit 5c15c60e7be615f05a45cd905093a54b11f461bc upstream.

syzbot has found a use-after-free bug [1] in the powermate driver. This
happens when the device is disconnected, which leads to a memory free from
the powermate_device struct.  When an asynchronous control message
completes after the kfree and its callback is invoked, the lock does not
exist anymore and hence the bug.

Use usb_kill_urb() on pm->config to cancel any in-progress requests upon
device disconnection.

[1] https://syzkaller.appspot.com/bug?extid=0434ac83f907a1dbdd1e

Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Reported-by: syzbot+0434ac83f907a1dbdd1e@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/20230916-topic-powermate_use_after_free-v3-1-64412b81a7a2@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/powermate.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/misc/powermate.c
+++ b/drivers/input/misc/powermate.c
@@ -424,6 +424,7 @@ static void powermate_disconnect(struct
 		pm->requires_update = 0;
 		usb_kill_urb(pm->irq);
 		input_unregister_device(pm->input);
+		usb_kill_urb(pm->config);
 		usb_free_urb(pm->irq);
 		usb_free_urb(pm->config);
 		powermate_free_buffers(interface_to_usbdev(intf), pm);


