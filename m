Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9CA22F8EAE;
	Sat, 12 Sep 2026 14:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221769; cv=none; b=PMmPNAwLjd1YgCPwVZ4+nJq0tnIPKi6jHYA4fOahzkBXTveokss40gRMIvAaqHVfwDB9jt9jZENqO/8yOB/jS5dHOvwtD/rRumGBX0cfExdOSTdHC9bp8CiE4YD6fC8K6A2Xs5TjYMUHr0ltG1hC3djG/G+2OvDTIHoWceDkWVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221769; c=relaxed/simple;
	bh=/7plBb1nMOD+P+TGE578W2z4mFCAZ0ihRU52Ql33hxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GwMTma5I2PEojN267OVYDIXQsuHsPLBT1R7CdMBhhV6p6JsJZytYYJR1jKyef86LVxKKfJAw8Yo7bqT65HINdQ6W0slhPaBGluDhDS6KdcymXU2F4vF4Vhc/iohUvZOEm9vL25i1TDrbZ6iYhJCmBj0AHg9SnUyMaNjUedXxKkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zueEyoJN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zueEyoJN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A22D11F000FF;
	Sat, 12 Sep 2026 14:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221767;
	bh=du63Ekgjz78tl6kGnAfmS1cLWv0e+WjgwB1cwBZYHiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zueEyoJNLKI9X94LwpY7lyTGDPTVGOkSxjPKJ9CAUfjtQdryReLgxpweJkbyiTMc6
	 SNrBy8BLcrG9775YmR0yGLqiW/PEjtQQV9AL7qX/jJ+5SzzR6xX1XaWuN5Wii5BdOl
	 rf3S0muXUzAL8Q9ukzaCOIQgUZ2gdp6pnWl8KH9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 0451/1424] media: go7007: defer the ALSA v4l2 put until card release
Date: Sat, 12 Sep 2026 08:48:03 +0200
Message-ID: <20260912065617.384607112@linuxfoundation.org>
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

From: Shuangpeng Bai <shuangpeng.kernel@gmail.com>

commit 1bd456afeb8a515137e567967069fce6f8fcd23e upstream.

go7007_snd_init() already takes a v4l2_device reference for the ALSA
side, but go7007_snd_remove() drops it immediately after calling
snd_card_free_when_closed().

That is too early when a userspace process still has the capture PCM open.
The ALSA card and its PCM callbacks remain alive until the last file is
closed, so the release path can still reach struct go7007 through
pcm->private_data and call go7007_snd_hw_free() after the V4L2 release path
has freed the object.

Move the matching v4l2_device_put() to the ALSA card private_free callback
so the existing ALSA reference covers the whole deferred card lifetime.

Closes: https://lore.kernel.org/r/178144969601.60470.6005237146425573205@gmail.com
Fixes: d5d3a7cc127d ("[media] go7007: fix unregister/disconnect handling")
Cc: stable@vger.kernel.org
Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/go7007/snd-go7007.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/media/usb/go7007/snd-go7007.c
+++ b/drivers/media/usb/go7007/snd-go7007.c
@@ -195,6 +195,13 @@ static const struct snd_device_ops go700
 	.dev_free	= go7007_snd_free,
 };
 
+static void go7007_snd_card_free(struct snd_card *card)
+{
+	struct go7007 *go = card->private_data;
+
+	v4l2_device_put(&go->v4l2_dev);
+}
+
 int go7007_snd_init(struct go7007 *go)
 {
 	static int dev;
@@ -245,6 +252,8 @@ int go7007_snd_init(struct go7007 *go)
 	gosnd->substream = NULL;
 	go->snd_context = gosnd;
 	v4l2_device_get(&go->v4l2_dev);
+	gosnd->card->private_data = go;
+	gosnd->card->private_free = go7007_snd_card_free;
 	++dev;
 
 	return 0;
@@ -263,7 +272,6 @@ int go7007_snd_remove(struct go7007 *go)
 
 	snd_card_disconnect(gosnd->card);
 	snd_card_free_when_closed(gosnd->card);
-	v4l2_device_put(&go->v4l2_dev);
 	return 0;
 }
 EXPORT_SYMBOL(go7007_snd_remove);


