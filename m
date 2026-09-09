Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542BC46E005;
	Wed,  9 Sep 2026 14:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962636; cv=none; b=muR7xMDvUZyKfauy5bVMomQUFrSNNAoZ45jX3BHlC0/66SHTMRaceSHPhZUZb83GeFhCMDQQkQQVYX8PeTGAS0MW5RCQtUPBrlYv9D70OP2Uza04cL+j4VGdOSmw6Sdiy404bz9Pm+bakVe+X8eXJVF09gpIC7s7i/IJlWbd/x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962636; c=relaxed/simple;
	bh=y+aU5AYe9zxT9Dxlc3E+Nsli+goEX18q1YObWh/Kxds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OfpCQClFwgSSSS3zUbCtbq4LEZS23q1/BloVhgeD7/fnLDLGoy7KxDzpacWjmwFYvCwsVH6l9Ub6GtGauO+CKYBz6cHM+RkyG7FEp54vSDB6N/VtoP4sZPRZ75ABEapjSjtrN1zRJE/xlIuBwgOSbfU2EoV8s1Ixu8tiSOMb8P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iH79Suoo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iH79Suoo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 580071F00A3A;
	Wed,  9 Sep 2026 14:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962633;
	bh=HuHXTCPK6FTAGrVdrMle1L7QZBynifFM6zQuROFueY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iH79Suoo0YO7jPB/OWIOHF4T0YNtfCs9n0WGEYsboWuPZAcMZ+YuxjP11PXBPecSH
	 LGFv7/nVVWM8GvZKvsjQzEf4GdhkB0m7bi1+nxuLRTIjIGv0TsE7oMapSPyLHK6tKm
	 jtyCCK/qKhQnL11WJZUpwUQifstZPLwPrP88icsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a11c46f37ee083a73deb@syzkaller.appspotmail.com,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Diego Fernando Mancera Gomez <diegomancera.dev@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.2 359/556] media: em28xx: defer audio-only extension registration
Date: Wed,  9 Sep 2026 15:40:39 +0200
Message-ID: <20260909134243.299955371@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3651,6 +3651,7 @@ static void request_module_async(struct
 	 * intf. Don't register extensions twice on those devices.
 	 */
 	if (dev->is_audio_only) {
+		em28xx_init_extension(dev);
 #if defined(CONFIG_MODULES) && defined(MODULE)
 		request_module("em28xx-alsa");
 #endif
@@ -3884,8 +3885,6 @@ static int em28xx_init_dev(struct em28xx
 			retval = -ENODEV;
 			goto err_deinit_media;
 		}
-		em28xx_init_extension(dev);
-
 		return 0;
 	}
 


