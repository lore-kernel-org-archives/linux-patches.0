Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CDDD2E7631;
	Sat, 12 Sep 2026 14:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221759; cv=none; b=NXZseVr4uCi9d5wtCcN4ouTh+ZadVlRRRdAT+wvyWgIVjD9kpY8+FGa/WcSdEW+bCwTOtnG+T0ub0AoNsmlYCLsXWi66o+ZJQDsi/lGqlPDuMkkf43UQORZ586ENnR5PUhhuRGI8GM9aqNYgdRc6Cz263sjipriivJIrQzXNYtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221759; c=relaxed/simple;
	bh=fbjK6JNu2hXgmfmOr3k0WTZn0/fekaG42NgYjXSEUx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=npL1p7LwKqjNTECNsbKd+87tdYI6JvQv8W//8voGPoXE4XnzRrGCLYUjA4Wl1BeUS2XabOIyKISfCyFPx7KkOnnFPNFMbU/PdPl/AGLTOaRHJVOoCQdUANLnsp3pfyE65uecSUJquDffrg5MmUKQYwCc4Szg10pEm0RQDvNjZU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K1XrNJjH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K1XrNJjH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21DFD1F000FF;
	Sat, 12 Sep 2026 14:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221758;
	bh=bdVG9T1Lv0qXTMSKRZ4VM0wx9L7lhAUwWCNAeSWyArE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K1XrNJjH3Z/j+FftPRH0I8P9pFQlxdx58rx18fAKyRJIpjJRSXEmQ8l2UF+mkwerk
	 1SAz4RTchnsxqQALVlzmzJJvGm2GXnbBbBM+IaghHTtElHibUwaCfByUIdPNLkxyBK
	 7soBlPutOQOycH4Xe4iRIXxL/ThHQP04JaN1iMLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a11c46f37ee083a73deb@syzkaller.appspotmail.com,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Diego Fernando Mancera Gomez <diegomancera.dev@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 0449/1424] media: em28xx: defer audio-only extension registration
Date: Sat, 12 Sep 2026 08:48:01 +0200
Message-ID: <20260912065617.339927188@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
@@ -3396,6 +3396,7 @@ static void request_module_async(struct
 	 * intf. Don't register extensions twice on those devices.
 	 */
 	if (dev->is_audio_only) {
+		em28xx_init_extension(dev);
 #if defined(CONFIG_MODULES) && defined(MODULE)
 		request_module("em28xx-alsa");
 #endif
@@ -3624,8 +3625,6 @@ static int em28xx_init_dev(struct em28xx
 			retval = -ENODEV;
 			goto err_deinit_media;
 		}
-		em28xx_init_extension(dev);
-
 		return 0;
 	}
 


