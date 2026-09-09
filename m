Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3DE857C72D;
	Wed,  9 Sep 2026 14:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964035; cv=none; b=kHTH1yIX9y2b98p0E04sEM6pRVza/tFTItEokRa+PCrTA1FCI4yaUjld0VMofVQi7U8/bE6t3ifhakCP0wcyx73uLkjOHyp4UeC9F8S9lso7xTufmnRYtqDM5kAe/SzX0B60LMxbMvvK9a7mEzsTcpdS0cMk/NiCiGnOdPa8XDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964035; c=relaxed/simple;
	bh=HJF+EZb+BM1XCP2CthQYr7ofRDoTbtjHerN4wFa22jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AUnp+w8d0rqpLA6n4dS/9H8F38mPGKRr69O8+r1qtDHK3dLcbUy+hKgm7MjhCWlD16sacJCkmw0ZgfE3qC0cV6LaIdkubh0rcFBL8bERJf0aJkfVz3XbfWqjcKFS9oV9cqvXm8U3nat6tEaTRpbtUIJeTMFuhFpaVlCisl3Q1Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M6ZKoR8g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M6ZKoR8g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487801F00A3A;
	Wed,  9 Sep 2026 14:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964033;
	bh=1OjTwO7D6ynlQL8YvtGA0FqTCeUcGTr0bCwDm2qOoec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M6ZKoR8gz7DKernteyXoFvwD+vM01BkxeG/da0QSoiaO7Rx3t/J7tFZqssIcYMbIf
	 OSo6aa6/MH+smZyGFe8SwwvopzTB2LblfVhRy2SBzDAfuZaucy1X1fn62g+qLlgbjR
	 YbnYRXiPjxCXFBP4ycTi/WNU9IoiVr8YYxRkwPa0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a11c46f37ee083a73deb@syzkaller.appspotmail.com,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Diego Fernando Mancera Gomez <diegomancera.dev@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 285/583] media: em28xx: defer audio-only extension registration
Date: Wed,  9 Sep 2026 15:39:30 +0200
Message-ID: <20260909134247.916530494@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3448,6 +3448,7 @@ static void request_module_async(struct
 	 * intf. Don't register extensions twice on those devices.
 	 */
 	if (dev->is_audio_only) {
+		em28xx_init_extension(dev);
 #if defined(CONFIG_MODULES) && defined(MODULE)
 		request_module("em28xx-alsa");
 #endif
@@ -3676,8 +3677,6 @@ static int em28xx_init_dev(struct em28xx
 			retval = -ENODEV;
 			goto err_deinit_media;
 		}
-		em28xx_init_extension(dev);
-
 		return 0;
 	}
 


