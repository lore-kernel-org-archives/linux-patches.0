Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B77133BA244;
	Wed, 30 Sep 2026 19:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796072; cv=none; b=EbyKiAKLGDw9rGlxrBlJWQrtLtkbP9lKJG04V75+OZM8ukFP8DeVRbONgh28qOy0ZJYjqxZvazR0lZpOPESAwq2re+OzyKkhmlVoff/SwXgUkR9fyboKscUQdpT6s0c1UBf66X0UDYrusVb7pvKn77RkZZ73erVVk0wY8JeRH6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796072; c=relaxed/simple;
	bh=y8umk38P9zrVD9pW7JKwwElulmwRAJNzEsUlcSW8ItQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XZYSCm8+ydd0jYF7RP8tqN3j+KbbLy8cFrccn6alCTPyKKWw3+pwC6Ze8GWe0XmPnIYm3VRaADXizD6HKfCPScORfK0J3p2kiJkb/q8Mzd1j/Aqg4ecALVcPL7wteAON/tCBTK/paI4FgGjSWvpZMVsHseBwN9xYW7Qx7L33eCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pdbJ/qgb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pdbJ/qgb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 216B91F000FF;
	Wed, 30 Sep 2026 19:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796071;
	bh=TYkkzkRgim2cwXxYfxc2le8h6a3RfNsZ+yvai1Lq1HI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pdbJ/qgbd64Q4lHSefdXOLzcmxsDg2M7A7aGt4NQvGJe4NrjIgBT8NVAqB5VGKnDJ
	 nl+Jqa20881h7bF8YYke+xtjECC8QH7ghbDFcq+mgrLgUgJ7c49BNI8J9/74rM2UqS
	 pxEMu3cttU+nshmEytHc9OufKYVl2YaDdz1/V3+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+19da64013c46df87f971@syzkaller.appspotmail.com,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0784/1193] ALSA: pcm: set timer->private_data before registering the PCM timer
Date: Wed, 30 Sep 2026 17:24:28 +0200
Message-ID: <20260930152451.666986356@linuxfoundation.org>
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

From: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>

[ Upstream commit 1e713f9bb2ac583521f06b0eb4e22440b1e3d078 ]

snd_pcm_timer_init() calls snd_device_register() to link the new
struct snd_timer into the global timer list while it still carries
hw.c_resolution = snd_pcm_timer_resolution (and hw.start/hw.stop),
and only afterwards sets timer->private_data = substream.

Once the timer is on the list under register_mutex, a concurrent
reader can already reach it through the same mutex and invoke these
callbacks. /proc/asound/timers does this via c_resolution(), and
snd_timer_open()+snd_timer_start() reach start()/stop() the same way.
All three dereference timer->private_data, which for this brief
window is NULL, giving a NULL-pointer dereference:

  substream = timer->private_data;
  return substream->runtime ? ...   // substream is NULL

Move the private_data/private_free assignment before
snd_device_register() so the timer is never visible on the list
without its private_data set. On the snd_device_register() failure
path, private_free() (snd_pcm_timer_free()) can now run, but it only
does substream->timer = NULL, which is already NULL at that point
since substream->timer is set to the new timer just once, after a
successful registration -- so the failure path stays safe.

Reported-by: syzbot+19da64013c46df87f971@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=19da64013c46df87f971
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Link: https://patch.msgid.link/20260913134446.114724-1-ngocthang2710.1999@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/pcm_timer.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/sound/core/pcm_timer.c b/sound/core/pcm_timer.c
index c43484b22b34c..725a7272cd076 100644
--- a/sound/core/pcm_timer.c
+++ b/sound/core/pcm_timer.c
@@ -112,12 +112,15 @@ void snd_pcm_timer_init(struct snd_pcm_substream *substream)
 				"capture" : "playback",
 			tid.card, tid.device, tid.subdevice);
 	timer->hw = snd_pcm_timer;
+	/* Set before registering: a concurrent reader can invoke our hw
+	 * callbacks as soon as the timer is on the global list.
+	 */
+	timer->private_data = substream;
+	timer->private_free = snd_pcm_timer_free;
 	if (snd_device_register(timer->card, timer) < 0) {
 		snd_device_free(timer->card, timer);
 		return;
 	}
-	timer->private_data = substream;
-	timer->private_free = snd_pcm_timer_free;
 	substream->timer = timer;
 }
 
-- 
2.53.0



