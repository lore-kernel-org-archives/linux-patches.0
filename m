Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C256C3939B1;
	Sat, 12 Sep 2026 18:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237712; cv=none; b=L8aHxejr9WXTU/7I+5hl3y2b2SBWbSWwDrYphk4Gxnyopxuu/4V/mLK+UAGQG26BDUh5+OZfp4HudBUe8lkAqwZ+d2xCqTeX12nSsMKeDIeyzonjaR+nmmItvUCQKdmte+Ehts0Azi1fi2H9mUAEbP5XcsF0iDjG27kfNX/H+3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237712; c=relaxed/simple;
	bh=CAE+7a5U/3KyPhnuEJJPN7rxBT38ml5IDC0b01ahMCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MLwu4VUl+bx7ilHwlDITDOsoaUzU4T0iDYWqm5dlU6b884KS2GeNLLeKkGoUsxnKrMkz4nf7x+JGTecqsFqWytWi8e7SC2cGd+Sh5q/9zcMAqCeSQdDAohBSDRuXHsC0Gl8KNxINM28V1kzWOGeWv7tNAI4FN7dLYZlAiNsXRjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nWedd8Qv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nWedd8Qv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CA781F000FF;
	Sat, 12 Sep 2026 18:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237710;
	bh=8WdSZ9HxgoSHO8/fVj07XXGUw9bpgUTdEQhmOnmNBiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nWedd8QvemPkZa/CDm0sjmDZXLMj5xfDrP5kriU8Qxzx/rrIKIUy9yoLRy4Ry09A0
	 3Taia/3jgl8oVR2QPn7/XAWcAkw0tMFmHdl1V/Q4oE8/lDvkRkStF26k9FFTo7ktwd
	 HNOhpTci5+s+h9d0zvnL7R4vJfPR6VaJWj48qz1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a11c46f37ee083a73deb@syzkaller.appspotmail.com,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Diego Fernando Mancera Gomez <diegomancera.dev@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.15 315/935] media: em28xx: defer audio-only extension registration
Date: Sat, 12 Sep 2026 08:55:45 +0200
Message-ID: <20260912065534.031715259@linuxfoundation.org>
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

From: Diego Fernando Mancera Gomez <diegomancera.dev@gmail.com>

commit 95f76f51937fdfb0fc1e14cae606b1ef574a56f3 upstream.

The audio-only path registers extensions while probing the primary device.
For a dual-TS board, this happens before dev_next is created. The duplicate
device inherits is_audio_only and is then independently inserted into
em28xx_devlist.

The list is intended to contain only primary devices: extension operations
reach the secondary device through dev_next. The independently linked
secondary can be freed during disconnect while its list node remains
reachable, resulting in a use-after-free.

Defer audio-only extension registration to the module-request work item. It
runs only after probing has completed construction of the optional
secondary device, so only the primary is registered and extension callbacks
reach the secondary through dev_next.

Fixes: 4a089668ef22 ("media: em28xx-cards: rework the em28xx probing code")
Cc: stable@vger.kernel.org
Reported-by: syzbot+a11c46f37ee083a73deb@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/66ec3c83.050a0220.29194.002f.GAE@google.com/T/
Suggested-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Diego Fernando Mancera Gomez <diegomancera.dev@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/em28xx/em28xx-cards.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3401,6 +3401,7 @@ static void request_module_async(struct
 	 * intf. Don't register extensions twice on those devices.
 	 */
 	if (dev->is_audio_only) {
+		em28xx_init_extension(dev);
 #if defined(CONFIG_MODULES) && defined(MODULE)
 		request_module("em28xx-alsa");
 #endif
@@ -3629,8 +3630,6 @@ static int em28xx_init_dev(struct em28xx
 			retval = -ENODEV;
 			goto err_deinit_media;
 		}
-		em28xx_init_extension(dev);
-
 		return 0;
 	}
 


