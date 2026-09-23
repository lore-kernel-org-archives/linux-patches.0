Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A803378838;
	Wed, 23 Sep 2026 14:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173020; cv=none; b=gXJutwV0HgUkkXqofcT+DqEe5ucQvfoMW2fcf2ATAN4jZsxksSuEtoPlkYNsHt7NHRtLRm+e3/i2pBHxFljF7k5nHZnAcOUaX/Tw4fUutrJfp1V2kQpyQrxUukDQ24wp53nbrs5V5cDjHIKudN5kDgrNGgqsr+lQHJFF9zc2O9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173020; c=relaxed/simple;
	bh=iZOm67f9Sp4KxwpeGEsrO0va32NdqKtCEhViI88bP8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SE97an1yvRzwsekgFqKCAep2hS1RhUkQ+jDneTTOaroeISNAD/J+UJVlUV0WMpiytiZ3Sxg5VrvkiWgIMBTj4ihnnQcL/lH7yakgzzlnO/lBp0hQJ0fVZCcWjQ5sqACrUd2ZSos5Csm1x4uYyt/5sL6M76k1sJuWUzhFk8eBDLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wvj6xHpB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wvj6xHpB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB0D51F000FF;
	Wed, 23 Sep 2026 14:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173019;
	bh=wML3DWXm3sGdyChxultBpFX7xCoQHpJc+TDRIXbuIxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wvj6xHpBwNzYK51HMqNT1jx1QV4Y45+nB40hYO7pPaW1Bx0bQ2KtVsYXU7scEjjF3
	 KBFjhjv6vpYiTGvpyTb//RbnHE4f7tYSQxG4q+fy5rJgSKJqdiynihgYbqcwlyLGB9
	 KGsWWecRZ+x64Spk6DVEgxhQRKUdzi3Rt97RFq0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+19da64013c46df87f971@syzkaller.appspotmail.com,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 128/438] ALSA: pcm: set timer->private_data before registering the PCM timer
Date: Wed, 23 Sep 2026 16:02:29 +0200
Message-ID: <20260923140648.097292868@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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
index ab0e5bd70f8fa..18bedd66435dc 100644
--- a/sound/core/pcm_timer.c
+++ b/sound/core/pcm_timer.c
@@ -111,12 +111,15 @@ void snd_pcm_timer_init(struct snd_pcm_substream *substream)
 			snd_pcm_direction_name(substream->stream),
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



